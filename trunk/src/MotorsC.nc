module MotorsC {
  provides {
    interface Motors;
  }
}

implementation {

  async command void Motors.setTopRotorPower    (float) { };
  async command void Motors.setBottomRotorPower (float) { };
  async command void Motors.rotateA () { };
  async command void Motors.switchA () { };
  async command void Motors.rotateB () { };
  async command void Motors.switchB () { };

}
