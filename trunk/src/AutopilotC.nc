/* Yellow (Toggle): The SPI bus has been released.
   Green  (Toggle): The SPI bus has been acquired.
   Red    (Toggle): A timer period has elapsed.
*/

#include "IMU.h"
#include "Vector3.h"

#define TIMER_PERIOD 2000 //We will poll the IMU every 1 milliseconds

// Provides a program for the mote controlling the helicopter.
module AutopilotC {
  uses {
    interface Boot;
    interface Receive;
    interface Timer <TMilli> as MilliTimer;
    interface IMU;
    interface Motors;
    interface SplitControl as IMUControl;
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
    interface Init as MotorsInit;
  }
}

implementation {

  bool autopilotActive;

  Vector3 targetPosition;
  float targetYaw;

  event void Boot.booted ()
  {
    call AMControl.start ();
    call MotorsInit.init ();
    call Motors.setTopRotorPower (0.5);
    call Motors.setBottomRotorPower (0.25);
    call Motors.setPitchPower (0.5);
    call Motors.setRollPower (0.25);
    call MilliTimer.startPeriodic (TIMER_PERIOD);
    //autopilotActive = FALSE;
    //targetPosition = zeroV3;
    //    targetYaw = 0;
    // Initialize the PIDs with weights of (1, 1, 1) and initial previous error and integral of zero.
    //    call LinearPID.initialize (1, 1, 1, zeroV3, zeroV3);
    //    call YawPID.initialize    (1, 1, 1, 0     , 0     );
    //    call DeadReckoning.initialize (zeroV3, zeroV3);
    //    call MuxSelect.clr ();
  }

  // This callback inspects the contents of the message.  If it is 'A', then the autopilot is activated.  If it is 'B', then the autopilot is deactivated.
  event message_t *Receive.receive (message_t *bufPtr, void *payload, uint8_t len)
  {
    char directive = *(char*)payload;
    dbg ("Autopilot", "directive: %c; length: %d\n", directive, len);
    /*  switch (directive) {
    case 'A':
      if (! autopilotActive) {
		call MilliTimer.startPeriodic (TIMER_PERIOD);
	//	call MuxSelect.set ();
		autopilotActive = TRUE;
	//	dbg ("Autopilot", "Autopilot activated\n");
      }
      break;
    case 'D':
      if (autopilotActive) {
		call MilliTimer.stop ();
		autopilotActive = FALSE;
	//	dbg ("Autopilot", "Autopilot deactivated\n");
      }
      break;
    default:
      dbg ("Autopilot", "Junk directive: &c\n", directive);
      }*/
    return bufPtr;
  }

  event void AMSend.sendDone (message_t *bufPtr, error_t error) { call Leds.led2On (); }

  event void AMControl.startDone (error_t err) {
    if (err == SUCCESS) {
    }
    else {
      call AMControl.start ();
    }
  }

  event void AMControl.stopDone (error_t err) { }

  #define CHECKDATA(prev, reg) do { data = call IMU.readRegister (reg); if (data | (1 << 14)) return; LAandAV.prev = data; } while (0)
  event void IMUControl.startDone (error_t)
  {

    static int tick = 0;
    static DoubleVector3 LAandAV;
    uint16_t data;
    Vector3 position, orientation, absoluteLinearCorrection, linearCorrection;
    DoubleVector3 positionAndOrientation;
    float yawCorrection;
    message_t activateP;

    tick++;

    *(char*)(call Packet.getPayload (&activateP, 1)) = 'A';
    call AMSend.send (AM_BROADCAST_ADDR, &activateP, 1);

    /*    call IMU.readRegister(XACCL_OUT);

    CHECKDATA (a.x, YACCL_OUT);
    CHECKDATA (a.y, ZACCL_OUT);
    CHECKDATA (a.z, XGYRO_OUT);
    CHECKDATA (b.pitch, YGYRO_OUT);
    CHECKDATA (b.roll , ZGYRO_OUT);
    CHECKDATA (b.yaw  , ZGYRO_OUT);
    */
    //    call IMUControl.stop ();
    /*positionAndOrientation = call DeadReckoning.updateReckoning (TIMER_PERIOD, LAandAV.a, LAandAV.b);
    position = positionAndOrientation.a; orientation = positionAndOrientation.b;
    dbg ("Autopilot", "Position: %f, %f, %f\n", position.x, position.y, position.z);
    dbg ("Autopilot", "Orientation: %f, %f, %f\n", orientation.roll, orientation.pitch, orientation.yaw);
    yawCorrection            = call    YawPID.updateError (TIMER_PERIOD, targetYaw - orientation.yaw);
    absoluteLinearCorrection = call LinearPID.updateError (TIMER_PERIOD, addV3 (targetPosition, scaleV3 (-1, position)));
    linearCorrection = absoluteToRelativeV3 (orientation, absoluteLinearCorrection);
    dbg ("Autopilot",               "Yaw correction required: %f\n", yawCorrection);
    dbg ("Autopilot", "Linear correction required (absolute): %f, %f, %f\n", absoluteLinearCorrection.x, absoluteLinearCorrection.y, absoluteLinearCorrection.z);
    dbg ("Autopilot", "Linear correction required (relative): %f, %f, %f\n", linearCorrection.x, linearCorrection.y, linearCorrection.z);
    */
    if (tick % 4 == 0) {
      // T + B = z
      // T - B = yaw
      // -----------
      // T = z + yaw
      // B = z - yaw
      //call Motors.setTopRotorPower    (linearCorrection.z + yawCorrection);
      //call Motors.setBottomRotorPower (linearCorrection.z - yawCorrection);
      //call Motors.setPitchPower       (linearCorrection.y                );
      //call Motors.setRollPower        (linearCorrection.x                );
    }

  }

  event void IMUControl.stopDone (error_t e)
  {
    /*    switch (e) {
    case SUCCESS:
      break;
    case FAIL:
      break;
      } */
  }

  event void MilliTimer.fired () {
    call IMUControl.start ();
  }

}
