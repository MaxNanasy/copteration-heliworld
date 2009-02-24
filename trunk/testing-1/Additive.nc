// A provider of Additive <a> implements addition of two as, scaling (multiplication) of an a by a float, and an additive identity.
interface Additive <a> {
  command a add (a, a);
  command a scale (float, a);
  command a zero ();
}
