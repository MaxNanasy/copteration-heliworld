/* A provider of IMU implements the ability to write to and read from registers defined by the IMU interface.
* The output of each of the two commands, provided that a read command was issued beforehand (whether or not the current command is a read command), is:
* ND EA Rest
* ND: New data (I'm not sure whether this specifically refers to only this register)
* EA: Error / Alarm
* Rest: 14 bits with either 12 data bits then two 0s or just 14 data bits, depending upon the register's data length.  The data bits are bitwise big-endian and either two's-complement or unsigned.  The scale (i.e., difference represented by incrementing the bitwise representation of the register) of each register is register-dependent.
* After a write command, the return value is probably unreliable and definitely best ignored.
*/
interface IMU {

  // Input: (register, value)
  async command uint16_t writeRegister (uint8_t, uint8_t);

  // Input: register
  async command uint16_t readRegister (uint8_t);

}
