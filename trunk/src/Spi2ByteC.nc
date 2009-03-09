generic module Spi2ByteC (uint16_t period)
{
  provides {
    interface Spi2Byte;
    interface Init;
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

  command error_t Init.init ()
  {
    call SCLK.makeOutput ();
    call MISO.makeInput  ();
    call MOSI.makeOutput ();
    call SS  .makeOutput ();

    call SS  .set ();
    call SCLK.set ();

    return SUCCESS;
  }

  inline void delay ()
  {
    call BusyWait.wait (period / 2);
  }

  // Code from http://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus#Example_of_bit-banging_the_SPI_Master_protocol
  async command uint16_t Spi2Byte.write (uint16_t x)
  {

    uint8_t bit;

    call SCLK.set ();
    call SS  .clr ();

    delay ();

    for (bit = 0; bit < 16; bit++) {

      if (x & (1 << 15))
	call MOSI.set ();
      else
	call MOSI.clr ();
      x <<= 1;

      call SCLK.clr ();
      delay ();

      x |= call MISO.get ();

      call SCLK.set ();
      delay ();

    }

    call SS.set ();

    delay ();
    delay ();

    return x;

  }

}

/*
ss is high.

set sclk high
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
*/
