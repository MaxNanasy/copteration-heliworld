#include "IMU.h"
#include "Vector3.h"

module EnvironmentC {
  provides {
    interface Motors;
    interface IMU;
    interface Init;
  }
  uses {
    interface Timer<TMilli> as MilliTimer;
  }
}

implementation {

  float topRotorPower, bottomRotorPower;
  float aAngle, bAngle;
  bool aReversed, bReversed;

  Vector3 heliPosition, heliVelocity, heliOrientation;

  uint16_t registers [0x80];
  uint16_t nextValue;

  command error_t Init.init ()
  {
    topRotorPower = bottomRotorPower = aAngle = bAngle = 0;
    aReversed = bReversed = FALSE;
    heliPosition = heliVelocity = heliOrientation = (Vector3) { 0, 0, 0 };
    nextValue = 0;
    call MilliTimer.startPeriodic (1);
    return SUCCESS;
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

  async command void Motors.rotateA ()
  {
    if (aReversed) {
      aAngle = max (-1.5, aAngle - .1);
    }
    else {
      aAngle = min ( 1.5, aAngle + .1);
    }
  }

  async command void Motors.switchA ()
  {
    aReversed = ! aReversed;
  }

  async command void Motors.rotateB ()
  {
    if (bReversed) {
      bAngle = max (-1.5, bAngle - .1);
    }
    else {
      bAngle = min ( 1.5, bAngle + .1);
    }
  }

  async command void Motors.switchB ()
  {
    bReversed = ! bReversed;
  }

  async command uint16_t IMU.writeRegister (uint8_t registr, uint8_t value)
  {
    uint16_t toReturn = nextValue;
    ((uint8_t *) registers) [registr] = value;
    nextValue = 0;
    return toReturn;
  }

  async command uint16_t IMU.readRegister (uint8_t registr)
  {
    uint16_t toReturn = nextValue;
    switch (registr) {
    case XGYRO_OUT:
      nextValue = heliOrientation.x;
      break;
    case YGYRO_OUT:
      nextValue = heliOrientation.y;
      break;
    case ZGYRO_OUT:
      nextValue = heliOrientation.z;
      break;
    case XACCL_OUT:
      //      nextValue = topRotor
    default:
      nextValue = (registers [registr >> 1]);
    }
    return toReturn;
  }

  event void MilliTimer.fired ()
  {
    
  }

}
