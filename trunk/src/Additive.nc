// A provider of Additive <a> implements addition of two as and scaling (multiplication) of an a by a float.
interface Additive <a> {
  command a add (a, a);
  command a scale (float, a);
}
