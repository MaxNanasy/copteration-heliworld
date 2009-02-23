//An interface for performing integrations required by the autopilot
interface Integrator<a> {
  command void initialize(a);
  command a updateIntegral(float, a);
}