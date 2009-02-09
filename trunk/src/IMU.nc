// A provider of IMU implements the ability to write to and read from registers defined by the IMU interface.
// The output of each of the two commands is the requested register's value (along with associated status bits) if the last IMU command was a read (I think) and implementation-defined otherwise.
interface IMU {

  // Input: (register, value)
  async command uint16_t writeRegister (uint8_t, uint8_t);

  // Input: register
  async command uint16_t readRegister (uint8_t);

}
