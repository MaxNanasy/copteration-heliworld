module NetworkC {
  provides {
    interface AMSend;
    interface Receive;
  }
}

implementation {

  command error_t AMSend.send (am_addr_t addr, message_t *msg, uint8_t len)
  {
    signal Receive.receive (msg, msg, len);
    signal AMSend.sendDone (msg, SUCCESS);
    return SUCCESS;
  }

  command error_t AMSend.cancel (message_t *msg)
  {
    return SUCCESS;
  }

  command uint8_t AMSend.maxPayloadLength ()
  {
    return 0;
  }

  command void *AMSend.getPayload (message_t *msg, uint8_t len)
  {
    return NULL;
  }

}
