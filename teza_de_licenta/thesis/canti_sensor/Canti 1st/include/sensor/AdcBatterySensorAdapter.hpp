#ifndef ADC_BATTERY_SENSOR_ADAPTER_H
#define ADC_BATTERY_SENSOR_ADAPTER_H

#include "AbstractSensor.hpp"

class AdcBatterySensorAdapter : public AbstractSensor {
  public:
    AdcBatterySensorAdapter(); // Constructor
    void init() override; // Implementation of the AbstractSensor init() method
    void read(ParameterType parameter) override; // Implementation of the AbstractSensor read() method
    float readValue(ParameterType parameter) override; // Implementation of the AbstractSensor readValue() method
    bool test() override; // Implementation of the AbstractSensor test() method
};

#endif
