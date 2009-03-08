module MuxC {
  provides {
    interface StdControl;
    interface Init;
  }
  uses {
    interface GeneralIO as MoteBuffer;
    interface GeneralIO as PassthroughBuffer;
  }
}

implementation {
  
  command error_t Init.init ()
  {
    call MoteBuffer.set ();
    call PassthroughBuffer.clr ();
    return SUCCESS;
  }
  
  command error_t StdControl.start ()
  {
    call PassthroughBuffer.set ();
    call MoteBuffer.clr ();
    return SUCCESS;
  }
  
  command error_t StdControl.stop ()
  {
    call MoteBuffer.set ();
    call PassthroughBuffer.clr ();
    return SUCCESS;
  }
  
}
