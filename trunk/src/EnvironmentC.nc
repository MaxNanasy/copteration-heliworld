#include "IMU.h"
#include "Vector3.h"

// This module implements the interface to external components (Motors and IMU) in the simulation.
module EnvironmentC {
  provides {
    interface Motors;
    interface IMU;
    interface Init;
  }
  uses {
    interface Timer <TMilli> as MilliTimer;
  }
}

implementation {

  float topRotorPower, bottomRotorPower, pitchPower, rollPower;
  
  Vector3 position, linearVelocity, orientation, angularVelocity;

  // The value to return for the next IMU transaction.
  uint16_t nextValue;

  command error_t Init.init ()
  {
    topRotorPower = bottomRotorPower = pitchPower = rollPower = 0;
    position = linearVelocity = orientation = angularVelocity = zeroV3;
    nextValue = 0;
    call MilliTimer.startPeriodic (1);
    return SUCCESS;
  }

  // Output is in terms of mg (9.8 mm / s ^ 2).
  Vector3 linearAcceleration ()
  {
    Vector3 accel;
    accel = V3 ( 0, 0, (topRotorPower + bottomRotorPower) );
    // If the helicopter is above the ground, then add gravity; otherwise, zero out Y.
    return V3 ( accel.x, accel.y, position.z > 0 ? accel.z - GRAVITY : 0 );
  }

  Vector3 angularAcceleration ()
  {
    return orientation;
  }

  float max (float x, float y)
  {
    return x < y ? y : x;
  }

  float min (float x, float y)
  {
    return x < y ? x : y;
  }

  async command void Motors.setTopRotorPower (float power)
  {
    topRotorPower = power;
  }

  async command void Motors.setBottomRotorPower (float power)
  {
    bottomRotorPower = power;
  }

  async command void Motors.setPitchPower (float power)
  {
    pitchPower = power;
  }

  async command void Motors.setRollPower (float power)
  {
    rollPower = power;
  }

  async command uint16_t IMU.writeRegister (uint8_t registr, uint8_t value)
  {
    uint16_t toReturn = nextValue;
    nextValue = 0;
    return toReturn;
  }

  // Set nextValue to a 16-bit unsigned integer based on a conceptual representation of the argument float as a two's-complement 14-bit fixed-point number.
  void nextS14 (float x)
  {
    nextValue = (1 << 15) | (((int16_t) x) & ~ (3 << 14));
  }

  async command uint16_t IMU.readRegister (uint8_t registr)
  {
    Vector3 accel = linearAcceleration ();
    uint16_t toReturn = nextValue;

    switch (registr & ~ 1) {
    case XGYRO_OUT:
      nextS14 ( angularVelocity.x  / GYRO_SCALE);
      break;
    case YGYRO_OUT:
      nextS14 ( angularVelocity.y  / GYRO_SCALE);
      break;
    case ZGYRO_OUT:
      nextS14 ( angularVelocity.z  / GYRO_SCALE);
      break;
    case XACCL_OUT:
      nextS14 ( accel.x            / ACCL_SCALE);
      break;
    case YACCL_OUT:
      nextS14 ( accel.y            / ACCL_SCALE);
      break;
    case ZACCL_OUT:
      nextS14 ((accel.z + GRAVITY) / ACCL_SCALE);
      break;
    default:
      dbg ("Environment", "Unsupported register: %d\n", registr);
      nextValue = 0;
    }
    return toReturn;
  }

  event void MilliTimer.fired ()
  {

    position        = addV3 (position       , linearVelocity        );
    orientation     = addV3 (orientation    , angularVelocity       );

    linearVelocity  = addV3 (linearVelocity , linearAcceleration  ());
    angularVelocity = addV3 (angularVelocity, angularAcceleration ());

  }

}
