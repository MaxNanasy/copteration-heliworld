#include "Vector3.h"

configuration AutopilotAppC {
}

implementation {

  components AutopilotC, MainC;
  components new PIDC (Vector3); components Vector3C;
  components new AMReceiverC (0), ActiveMessageC;
  components IMUC, EngineC;
  components new TimerMilliC () as AutopilotTimerC;

  AutopilotC.Boot -> MainC;
  AutopilotC.PID -> PIDC;
  AutopilotC.Receive -> AMReceiverC;
  AutopilotC.MilliTimer -> AutopilotTimerC;
  AutopilotC.IMU -> IMUC;
  AutopilotC.Engine -> EngineC;

}
