// This provides a simulation of the output of the switch on the remote.
module SwitchC {
  provides {
    interface GpioInterrupt;
  }
}

implementation {

  bool first = TRUE;

  // The first time the switch is enabled, it acts as if it has been pressed; thereafter, it acts as if it has not been pressed.
  async command error_t GpioInterrupt.enableRisingEdge ()
  {
    if (first) {
      first = FALSE;
      signal GpioInterrupt.fired ();
    }
    return SUCCESS;
  }

  async command error_t GpioInterrupt.enableFallingEdge ()
  {
    return SUCCESS;
  }

  async command error_t GpioInterrupt.disable ()
  {
    return SUCCESS;
  }

}
