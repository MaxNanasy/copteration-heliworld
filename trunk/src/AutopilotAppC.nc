#include "Vector3.h"
#include "Spi.h"

configuration AutopilotAppC {
}

implementation {

  components AutopilotC, MainC;
  components new AMReceiverC (0), ActiveMessageC;
  components IMUC;
  components new TimerMilliC () as AutopilotTimerC; //This timer will be used to help pull values from the IMU
  components BusyWaitMicroC;
  components new Spi2ByteC (SPI_PERIOD);
  //  components Vector3C, floatC;
  components new floatPIDC (1.0, 0.0, 0.0) as XPIDC, new floatPIDC (1.0, 0.0, 0.0) as YPIDC, new floatPIDC (1.0, 0.0, 0.0) as ZPIDC, new floatPIDC (1.0, 0.0, 0.0) as YawPIDC;
  components new DeadReckoningC ();
  //  components new IntegratorC (float) as XPIDCIntegratorC, new IntegratorC (float) as YPIDCIntegratorC, new IntegratorC (float) as ZPIDCIntegratorC, new IntegratorC (float) as YawPIDCIntegratorC;
  //  components new IntegratorC (Vector3) as LAtoLVIntegratorC, new IntegratorC (Vector3) as LVtoLPIntegratorC, new IntegratorC (Vector3) as AVtoOIntegratorC;
  components MotorsC;
  components LedsC;
  components HPLT1pwmC, HPLT3pwmC;
  //GPIO Pins for mux control & SPI
  components HplAtm128GeneralIOC as GPIOPins;
  components MuxC;
  components new InvertIOC () as InvertSCLK, new InvertIOC () as InvertMOSI, new InvertIOC () as InvertSS, new InvertIOC () as InvertReset;

  //wire up the autopilot to everything it needs
  AutopilotC.Boot -> MainC;
  AutopilotC.XPID -> XPIDC;
  AutopilotC.YPID -> YPIDC;
  AutopilotC.ZPID -> ZPIDC;
  AutopilotC.YawPID -> YawPIDC;
  AutopilotC.DeadReckoning -> DeadReckoningC;
  AutopilotC.Receive -> AMReceiverC;
  AutopilotC.AMControl -> ActiveMessageC;
  AutopilotC.Timer -> AutopilotTimerC;
  AutopilotC.IMU -> IMUC;
  AutopilotC.IMUControl -> IMUC;
  AutopilotC.Motors -> MotorsC.Motors;
  AutopilotC.Leds -> LedsC;
  AutopilotC.MotorsInit -> MotorsC.Init;
  AutopilotC.MuxInit    -> MuxC;
  AutopilotC.MuxControl -> MuxC;

  MotorsC.RotorPWM -> HPLT1pwmC;
  MotorsC. TiltPWM -> HPLT3pwmC;

  MuxC.MoteBuffer        -> GPIOPins.PortD3; // USART1_TxD
  MuxC.PassthroughBuffer -> GPIOPins.PortD2; // USART1_RxD

  IMUC.Spi2Byte -> Spi2ByteC;
  IMUC.Spi2Init -> Spi2ByteC;
  IMUC.Reset -> InvertReset; // GPIOPins.PortF4; // ADC4
  IMUC.BusyWait -> BusyWaitMicroC;

  InvertSCLK .NormalIO -> GPIOPins.PortF6; // ADC6
  InvertMOSI .NormalIO -> GPIOPins.PortF5; // ADC5
  InvertSS   .NormalIO -> GPIOPins.PortC7; // PW7
  InvertReset.NormalIO -> GPIOPins.PortF4; // ADC4

  Spi2ByteC.SCLK -> InvertSCLK; // GPIOPins.PortF6; // ADC6
  Spi2ByteC.MISO ->                GPIOPins.PortF7; // ADC7
  Spi2ByteC.MOSI -> InvertMOSI; // GPIOPins.PortF5; // ADC5
  Spi2ByteC.SS   -> InvertSS  ; // GPIOPins.PortC7; // PW7
  Spi2ByteC.BusyWait -> BusyWaitMicroC;

}
