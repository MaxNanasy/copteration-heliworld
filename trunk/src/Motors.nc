// An interface for controlling the four helicopter motors.
interface Motors {

  // Format of description:
  // Input: [minimum, maximum]
  // The affected motor's power scales linearly from 0 at minimum to full power at maximum.

  // Input: [0, 1]
  command void setTopRotorPower    (float);
  command void setBottomRotorPower (float);

  // Input: [.5, 0] for backward; [.5, 1] for forward
  command void setPitchPower       (float); //tilt forward and backward

  // Input: [.5, 0] for left    ; [.5, 1] for right
  command void setRollPower        (float); //tilt left and right

}
