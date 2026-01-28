#include "Timer.h"

void timer_init(Timer *timer, unsigned long interval) {
  timer->interval = interval;
  timer->previousMillis = millis();
}

bool timer_expired(Timer *timer) {
  unsigned long currentMillis = millis();
  if (currentMillis - timer->previousMillis >= timer->interval) {
    timer->previousMillis = currentMillis;
    return true;
  }
  return false;
}

void timer_reset(Timer *timer) {
  timer->previousMillis = millis();
}

unsigned long timer_get_interval(Timer *timer) {
  return timer->interval;
}