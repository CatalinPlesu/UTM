#ifndef RELAY_H
#define RELAY_H

#include <Arduino.h>
#include "Config.h" 

enum RelayState {
  POWER_OFF,
  POWER_ON
};

enum RelayType {
  NORMALLY_OPEN,
  NORMALLY_CLOSED
};

struct Relay {
  uint8_t pin;
  RelayState state;
  RelayType type;
};

Relay relay_new(uint8_t pin, RelayType relayType);
void relay_init(Relay* relay);
void relay_on(Relay* relay);
void relay_off(Relay* relay);
void relay_toggle(Relay* relay);
RelayState relay_get_state(Relay* relay);


#endif /* RELAY_H */
