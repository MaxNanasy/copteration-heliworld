module RemoteC {
  uses {
    interface Boot;
    interface AMSend;
    interface SplitControl as AMControl;
  }
}

implementation {

  bool remoteRole, roleSet;
  bool autopilotActive;

  message_t remoteMessage [] = {};

  event void Boot.booted ()
  {
    call AMControl.start ();
    if (call AMSend.send (1, remoteMessage, 0) == SUCCESS) {
      dbg ("Remote", "Autopilot toggled (hopefully)\n");
    }
    else {
      dbg ("Remote", "Message failure\n");
    }
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

}
