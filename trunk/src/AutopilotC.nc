#include "IMU.h"
#include "Vector3.h"

#define   IMU_PERIOD 5 // Poll   the IMU    every  IMU_PERIOD                 ms.
#define MOTOR_PERIOD 4 // Adjust the motors every (IMU_PERIOD * MOTOR_PERIOD) ms.

// Provides a program for the mote controlling the helicopter.
module AutopilotC {
  uses {
    interface Boot;
    interface Receive;
    interface Timer <TMilli> as MilliTimer;
    interface IMU;
    interface StdControl as IMUControl;
    interface Motors;
    interface Init as MotorsInit;
    interface PID <Vector3> as LinearPID;
    interface PID <float>   as YawPID   ;
    interface SplitControl as AMControl;
    interface AMSend;
    interface Packet;
    interface DeadReckoning;
    // 0: pass-through
    // 1: autopilot
    interface GeneralIO as MuxSelect;
    interface Leds;
    interface BusyWait <TMicro, uint16_t>;
    interface Spi2Byte;
  }
}

implementation {

  bool autopilotActive;

  Vector3 targetPosition;
  float targetYaw;

  event void Boot.booted ()
  {

    uint8_t i, j;

    int16_t accl;

    call MuxSelect.clr ();

    call MotorsInit.init ();

    autopilotActive = FALSE;
    targetPosition = zeroV3;
    targetYaw = 0;

    // Initialize the PIDs with weights of (1, 1, 1) and initial previous error and integral of zero.
    call LinearPID.initialize (1, 1, 1, zeroV3, zeroV3);
    call YawPID.initialize    (1, 1, 1, 0     , 0     );
    call DeadReckoning.initialize (zeroV3, zeroV3);
    call AMControl.start ();

    call IMU.readRegister (YACCL_OUT);

    for (i = 0;; i++) {
      //      call IMUControl.start ();
      //      call Spi2Byte.write (0xFFFF);
      call Leds.set (i);
      for (j = 0; j < 10; j ++)
	call BusyWait.wait (50000);
      //      call Spi2Byte.write (0x0000);
      //      call IMUControl.stop ();
      call Leds.set (++i);
      for (j = 0; j < 10; j ++)
	call BusyWait.wait (50000);
      /*      accl = call IMU.readRegister (YACCL_OUT) << 2;
      if      (accl >= 4 *  535)
	call Leds.set (1); // 001
      else if (accl <= 4 * -535)
	call Leds.set (4); // 100
      else
      call Leds.set (2); // 010 */
    }

  }

  // This callback inspects the contents of the message.  If it is 'A', then the autopilot is activated.  If it is 'D', then the autopilot is deactivated.
  event message_t *Receive.receive (message_t *bufPtr, void *payload, uint8_t len)
  {
    char directive = *(char*)payload;
    dbg ("Autopilot", "directive: %c; length: %d\n", directive, len);
    switch (directive) {
    case 'A':
      if (! autopilotActive) {
		call MilliTimer.startPeriodic (IMU_PERIOD);
		call MuxSelect.set ();
		autopilotActive = TRUE;
		dbg ("Autopilot", "Autopilot activated\n");
      }
      break;
    case 'D':
      if (autopilotActive) {
		call MilliTimer.stop ();
		autopilotActive = FALSE;
		dbg ("Autopilot", "Autopilot deactivated\n");
      }
      break;
    default:
      dbg ("Autopilot", "Junk directive: &c\n", directive);
      }
    return bufPtr;
  }

  event void AMSend.sendDone (message_t *bufPtr, error_t error) { }

  event void AMControl.startDone (error_t err) {
    if (err == SUCCESS) {
    }
    else {
      call AMControl.start ();
    }
  }

  event void AMControl.stopDone (error_t err) { }

  #define CHECKDATA(prev, reg) do { data = call IMU.readRegister (reg); if (data | (1 << 14)) return; LAandAV.prev = data; } while (0)
  void updateData ()
  {

    static int tick = 0;
    static DoubleVector3 LAandAV;
    uint16_t data;
    Vector3 position, orientation, absoluteLinearCorrection, linearCorrection;
    DoubleVector3 positionAndOrientation;
    float yawCorrection;

    tick++;

    call IMU.readRegister(XACCL_OUT);

    CHECKDATA (a.x, YACCL_OUT);
    CHECKDATA (a.y, ZACCL_OUT);
    CHECKDATA (a.z, XGYRO_OUT);
    CHECKDATA (b.pitch, YGYRO_OUT);
    CHECKDATA (b.roll , ZGYRO_OUT);
    CHECKDATA (b.yaw  , ZGYRO_OUT);

    positionAndOrientation = call DeadReckoning.updateReckoning (IMU_PERIOD, LAandAV.a, LAandAV.b);
    position = positionAndOrientation.a; orientation = positionAndOrientation.b;
    dbg ("Autopilot", "Position: %f, %f, %f\n", position.x, position.y, position.z);
    dbg ("Autopilot", "Orientation: %f, %f, %f\n", orientation.roll, orientation.pitch, orientation.yaw);
    yawCorrection            = call    YawPID.updateError (IMU_PERIOD, targetYaw - orientation.yaw);
    absoluteLinearCorrection = call LinearPID.updateError (IMU_PERIOD, addV3 (targetPosition, scaleV3 (-1, position)));
    linearCorrection = absoluteToRelativeV3 (orientation, absoluteLinearCorrection);
    dbg ("Autopilot",               "Yaw correction required: %f\n", yawCorrection);
    dbg ("Autopilot", "Linear correction required (absolute): %f, %f, %f\n", absoluteLinearCorrection.x, absoluteLinearCorrection.y, absoluteLinearCorrection.z);
    dbg ("Autopilot", "Linear correction required (relative): %f, %f, %f\n", linearCorrection.x, linearCorrection.y, linearCorrection.z);

    if (tick % MOTOR_PERIOD == 0) {
      // T + B = z
      // T - B = yaw
      // -----------
      // T = z + yaw
      // B = z - yaw
      call Motors.setTopRotorPower    (linearCorrection.z + yawCorrection);
      call Motors.setBottomRotorPower (linearCorrection.z - yawCorrection);
      call Motors.setPitchPower       (linearCorrection.y                );
      call Motors.setRollPower        (linearCorrection.x                );
    }

  }

  event void MilliTimer.fired () {
    updateData ();
  }

}
