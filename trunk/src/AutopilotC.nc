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

  bool autopilotActive = FALSE;

  event void Boot.booted ()
  {
    call PID.initialize (1, 1, 1, (Vector3) {0, 0, 0}, (Vector3) {0, 0, 0});
  }

  // This callback does not need to inspect the contents of the message, since each message indicates that the autopilot should be toggled.
  event message_t *Receive.receive (message_t *bufPtr, void *payload, uint8_t len)
  {
    autopilotActive = ! autopilotActive;
    if (autopilotActive) {
      dbg ("Autopilot", "Autopilot on\n");
      call MilliTimer.startPeriodic (250);
    }
    else {
      dbg ("Autopilot", "Autopilot off\n");
      call MilliTimer.stop ();
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

  event void AMControl.stopDone (error_t err) {
  }

  event void MilliTimer.fired () {
    Vector3 a = call PID.updateError (1, (Vector3) {2, -2, 0});
    dbg ("Autopilot", "%f, %f, %f\n", a.x, a.y, a.z);
  }

}
