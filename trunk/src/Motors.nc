// An interface for controlling the four helicopter motors.
interface Motors {
  
  async command void setTopRotorPower    (float power);
  async command void setBottomRotorPower (float);
  async command void setPitchPower       (float); //tilt forward and backward
  async command void setRollPower        (float); //tilt left and right

}
