/* HPLT1pwm.nc -- Interface for Pulse Width Modulation outputs
 *					using Timer1A,B on pins:
 * 						PWM1aout   PB5		MOTORAPWM
 *						PWM1bout   PB6		MOTORBPWM
 * Defaults for running modified "hobby servo" motors with a 20ms PWM signal.
 * But with some extras to make it a general PWM/freq generator.
 *
 * Authors:		M.Schipling
 */

interface HPLT3pwm
{
  /** Init()
   *  Setup the Timer1A,B for Phase and Frequency correct PWM
   *   with default duration of 20ms and outputs OFF.
   *  @return nada.
   */
  command result_t init();

  /** setPreScale()
   *  Set the clock pre-scale and clock source value, default: internal /64
   * @param ps -- TCR1B register set value.
   *		0 -- 000 No clock source. (Timer/Counter stopped)
   *		1 -- 001 clkI/O/1 (No prescaling
   *		2 -- 010 clkI/O/8 (From prescaler)
   *		3 -- 011 clkI/O/64 (From prescaler)
   *		4 -- 100 clkI/O/256 (From prescaler)
   *		5 -- 101 clkI/O/1024 (From prescaler)
   *		6 -- 110 External clock source on Tn pin. Clock on falling edge
   *		7 -- 111 External clock source on Tn pin. Clock on rising edge
   * @return nada.
   **/
  command void setPreScale( uint8_t ps );

  /** setFreq()
   *  Set the base frequency of counters for both pwm outputs.
   * @param f: ICR1H,L register TOP count value
   *		    The acceptable range is from 1-64K for counting,
   *			or 0 to stop.
   *  @return nada.
   **/
  command void setFreq( uint16_t f );

  /** setApw()
   *  Turn on and set the pulse width of the A counter.
   * @param w: OCR1AH,L register value
   *		    The acceptable range is from 1-64K for counting,
   *			or 0 to stop.
   *  @return nada
   **/
  command void setApw( uint16_t w );

  /** setBpw()
   *  Turn on and set the pulse width of the B counter.
   * @param w: OCR1BH,L register value
   *		    The acceptable range is from 1-64K for counting,
   *			or 0 to stop.
   *  @return nada
   **/
  command void setBpw( uint16_t w );

  /** setApw8()
   *  Set the pulse width of the A counter, low byte only.
   *  Note: assume that output is already enabled.
   * @param w: OCR1AL register value
   *		    The acceptable range is from 1-255
   *  @return nada.
   **/
  command void setApw8( uint8_t w );

  /** setBpw8()
   *  Set the pulse width of the B counter, low byte only.
   *  Note: assume that output is already enabled.
   * @param w: OCR1BL register value
   *		    The acceptable range is from 1-255
   *  @return nada
   **/
  command void setBpw8( uint8_t w );

  /** setABpw8()
   *  Turn on and set the duty-cycle of both outputs, low byte only.
   * @param dcB, dcA -- Duty cycle actual values for A and B outputs
   *				Note: RoboII motors map Right=B, Left=A
   *				The acceptable range is from 1-255.
   * 				use stopAll() to shut off entirely.
   *  @return nada
   **/
  command void setABpw8( uint8_t dcA, uint8_t dcB );
  
  /** stopAll()
   *    Stop both the PWM outputs and set to 0.
   *  @return nada.
   */
  command void stopAll();

}
