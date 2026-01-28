#ifndef ULN2003_H
#define ULN2003_H

#include "Config.h" // Include the Config.h file with aliases
#include <Stepper.h>

struct ULN2003 {
  Stepper* stepper;
  u8 direction;
};
typedef ULN2003 L298;

#define STEPS 32

L298 l298_new(Stepper* stepper);
void l298_init(L298* motor);
void l298_set_speed_A(L298* motor, u8 speed);
void l298_set_speed_B(L298* motor, u8 speed);
void l298_enable(L298* motor);
void l298_disable(L298* motor);
void l298_move(L298* motor);
void l298_stop(L298* motor);

#endif
