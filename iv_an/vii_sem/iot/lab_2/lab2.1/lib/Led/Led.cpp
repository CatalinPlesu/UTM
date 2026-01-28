#include "Led.h"

Led leds[LedCnt] =
{
    [Led1] = { LED_ON, LED_01},
    [Led2] = { LED_OFF, LED_02},
};

/**
 * @brief Init all led pins as output.
 */
void vDoLedInit()
{
  // Set LED pins as output
  for (int i = 0; i < LedCnt; i++)
  {
    pinMode(leds[i].pin, OUTPUT);
  }
  // put the leds in desired states
  vDoLedOn(Led1);
  vDoLedOff(Led2);
}

/**
 * @brief Trun the led on, and sets its sw state.
 */
void vDoLedOn(Leds led)
{
    digitalWrite(leds[led].pin, F_LED_ON);
    leds[led].state = LED_ON;
}

/**
 * @brief Trun the led off, and sets its sw state.
 */
void vDoLedOff(Leds led)
{
    digitalWrite(leds[led].pin, F_LED_OFF);
    leds[led].state = LED_OFF;
}

/**
 * @brief Toggle the led value state.
 */
void vDoLedToggle(Leds led)
{
    if(leds[led].state == LED_ON)
    {
        vDoLedOff(led);
    }
    else
    {
        vDoLedOn(led);
    }
}

/**
 * @brief Returns the led state
 */
LedState eDoGetLedState(Leds led)
{
    return leds[led].state;
}