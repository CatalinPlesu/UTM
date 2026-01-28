#ifndef ARDUINIO_H_
#define UARDUINIO_H_

#include "stdint.h"

#define INPUT_PULLUP      0x02
#define OUTPUT            0x01

#define HIGH 1
#define LOW 0

void ArduinoInit();
unsigned long millis();
void pinMode(uint8_t pin, uint8_t mode);
int digitalRead(uint8_t pin);
void digitalWrite(uint8_t pin, uint8_t value);

#endif