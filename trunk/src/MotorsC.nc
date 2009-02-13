// Implements the real-life motor interface.
module MotorsC {
  provides {
    interface Motors;
  }
  uses {

    interface GeneralIO as TopRotorPin0;
    interface GeneralIO as TopRotorPin1;

    interface GeneralIO as BottomRotorPin0;
    interface GeneralIO as BottomRotorPin1;

    interface GeneralIO as APin0;
    interface GeneralIO as APin1;
    interface GeneralIO as APin2;

    interface GeneralIO as BPin0;
    interface GeneralIO as BPin1;
    interface GeneralIO as BPin2;

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
