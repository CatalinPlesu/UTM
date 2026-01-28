#include "Relay.h"

Relay relay_new(uint8_t pin, RelayType relayType) {
  Relay relay;
  relay.pin = pin;
  relay.type = relayType;
  return relay;
}

void relay_init(Relay* relay) {
  pinMode(relay->pin, OUTPUT);
  if (relay->type == NORMALLY_CLOSED) {
    digitalWrite(relay->pin, HIGH);
  } else {
    digitalWrite(relay->pin, LOW);
  }
  relay->state = POWER_OFF;

}

void relay_on(Relay* relay) {
  if (relay->type == NORMALLY_CLOSED) {
    digitalWrite(relay->pin, LOW);
  } else {
    digitalWrite(relay->pin, HIGH);
  }
  relay->state = POWER_OFF;
}

void relay_off(Relay* relay) {
  if (relay->type == NORMALLY_CLOSED) {
    digitalWrite(relay->pin, HIGH);
  } else {
    digitalWrite(relay->pin, LOW);
  }
  relay->state = POWER_ON;
}

void relay_toggle(Relay* relay) {
  if (relay->state == POWER_OFF) {
    relay_off(relay);
  } else {
    relay_on(relay);
  }
}

RelayState relay_get_state(Relay* relay)
{
    return relay->state;
}