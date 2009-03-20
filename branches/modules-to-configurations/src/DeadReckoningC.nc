generic configuration DeadReckoningC () {
  provides interface DeadReckoning;
}

implementation {

  components new Vector3IntegratorC () as LAtoLV, new Vector3IntegratorC () as LVtoLP, new Vector3IntegratorC () as AVtoO;
  components DeadReckoningP;

  DeadReckoning = DeadReckoningP;

  DeadReckoningP.LAtoLV -> LAtoLV;
  DeadReckoningP.LVtoLP -> LVtoLP;
  DeadReckoningP.AVtoO  -> AVtoO ;

}
