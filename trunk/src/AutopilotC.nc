#include "IMU.h"
#include "Vector3.h"

#define   IMU_PERIOD 20 // Poll   the IMU    every  IMU_PERIOD                 ms.
#define MOTOR_PERIOD 5  // Adjust the motors every (IMU_PERIOD * MOTOR_PERIOD) ms.

#define IMU_PERIOD_S (((float) IMU_PERIOD) / 1000) // IMU_PERIOD in seconds.


// Provides a program for the mote controlling the helicopter.
module AutopilotC {
  uses {
    interface Boot;
    interface Receive;
    interface Timer <TMilli>;
    interface IMU;
    interface StdControl as IMUControl;
    interface Motors;
    interface Init as MotorsInit;
    interface PID <float> as XPID  ;
    interface PID <float> as YPID  ;
    interface PID <float> as ZPID  ;
    interface PID <float> as YawPID;
    interface SplitControl as AMControl;
    interface DeadReckoning;
    interface Init as MuxInit;
    interface StdControl as MuxControl;
    interface Leds;
  }
}

implementation {

  bool autopilotActive;

  Vector3 targetPosition;
  float targetYaw;

  Vector3 determineOrientation ();
  DoubleVector3 getIMUData ();

  event void Boot.booted ()
  {

    call MuxInit.init ();

    call MotorsInit.init ();

    autopilotActive = FALSE;
    targetPosition = zeroV3;
    targetYaw = 0;

    call IMUControl.start ();

    // Initialize the PIDs with initial previous error and integral of zero.    
    call XPID  .initialize (0, 0);
    call YPID  .initialize (0, 0);
    call ZPID  .initialize (0, 0);
    call YawPID.initialize (0, 0);
    call DeadReckoning.initialize (zeroV3, determineOrientation ());

    call AMControl.start ();

    call IMU.readRegister (YACCL_OUT);

    call Timer.startPeriodic (IMU_PERIOD);

  }

  // Assuming the system is at rest (the only force acting upon it is Gravity), this determines its orientation based on acceleration due to gravity.
  Vector3 determineOrientation ()
  {
    Vector3 accl = getIMUData ().a;
    if (accl.z == 0)
      accl.z = 1;
    return V3 (atan (accl.y / accl.z), atan (accl.x / accl.z), 0);
  }

  // This callback inspects the contents of the message.  If it is 'A', then the autopilot is activated.  If it is 'D', then the autopilot is deactivated.
  event message_t *Receive.receive (message_t *bufPtr, void *payload, uint8_t len)
  {
    char directive = *(char*)payload;
    switch (directive) {
    case 'A':
      if (! autopilotActive) {
        call MuxControl.start ();
        autopilotActive = TRUE;
	//	call Timer.startPeriodic (IMU_PERIOD);
      }
      break;
    case 'D':
      if (autopilotActive) {
	//	call Timer.stop ();
        call MuxControl.stop ();
        autopilotActive = FALSE;
	//	call Leds.set (0);
      }
      break;
    default:
    }
    return bufPtr;
  }

  event void AMControl.startDone (error_t err) {
    if (err == SUCCESS) {
    }
    else {
      call AMControl.start ();
    }
  }

  event void AMControl.stopDone (error_t err) { }

  DoubleVector3 getIMUData ()
  {

    static DoubleVector3 LAandAV;
    uint16_t data;

    call IMU.readRegister(XACCL_OUT);

#define CHECKDATA(prev, reg) do { data = call IMU.readRegister (reg); LAandAV.prev = ((float) ((int16_t) (data << 2))) / 4; } while (0)

    CHECKDATA (a.x, YACCL_OUT);
    CHECKDATA (a.y, ZACCL_OUT);
    CHECKDATA (a.z, XGYRO_OUT);
    CHECKDATA (b.pitch, YGYRO_OUT);
    CHECKDATA (b.roll , ZGYRO_OUT);
    CHECKDATA (b.yaw  , ZGYRO_OUT);

    return LAandAV;

  }

#define pi 3.141592653589793238

  event void Timer.fired ()
  {

    static uint8_t tick = 0;
    Vector3 position, orientation, absoluteLinearCorrection, linearCorrection, errorPosition;
    DoubleVector3 LAandAV, positionAndOrientation;
    float yawCorrection;

    float accl;

    tick++;

    LAandAV = getIMUData ();

    accl = LAandAV.a.y;

    if      (accl >=  200)
      call Leds.set (1); // 001
    else if (accl <= -200)
      call Leds.set (4); // 100
    else
      call Leds.set (2); // 010

    if (autopilotActive) {

      call Motors.setTopRotorPower    (accl / 1500 + .5);
      call Motors.setBottomRotorPower (accl / 1500 + .5);

      call Motors.setPitchPower ( LAandAV.a.x            / 1000 + .5);
      call Motors.setRollPower  ((LAandAV.a.z - GRAVITY) / 1000 + .5);

    }

    else {

      call Motors.setTopRotorPower    (.15 + .85 * (.5 + .5 * cos (2 * pi * ((float) tick) / 100 )));
      call Motors.setBottomRotorPower (.15 + .85 * (.5 + .5 * cos (2 * pi * ((float) tick) / 200)));
      call Motors.setPitchPower       (             .5 + .5 * cos (2 * pi * ((float) tick) / 100) );
      call Motors.setRollPower        (             .5 + .5 * cos (2 * pi * ((float) tick) / 50 ) );

    }

      /*    positionAndOrientation = call DeadReckoning.updateReckoning (IMU_PERIOD_S, LAandAV.a, scaleV3 (GYRO_SCALE * pi / 180, LAandAV.b));
    position = positionAndOrientation.a; orientation = positionAndOrientation.b;
    errorPosition = addV3 (targetPosition, scaleV3 (-1, position));
    absoluteLinearCorrection = V3 (call XPID.updateError (IMU_PERIOD_S, errorPosition.x), call YPID.updateError (IMU_PERIOD_S, errorPosition.y), call ZPID.updateError (IMU_PERIOD_S, errorPosition.z));
    yawCorrection = call    YawPID.updateError (IMU_PERIOD_S, targetYaw - orientation.yaw);
    linearCorrection = absoluteToRelativeV3 (orientation, absoluteLinearCorrection);

    if (autopilotActive && tick % MOTOR_PERIOD == 0) {
      // T + B = z
      // T - B = yaw
      // -----------
      // T = z + yaw
      // B = z - yaw
      call Motors.setTopRotorPower    (linearCorrection.z + yawCorrection);
      call Motors.setBottomRotorPower (linearCorrection.z - yawCorrection);
      call Motors.setPitchPower       (linearCorrection.y                );
      call Motors.setRollPower        (linearCorrection.x                ); */
  }

}
