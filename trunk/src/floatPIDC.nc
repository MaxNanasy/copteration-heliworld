generic configuration floatPIDC (float kp, float ki, float kd) {
  provides interface PID <float>;
}

implementation {

  components floatC, new floatIntegratorC (), new PIDP (float, kp, ki, kd);

  PID = PIDP;

  PIDP.Additive -> floatC;
  PIDP.Integrator -> floatIntegratorC;

}
