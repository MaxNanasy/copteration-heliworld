// This provides a simulation of the output of the switch on the remote.
module SwitchC {
  provides {
    interface GeneralIO;
  }
}

implementation {

  uint8_t readsLeft; bool isInput = FALSE;

  async command void GeneralIO.makeInput ()
  {
    isInput = TRUE;
    readsLeft = 64;
  }

  async command bool GeneralIO.get ()
  {
    if (isInput && readsLeft) {
      readsLeft--;
      return TRUE;
    }
    return FALSE;
  }

  async command bool GeneralIO.isInput ()
  {
    return isInput;
  }

  async command bool GeneralIO.isOutput ()
  {
    return FALSE;
  }

  async command void GeneralIO.makeOutput () {}
  async command void GeneralIO.set () {}
  async command void GeneralIO.clr () {}
  async command void GeneralIO.toggle () {}

}
