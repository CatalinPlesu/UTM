// Buzzer.cpp

#include "buzzer.hpp"

Buzzer::Buzzer(int pin) : pin(pin), enabled(false) {}

void Buzzer::init()
{
    pinMode(pin, OUTPUT);
    setToneChannel(0);
    disable(); // By default, the buzzer is disabled after initialization
}

void Buzzer::enable()
{
    enabled = true;
    ledcAttachPin(pin, 0);             // pin, channel
}

void Buzzer::disable()
{
    enabled = false;
    digitalWrite(pin, LOW); // Make sure the buzzer is off when disabled
    ledcDetachPin(pin);
}

void Buzzer::playTune(int frequency, uint64_t duration)
{
    if (enabled)
    {
        tone(pin, frequency, duration); // Example frequency for tune 1
        delay(500);      // Example duration
        noTone(pin);     // Stop the tone
    }
}

void Buzzer::playTune1()
{
    if (enabled)
    {
        tone(pin, 9000, 500); // Example frequency for tune 1
        delay(500);      // Example duration
        noTone(pin);     // Stop the tone
    }
}

void Buzzer::playTune2()
{
  ledcWriteNote(0, NOTE_F, 4);    // channel, frequency, octave
}
