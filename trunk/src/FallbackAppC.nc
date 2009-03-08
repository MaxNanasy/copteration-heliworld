configuration FallbackAppC { }

implementation {
  components FallbackC, MainC;
  components new AMReceiverC (0), ActiveMessageC;
  components MotorsC;
  components LedsC;
  components HPLT1pwmC, HPLT3pwmC;
  //GPIO pins for mux control & SPI (SPI not needed in this case)
  components HplAtm128GeneralIOC as GPIOPins;
  components MuxC;
  
  //Begin wiring
  FallbackC.Boot -> MainC;
  FallbackC.Receive -> AMReceiverC;
  FallbackC.Motors -> MotorsC;
  FallbackC.AMControl -> ActiveMessageC;
  FallbackC.Leds -> LedsC;
  FallbackC.MotorsInit -> MotorsC.Init;
  FallbackC.MuxInit -> MuxC;
  FallbackC.MuxControl -> MuxC;
  
  MotorsC.RotorPWM -> HPLT1pwmC;
  MotorsC.TiltPWM  -> HPLT3pwmC;

  MuxC.MoteBuffer -> GPIOPins.PortC4;
  MuxC.PassthroughBuffer -> GPIOPins.PortC5;

}
