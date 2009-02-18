module floatC {
  provides {
    interface Additive <float>;
  }
}

implementation {

  command float Additive.add (float x, float y)
  {
    return x + y;
  }

  command float Additive.scale (float x, float y)
  {
    return x * y;
  }

}
