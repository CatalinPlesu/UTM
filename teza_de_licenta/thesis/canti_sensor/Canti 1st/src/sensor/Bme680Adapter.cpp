#include "sensor/Bme680Adapter.hpp"
#include <Adafruit_BME680.h>
#include <Wire.h>

static Adafruit_BME680 bme(&Wire);
#define SEALEVELPRESSURE_HPA (1013.25)

float gas_reference = 250000;
int getgasreference_count = 0;

// Constructor
Bme680Adapter::Bme680Adapter()
{
    // Initialize BME680 sensor here if needed
    initiated = false;
    testSucces = false;
}

// Implementation of the AbstractSensor init() method
void Bme680Adapter::init()
{
    if(initiated)
    {
        return;
    }
    
    // Initialize BME680 sensor
    if (!bme.begin())
    {
        initiated = false;
    }
    // Set up oversampling and filter initialization
    bme.setTemperatureOversampling(BME680_OS_2X);
    bme.setHumidityOversampling(BME680_OS_2X);
    bme.setPressureOversampling(BME680_OS_2X);
    bme.setIIRFilterSize(BME680_FILTER_SIZE_3);
    bme.setGasHeater(320, 150); // 320°C for 150 ms
    // Now run the sensor for a burn-in period, then use combination of relative humidity and gas resistance to estimate indoor air quality as a percentage.
    getGasReference();
    initiated = true;
}

// Implementation of the AbstractSensor beginReading() method
void Bme680Adapter::read(ParameterType parameter)
{
    bme.performReading();
}

// Implementation of the AbstractSensor readValue() method
float Bme680Adapter::readValue(ParameterType parameter)
{
    // Read value from BME680 sensor for the specified parameter
    switch (parameter)
    {
    case TEMPERATURE:
        return bme.readTemperature();
    case HUMIDITY:
        return bme.readHumidity();
    case PRESSURE:
        return bme.readPressure() / 100.0f; // Convert Pa to hPa
    case ALTITUDE:
        return bme.readAltitude(SEALEVELPRESSURE_HPA);
    case VOCS:
        // Calculate IAQ and return as VOC concentration
        return calculateIAQ();
    default:
        // Return a default value if parameter is not supported or if reading fails
        return 0.0f;
    }
}

// Implementation of the AbstractSensor test() method
bool Bme680Adapter::test()
{
    // Test BME680 sensor
    // Return true if the test passes, false otherwise
    testSucces = bme.begin();
    return testSucces; // Simply check if sensor initialization succeeds
}

// Method to calculate Indoor Air Quality (IAQ) as VOC concentration
float Bme680Adapter::calculateIAQ()
{
    // Calculate humidity contribution to IAQ index
    float current_humidity = bme.readHumidity();
    float hum_score;
    if (current_humidity >= 38 && current_humidity <= 42)
        hum_score = 0.25 * 100; // Humidity +/-5% around optimum
    else
    {
        // Sub-optimal humidity
        if (current_humidity < 38)
            hum_score = 0.25 / 40 * current_humidity * 100;
        else
            hum_score = ((-0.25 / (100 - 40) * current_humidity) + 0.416666) * 100;
    }

    // Calculate gas contribution to IAQ index
    float gas_lower_limit = 5000;  // Bad air quality limit
    float gas_upper_limit = 50000; // Good air quality limit
    if (gas_reference > gas_upper_limit)
        gas_reference = gas_upper_limit;
    if (gas_reference < gas_lower_limit)
        gas_reference = gas_lower_limit;
    float gas_score = (0.75 / (gas_upper_limit - gas_lower_limit) * gas_reference - (gas_lower_limit * (0.75 / (gas_upper_limit - gas_lower_limit)))) * 100;

    // Combine results for the final IAQ index value (0-100% where 100% is good quality air)
    return hum_score + gas_score;
}

// Method to get a new gas reference value
void Bme680Adapter::getGasReference()
{
    // Now run the sensor for a burn-in period, then use combination of relative humidity and gas resistance to estimate indoor air quality as a percentage.
    int readings = 10;
    for (int i = 1; i <= readings; i++)
    { // Read gas for 10 x 0.150mS = 1.5secs
        gas_reference += bme.readGas();
    }
    gas_reference /= readings;
}
