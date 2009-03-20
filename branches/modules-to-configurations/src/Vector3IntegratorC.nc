generic configuration Vector3IntegratorC () {
  provides interface Integrator <Vector3>;
}

implementation {

  components Vector3C, new IntegratorP (Vector3);

  Integrator = IntegratorP;

  IntegratorP.Additive -> Vector3C;

}

