#include "Vector3.h"

interface DeadReckoning {

  // Input: (linear position, orientation)
  // Assumes that acceleration and velocity are currently 0.
  command void initialize (Vector3, Vector3);

  // Input: (time elapsed, linear acceleration, angular velocity)
  // Output: (linear position, orientation)
  command DoubleVector3 updateReckoning (float, Vector3, Vector3);

}
