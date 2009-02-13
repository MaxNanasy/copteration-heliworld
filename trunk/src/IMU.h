#ifndef IMU_H
#define IMU_H

//constants
#define GRAVITY 1000

// Registers
// Power supply
#define SUPPLY_OUT 0x02
// Angular velocity
#define  XGYRO_OUT 0x04
#define  YGYRO_OUT 0x06
#define  ZGYRO_OUT 0x08
// Linear acceleration
#define  XACCL_OUT 0x0A
#define  YACCL_OUT 0x0C
#define  ZACCL_OUT 0x0E
//
#define  XTEMP_OUT 0x10
#define  YTEMP_OUT 0x12
#define  ZTEMP_OUT 0x14
#define    AUX_ADC 0x16

// Scale factors
#define ACCL_SCALE 2.522   // 2.522 mg
#define GYRO_SCALE  .07326 // .07326 degrees / s

#endif
