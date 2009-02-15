#include "Vector3.h"

configuration SimAppC {
}

implementation {

  components SimC, MainC;
  components RemoteC, AutopilotC;
  components SwitchC;
  components EnvironmentC;
  components Vector3C, new PIDC (Vector3) as LinearPIDC, new PIDC (Vector3) as AngularPIDC;
  components NetworkC, ActiveMessageC;
  components new TimerMilliC () as RemoteTimerC, new TimerMilliC () as AutopilotTimerC, new TimerMilliC () as EnvironmentTimerC;
  components new AlarmMicro32C ();

  SimC.Boot -> MainC;
  SimC.Environment -> EnvironmentC;

  RemoteC.Boot -> SimC.Remote;
  RemoteC.Switch -> SwitchC;
  RemoteC.AMSend -> NetworkC;
  RemoteC.Packet -> NetworkC;
  RemoteC.AMControl -> ActiveMessageC;

  AutopilotC.Boot -> SimC.Autopilot;
  AutopilotC.LinearPID -> LinearPIDC;
  AutopilotC.AngularPID -> AngularPIDC;
  AutopilotC.Receive -> NetworkC;
  AutopilotC.MilliTimer -> AutopilotTimerC;
  AutopilotC.IMU -> EnvironmentC;
  AutopilotC.Motors -> EnvironmentC;
  AutopilotC.Alarm -> AlarmMicro32C;

  EnvironmentC.MilliTimer -> EnvironmentTimerC;

  LinearPIDC.Additive -> Vector3C;
  AngularPIDC.Additive -> Vector3C;

}
