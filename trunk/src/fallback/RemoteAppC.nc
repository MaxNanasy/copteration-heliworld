configuration RemoteAppC { }

implementation
{

  components RemoteC, MainC;
  components HplAtm128GeneralIOC as GPIOPins;
  components new AMSenderC (0), ActiveMessageC;
  components new TimerMilliC ();
  components LedsC;

  RemoteC.Boot -> MainC;
  RemoteC.AMSend -> AMSenderC;
  RemoteC.Packet -> AMSenderC;
  RemoteC.AMControl -> ActiveMessageC;
  RemoteC.Timer -> TimerMilliC;
  RemoteC.ActivateSwitch -> GPIOPins.PortC4; // PW4
  RemoteC.LeftSwitch     -> GPIOPins.PortC2; // PW2
  RemoteC.RightSwitch    -> GPIOPins.PortC0; // PW0
  RemoteC.Leds -> LedsC;

}
