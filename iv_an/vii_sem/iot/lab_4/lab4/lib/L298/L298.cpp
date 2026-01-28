#include "L298.h"
#include "Config.h" // Include the Config.h file with aliases
#include <Arduino.h>

L298 l298_new(u8 pinA, u8 pinB, u8 enablePin) {
  L298 motor;
  motor.pinA = pinA;
  motor.pinB = pinB;
  motor.enablePin = enablePin;
  motor.valueA = 0;
  motor.valueB = 0;
  return motor;
}

void l298_init(L298* motor) {
  pinMode(motor->pinA, OUTPUT);
  pinMode(motor->pinB, OUTPUT);
  pinMode(motor->enablePin, OUTPUT);
  digitalWrite(motor->pinA, LOW);
  digitalWrite(motor->pinB, LOW);
  digitalWrite(motor->enablePin, LOW);
}

void l298_set_speed_A(L298* motor, u8 speed) {
  if (speed >= 0 && speed <= 100) {
    motor->valueA = map(speed, 0, 100, 0, 255);
    analogWrite(motor->pinA, motor->valueA);
    digitalWrite(motor->pinB, LOW);
  }
}

void l298_set_speed_B(L298* motor, u8 speed) {
  if (speed >= 0 && speed <= 100) {
    motor->valueB = map(speed, 0, 100, 0, 255);
    analogWrite(motor->pinB, motor->valueB);
    digitalWrite(motor->pinA, LOW);
  }
}

void l298_enable(L298* motor) {
  digitalWrite(motor->enablePin, HIGH);
}

void l298_disable(L298* motor) {
  digitalWrite(motor->enablePin, LOW);
  analogWrite(motor->pinA, 0);
  analogWrite(motor->pinB, 0);
  digitalWrite(motor->pinA, LOW);
  digitalWrite(motor->pinB, LOW);
  motor->valueA = 0;
  motor->valueB = 0;
}

void l298_stop(L298* motor) {
  digitalWrite(motor->pinA, LOW);
  digitalWrite(motor->pinB, LOW);
  motor->valueA = 0;
  motor->valueB = 0;
}
