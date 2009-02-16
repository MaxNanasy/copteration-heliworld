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

  AutopilotC.Boot -> MainC;
  AutopilotC.LinearPID -> LinearPIDC;
  AutopilotC.AngularPID -> AngularPIDC;
  AutopilotC.Receive -> AMReceiverC;
  AutopilotC.AMControl -> ActiveMessageC;
  AutopilotC.MilliTimer -> AutopilotTimerC;
  AutopilotC.IMU -> IMUC;
  AutopilotC.Motors -> MainLoopC;
  AutopilotC.Alarm -> AlarmMicro32C;

  LinearPIDC.Additive -> Vector3C;
  AngularPIDC.Additive -> Vector3C;
  IMUC.SpiByte -> Atm128SpiC;
}
