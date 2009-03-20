#include "directive.h"

#define LEFT_POWER 0.25
#define RIGHT_POWER 0.75
#define FORWARD_POWER 0.75
#define BACKWARD_POWER 0.25
#define UPWARD_POWER 0.8
#define DOWNWARD_POWER 0.4
#define STABLE_ROTOR_POWER 0.6
#define STABLE_PITCH_POWER 0.5
#define STABLE_ROLL_POWER 0.5

module FallbackC {
  uses {
    interface Boot;
    interface Receive;
    interface Motors;
    interface Init as MotorsInit;
    interface SplitControl as AMControl;
    interface StdControl as MuxControl;
    interface Init as MuxInit;
    interface Leds;
  }
}

implementation {
  bool fallbackActive;
  
  event void Boot.booted() {
    
    call MuxInit.init();
    call MotorsInit.init();
    
    fallbackActive = FALSE;
    
    call AMControl.start(); 
  }

  void stabilize ()
  {
    call Motors.setTopRotorPower (STABLE_ROTOR_POWER);
    call Motors.setBottomRotorPower (STABLE_ROTOR_POWER);
    call Motors.setPitchPower (STABLE_PITCH_POWER);
    call Motors.setRollPower (STABLE_ROLL_POWER);
  }

  event message_t *Receive.receive (message_t *bufPtr, void *payload, uint8_t len) {

    static directive state = DEACTIVATE;
    directive dir = *(directive*)payload;

    if (dir != state) stabilize ();

    if (fallbackActive)
      switch (dir) {
      case DEACTIVATE:
        call MuxControl.stop ();
        fallbackActive = FALSE;
        break;
      case LEFT:
        call Motors.setRollPower(LEFT_POWER);
        break;
      case RIGHT:
        call Motors.setRollPower(RIGHT_POWER);
        break;
      case UP:
        call Motors.setTopRotorPower    (UPWARD_POWER);
        call Motors.setBottomRotorPower (UPWARD_POWER);
        break;
      case DOWN:
        call Motors.setTopRotorPower    (DOWNWARD_POWER);
        call Motors.setBottomRotorPower (DOWNWARD_POWER);
      case STABILIZE:
      default:
        stabilize ();
      }
    else switch (dir) {
      case ACTIVATE:
	call MuxControl.start ();
	fallbackActive = TRUE;
	break;
      default:
      }

    return bufPtr;

  }

  event void AMControl.startDone (error_t err)
  {
    if (err != SUCCESS) call AMControl.start ();
  }

  event void AMControl.stopDone (error_t err) { }

}
