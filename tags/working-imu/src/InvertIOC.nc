module InvertIOC
{
  uses     { interface GeneralIO as NormalIO  ; }
  provides { interface GeneralIO as InvertedIO; }
}

implementation
{
  async command void InvertedIO.clr        () { call NormalIO.set             (); }
  async command bool InvertedIO.get        () { return ~ call NormalIO.get    (); }
  async command bool InvertedIO.isInput    () { return call NormalIO.isInput  (); }
  async command bool InvertedIO.isOutput   () { return call NormalIO.isOutput (); }
  async command void InvertedIO.makeInput  () { call NormalIO.makeInput       (); }
  async command void InvertedIO.makeOutput () { call NormalIO.makeOutput      (); }
  async command void InvertedIO.set        () { call NormalIO.clr             (); }
  async command void InvertedIO.toggle     () { call NormalIO.toggle          (); }
}
