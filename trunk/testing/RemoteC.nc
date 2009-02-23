// Provides a program for the mote that, when a button is pressed, signals the autopilot to begin.
module RemoteC {
  uses {
    interface Boot;
    interface AMSend;
    interface Packet;
    interface SplitControl as AMControl;
    interface GeneralIO as On;
    interface GeneralIO as Off;
    interface Leds;
    //interface Timer <TMilli>;
    interface Alarm <TMicro, uint32_t>;
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
    call On.makeInput ();
    call Off.makeInput ();
   
    activateAutopilot = TRUE;
    call AMControl.start ();
    *(char*)(call Packet.getPayload (&activateP  , 1)) = 'A';
    *(char*)(call Packet.getPayload (&deactivateP, 1)) = 'D';
    //    call Timer.startPeriodic (1);
    //    call Switch.enableRisingEdge ();
    call Alarm.start (1000);
  }

  event void AMSend.sendDone (message_t *bufPtr, error_t error)
  {
    if (error == SUCCESS)
      call Leds.led0Toggle ();
    /*    if (error == SUCCESS) {
      // The documentation says "Interrupts keep running until \"disable()\" is called", so I assume this is the proper protocol to reenable interrupts after they have been processed.
      call Switch.disable ();
      call Switch.enableRisingEdge ();
      if (activateAutopilot) { dbg ("Remote", "Autopilot activated (hopefully)\n"); Leds.led0On (); }
      else                   { dbg ("Remote", "Autopilot deactivated (hopefully)\n"); Leds.led0Off (); }
      activateAutopilot = ! activateAutopilot;
      } */
  }

  event void AMControl.startDone (error_t err) {
    if (err == SUCCESS) {
    }
    else {
      call AMControl.start ();	call Leds.led2Toggle ();

    }
  }

  event void AMControl.stopDone (error_t err) { }

  async event void Alarm.fired ()
  {
    if (!call Off.get ()) {
      call Leds.led1On ();
      call AMSend.send (AM_BROADCAST_ADDR, &deactivateP, 1);
    }
    else {
      call Leds.led1Off ();
    }
    if (!call On .get ()) {
      call Leds.led2On ();
      call AMSend.send (AM_BROADCAST_ADDR, &activateP, 1);
    }
    else {
      call Leds.led2Off ();
    }

    call Alarm.start (100);

    /*    if (call AMSend.send (AM_BROADCAST_ADDR, activateAutopilot ? &activateP : &deactivateP, 1) == SUCCESS) {
    }
    else {
      dbg ("Remote", "Message failure\n");
      }*/
  }

}
