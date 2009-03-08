#include "util.h"
#include "IMU.h"
#include "Spi.h"

// This module implements communication with the IMU through SPI.
module IMUC {
  provides {
    interface IMU;
    interface Init;
  }
  uses {
    interface Spi2Byte;
    interface Init as Spi2Init;
    interface GeneralIO as Reset;
    interface BusyWait <TMicro, uint16_t>;
  }
}

implementation {

  command error_t Init.init ()
  {
    call Spi2Init.init ();
    call Reset.clr ();
    call BusyWait.wait (1000);
    call Reset.set ();
  }

  void afterFrameDelay ()
  {
    call BusyWait.wait (max (DATARATE - 18 * SPI_PERIOD, DATASTALL));
  }

  async command uint16_t IMU.writeRegister (uint8_t registr, uint8_t value)
  {    
    // When writing a register, the first bit in the write request must be high.
    uint16_t ret = call Spi2Byte.write ((1 << 15) | registr << 8 | value);
    afterFrameDelay ();
    return ret;
  }

  async command uint16_t IMU.readRegister (uint8_t registr)
  {
    // When reading a register, the first bit in the read request must be low.
    uint16_t ret = call Spi2Byte.write (registr << 8);
    afterFrameDelay ();
    return ret;
  }

}
