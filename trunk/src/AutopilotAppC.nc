#include "Vector3.h"

configuration AutopilotAppC {
}

implementation {

  components AutopilotC, MainC;
  components new PIDC (Vector3) as LinearPIDC, new PIDC (Vector3) as AngularPIDC; components Vector3C;
  components new AMReceiverC (0), ActiveMessageC;
  components IMUC, MotorsC;
  components new TimerMilliC () as AutopilotTimerC;
  components new AlarmMicro32C();
  components Atm128SpiC;
  components MainLoopC;
  components new IntegratorC(Vector3) as AutoIntegrator;
  components HplAtm128GeneralIOC as GPIOPins;
  //timer components
  components new Atm128CounterC(TMicro,uint16_t) as PWMCounter;
  components HplAtm128Timer3C as PWMTimer;
  //for debugging purposes (testing PWMCounter)
  components LedsC;
  
  //wire up the autopilot to everything it needs
  AutopilotC.Boot -> MainC;
  AutopilotC.LinearPID -> LinearPIDC;
  AutopilotC.AngularPID -> AngularPIDC;
  AutopilotC.Receive -> AMReceiverC;
  AutopilotC.AMControl -> ActiveMessageC;
  AutopilotC.MilliTimer -> AutopilotTimerC;
  AutopilotC.IMU -> IMUC;
  AutopilotC.Motors -> MainLoopC;
  AutopilotC.Alarm -> AlarmMicro32C;
  AutopilotC.MainLoop -> MainLoopC;
  
  //wire up the remaining components
  LinearPIDC.Additive -> Vector3C;
  AngularPIDC.Additive -> Vector3C;
  LinearPIDC.Integrator -> AutoIntegrator;
  AngularPIDC.Integrator -> AutoIntegrator;
  AutoIntegrator.Additive -> Vector3C;
  IMUC.SpiByte -> Atm128SpiC;
  
  //wire the counter to use for PWM
  MainLoopC.Leds -> LedsC;
  MainLoopC.Counter -> PWMCounter;
  //PWMCounter.Timer -> PWMTimer.Timer; //Error appears here when attempting to compile!!!!!!
  
  //wire the pins for the motor
  MotorsC.APin0 -> GPIOPins.PortA0;
}
