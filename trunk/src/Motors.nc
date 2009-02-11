interface Motors {
  async command void setTopRotorPower    (float);
  async command void setBottomRotorPower (float);
  async command void rotateA ();
  async command void switchA ();
  async command void rotateB ();
  async command void switchB ();
}
