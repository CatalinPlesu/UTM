#ifndef TIMER_H
#define TIMER_H

#include "uArduino.h"
#include "stdbool.h"

typedef struct {
  unsigned long previousMillis;
  unsigned long interval;
} Timer;

void timer_init(Timer *timer, unsigned long interval);
bool timer_expired(Timer *timer);
void timer_reset(Timer *timer);
unsigned long timer_get_interval(Timer *timer);

#endif
