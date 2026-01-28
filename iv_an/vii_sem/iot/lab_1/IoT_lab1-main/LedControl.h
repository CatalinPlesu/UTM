#ifndef LEDCONTROL_H
#define LEDCONTROL_H

#include <Arduino.h>

/* Define LED pins */
#define LED_PIN D0

extern void LedInit(void);
extern void LedTurnOn(uint8_t pin);
extern void LedTurnOff(uint8_t pin);

#endif
