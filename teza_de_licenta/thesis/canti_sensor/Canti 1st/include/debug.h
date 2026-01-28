#ifndef DEBUG_MACROS_H
#define DEBUG_MACROS_H

#include <Arduino.h>
#include <RTCSingleton.hpp>

#if DEBUGENABLE == 1

#define DEBUGINIT(rate) USBSerial.begin(rate)
#define DEBUG(...) USBSerial.printf(__VA_ARGS__)
#define TIMESTAMP() DEBUG("%d/%d/%d | %d:%d:%d:%d\n", RTCSingleton::rtc.getDay(), RTCSingleton::rtc.getMonth() + 1, RTCSingleton::rtc.getYear(), RTCSingleton::rtc.getHour(), RTCSingleton::rtc.getMinute(), RTCSingleton::rtc.getSecond(), RTCSingleton::rtc.getMillis())

#else

#define DEBUGINIT(rate)
#define DEBUG(...)
#define TIMESTAMP()

#endif

#endif /* DEBUG_MACROS_H */
