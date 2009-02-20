#include <Atm128Timer.h>

#define TIME_PERIOD 20.6

#define TILT_MS (

#define ROTOR_TOP 1150
#define ROTOR_MAX ROTOR_TOP
#define TILT_TOP 1150
#define TILT_MAX 1150 / 10

module MotorsC {
  provides {
    interface Init;
    interface Motors;
  }
  uses {
    // A: Top rotor
    // B: Bottom rotor
    interface HPLT1pwm as RotorPWM;
    // A: 
    interface HPLT1pwm as TiltPWM;
  }
}

implementation {

  async command error_t Init.init ()
  {
    RotorPWM.setApw (0);
    RotorPWM.setBpw (0);
    TiltPWM .setApw (0);
    TiltPWM .setBpw (0);
    return SUCCESS;
  }

  async command void Motors.setTopRotorPower (float power)
  {
    RotorPWM.setApw (power * ROTOR_MAX);
  }

  async command void Motors.setBottomRotorPower (float power)
  {
    RotorPWM.setBpw (power * ROTOR_MAX);
  }

  async command void Motors.setPitchPower (float power)
  {
    
  }

  async command void Motors.setRollPower (float power)
  {
    
  }

}
