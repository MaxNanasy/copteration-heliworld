#include "Vector3.h"

module DeadReckoningC {
  provides {
    interface DeadReckoning;
  }
  uses {
    interface Integrator <Vector3> as LAtoLV; // Linear acceleration integrated to linear velocity
    interface Integrator <Vector3> as LVtoLP; // Linear velocity     integrated to linear position
    interface Integrator <Vector3> as AVtoO ; // Angular velocity    integrated to orientation
  }
}

implementation {

  command void DeadReckoning.initialize (Vector3 position, Vector3 orientation)
  {
    call LAtoLV.initialize (zeroV3);
    call LVtoLP.initialize (position);
    call AVtoO.initialize (orientation);
  }

  // This code doesn't actually work properly yet, since linear quantities are measured relative to the helicopter's orientation, and this code treats them as absolute.
  command DoubleVector3 DeadReckoning.updateReckoning (float dt, Vector3 linearAcceleration, Vector3 angularVelocity)
  {
    DoubleVector3 toReturn;
    toReturn.a = call LVtoLP.updateIntegral (dt, call LAtoLV.updateIntegral (dt, linearAcceleration));
    toReturn.b = call AVtoO.updateIntegral (dt, angularVelocity);
    return toReturn;
  }

}
