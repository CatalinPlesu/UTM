#include "sensor/AdcMicrophoneAdapter.hpp"
#include <Arduino.h>

#define SENSOR_PIN A0
#define ADC_RESOLUTION 4096
#define PEAK_MIN_VALUE 20
#define PEAK_MAX_VALUE 1600
#define DB_MIN_VALUE 40
#define DB_MAX_VALUE 90
const int sampleWindow = 50; // Sample window width in mS (50 mS = 20Hz)
unsigned int sample;

AdcMicrophoneAdapter::AdcMicrophoneAdapter()
{
    // Constructor implementation
}

void AdcMicrophoneAdapter::init()
{
    // Set the input pin and resolution of the ADC
    pinMode(SENSOR_PIN, INPUT);
    analogReadResolution(12);
    initiated = true;
}

void AdcMicrophoneAdapter::read(ParameterType parameter)
{
    // No action needed for reading
}

float AdcMicrophoneAdapter::readValue(ParameterType parameter)
{
    int db = 0;
    switch (parameter)
    {
    case NOISE:
    {
        unsigned long startMillis = millis();    // Start of sample window
        float peakToPeak = 0;                    // peak-to-peak level
        unsigned int signalMax = 0;              // minimum value
        unsigned int signalMin = ADC_RESOLUTION; // maximum value

        // collect data for 50 mS
        while (millis() - startMillis < sampleWindow)
        {
            sample = analogRead(SENSOR_PIN); // get reading from microphone
            if (sample < ADC_RESOLUTION)     // toss out spurious readings
            {
                if (sample > signalMax)
                {
                    signalMax = sample; // save just the max levels
                }
                else if (sample < signalMin)
                {
                    signalMin = sample; // save just the min levels
                }
            }
        }

        peakToPeak = signalMax - signalMin;                                               // max - min = peak-peak amplitude
        db = map(peakToPeak, PEAK_MIN_VALUE, PEAK_MAX_VALUE, DB_MIN_VALUE, DB_MAX_VALUE); // calibrate for decibels
    }
    break;
    default:
        break;
    }

    return db;
}

bool AdcMicrophoneAdapter::test()
{
    // Check if ADC is working and value isn't 0 or the max value
    int adcValue = analogRead(SENSOR_PIN);
    testSucces = (adcValue != 0 && adcValue != ADC_RESOLUTION);
    return testSucces; // Simply check if sensor initialization succeeds
}
