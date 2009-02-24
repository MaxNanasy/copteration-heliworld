#include "Vector3.h"

configuration AutopilotAppC {
}

implementation {

  components AutopilotC, MainC;
  components new AMReceiverC (0), ActiveMessageC;
  components IMUC;
  components new TimerMilliC () as AutopilotTimerC;
  components new AlarmMicro32C();
  components Atm128SpiC;
  components Vector3C, floatC;
  components new PIDC (Vector3) as LinearPIDC, new PIDC (float) as YawPIDC;
  components DeadReckoningC;
  components new IntegratorC (Vector3) as LinearPIDCIntegratorC, new IntegratorC (float) as YawPIDCIntegratorC;
  components new IntegratorC (Vector3) as LAtoLVIntegratorC, new IntegratorC (Vector3) as LVtoLPIntegratorC, new IntegratorC (Vector3) as AVtoOIntegratorC;
  components MotorsC;
  components HPLT1pwmC, HPLT3pwmC;
  //GPIO Pins for mux control
  components HplAtm128GeneralIOC as GPIOPins;

  //wire up the autopilot to everything it needs
  AutopilotC.Boot -> MainC;
  AutopilotC.LinearPID -> LinearPIDC;
  AutopilotC.YawPID -> YawPIDC;
  AutopilotC.DeadReckoning -> DeadReckoningC;
  AutopilotC.Receive -> AMReceiverC;
  AutopilotC.AMControl -> ActiveMessageC;
  AutopilotC.MilliTimer -> AutopilotTimerC;
  AutopilotC.IMU -> IMUC;
  AutopilotC.Motors -> MotorsC;
  //Wire the pin for the Multiplexor Select Bit used to choose whether the autopilot or user controls
  //the helicopter.  Corresponds to pin 33 on the 51 pin connector.
  AutopilotC.MuxSelect -> GPIOPins.PortC4;

  MotorsC.RotorPWM -> HPLT1pwmC;
  MotorsC.RotorPWM -> HPLT3pwmC;
  MotorsC. TiltPWM -> HPLT3pwmC;

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

  IMUC.SpiByte -> Atm128SpiC;
  
}