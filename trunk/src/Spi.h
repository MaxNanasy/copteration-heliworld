#ifndef SPI_H
#define SPI_H

#define SPI_PERIOD 14 // Through experimentation, the lowest effective value.
/*
 * With a 14 microsecond spi clock period, we actually achieve a 24 micro second period, due to unkown delays.
 * This means:
 * (24 uS / bit * 16 bits / word + 9 uS dataframe) * 6 words = 2358 uS or 2.358 milliseconds to read all
 * registers from the IMU.  We may be able to improve this, by changing the delay while SCLK is low (where
 * an additional unkown delay is added) such that it is shorter to compensate for said unknown delay.
 * Example:
 * high = 7 uS
 * low  = 10 uS (we set our low delay to 0, as in: max(0,period/2-10);
 * Effictively making our new SCLK period 17 uS yielding a minimum read time of 1686 uS for all 6 registers.
 * This MAY be enough time for us to poll the IMU every 2 mS and still perform our necessary calculations
 *
 * NOTE: Throudh further experimentation, we found that a minimum busywait of 1 uS for the delay function
 * when SCLK is low is necessary for everything to function properly.
*/

#endif
