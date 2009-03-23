configuration AutopilotAppC { }

implementation {

  components AutopilotC, MainC;
  components new AMReceiverC (0), ActiveMessageC;
  components MotorsC;
  components LedsC;
  components HPLT1pwmC, HPLT3pwmC;
  //GPIO pins for mux control & SPI (SPI not needed in this case)
  components HplAtm128GeneralIOC as GPIOPins;
  components MuxC;
  
  //Begin wiring
  AutopilotC.Boot -> MainC;
  AutopilotC.Receive -> AMReceiverC;
  AutopilotC.Motors -> MotorsC;
  AutopilotC.AMControl -> ActiveMessageC;
  AutopilotC.Leds -> LedsC;
  AutopilotC.MotorsInit -> MotorsC.Init;
  AutopilotC.MuxInit    -> MuxC;
  AutopilotC.MuxControl -> MuxC;
  
  MotorsC.RotorPWM -> HPLT1pwmC;
  MotorsC.TiltPWM  -> HPLT3pwmC;

  MuxC.MoteBuffer        -> GPIOPins.PortD3; // USART1_TxD
  MuxC.PassthroughBuffer -> GPIOPins.PortD2; // USART1_RxD

}
