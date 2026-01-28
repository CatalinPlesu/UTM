#include "Motor.h"

void motor_init(L298* motor) {
    l298_init(motor);
    l298_enable(motor);
}

void motor_set_speed(L298* motor, i8 speed) {
    if (speed > 0) {
        l298_set_speed_A(motor, (u8)speed);
    } else if (speed < 0) {
        l298_set_speed_B(motor, (u8)(-speed));
    } else {
        l298_stop(motor);
    }
}

void motor_enable(L298* motor) {
    l298_enable(motor);
}

void motor_disable(L298* motor) {
    l298_disable(motor);
}

void motor_stop(L298* motor) {
    l298_stop(motor);
}
