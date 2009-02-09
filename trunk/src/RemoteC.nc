module RemoteC {
  provides {
    interface Init;
  }
  uses {
    interface Boot;
    interface GeneralIO as Switch;
    interface AMSend;
    interface SplitControl as AMControl;
    interface Timer<TMilli> as MilliTimer;
    interface Init as IMUInit;
  }
}

implementation {

  bool remoteRole, roleSet;
  bool autopilotActive;

  message_t remoteMessage [] = {};

  event void Boot.booted ()
  {
    call AMControl.start ();
    call MilliTimer.startPeriodic (1000);
  }

  command error_t Init.init ()
  {
    call AMControl.start ();
    call MilliTimer.startPeriodic (1000);
    return SUCCESS;
  }

  event void AMSend.sendDone (message_t *bufPtr, error_t error) {
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
    if (call Switch.get ()) {
      if (call AMSend.send (1, remoteMessage, 0) == SUCCESS) {
	dbg ("Remote", "Autopilot toggled (hopefully)\n");
      }
      else {
	dbg ("Remote", "Message failure\n");
      }
    }
  }

}
