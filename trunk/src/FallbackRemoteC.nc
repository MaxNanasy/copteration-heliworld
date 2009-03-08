#include "directive.h"

module FallbackRemoteC {
uses {
  interface Boot;
  interface AMSend;
  interface Packet;
  interface SplitControl as AMControl;
  interface GeneralIO as ActiveSwitch;
  interface GeneralIO as LeftSwitch;
  interface GeneralIO as RightSwitch;
 }
}


implementation{

  bool activateFallback;
  message_t activateP, deactivateP, leftP, rightP, fowardP, backwardP, upP, downP, stabilizeP;

  event void Boot.booted()  {
    activateFallback = TRUE;
    call AMControl.start();
    *(uint8_t*)(call Packet.getPayload (&activateP  , sizeof (directive))) = ACTIVATE;
    *(uint8_t*)(call Packet.getPayload (&deactivateP, sizeof (directive))) = DEACTIVATE;
    *(uint8_t*)(call Packet.getPayload (&leftP      , sizeof (directive))) = LEFT;
    *(uint8_t*)(call Packet.getPayload (&rightP     , sizeof (directive))) = RIGHT;
    *(uint8_t*)(call Packet.getPayload (&forwardP   , sizeof (directive))) = FORWARD;
    *(uint8_t*)(call Packet.getPayload (&backwardP  , sizeof (directive))) = BACKWARD;
    *(uint8_t*)(call Packet.getPayload (&upP        , sizeof (directive))) = UP;
    *(uint8_t*)(call Packet.getPayload (&downP      , sizeof (directive))) = DOWN;
    *(uint8_t*)(call Packet.getPayload (&stabilizeP , sizeof (directive))) = STABILIZE;
  }

  event void AMSend.sendDone(message_t *bufPtr, error_t error)
  {
  }

  event void AMControl.startDone (error_t err)
  {
    if (err != SUCCESS) call AMControl.start ();
  }

  event void AMControl.stopDone (error_t err) { }


}
