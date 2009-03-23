configuration RemoteAppC {
}

implementation {

  components RemoteC, MainC;
  components new AMSenderC (0), ActiveMessageC;
  components new TimerMilliC ();
  components LedsC;
  components HplAtm128GeneralIOC as PinsC;

  RemoteC.Boot -> MainC;
  RemoteC.AMSend -> AMSenderC;
  RemoteC.Packet -> AMSenderC;
  RemoteC.AMControl -> ActiveMessageC;
  RemoteC.Timer -> TimerMilliC;
  RemoteC.Leds -> LedsC;
  RemoteC.Switch -> PinsC.PortE7; // INT3

}
