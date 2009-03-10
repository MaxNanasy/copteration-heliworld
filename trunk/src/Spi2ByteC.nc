/*
 * Please note that all output using SPI has been inverted, since we pass our SPI signals through
 * an inverting buffer.
*/
#include "util.h"

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

    call SS  .clr ();
    call SCLK.clr ();

    return SUCCESS;
  }

  inline void delay ()
  {
    call BusyWait.wait (period / 2);
  }
  
  inline void delay2 () {
    call BusyWait.wait (max (1, period / 2 - 10));
  }

  // Code from http://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus#Example_of_bit-banging_the_SPI_Master_protocol
  async command uint16_t Spi2Byte.write (uint16_t x)
  {

    uint8_t bit;

    call SCLK.clr ();
    call SS  .set ();

    delay ();

    for (bit = 0; bit < 16; bit++) {

      if (x & (1 << 15))
	call MOSI.clr ();
      else
	call MOSI.set ();
      x <<= 1;

      call SCLK.set ();
      delay2 ();  //could call delay2 here?

      x |= call MISO.get ();

      call SCLK.clr ();
      delay ();

    }

    call SS.clr ();

    delay ();
    delay ();

    return x;

  }

}

/*
INVERT THIS FOR OUR SETUP

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
