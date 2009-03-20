module SimC {
  provides {
    interface Boot as Remote;
    interface Boot as Autopilot;
  }
  uses {
    interface Boot;
    interface Init as Environment;
  }
}

implementation {

  event void Boot.booted ()
  {
    signal Autopilot.booted ();
    signal Remote.booted ();
    call Environment.init ();
  }

}
