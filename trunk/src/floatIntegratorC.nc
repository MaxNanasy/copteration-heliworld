generic configuration floatIntegratorC () {
  provides interface Integrator <float>;
}

implementation {

  components floatC, new IntegratorP (float);

  Integrator = IntegratorP;

  IntegratorP.Additive -> floatC;

}
