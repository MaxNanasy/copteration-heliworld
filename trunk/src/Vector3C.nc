#include "Vector3.h"

module Vector3C {
  provides {
    interface Additive <Vector3>;
  }
}

implementation {

  command Vector3 Additive.add (Vector3 a, Vector3 b)
  {
    return (Vector3) { a.x + b.x, a.y + b.y, a.z + b.z };
  }

  command Vector3 Additive.scale (float a, Vector3 b)
  {
    return (Vector3) { a * b.x, a * b.y, a * b.z };
  }

}
