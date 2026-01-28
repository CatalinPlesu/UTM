#ifndef BME680_ADAPTER_H
#define BME680_ADAPTER_H

#include "AbstractSensor.hpp"

class Bme680Adapter : public AbstractSensor {
public:
    Bme680Adapter(); // Constructor

    // Implementation of the AbstractSensor methods
    void init() override;
    void read(ParameterType parameter) override;
    float readValue(ParameterType parameter) override;
    bool test() override;

private:
    float calculateIAQ();
    void getGasReference();
    // Add any private members needed for BME680 initialization
};

#endif
