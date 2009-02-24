#include <Atm128Timer.h>

#define TIME_PERIOD 20 //milliseconds

#define TILT_MS (TILT_TOP / TIME_PERIOD)

#define ROTOR_TOP 1150
#define ROTOR_MAX ROTOR_TOP
#define TILT_TOP 1150	//ticks per time period
#define TILT_MAX (TILT_MS * 2)

module MotorsC {
  provides {
    interface Init;
    interface Motors;
  }
  uses {
    // A: Top rotor
    // B: Bottom rotor
    interface HPLpwm as RotorPWM;
    // A: pitch
    // B: roll
    interface HPLpwm as TiltPWM;
  }
}

implementation {

  command error_t Init.init ()
  {
    call RotorPWM.init ();
    call RotorPWM.setApw (0);
    call RotorPWM.setBpw (0);
    call TiltPWM .setApw (0);
    call TiltPWM .setBpw (0);
    return SUCCESS;
  }

  // To prevent any out-of-range sets.
  float normalize (float x)
  {
    return x < 0 ? 0 : x > 1 ? 1 : x;
  }

  async command void Motors.setTopRotorPower (float power)
  {
    call RotorPWM.setApw (normalize (power) * ROTOR_MAX);
  }

  async command void Motors.setBottomRotorPower (float power)
  {
    call RotorPWM.setBpw (normalize (power) * ROTOR_MAX);
  }

  // All the way to left  is 1 ms (min pulse)
  // All the way to right is 2 ms (max pulse)
  async command void Motors.setPitchPower (float power)
  {
    call TiltPWM.setApw((normalize (power) + 1)*TILT_MS);
  }

  async command void Motors.setRollPower (float power)
  {
    call TiltPWM.setBpw((normalize (power) + 1)*TILT_MS);
  }

}
