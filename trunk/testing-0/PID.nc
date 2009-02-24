// A provider of PID <a> implements a Proportional-Integrative-Derivative Controller that operates on values of type a.
interface PID <a> {

  // Input: (P weight, I weight, D weight, initial previous error, initial integral)
  async command void initialize (float, float, float, a, a);

  // Input: (time elapsed, error)
  // Output: correction
  async command a updateError (float, a);

}
