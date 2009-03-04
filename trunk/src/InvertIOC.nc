component InvertIOC
{
  uses     interface GeneralIO as NormalIO  ;
  provides interface GeneralIO as InvertedIO;
}

implementation
{
  command void InvertedIO.clr        () { NormalIO.set             (); }
  command bool InvertedIO.get        () { return ~ NormalIO.get    (); }
  command bool InvertedIO.isInput    () { return NormalIO.isInput  (); }
  command bool InvertedIO.isOutput   () { return NormalIO.isOutput (); }
  command void InvertedIO.makeInput  () { NormalIO.makeInput       (); }
  command void InvertedIO.makeOutput () { NormalIO.makeOutput      (); }
  command void InvertedIO.set        () { NormalIO.clr             (); }
  command void InvertedIO.toggle     () { NormalIO.toggle          (); }
}
