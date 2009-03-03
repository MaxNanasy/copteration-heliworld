// This module implements communication with the IMU through SPI.
module IMUC {
  provides {
    interface IMU;
    interface SplitControl;
  }
  uses {
    interface SpiByte;
    interface Resource as SpiResource;
    interface ChipSpiResource;
    interface Leds;
  }
}

implementation {

  error_t acquireSpiResource ();
  void wasGranted ();

  command error_t SplitControl.start() {
    switch (acquireSpiResource ()) {
    case SUCCESS:
      if (call SpiResource.isOwner ()) {
	call Leds.led1Toggle ();
	wasGranted ();
      }
      break;
    case FAIL:
      call Leds.led2Toggle ();
      break;
    case EBUSY:
      break;
    }
    return SUCCESS;
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

  void wasGranted ()
  {
    signal SplitControl.startDone (SUCCESS);
  }

  event void SpiResource.granted ()
  {
    wasGranted ();
  }

  command error_t SplitControl.stop ()
  {
    signal SplitControl.stopDone (call SpiResource.release ());
    return SUCCESS;
  }

  async event void ChipSpiResource.releasing () //the SPI bus is about to be automatically released
  {
  }

  error_t acquireSpiResource () {
    error_t error = call SpiResource.immediateRequest (), newError;
    if ( error != SUCCESS ) {
      newError = call SpiResource.request ();
      if (newError != SUCCESS)
	error = newError;
    }
    return error;
  }

}
