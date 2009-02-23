// With help from http://en.wikipedia.org/wiki/PID_control

// Provides PID for an a that implements Additive.
generic module PIDC (typedef a) {
  provides {
    interface PID <a>;
  }
  uses {
    interface Additive <a>;
    interface Integrator <a>;
  }
}

implementation {

  float kp, ki, kd; // P weight, I weight, D weight
  a previousError; // the last recorded error value, the time-weighted summation of all known error values

  async command void PID.initialize (float p, float i, float d, a pe, a it)
  {
    kp = p; ki = i; kd = d;
    previousError = pe; call Integrator.initialize (it);
  }

  async command a PID.updateError (float dt, a error)
  {
    a integral, derivative;
    // integral (0, t, e (u) * du) = integral (0, t - d, e (u) * du) + d * e (t)
    integral = call Integrator.updateIntegral (dt, error);
    // de (t) / dt = (e (t) - e (t - d)) / d
    derivative = call Additive.scale (1 / dt, call Additive.add (error, call Additive.scale (-1, previousError)));
    previousError = error;
    // pid (t) = kp * e (t) + ki * integral (0, t, e (u) * du) + kd * (de (t) / dt)
    return call Additive.add (call Additive.scale (kp, error), call Additive.add (call Additive.scale (ki, integral), call Additive.scale (kd, derivative)));
  }

}
