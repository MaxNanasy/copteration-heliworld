module IMUC {
  provides {
    interface IMU;
  }
  uses {
    interface SpiByte;
  }
}

implementation {

  async command uint16_t IMU.writeRegister (uint8_t registr, uint8_t value)
  {
    uint8_t readHigh, readLow;
    readHigh = call SpiByte.write ((1 << 7) | registr);
    readLow = call SpiByte.write (value);
    return (readHigh << 8) | readLow;
  }

  async command uint16_t IMU.readRegister (uint8_t registr)
  {
    uint8_t readHigh, readLow;
    readHigh = call SpiByte.write (registr);
    readLow = call SpiByte.write (0);
    return (readHigh << 8) | readLow;
  }

}
