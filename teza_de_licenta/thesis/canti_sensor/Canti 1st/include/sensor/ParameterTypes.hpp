#ifndef PARAMETERTYPE_H
#define PARAMETERTYPE_H
#include <string>

enum ParameterType
{
    NONE,
    BATTERY = 1,
    TEMPERATURE = 10,
    HUMIDITY = 20,
    PRESSURE = 30,
    ALTITUDE = 31,
    VOCS = 40,
    NOISE = 50,
    ILLUMINATION = 60,
    UV = 70
};

std::string parameterTypeToString(ParameterType type);

#endif
