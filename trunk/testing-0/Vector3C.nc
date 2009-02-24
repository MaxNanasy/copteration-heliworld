#include "Vector3.h"

module Vector3C {
  provides {
    interface Additive <Vector3>;
  }
}

implementation {

  command Vector3 Additive.add (Vector3 a, Vector3 b)
  {
    return addV3 (a, b);
  }

  command Vector3 Additive.scale (float a, Vector3 b)
  {
    return scaleV3 (a, b);
  }

  command Vector3 Additive.zero ()
  {
    return zeroV3;
  }

}
