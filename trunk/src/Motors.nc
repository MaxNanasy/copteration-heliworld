// An interface for controlling the four helicopter motors.
interface Motors {

  async command void setTopRotorPower    (float);
  async command void setBottomRotorPower (float);

  // These four commands refer to the stepper motors.  Please replace their names if you know of better ones.
  async command void rotateA ();
  async command void switchA ();
  async command void rotateB ();
  async command void switchB ();

}
