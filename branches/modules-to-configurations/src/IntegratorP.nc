generic module IntegratorP (typedef a) {
  provides interface Integrator <a>;
  uses interface Additive <a>;
}

implementation {

  a integral;
  
  command void Integrator.initialize (a it)
  {
    integral = it;
  }

  command a Integrator.updateIntegral (float dt, a x)
  {
    integral = call Additive.add (integral, call Additive.scale (dt, x));
    return integral;
  }

}
