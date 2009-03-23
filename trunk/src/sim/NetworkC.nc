module NetworkC {
  provides {
    interface AMSend;
    interface Receive;
    interface Packet;
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

  command void Packet.clear (message_t *msg) { }

  command void *Packet.getPayload (message_t *msg, uint8_t len)
  {
    return msg;
  }

  command uint8_t Packet.maxPayloadLength ()
  {
    return 1;
  }

  command uint8_t Packet.payloadLength (message_t *msg)
  {
    return 1;
  }

  command void Packet.setPayloadLength (message_t *msg, uint8_t len) { }

}
