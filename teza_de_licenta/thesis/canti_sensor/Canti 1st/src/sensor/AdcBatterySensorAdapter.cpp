#include "sensor/AdcBatterySensorAdapter.hpp"
#include <Arduino.h>
#include <debug.h>

#define SENSOR_PIN A1
#define ADC_RESOLUTION 4096
#define CALIBRATION 300
#define MAX_BATTERY_VOLTAGE 4.2 // Maximum voltage of the LiPo battery
#define MIN_BATTERY_VOLTAGE 3.7
#define VOLTAGE_DIVIDER_RATIO 2.0 // Voltage divider ratio (R2 / (R1 + R2))

AdcBatterySensorAdapter::AdcBatterySensorAdapter()
{
    // Constructor implementation
}

void AdcBatterySensorAdapter::init()
{
    // Set the input pin and resolution of the ADC
    pinMode(SENSOR_PIN, INPUT);
    analogReadResolution(12);
    initiated = true;
}

void AdcBatterySensorAdapter::read(ParameterType parameter)
{
    // No action needed for reading
}

float AdcBatterySensorAdapter::readValue(ParameterType parameter)
{
    float percent = 0;
    switch (parameter)
    {
    case BATTERY:
    {
        // Read the raw ADC value from the sensor pin
        int raw = analogRead(SENSOR_PIN);

        // Convert the raw ADC value to battery voltage
        float batteryVoltage = (raw - CALIBRATION) * (3.3 / ADC_RESOLUTION) * VOLTAGE_DIVIDER_RATIO;

        percent = map(batteryVoltage * 1000, MIN_BATTERY_VOLTAGE * 1000, MAX_BATTERY_VOLTAGE * 1000, 0, 1000) / 10.0; // Multiply by 1000 to avoid floating point operations
        // Ensure the battery percentage is within the valid range
        percent = constrain(percent, 0, 100);
    }
    break;
    default:
        break;
    }

    return percent;
}

bool AdcBatterySensorAdapter::test()
{
    // Check if ADC is working and value isn't 0 or the max value
    int adcValue = analogRead(SENSOR_PIN);
    testSucces = (adcValue != 0 && adcValue != ADC_RESOLUTION);
    return testSucces; // Simply check if sensor initialization succeeds
}
