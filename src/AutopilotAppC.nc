#include "Vector3.h"
#include "Spi.h"

configuration AutopilotAppC {
}

implementation {

  components AutopilotC, MainC;
  components new AMReceiverC (0), new AMSenderC (0), ActiveMessageC;
  components IMUC;
  components new TimerMilliC () as AutopilotTimerC; //This timer will be used to help pull values from the IMU
  components BusyWaitMicroC;
  components new Spi2ByteC (SPI_PERIOD);
  components Vector3C, floatC;
  components new PIDC (Vector3) as LinearPIDC, new PIDC (float) as YawPIDC;
  components DeadReckoningC;
  components new IntegratorC (Vector3) as LinearPIDCIntegratorC, new IntegratorC (float) as YawPIDCIntegratorC;
  components new IntegratorC (Vector3) as LAtoLVIntegratorC, new IntegratorC (Vector3) as LVtoLPIntegratorC, new IntegratorC (Vector3) as AVtoOIntegratorC;
  components MotorsC;
  components LedsC;
  components HPLT1pwmC, HPLT3pwmC;
  //GPIO Pins for mux control & SPI
  components HplAtm128GeneralIOC as GPIOPins;
  components MuxC;

  //wire up the autopilot to everything it needs
  AutopilotC.Boot -> MainC;
  AutopilotC.LinearPID -> LinearPIDC;
  AutopilotC.YawPID -> YawPIDC;
  AutopilotC.DeadReckoning -> DeadReckoningC;
  AutopilotC.Receive -> AMReceiverC;
  AutopilotC.AMControl -> ActiveMessageC;
  AutopilotC.MilliTimer -> AutopilotTimerC;
  AutopilotC.IMU -> IMUC;
  AutopilotC.IMUControl -> IMUC;
  AutopilotC.Spi2Byte -> Spi2ByteC;
  AutopilotC.Motors -> MotorsC.Motors;
  AutopilotC.Leds -> LedsC;
  AutopilotC.MotorsInit -> MotorsC.Init;
  //Wire the pin for the Multiplexor Select Bit used to choose whether the autopilot or user controls
  //the helicopter.  Corresponds to pin 33 on the 51 pin connector.
  AutopilotC.MuxInit    -> MuxC;
  AutopilotC.MuxControl -> MuxC;
  AutopilotC.AMSend -> AMSenderC;
  AutopilotC.Packet -> AMSenderC;
  AutopilotC.BusyWait -> BusyWaitMicroC;

  MotorsC.RotorPWM -> HPLT1pwmC;
  MotorsC. TiltPWM -> HPLT3pwmC;

  MuxC.MoteBuffer        -> GPIOPins.PortD3; // USART1_TxD
  MuxC.PassthroughBuffer -> GPIOPins.PortD2; // USART1_RxD

  //wire up the remaining components
  LinearPIDC.Additive -> Vector3C;
  YawPIDC   .Additive -> floatC;
  LinearPIDC.Integrator -> LinearPIDCIntegratorC;
  YawPIDC   .Integrator -> YawPIDCIntegratorC;
  LinearPIDCIntegratorC.Additive -> Vector3C;
  YawPIDCIntegratorC   .Additive -> floatC;

  DeadReckoningC.LAtoLV -> LAtoLVIntegratorC;
  DeadReckoningC.LVtoLP -> LVtoLPIntegratorC;
  DeadReckoningC.AVtoO  -> AVtoOIntegratorC ;

  LAtoLVIntegratorC.Additive -> Vector3C;
  LVtoLPIntegratorC.Additive -> Vector3C;
  AVtoOIntegratorC .Additive -> Vector3C;

  IMUC.Spi2Byte -> Spi2ByteC;
  IMUC.Spi2Init -> Spi2ByteC;
  IMUC.Reset -> GPIOPins.PortF4; // ADC4
  IMUC.BusyWait -> BusyWaitMicroC;

  Spi2ByteC.SCLK -> GPIOPins.PortF7; // ADC7
  Spi2ByteC.MISO -> GPIOPins.PortF6; // ADC6
  Spi2ByteC.MOSI -> GPIOPins.PortF5; // ADC5
  Spi2ByteC.SS   -> GPIOPins.PortC7; // PW7
  Spi2ByteC.BusyWait -> BusyWaitMicroC;

}
