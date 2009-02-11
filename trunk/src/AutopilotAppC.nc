#include "Vector3.h"

configuration AutopilotAppC {
}

implementation {

  components AutopilotC, MainC;
  components new PIDC (Vector3); components Vector3C;
  components new AMReceiverC (0), ActiveMessageC;
  components IMUC, MotorsC;
  components new TimerMilliC () as AutopilotTimerC;

  AutopilotC.Boot -> MainC;
  AutopilotC.PID -> PIDC;
  AutopilotC.Receive -> AMReceiverC;
  AutopilotC.AMControl -> ActiveMessageC;
  AutopilotC.MilliTimer -> AutopilotTimerC;
  AutopilotC.IMU -> IMUC;
  AutopilotC.Motors -> MotorsC;

  PIDC.Additive -> Vector3C;

}
