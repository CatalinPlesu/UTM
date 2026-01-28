#ifndef RTCSINGLETON_H
#define RTCSINGLETON_H

#include <ESP32Time.h>

class RTCSingleton {
public:
    // Public static instance of ESP32Time for managing RTC
    static ESP32Time rtc;

    // Prevent instantiation by deleting the constructor
    RTCSingleton() = delete;
};
    
#endif // RTCSINGLETON_H
