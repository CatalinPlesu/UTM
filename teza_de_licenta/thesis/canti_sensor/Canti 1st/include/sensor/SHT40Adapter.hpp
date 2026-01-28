#ifndef SHT40_ADAPTER_H
#define SHT40_ADAPTER_H

#include "AbstractSensor.hpp"

class SHT40Adapter : public AbstractSensor {
  public:
    SHT40Adapter(); // Constructor
    void init() override; // Implementation of the AbstractSensor init() method
    void read(ParameterType parameter) override; // Implementation of the AbstractSensor read() method
    float readValue(ParameterType parameter) override; // Implementation of the AbstractSensor readValue() method
    bool test() override; // Implementation of the AbstractSensor test() method
};

#endif
