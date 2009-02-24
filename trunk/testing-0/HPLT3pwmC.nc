/* HPLT3pwmC.nc -- Code to use Timer3A and 3B for Pulse Width Modulation or
 *   Frequency Generator outputs on PWM3a,b (ports PB5,6).
 *	Defaults to values used to control "hobby-servo" motors
 *	 but includes a more general PWM setup interface.
 *
 * Authors:		M.Schippling
 * Based on HPLMotor.nc in the contrib/cotsbots project by Sarah Bergbreiter
 */
#include "avr_definitions.h"

module HPLT3pwmC
{
  provides interface HPLpwm;
}
implementation
{
// assign PWM pin names
TOSH_ASSIGN_PIN(PWM3Aout, E, 5);	// port,pin B5
TOSH_ASSIGN_PIN(PWM3Bout, E, 6);	// port,pin B6
 
  /** init()
   *  Setup the Timer3A,B for Phase and Frequency correct PWM
   *   default settings: /64 internal clock pre-scale
   *					 ICR1 as TOP (frequency count)
   *					 OCR1A,B as pulse-width count
   *					 pulse repeat at approx 20ms
   *    				 outputs at 0 (until a set PW is called)
  **/
  command error_t HPLpwm.init()
  {
    // Set pin directions and clear output value
    TOSH_MAKE_PWM3Aout_OUTPUT(); //This sets the data direction of pin PWM3A (DDRE bit 5)
    TOSH_MAKE_PWM3Bout_OUTPUT(); //This sets the data direction of pin PWM3B (DDRE bit 4)
    // Now clear the output values
    TOSH_CLR_PWM3Aout_PIN();
    TOSH_CLR_PWM3Bout_PIN();

    // Do one bit at a time to not overwrite other things that may be set
    // Sean's Note: we can set these values to 11 instead of 10 such that TCCR3A is 1111XXXX to set output
    // on compare (rising) and clear output on compare (falling) instead of the opposite, which is what
    // is currently set
    sbi(TCCR3A, COM1A1 );// COMA = 10bin    -- clear output on compare
    cbi(TCCR3A, COM1A0); // 				so we can use 8bit speed values
    sbi(TCCR3A, COM1B1); // COMB = 10bin
    cbi(TCCR3A, COM1B0); //TCCR3A now looks like: 1010XXXX
    
    // NOTE: these bits are shared with both A&B PWM outputs
    // See page 135 of the ATMega128 Datasheet for more info on WGM (Waveform Generation Mode)
    cbi(TCCR3A, WGM10);  // WGM = 1000bin  -- Phase/freq correct, ICR bottom
    cbi(TCCR3A, WGM11);  // 		""""
    cbi(TCCR3B, WGM12);  // 		"""" (note: shadowed in setPreScale())
    sbi(TCCR3B, WGM13);  // 		""""			"""" set bit4: 0x10

    // Set prescaler to CK/64
    call HPLpwm.setPreScale( 0x03 );

    // set TOP value for both A&B.
    //  NOTE: 1150 is magic number to get ~20ms pulse spacing.
    call HPLpwm.setFreq( 1150 );

    // Initialize OCR1A/B,H/L registers to count from 0
    //   shuts off counting and keeps outputs at 0
    outp( 0, OCR3AH);
    outp( 0, OCR3AL);
    outp( 0, OCR3BH);
    outp( 0, OCR3BL);

    // Note: not setting any interrupts

    return SUCCESS;
  }

  /** setPreScale()
   *  Set the clock pre-scale and clock source value
   * @param ps:	TCR1B register set value.
   *		0 -- 000 No clock source. (Timer/Counter stopped)
   *		1 -- 001 clkI/O/1    136ns clock (clock no-prescaling)
   *		2 -- 010 clkI/O/8 	   1.088us
   *		3 -- 011 clkI/O/64     8.704us
   *		4 -- 100 clkI/O/256   34.816ms
   *		5 -- 101 clkI/O/1024 139.264ms
   *		6 -- 110 External clock source on Tn pin. Clock on falling edge
   *		7 -- 111 External clock source on Tn pin. Clock on rising edge
   * @return nada.
   **/
  command void HPLpwm.setPreScale( uint8_t ps )
  {
  	// OR with WGM13 bit setting 0x10, as per init()
	outp( (ps & 0x07) | 0x10, TCCR3B );
  }

  /** setFreq()
   *  Set the base frequency of counters for both pwm outputs.
   * @param f: ICR1H,L register BOTTOM count value
   *		    The acceptable range is from 1-64K for counting,
   *			or 0 to stop.
   *
   * Note that the MICA clock is about 136ns
   *  and the pulse&freq correct mode counts up and down to ICR value
   *  so the maximum pulse repeat cycle is 272ns with a pre-scale of /1
   *  and a "f" argument here of 1
   *   Two (approximate) examples:
   *	40us (25KHz) -- pre-scale /1 (0x01), freq 147
   *	20ms (50Hz)  -- pre-scale /64 (0x03), freq 1150	(default settings)
   *
   *  @return nada.
   **/
  command void HPLpwm.setFreq( uint16_t f )
  {
    // This is just loading the ICR3 register to the value of TOP (see ATMega documentation for further details)
    outp( (f >> 8) & 0xff, ICR3H);
    outp(  f & 0xff, ICR3L);
  }

  /** setApw()
   *  Turn on and set the pulse width of the A counter.
   * @param pw -- pulse width...OCR1AH,L register value
   *		    The acceptable range is from 1-64K for counting,
   *			or 0 to stop. Use 1/2 the freq count for 50% duty cycle.
   *			The output high pulse will be 2*pw *preScaleClocks long.
   *  @return nada.
   **/
  command void HPLpwm.setApw( uint16_t pw )
  {
    // This is just loading the OCR1A register with the desired pulse width
    // The input should be in the range 0-TOP
    // The width of the pulse is equal to (pw/TOP)*T where T is the period determined by foc1a.
    sbi( TCCR3A, COM1A1 );	// clear A output on compare match
    outp( (pw >> 8) & 0xff, OCR3AH );
    outp(  pw & 0xff, OCR3AL );
  }

  /** setBpw()
   *  Turn on and set the pulse width of the B counter.
   * @param pw -- pulse width...OCR1BH,L register value
   *		    The acceptable range is from 1-64K for counting,
   *			or 0 to stop. Use 1/2 the freq count for 50% duty cycle.
   *			The output high pulse will be 2*pw *preScaleClocks long.
   *  @return nada.
   **/
  command void HPLpwm.setBpw( uint16_t pw )
  {
    // My comments for setApw apply here as well.
    sbi( TCCR3A, COM1B1 );	// clear B output on compare match
    outp( (pw >> 8) & 0xff, OCR3BH );
    outp(  pw & 0xff, OCR3BL );
  }
  
  /** setApw8()
   *  Set the pulse width of the A counter, low byte only.
   *  Note: assume that output is already enabled.
   * @param w: OCR1AL register value
   *		    The acceptable range is from 1-255
   *  @return nada
   **/
  command void HPLpwm.setApw8( uint8_t w )
  {
    outp( w, OCR3AL );	// set Pwidth low byte
  }

  /** setBpw8()
   *  Set the pulse width of the B counter, low byte only.
   *  Note: assume that output is already enabled.
   * @param w: OCR1BL register value
   *		    The acceptable range is from 1-255
   *  @return nada
   **/
  command void HPLpwm.setBpw8( uint8_t w )
  {
    outp( w, OCR3BL );	// set Pwidth low byte
  }

  /** setABpw8()
   *  Turn on and set the duty-cycle of both outputs, low byte only.
   * @param dcA, dcB -- Duty cycle actual values for A and B outputs
   *				Note: RoboII motors map Right=B, Left=A
   *				The acceptable range is from 1-255 where 90 is "off".
   * 				use stopAll() to shut off entirely.
   *  @return nada
   **/
  command void HPLpwm.setABpw8( uint8_t dcA, uint8_t dcB )
  {
    sbi( TCCR3A, COM1A1 );	// clear A output on compare match
    outp( dcA, OCR3AL );	// set A Pwidth low byte
    sbi( TCCR3A, COM1B1 );	// clear B output on compare match
    outp( dcB, OCR3BL );	// set B Pwidth low byte
  }
  
  /** stopAll()
   *    Stop both the PWM outputs and set to 0.
   *  @return nada.
   */
  command void HPLpwm.stopAll()
  {
    cbi(TCCR3A, COM1A1);			// disconnect from A output pin
    TOSH_CLR_PWM3Aout_PIN();		// clear A output pin
    cbi(TCCR1A, COM1B1);			// disconnect from B output pin
    TOSH_CLR_PWM3Bout_PIN();		// clear B output pin
	
    /** could set PW to motor 0 default...but doesn't matter...
    outp( 0, OCR3AH );
    outp( 90, OCR3AL );
    outp( 0, OCR3BH );
    outp( 90, OCR3BL );
    **/
  }

} // end'o'impl
