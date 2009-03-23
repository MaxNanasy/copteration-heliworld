#include "directive.h"

#define PERIOD 1

module RemoteC {
uses {
  interface Boot;
  interface AMSend;
  interface Packet;
  interface SplitControl as AMControl;
  interface GeneralIO as ActivateSwitch;
  interface GeneralIO as LeftSwitch    ;
  interface GeneralIO as RightSwitch   ;
  interface Timer <TMilli>;
  interface Leds;
 }
}

implementation{

  event void Boot.booted()  {

    call AMControl.start();

    call ActivateSwitch.makeInput ();
    call LeftSwitch    .makeInput ();
    call RightSwitch   .makeInput ();

    call Timer.startPeriodic (PERIOD);

  }

  event void AMSend.sendDone(message_t *bufPtr, error_t error)
  {
  }

  event void AMControl.startDone (error_t err)
  {
    if (err != SUCCESS) call AMControl.start ();
  }

  event void AMControl.stopDone (error_t err) { }

  void send (directive dir)
  {
    message_t packet;
    *(directive*)(call Packet.getPayload (&packet, sizeof (directive))) = dir;
    call AMSend.send (AM_BROADCAST_ADDR, &packet, sizeof (directive));
  }

  event void Timer.fired ()
  {

    static bool activateFallback = TRUE, activeSwitchPressed = FALSE;

    if      (! call ActivateSwitch.get ()) {
      call Leds.set (1);
      activeSwitchPressed = TRUE;
      send (activateFallback ? ACTIVATE : DEACTIVATE);
    }
    else if (! call LeftSwitch    .get ()) { call Leds.set (2); send (LEFT ); }
    else if (! call RightSwitch   .get ()) { call Leds.set (4); send (RIGHT); }
    else {
      call Leds.set (7);
      send (STABILIZE);
      if (activeSwitchPressed) {
        activeSwitchPressed = FALSE;
        activateFallback = ! activateFallback;
      }
    }

  }

}
