// A provider of PID <a> implements a Proportional-Integrative-Derivative Controller that operates on values of type a.
interface PID <a> {

  // Input: (initial previous error, initial integral)
  command void initialize (a, a);

  // Input: (time elapsed, error)
  // Output: correction
  command a updateError (float, a);

}
