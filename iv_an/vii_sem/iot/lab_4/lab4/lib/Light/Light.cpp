#include "Light.h"

void light_init(Relay* relay) {
  relay_init(relay);
}

void light_on(Relay* relay) {
  relay_on(relay);
}

void light_off(Relay* relay) {
  relay_off(relay);
}

void light_toggle(Relay* relay) {
  relay_toggle(relay);
}

LightState light_get_state(Relay* relay) {
  RelayState relayState = relay_get_state(relay);

  // Determine the light state based on the relay state
  if (relayState == POWER_OFF) {
    return LIGHT_ON;
  } else {
    return LIGHT_OFF;
  }
}
