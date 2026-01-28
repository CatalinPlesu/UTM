#ifndef LIGHT_H
#define LIGHT_H

#include "Relay.h"
#include "Config.h"

enum LightState {
  LIGHT_OFF,
  LIGHT_ON
};

void light_init(Relay* relay);
void light_on(Relay* relay);
void light_off(Relay* relay);
void light_toggle(Relay* relay);
LightState light_get_state(Relay* relay);

#endif /* LIGHT_H */
