configuration RemoteAppC {
}

implementation {

  components RemoteC, MainC;
  // This line causes an error for me when I compile for sim, but I have reason to believe (http://www.mail-archive.com/tinyos-help@millennium.berkeley.edu/msg08408.html) that it will work when compiling for the mote.
  components HplCC2420InterruptsC;
  components new AMSenderC (0), ActiveMessageC;

  RemoteC.Boot -> MainC;
  RemoteC.Switch -> HplCC2420InterruptsC.InterruptFIFOP;
  RemoteC.AMSend -> AMSenderC;
  RemoteC.AMControl -> ActiveMessageC;

}
