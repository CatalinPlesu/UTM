// Buzzer.hpp

#ifndef BUZZER_HPP
#define BUZZER_HPP

#include <Arduino.h>

class Buzzer {
public:
    Buzzer(int pin);
    void init();
    void enable();
    void disable();
    void playTune(int frequency, uint64_t duration);
    void playTune1();
    void playTune2();

private:
    int pin;
    bool enabled;
};

#endif // BUZZER_HPP
