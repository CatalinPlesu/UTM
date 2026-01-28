#include "Timer.h"

/**
 * @brief Init the sw timer with the desired interval
 */
void timer_init(Timer *timer, unsigned long interval) {
  timer->interval = interval;
  timer->previousMillis = millis();
}

/**
 * @brief Check if the sw timer has expired
 */
bool timer_expired(Timer *timer) {
  unsigned long currentMillis = millis();
  if (currentMillis - timer->previousMillis >= timer->interval) {
    timer->previousMillis = currentMillis;
    return true;
  }
  return false;
}

/**
 * @brief Restarts the sw timer so it will count again.
 */
void timer_reset(Timer *timer) {
  timer->previousMillis = millis();
}

/**
 * @brief Gets the sw timer interval value.
 */
unsigned long timer_get_interval(Timer *timer) {
  return timer->interval;
}