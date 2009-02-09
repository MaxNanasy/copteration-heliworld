module SwitchC {
  provides {
    interface GeneralIO;
  }
}

implementation {

  bool first = TRUE;

  async command void GeneralIO.set () {}
  async command void GeneralIO.clr () {}
  async command void GeneralIO.toggle() {}

  async command bool GeneralIO.get () {
    if (first) {
      first = FALSE;
      return TRUE;
    }
    return FALSE;
  }

  async command void GeneralIO.makeInput() {}
  async command bool GeneralIO.isInput() { return FALSE; }
  async command void GeneralIO.makeOutput() {}
  async command bool GeneralIO.isOutput() { return FALSE; }
}
