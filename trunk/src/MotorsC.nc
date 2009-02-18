// Implements the real-life motor interface.
module MotorsC {
  provides {
    interface Motors;
  }
  uses {

    interface GeneralIO as TopRotorPin;
    interface GeneralIO as BottomRotorPin;
    interface GeneralIO as RollPin;
    interface GeneralIO as PitchPin;

  }
}

implementation {

  async command void Motors.setTopRotorPower    (float) { };
  async command void Motors.setBottomRotorPower (float) { };
  async command void Motors.setPitchPower       (float) { };
  async command void Motors.setRollPower        (float) { };

}
