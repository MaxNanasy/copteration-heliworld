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
    call Reset.set ();
    call BusyWait.wait (40);
    call Reset.clr ();
  }

  async command uint16_t IMU.writeRegister (uint8_t registr, uint8_t value)
  {
    
    // When writing a register, the first bit in the write request must be high.
    return call Spi2Byte.write ((1 << 15) | registr << 8 | value);
  }

  async command uint16_t IMU.readRegister (uint8_t registr)
  {
    // When reading a register, the first bit in the read request must be low.
    return call Spi2Byte.write (registr << 8);
  }

}
