configuration FallbackRemoteAppC { }

implementation
{

  components FallbackRemoteC, MainC;
  components HplAtm128GeneralIOC as GPIOPins;
  components new AMSenderC (0), ActiveMessageC;

  FallbackRemoteC.Boot -> MainC;
  FallbackRemoteC.AMSend -> AMSenderC;
  FallbackRemoteC.Packet -> AMSenderC;
  FallbackRemoteC.AMControl -> ActiveMessageC;
  FallbackRemoteC.ActivateSwitch -> GPIOPins.PortC0;
  FallbackRemoteC.LeftSwitch -> GPIOPins.PortC1;
  FallbackRemoteC.RightSwitch -> GPIOPins.PortC2;

  

}
