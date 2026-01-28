#include "Hbridge.h"
#include "Config.h" // Include the Config.h file with aliases
#include <Arduino.h>

L298 l298_new(u8 pinPNP0, u8 pinNPN0, u8 pinPNP1, u8 pinNPN1) {
  L298 motor;
  motor.pinPNP0 = pinPNP0;
  motor.pinNPN0 = pinNPN0;
  motor.pinPNP1 = pinPNP1;
  motor.pinNPN1 = pinNPN1;
  motor.valueA = 0;
  motor.valueB = 0;
  return motor;
}

void l298_init(L298* motor) {
  pinMode(motor->pinPNP0, OUTPUT);
  pinMode(motor->pinNPN0, OUTPUT);
  pinMode(motor->pinPNP1, OUTPUT);
  pinMode(motor->pinNPN1, OUTPUT);
  l298_stop(motor);
}

void l298_set_speed_A(L298* motor, u8 speed) {
  if (speed >= 0 && speed <= 100) {
    motor->valueA = map(speed, 0, 100, 0, 255);
    Serial.println(motor->valueA);
    l298_init(motor);
    digitalWrite(motor->pinPNP1, LOW);
    digitalWrite(motor->pinNPN1, LOW);
    analogWrite(motor->pinNPN0, motor->valueA);
    digitalWrite(motor->pinPNP0, LOW);
  }
}

void l298_set_speed_B(L298* motor, u8 speed) {
  if (speed >= 0 && speed <= 100) {
    motor->valueB = map(speed, 0, 100, 0, 255);
    Serial.println(motor->valueB);
    l298_init(motor);
    digitalWrite(motor->pinPNP0, LOW);
    digitalWrite(motor->pinNPN0, LOW);
    analogWrite(motor->pinNPN1, motor->valueB);
    digitalWrite(motor->pinPNP1, LOW);
  }
}

void l298_enable(L298* motor) {
}

void l298_disable(L298* motor) {
    l298_init(motor);
}

void l298_stop(L298* motor) {
  digitalWrite(motor->pinPNP0, LOW);
  digitalWrite(motor->pinNPN0, LOW);
  digitalWrite(motor->pinPNP1, LOW);
  digitalWrite(motor->pinNPN1, LOW);
  motor->valueA = 0;
  motor->valueB = 0;
}
