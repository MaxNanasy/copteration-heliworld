module SwitchC {
  provides {
    interface GpioInterrupt;
  }
}

implementation {

  bool first = TRUE;

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
