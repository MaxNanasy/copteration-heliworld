// Provides a program for the mote that, when a button is pressed, signals the autopilot to begin.
module RemoteC {
  uses {
    interface Boot;
    interface AMSend;
    interface Packet;
    interface SplitControl as AMControl;
    interface GpioInterrupt as Switch;
  }
}

implementation {

  // TRUE : Send an  activation packet.
  // FALSE: Send a deactivation packet.
  bool activateAutopilot;

  // Packets for activation and deactivation respectively.
  message_t activateP, deactivateP;

  event void Boot.booted ()
  {
    activateAutopilot = TRUE;
    call AMControl.start ();
    *(char*)(call Packet.getPayload (&activateP  , 1)) = 'A';
    *(char*)(call Packet.getPayload (&deactivateP, 1)) = 'D';
    call Switch.enableRisingEdge ();
  }

  event void AMSend.sendDone (message_t *bufPtr, error_t error)
  {
    if (error == SUCCESS) {
      // The documentation says 'Interrupts keep running until "disable()" is called', so I assume this is the proper protocol to reenable interrupts after they have been processed.
      call Switch.disable ();
      call Switch.enableRisingEdge ();
      if (activateAutopilot) { dbg ("Remote", "Autopilot activated (hopefully)\n"); }
      else                   { dbg ("Remote", "Autopilot deactivated (hopefully)\n"); }
      activateAutopilot = ! activateAutopilot;
    }
  }

  event void AMControl.startDone (error_t err) {
    if (err == SUCCESS) {
    }
    else {
      call AMControl.start ();
    }
  }

  event void AMControl.stopDone (error_t err) { }

  // When this is fired, the button has been pressed.
  async event void Switch.fired ()
  {
    if (call AMSend.send (AM_BROADCAST_ADDR, activateAutopilot ? &activateP : &deactivateP, 1) == SUCCESS) {
    }
    else {
      dbg ("Remote", "Message failure\n");
    }
  }

}
