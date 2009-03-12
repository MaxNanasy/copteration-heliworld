#define PERIOD 1

// Provides a program for the mote that, when a button is pressed, signals the autopilot to begin.
module RemoteC {
  uses {
    interface Boot;
    interface AMSend;
    interface Packet;
    interface SplitControl as AMControl;
    interface GeneralIO as Switch;
    interface Leds;
    interface Timer <TMilli>;
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
    call Switch.makeInput ();
    activateAutopilot = TRUE;
    call AMControl.start ();
    *(char*)(call Packet.getPayload (&activateP  , 1)) = 'A';
    *(char*)(call Packet.getPayload (&deactivateP, 1)) = 'D';
    call Timer.startPeriodic (1);
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

  event void Timer.fired ()
  {

    static bool switchPressed = FALSE;

    if (! call Switch.get ()) {
      call Leds.set (7);
      switchPressed = TRUE;
      if (activateAutopilot) {
	call AMSend.send (AM_BROADCAST_ADDR, &activateP, 1);
      }
      else {
	call AMSend.send (AM_BROADCAST_ADDR, &deactivateP, 1);
      }
    }
    else {
      if (switchPressed) {
	call Leds.set (0);
	switchPressed = FALSE;
	activateAutopilot = ! activateAutopilot;
      }
    }

  }

}
