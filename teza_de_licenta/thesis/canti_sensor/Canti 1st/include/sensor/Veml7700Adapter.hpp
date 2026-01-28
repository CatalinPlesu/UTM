// Veml7700Adapter.hpp

#ifndef VEML7700_ADAPTER_H
#define VEML7700_ADAPTER_H

#include "AbstractSensor.hpp"

class Veml7700Adapter : public AbstractSensor {
  public:
    Veml7700Adapter(); // Constructor
    void init() override; // Initialization method
    void read(ParameterType parameter) override; // Start reading method
    float readValue(ParameterType parameter) override; // Read sensor value method
    bool test() override; // Test sensor method
};

#endif
