configuration FallbackRemoteAppC { }

implementation
{

  components FallbackRemoteC, MainC;
  components HplAtm128GeneralIOC as GPIOPins;
  components new AMSenderC (0), ActiveMessageC;
  components new TimerMilliC ();
  components LedsC;

  FallbackRemoteC.Boot -> MainC;
  FallbackRemoteC.AMSend -> AMSenderC;
  FallbackRemoteC.Packet -> AMSenderC;
  FallbackRemoteC.AMControl -> ActiveMessageC;
  FallbackRemoteC.Timer -> TimerMilliC;
  FallbackRemoteC.ActivateSwitch -> GPIOPins.PortC4; // PW4
  FallbackRemoteC.LeftSwitch     -> GPIOPins.PortC2; // PW2
  FallbackRemoteC.RightSwitch    -> GPIOPins.PortC0; // PW0
  FallbackRemoteC.Leds -> LedsC;

}
