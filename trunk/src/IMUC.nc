module IMUC {
  provides {
    interface IMU;
  }
  uses {
    interface SpiByte;
  }
}

implementation {

  async command uint16_t writeRegister (uint8_t register, uint8_t value)
  {
    uint8_t readHigh, readLow;
    readHigh = call SpiByte.write ((1 << 7) | register);
    readLow = call SpiByte.write (value);
    return (readHigh << 8) | readLow;
  }

  async command uint16_t readRegister (uint8_t register)
  {
    uint8_t readHigh, readLow;
    readHigh = call SpiByte.write (register);
    readLow = call SpiByte.write (0);
    return (readHigh << 8) | readLow;
  }

}
