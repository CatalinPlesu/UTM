#include "sensor/SHT40Adapter.hpp"
#include <Wire.h>
#include <SHTSensor.h>

SHTSensor sht;

SHT40Adapter::SHT40Adapter()
{
    // Constructor implementation
}

void SHT40Adapter::init()
{
    Wire.begin();
    // Initialize the sht sensor
    if (!sht.init())
    {
        initiated = false;
        return;
    }
    sht.setAccuracy(SHTSensor::SHTAccuracy::SHT_ACCURACY_HIGH);
    initiated = true;
}

void SHT40Adapter::read(ParameterType parameter)
{
    // No specific action needed for reading the sht sensor
    sht.readSample();
}

float SHT40Adapter::readValue(ParameterType parameter)
{
    // Read value from the sht sensor for the specified parameter
    switch (parameter)
    {
    case TEMPERATURE:
        return sht.getTemperature();
    case HUMIDITY:
        return sht.getHumidity();
    default:
        return 0.0; // Default value if parameter not supported or if reading fails
    }
}

bool SHT40Adapter::test()
{
    testSucces = sht.init(Wire);
    return testSucces;
}
