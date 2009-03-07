generic module SpiByteC (uint16_t period)
{
  provides {
    interface Spi2Byte;
    interface StdControl;
  }
  uses {
    interface GeneralIO as SCLK;
    interface GeneralIO as MISO;
    interface GeneralIO as MOSI;
    interface GeneralIO as SS  ;
    interface BusyWait <TMicro, uint16_t>;
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

    call SCLK.set ();
    call SS  .clr ();

    return SUCCESS;

  }

  command error_t StdControl.stop ()
  {
    call SS.set ();
    return SUCCESS;
  }

  inline void delay ()
  {
    call BusyWait.wait (period / 2);
  }

  // Code from http://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus#Example_of_bit-banging_the_SPI_Master_protocol
  async command uint16_t Spi2Byte.write (uint16_t x)
  {

    uint16_t bit;

    for (bit = 0; bit < 16; bit++) {

      if (x & 0x80)
	call MOSI.set ();
      else
	call MOSI.clr ();
      x <<= 1;

      delay ();
      call SCLK.toggle ();
      delay ();

      x |= call MISO.get ();
      call SCLK.toggle ();

    }

    return x;

  }

}


ss is high.

set ss low

delay

write bit
set clock low

delay

set clock high
read bit

delay 

set clock low
write bit

delay

set clock high...
