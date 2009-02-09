configuration RemoteAppC {
}

implementation {
  components RemoteC, MainC;
  components HplCC2420PinsC as PinsC;
  components SwitchC;
  components new AMSenderC (0), ActiveMessageC;
  components new TimerMilliC ();

  RemoteC.Boot -> MainC;
  RemoteC.Switch -> SwitchC;
  RemoteC.AMSend -> AMSenderC;
  RemoteC.Receive -> AMReceiverC;
  RemoteC.AMControl -> ActiveMessageC;
  RemoteC.MilliTimer -> TimerMilliC;
}
