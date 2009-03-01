// This module implements communication with the IMU through SPI.
module IMUC {
  provides {
    interface IMU;
    interface Init;
  }
  uses {
    interface SpiByte;
    interface Resource as SpiResource;
    interface ChipSpiResource;
  }
}

implementation {

  command error_t init() {
    
  }

  async command uint16_t IMU.writeRegister (uint8_t registr, uint8_t value)
  {
    uint8_t readHigh, readLow;
    // When writing a register, the first bit in the write request must be high.
    readHigh = call SpiByte.write ((1 << 7) | registr);
    readLow = call SpiByte.write (value);
    return (readHigh << 8) | readLow;
  }

  async command uint16_t IMU.readRegister (uint8_t registr)
  {
    uint8_t readHigh, readLow;
    // When reading a register, the first bit in the read request must be low.
    readHigh = call SpiByte.write (registr);
    // The byte written at this point is ignored by the IMU.
    readLow = call SpiByte.write (0);
    return (readHigh << 8) | readLow;
  }

  event void granted() {
     
  }

  event void releasing() { //the SPI bus is about to be automatically released

  }

  error_t acquireSpiResource() {
    error_t error = call SpiResource.immediateRequest();
    if ( error != SUCCESS ) {
      call SpiResource.request();
    }
    return error;
  }


}
