#include "ULN2003.h"
#include "Config.h" // Include the Config.h file with aliases
#include <Arduino.h>

L298 l298_new(Stepper stepper){
  
  stepper.setSpeed(0); // Set initial speed to 0
  ULN2003 stepperMotor = { &stepper, 1};
  return stepperMotor;
}

void l298_init(L298* motor) {
  motor->stepper->setSpeed(0);
}

void l298_set_speed_A(L298* motor, u8 speed) {
  if (speed >= 0 && speed <= 100) {
    motor->stepper->setSpeed(speed);
    motor->direction = 1;
  }
}

void l298_set_speed_B(L298* motor, u8 speed) {
  if (speed >= 0 && speed <= 100) {
    motor->stepper->setSpeed(speed);
    motor->direction = -1;
  }
}

void l298_move(L298* motor)
{
  motor->stepper->step(motor->direction);
}

void l298_enable(L298* motor) {
}

void l298_disable(L298* motor) {
    motor->stepper->setSpeed(0);
}

void l298_stop(L298* motor) {
  motor->stepper->setSpeed(0);
}
