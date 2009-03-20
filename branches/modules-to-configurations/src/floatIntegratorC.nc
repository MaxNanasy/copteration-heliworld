generic configuration floatIntegratorC () {
  provides interface Integrator <float>;
}

implementation {

  components floatC, new IntegratorP (float);

  Integrator = IntegratorC;

  IntegratorP.Additive -> floatC;

}
