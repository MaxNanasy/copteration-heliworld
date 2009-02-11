module RemoteC {
  uses {
    interface Boot;
    interface AMSend;
    interface SplitControl as AMControl;
    interface GpioInterrupt as Switch;
  }
}

implementation {

  bool remoteRole, roleSet;
  bool autopilotActive;

  message_t remoteMessage [] = {};

  event void Boot.booted ()
  {
    call AMControl.start ();
    call Switch.enableRisingEdge ();
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

  event void AMControl.stopDone (error_t err) { }

  async event void Switch.fired ()
  {
    if (call AMSend.send (1, remoteMessage, 0) == SUCCESS) {
      dbg ("Remote", "Autopilot toggled (hopefully)\n");
      // The documentation says "Interrupts keep running until \"disable()\" is called", so I assume this is the proper protocol to reenable.
      call Switch.disable ();
      call Switch.enableRisingEdge ();
    }
    else {
      dbg ("Remote", "Message failure\n");
    }
  }

}
