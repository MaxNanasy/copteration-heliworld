configuration RemoteAppC {
}

implementation {

  components RemoteC, MainC;
  // This line causes an error for me when I compile for sim, but does not complain when I compile for the mote.
  components HplCC2420InterruptsC;
  components new AMSenderC (0), ActiveMessageC;
  components new TimerMilliC ();
  components new AlarmMicro32C ();
  components LedsC;
  components HplAtm128GeneralIOC as PinsC;

  RemoteC.Boot -> MainC;
  // According to the documentation (http://www.tinyos.net/tinyos-2.x/doc/nesdoc/micaz/chtml/tos.platforms.micaz.chips.cc2420.HplCC2420InterruptsP.html), "FIFOP is a real interrupt, while CCA and FIFO are emulated through timer polling"; therefore, FIFOP seems to be the most efficient choice.
//  RemoteC.Switch -> HplCC2420InterruptsC.InterruptFIFOP;
  RemoteC.AMSend -> AMSenderC;
  RemoteC.Packet -> AMSenderC;
  RemoteC.AMControl -> ActiveMessageC;
//  RemoteC.Timer -> TimerMilliC;
  RemoteC.Alarm -> AlarmMicro32C;
  RemoteC.Leds -> LedsC;
  RemoteC.Switch -> PinsC.PortE7; // INT3

}
