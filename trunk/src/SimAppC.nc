#include "Vector3.h"

configuration SimAppC {
}

implementation {

  components SimC, MainC;
  components RemoteC, AutopilotC;
  components SwitchC;
  components EnvironmentC;
  components new PIDC (Vector3); components Vector3C;
  components NetworkC, ActiveMessageC;
  components new TimerMilliC () as RemoteTimerC, new TimerMilliC () as AutopilotTimerC, new TimerMilliC () as EnvironmentTimerC;

  SimC.Boot -> MainC;
  SimC.Environment -> EnvironmentC;

  RemoteC.Boot -> SimC.Remote;
  RemoteC.Switch -> SwitchC;
  RemoteC.AMSend -> NetworkC;
  RemoteC.Packet -> NetworkC;
  RemoteC.AMControl -> ActiveMessageC;

  AutopilotC.Boot -> SimC.Autopilot;
  AutopilotC.PID -> PIDC;
  AutopilotC.Receive -> NetworkC;
  AutopilotC.MilliTimer -> AutopilotTimerC;
  AutopilotC.IMU -> EnvironmentC;
  AutopilotC.Motors -> EnvironmentC;

  EnvironmentC.MilliTimer -> EnvironmentTimerC;

  PIDC.Additive -> Vector3C;

}
