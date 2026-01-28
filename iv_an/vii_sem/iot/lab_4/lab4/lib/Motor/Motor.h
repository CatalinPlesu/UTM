#ifndef MOTOR_H
#define MOTOR_H

#include "ULN2003.h"

void motor_init(L298* motor);
void motor_set_speed(L298* motor, i8 speed);
void motor_enable(L298* motor);
void motor_disable(L298* motor);
void motor_stop(L298* motor);

#endif
