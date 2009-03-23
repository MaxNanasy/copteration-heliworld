#include "Vector3.h"

configuration SimAppC {
}

implementation {

  components SimC, MainC;
  components LedsC;
  components RemoteC, AutopilotC;
  components SwitchC;
  components EnvironmentC;
  components NetworkC, ActiveMessageC;
  components new TimerMilliC () as RemoteTimerC, new TimerMilliC () as AutopilotTimerC, new TimerMilliC () as EnvironmentTimerC;
  components new floatPIDC (1.0, 0.0, 0.0) as XPIDC, new floatPIDC (1.0, 0.0, 0.0) as YPIDC, new floatPIDC (1.0, 0.0, 0.0) as ZPIDC, new floatPIDC (1.0, 0.0, 0.0) as YawPIDC;
  components new DeadReckoningC ();

  SimC.Boot -> MainC;
  SimC.EnvironmentInit -> EnvironmentC.Init;

  RemoteC.Boot -> SimC.RemoteBoot;
  RemoteC.Switch -> SwitchC;
  RemoteC.AMSend -> NetworkC;
  RemoteC.Packet -> NetworkC;
  RemoteC.Timer -> RemoteTimerC;
  RemoteC.Leds -> LedsC;
  RemoteC.AMControl -> ActiveMessageC;

  AutopilotC.Boot -> SimC.AutopilotBoot;
  AutopilotC.XPID -> XPIDC;
  AutopilotC.YPID -> YPIDC;
  AutopilotC.ZPID -> ZPIDC;
  AutopilotC.YawPID -> YawPIDC;
  AutopilotC.DeadReckoning -> DeadReckoningC;
  AutopilotC.Leds -> LedsC;
  AutopilotC.Receive -> NetworkC;
  AutopilotC.AMControl -> ActiveMessageC;
  AutopilotC.Timer -> AutopilotTimerC;
  AutopilotC.IMU -> EnvironmentC;
  AutopilotC.IMUControl -> EnvironmentC.IMUControl;
  AutopilotC.Motors -> EnvironmentC;
  AutopilotC.MotorsInit -> EnvironmentC.MotorsInit;
  AutopilotC.MuxInit -> EnvironmentC.MuxInit;
  AutopilotC.MuxControl -> EnvironmentC.MuxControl;

  EnvironmentC.MilliTimer -> EnvironmentTimerC;

}
