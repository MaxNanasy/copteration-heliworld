// With help from http://en.wikipedia.org/wiki/PID_control

// Provides PID for an a that implements Additive with coefficients kp (proportional), ki (integrative), and kd (derivative).
generic module PIDP (typedef a, float kp, float ki, float kd) {
  provides {
    interface PID <a>;
  }
  uses {
    interface Additive <a>;
    interface Integrator <a>;
  }
}

implementation {

  a previousError; // the last recorded error value

  command void PID.initialize (a pe, a it)
  {
    atomic {
      //      kp = p; ki = i; kd = d;
      previousError = pe; call Integrator.initialize (it);
    }
  }

  // In the formulae:
  // t: current time
  // d: time interval since last update
  // e: error
  command a PID.updateError (float dt, a error)
  {
    a integral, derivative;
    atomic {
      // integral (0, t, e (u) * du) = integral (0, t - d, e (u) * du) + d * e (t)
      integral = call Integrator.updateIntegral (dt, error);
      // de (t) / dt = (e (t) - e (t - d)) / d
      derivative = call Additive.scale (1 / dt, call Additive.add (error, call Additive.scale (-1, previousError)));
      previousError = error;
      // pid (t) = kp * e (t) + ki * integral (0, t, e (u) * du) + kd * (de (t) / dt)
      return call Additive.add (call Additive.scale (kp, error), call Additive.add (call Additive.scale (ki, integral), call Additive.scale (kd, derivative)));
    }
  }

}
