#include "IMU.h"

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

  float topRotorPower = 0, bottomRotorPower = 0;
  float aAngle = 0, bAngle = 0;
  bool aReversed = FALSE, bReversed = FALSE;

  uint16_t registers [0x80];
  uint16_t nextValue = 0;

  command error_t Init.init ()
  {
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
    nextValue = (registers [registr >> 1]);
    return toReturn;
  }

  event void MilliTimer.fired ()
  {

  }

}
