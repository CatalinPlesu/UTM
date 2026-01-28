#include "LedControl.h"

void LedInit(void){
  pinMode(LED_PIN, OUTPUT);
}

void LedTurnOn(uint8_t pin) {
  digitalWrite(pin, HIGH);
}

void LedTurnOff(uint8_t pin) {
  digitalWrite(pin, LOW);
}
