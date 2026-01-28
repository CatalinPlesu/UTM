// AbstractSensor.h

#ifndef ABSTRACTSENSOR_H
#define ABSTRACTSENSOR_H

#include "sensor/ParameterTypes.hpp"

class AbstractSensor {
  public:
    virtual void init() = 0; // Pure virtual function for initialization
    virtual void read(ParameterType parameter) = 0; // Pure virtual function to start reading
    virtual float readValue(ParameterType parameter) = 0; // Pure virtual function for reading sensor value
    virtual bool test() = 0; // Pure virtual function for testing
    bool initiated;
    bool testSucces;
};

#endif
