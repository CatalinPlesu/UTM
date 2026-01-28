#include "sensor/Veml7700Adapter.hpp"
#include "Adafruit_VEML7700.h"
#include <Wire.h>

static Adafruit_VEML7700 veml;

// Constructor
Veml7700Adapter::Veml7700Adapter() {
    // Initialize VEML7700 sensor here if needed
    initiated = false;
    testSucces = false;
}

// Implementation of the AbstractSensor init() method
void Veml7700Adapter::init() {
    if(initiated)
    {
        return;
    }

    // Initialize VEML7700 sensor
    if (!veml.begin(&Wire)) {
        initiated = false;
    }
    initiated = true;
}

// Implementation of the AbstractSensor read() method
void Veml7700Adapter::read(ParameterType parameter) {
    // No action needed for starting a read with VEML7700, as it continuously updates values
    veml.enable(true);
}

// Implementation of the AbstractSensor readValue() method
float Veml7700Adapter::readValue(ParameterType parameter) {
    // Read value from VEML7700 sensor for the specified parameter
    float lux = 0.0;
    switch (parameter) {
        case ILLUMINATION:
            lux = veml.readLux(VEML_LUX_AUTO);
            break;
        default:
            break;
    }
    veml.enable(false);
    return lux;
}

// Implementation of the AbstractSensor test() method
bool Veml7700Adapter::test() {
    // Test VEML7700 sensor
    // Return true if the test passes, false otherwise
    testSucces = veml.begin(&Wire);
    return testSucces; // Simply check if sensor initialization succeeds
}
