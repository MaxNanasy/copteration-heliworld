#include "Vector3.h"

configuration SimAppC {
}

implementation {

  components SimC, MainC;
  components RemoteC, AutopilotC;
  components SwitchC;
  components EnvironmentC;
  components NetworkC, ActiveMessageC;
  components new TimerMilliC () as RemoteTimerC, new TimerMilliC () as AutopilotTimerC, new TimerMilliC () as EnvironmentTimerC;
  components Vector3C, floatC;
  components new PIDC (Vector3) as LinearPIDC, new PIDC (float) as YawPIDC;
  components DeadReckoningC;
  components new IntegratorC (Vector3) as LinearPIDCIntegratorC, new IntegratorC (float) as YawPIDCIntegratorC;
  components new IntegratorC (Vector3) as LAtoLVIntegratorC, new IntegratorC (Vector3) as LVtoLPIntegratorC, new IntegratorC (Vector3) as AVtoOIntegratorC;
  components MainLoopC, LedsC;
  components new Atm128CounterC(TMicro,uint16_t) as PWMCounter;
  components HplAtm128Timer3C as PWMTimer;
  components HPLT1pwmM as RotorPWM; //, HPLT3pwmM as TiltPWM;

  SimC.Boot -> MainC;
  SimC.Environment -> EnvironmentC;

  RemoteC.Boot -> SimC.Remote;
  RemoteC.Switch -> SwitchC;
  RemoteC.AMSend -> NetworkC;
  RemoteC.Packet -> NetworkC;
  RemoteC.AMControl -> ActiveMessageC;

  AutopilotC.Boot -> SimC.Autopilot;
  AutopilotC.LinearPID -> LinearPIDC;
  AutopilotC.YawPID -> YawPIDC;
  AutopilotC.DeadReckoning -> DeadReckoningC;
  AutopilotC.Receive -> NetworkC;
  AutopilotC.MilliTimer -> AutopilotTimerC;
  AutopilotC.IMU -> EnvironmentC;
  AutopilotC.Motors -> EnvironmentC;
  AutopilotC.MainLoop -> MainLoopC;
  AutopilotC.Init -> MainLoopC;

  EnvironmentC.MilliTimer -> EnvironmentTimerC;

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

  MainLoopC.Leds -> LedsC;
  MainLoopC.Counter -> PWMCounter;
  PWMCounter.Timer -> PWMTimer.Timer;

}
