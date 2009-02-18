#include "Vector3.h"

configuration AutopilotAppC {
}

implementation {

  components AutopilotC, MainC;
  components new AMReceiverC (0), ActiveMessageC;
  components IMUC, MotorsC;
  components new TimerMilliC () as AutopilotTimerC;
  components new AlarmMicro32C();
  components Atm128SpiC;
  components MainLoopC;
  components Vector3C, floatC;
  components new PIDC (Vector3) as LinearPIDC, new PIDC (float) as YawPIDC;
  components DeadReckoningC;
  components new IntegratorC (Vector3) as LinearPIDCIntegratorC, new IntegratorC (float) as YawPIDCIntegratorC;
  components new IntegratorC (Vector3) as LAtoLVIntegratorC, new IntegratorC (Vector3) as LVtoLPIntegratorC, new IntegratorC (Vector3) as AVtoOIntegratorC;
  //GPIO Pins for motor control
  components HplAtm128GeneralIOC as GPIOPins;
  //timer components
  components new Atm128CounterC(TMicro,uint16_t) as PWMCounter;
  components HplAtm128Timer3C as PWMTimer;
  //for debugging purposes (testing PWMCounter)
  components LedsC;
  
  //wire up the autopilot to everything it needs
  AutopilotC.Boot -> MainC;
  AutopilotC.LinearPID -> LinearPIDC;
  AutopilotC.YawPID -> YawPIDC;
  AutopilotC.DeadReckoning -> DeadReckoningC;
  AutopilotC.Receive -> AMReceiverC;
  AutopilotC.AMControl -> ActiveMessageC;
  AutopilotC.MilliTimer -> AutopilotTimerC;
  AutopilotC.IMU -> IMUC;
  AutopilotC.Motors -> MainLoopC;
  AutopilotC.Alarm -> AlarmMicro32C;
  AutopilotC.MainLoop -> MainLoopC;
  AutopilotC.Init -> MainLoopC;
  //Wire the pin for the Multiplexor Select Bit used to choose whether the autopilot or user controls
  //the helicopter.  TODO: actually use this pin when activating the autopilot.
  AutopilotC.MuxSelectBit -> GPIOPins.PortC4;
  
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
  
  //wire the counter to use for PWM.  Corresponds to pin 33 on the 51 pin connector.
  MainLoopC.Leds -> LedsC;
  MainLoopC.Counter -> PWMCounter;
  PWMCounter.Timer -> PWMTimer.Timer;
  
  //wire the pins for the motor.  Corresponds to pins 29-32 on the 51 pin connector.
  MotorsC.TopRotorPin -> GPIOPins.PortC0;
  MotorsC.BottomRotorPin -> GPIOPins.PortC1;
  MotorsC.RollPin -> GPIOPins.PortC2;
  MotorsC.PitchPin -> GPIOPins.PortC3;

}
