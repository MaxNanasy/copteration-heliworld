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
    call LAtoLV.initialize (zeroV3     );
    call LVtoLP.initialize (position   );
    call AVtoO .initialize (orientation);
  }

  command DoubleVector3 DeadReckoning.updateReckoning (float dt, Vector3 linearAcceleration, Vector3 angularVelocity)
  {
    DoubleVector3 positionAndOrientation;
    positionAndOrientation.b = call AVtoO.updateIntegral (dt, angularVelocity);
    positionAndOrientation.a = call LVtoLP.updateIntegral (dt, call LAtoLV.updateIntegral (dt, relativeToAbsoluteV3 (linearAcceleration, positionAndOrientation.b)));
    return positionAndOrientation;
  }

}
