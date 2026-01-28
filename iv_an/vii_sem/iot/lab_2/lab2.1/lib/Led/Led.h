#ifndef LED_H_
#define LED_H_

#include "Arduino.h"

#define LED_01 5
#define LED_02 4

#define F_LED_ON 0
#define F_LED_OFF 1

typedef enum{
  LED_OFF,    // LED is off
  LED_ON      // LED is on
}LedState;

typedef struct {
  LedState state;
  uint8_t pin;
} Led;

enum Leds {
  Led1 = 0,
  Led2 = 1,
  LedCnt
};

void vDoLedInit();
void vDoLedOn(Leds led);
void vDoLedOff(Leds led);
void vDoLedToggle(Leds led);
LedState eDoGetLedState(Leds led);

#endif