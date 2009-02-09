interface Engine {
  async command void setTopRotorStrength    (float);
  async command void setBottomRotorStrength (float);
  async command void rotateA ();
  async command void switchA ();
  async command void rotateB ();
  async command void switchB ();
}
