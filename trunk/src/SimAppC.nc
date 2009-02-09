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
  //  SimC.Remote <- RemoteC;
  //  SimC.Autopilot <- AutopilotC;
  SimC.Environment -> EnvironmentC;

  PIDC.Additive -> Vector3C;

  RemoteC.Boot -> SimC.Remote;
  RemoteC.Switch -> SwitchC;
  RemoteC.AMSend -> NetworkC;
  RemoteC.AMControl -> ActiveMessageC;
  RemoteC.MilliTimer -> RemoteTimerC;

  AutopilotC.Boot -> SimC.Autopilot;
  AutopilotC.PID -> PIDC;
  AutopilotC.Receive -> NetworkC;
  AutopilotC.MilliTimer -> AutopilotTimerC;
  AutopilotC.IMU -> EnvironmentC;
  AutopilotC.Engine -> EnvironmentC;

  EnvironmentC.MilliTimer -> EnvironmentTimerC;

}
