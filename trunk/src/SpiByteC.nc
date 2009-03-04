module SpiByteC
{
  provides {
    interface SPIByte;
    interface StdControl;
  }
  uses {
    interface GeneralIO as SCLK;
    interface GeneralIO as MISO;
    interface GeneralIO as MOSI;
    interface GeneralIO as SS;
  }
}

implementation
{

  command error_t StdControl.start ()
  {

    call SCLK.makeOutput ();
    call MISO.makeInput  ();
    call MOSI.makeOutput ();
    call SS  .makeOutput ();

    call SS.clr ();

    return SUCCESS;

  }

  command error_t StdControl.stop ()
  {
    call SS.set ();
    return SUCCESS;
  }

  // Code from http://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus#Example_of_bit-banging_the_SPI_Master_protocol
  command uint8_t write (uint8_t x)
  {

    uint8_t bit;

    for (bit = 0; bit < 8; bit++) {

      if (x & 0x80)
	call MOSI.set ();
      else
	call MOSI.clr ();
      x <<= 1;

      delay ();
      SCLK.set ();
      delay ();

      x |= MISO.get ();
      SCLK.clear ();

  }

}
