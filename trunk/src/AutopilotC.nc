#include "IMU.h"
#include "Vector3.h"

#define TIMER_PERIOD 250

// Provides a program for the mote controlling the helicopter.
module AutopilotC {
  uses {
    interface Boot;
    interface Init;
    interface Receive;
    interface Timer <TMilli> as MilliTimer;
    interface IMU;
    interface Motors;
    interface StdControl as IMUControl;
    interface PID <Vector3> as LinearPID;
    interface PID <float>   as YawPID   ;
    interface SplitControl as AMControl;
    interface Alarm<TMicro, uint32_t>; 
    interface MainLoop;
    interface DeadReckoning;
    interface GeneralIO as MuxSelectBit;
  }
}

implementation {

  bool autopilotActive;

  Vector3 targetPosition;
  float targetYaw;

  event void Boot.booted ()
  {
  	dbg ("Autopilot", "%d %d %d %d\n", TCNT0, TCNT1, TCNT2, TCNT3);
    autopilotActive = FALSE;
    targetPosition = zeroV3;
    targetYaw = 0;
    // Initialize the PIDs with weights of (1, 1, 1) and initial previous error and integral of zero.
    call LinearPID.initialize (1, 1, 1, zeroV3, zeroV3);
    call YawPID.initialize (1, 1, 1, 0, 0);
    call DeadReckoning.initialize (zeroV3, zeroV3);
    call Init.init ();
    call MainLoop.main_loop();
  }

  // This callback inspects the contents of the message.  If it is 'A', then the autopilot is activated.  If it is 'B', then the autopilot is deactivated.  since each message indicates that the autopilot should be toggled.
  event message_t *Receive.receive (message_t *bufPtr, void *payload, uint8_t len)
  {
    char directive = *(char*)payload;
    dbg ("Autopilot", "directive: %c; length: %d\n", directive, len);
    switch (directive) {
    case 'A':
      if (! autopilotActive) {
	call MilliTimer.startPeriodic (TIMER_PERIOD);
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

  event void AMControl.startDone (error_t err) {
    if (err == SUCCESS) {
    }
    else {
      call AMControl.start ();
    }
  }

  event void AMControl.stopDone (error_t err) { }


  event void MilliTimer.fired () {
    Vector3 heliAcceleration = (call IMU.readRegister (XACCL_OUT), (Vector3) { call IMU.readRegister (YACCL_OUT), call IMU.readRegister (ZACCL_OUT), call IMU.readRegister (XGYRO_OUT) }), heliOrientation = (Vector3) { call IMU.readRegister (YGYRO_OUT), call IMU.readRegister (ZGYRO_OUT), call IMU.readRegister (ZGYRO_OUT) }, position, orientation;
    DoubleVector3 positionAndOrientation = call DeadReckoning.updateReckoning (TIMER_PERIOD, heliAcceleration, heliOrientation);
    float yawCorrection;
    position = positionAndOrientation.a; orientation = positionAndOrientation.b;
    dbg ("Autopilot", "Position: %f, %f, %f\n", position.x, position.y, position.z);
    dbg ("Autopilot", "Orientation: %f, %f, %f\n", orientation.x, orientation.y, orientation.z);
    yawCorrection = call YawPID.updateError (TIMER_PERIOD, orientation.z - targetYaw);
    dbg ("Autopilot", "Yaw correction required: %f, %f, %f\n", yawCorrection);
  }
  
  async event void Alarm.fired()
  {
  }

}
