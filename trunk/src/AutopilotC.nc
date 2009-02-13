#include "IMU.h"
#include "Vector3.h"

// Provides a program for the mote controlling the helicopter.
module AutopilotC {
  uses {
    interface Boot;
    interface Receive;
    interface Timer <TMilli> as MilliTimer;
    interface IMU;
    interface Motors;
    interface StdControl as IMUControl;
    interface PID <Vector3>;
    interface SplitControl as AMControl;
  }
}

implementation {

  bool autopilotActive;

  event void Boot.booted ()
  {
    autopilotActive = FALSE;
    // Initialize the PID with weights of (1, 1, 1) and initial previous error and integral of zero.
    call PID.initialize (1, 1, 1, (Vector3) {0, 0, 0}, (Vector3) {0, 0, 0});
  }

  // This callback inspects the contents of the message.  If it is 'A', then the autopilot is activated.  If it is 'B', then the autopilot is deactivated.  since each message indicates that the autopilot should be toggled.
  event message_t *Receive.receive (message_t *bufPtr, void *payload, uint8_t len)
  {
    char directive = *(char*)payload;
    dbg ("Autopilot", "directive: %c; length: %d\n", directive, len);
    switch (directive) {
    case 'A':
      if (! autopilotActive) {
	call MilliTimer.startPeriodic (250);
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
    Vector3 heliAcceleration = (call IMU.readRegister (XACCL_OUT), (Vector3) { call IMU.readRegister (YACCL_OUT), call IMU.readRegister (ZACCL_OUT), call IMU.readRegister (XGYRO_OUT) }), heliOrientation = (Vector3) { call IMU.readRegister (YGYRO_OUT), call IMU.readRegister (ZGYRO_OUT), call IMU.readRegister (ZGYRO_OUT) };
    dbg ("Autopilot", "Acceleration: %f, %f, %f\n", heliAcceleration.x, heliAcceleration.y, heliAcceleration.z);
    dbg ("Autopilot", "Orientation: %f, %f, %f\n", heliOrientation.x, heliOrientation.y, heliOrientation.z);
  }

}
