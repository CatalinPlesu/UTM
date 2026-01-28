#ifndef L298_H
#define L298_H

#include "Config.h" // Include the Config.h file with aliases

struct L298 {
  u8 pinA;
  u8 pinB;
  u8 enablePin;
  u8 valueA;
  u8 valueB;
};

L298 l298_new(u8 pinA, u8 pinB, u8 enablePin);
void l298_init(L298* motor);
void l298_set_speed_A(L298* motor, u8 speed);
void l298_set_speed_B(L298* motor, u8 speed);
void l298_enable(L298* motor);
void l298_disable(L298* motor);
void l298_stop(L298* motor);

#endif
