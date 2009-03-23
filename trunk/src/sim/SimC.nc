module SimC {
  provides {
    interface Boot as RemoteBoot;
    interface Boot as AutopilotBoot;
  }
  uses {
    interface Boot;
    interface Init as EnvironmentInit;
  }
}

implementation {

  event void Boot.booted ()
  {
    signal AutopilotBoot.booted ();
    signal RemoteBoot.booted ();
    call EnvironmentInit.init ();
  }

}
