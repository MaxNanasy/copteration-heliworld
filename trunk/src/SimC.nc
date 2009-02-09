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
    signal Remote.booted ();
    signal Autopilot.booted ();
    call Environment.init ();
  }

}
