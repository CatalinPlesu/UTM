#include "sensor/ParameterTypes.hpp"

std::string parameterTypeToString(ParameterType type)
{
    // Switch statement to convert enum values to strings
    switch (type)
    {
    case NONE:
        return "NONE";
    case BATTERY:
        return "BATTERY";
    case TEMPERATURE:
        return "TEMPERATURE";
    case HUMIDITY:
        return "HUMIDITY";
    case PRESSURE:
        return "PRESSURE";
    case ALTITUDE:
        return "ALTITUDE";
    case VOCS:
        return "VOCS";
    case NOISE:
        return "NOISE";
    case ILLUMINATION:
        return "ILLUMINATION";
    case UV:
        return "UV";
    default:
        return "UNKNOWN";
    }
}