#include "SensorManager.hpp"
#include <sensor/Bme680Adapter.hpp>
#include <sensor/Veml7700Adapter.hpp>
#include <sensor/AdcMicrophoneAdapter.hpp>
#include "sensor/SHT40Adapter.hpp"
#include <RTCSingleton.hpp>
#include <debug.h>
#include <sensor/AdcBatterySensorAdapter.hpp>

RTC_DATA_ATTR float value[MAX_SENSORS];
RTC_DATA_ATTR uint64_t last_read[MAX_SENSORS];
RTC_DATA_ATTR uint32_t recurrence[MAX_SENSORS];

SensorManager::SensorManager()
{
    currentSize = 0;
    AdcBatterySensorAdapter *bat = new AdcBatterySensorAdapter();
    SHT40Adapter *sht40 = new SHT40Adapter();
    Bme680Adapter *bme = new Bme680Adapter();
    Veml7700Adapter *veml = new Veml7700Adapter();
    AdcMicrophoneAdapter *mic = new AdcMicrophoneAdapter();

    // addSensor(BATTERY, DEFAULT_RECURRENCE, bat);
    addSensor(TEMPERATURE, DEFAULT_RECURRENCE, bme);
    addSensor(HUMIDITY, DEFAULT_RECURRENCE, bme);
    addSensor(PRESSURE, DEFAULT_RECURRENCE, bme);
    addSensor(ALTITUDE, DEFAULT_RECURRENCE, bme);
    addSensor(VOCS, DEFAULT_RECURRENCE, bme);
    addSensor(ILLUMINATION, DEFAULT_RECURRENCE, veml);
    addSensor(NOISE, DEFAULT_RECURRENCE, mic);

#if DEBUGENABLE == 1
    printSensorInformation();
#endif
}

inline void SensorManager::printSensorInfo(int index)
{
    DEBUG("Sensor %2d - Parameter: %13s, Recurrence: %3d\n", index + 1, parameterTypeToString(sensors[index].parameter).c_str(), recurrence[index]);
}

void SensorManager::printSensorInformation()
{
    DEBUG("Number of sensors added: %d\n", currentSize);
    for (int i = 0; i < currentSize; ++i)
    {
        printSensorInfo(i);
    }
}

void SensorManager::addSensor(ParameterType parameter, int recurrence_value, AbstractSensor *sensor)
{
    if (currentSize < MAX_SENSORS)
    {
        sensors[currentSize].parameter = parameter;
        sensors[currentSize].sensor = sensor;
        recurrence[currentSize] = recurrence_value;
        currentSize += 1;
    }
    else
    {
        // Handle error: array full
    }
}

ParameterType SensorManager::getSupportedParameter(bool reset)
{
    static int i = 0;
    if (reset || i > currentSize)
    {
        i = 0;
        return ParameterType::NONE;
    }
    ParameterType p = sensors[i].parameter;
    i += 1;
    return p;
}

void SensorManager::setRecurrenceWithIndex(ParameterType index, int new_recurrence)
{
    for (int i = 0; i < currentSize; ++i)
    {
        if (sensors[i].parameter == index)
        {
            DEBUG("Old sensor config\n");
            printSensorInfo(i);
            recurrence[i] = new_recurrence;
            DEBUG("New sensor config\n");
            printSensorInfo(i);
            break; // Exit loop once recurrence is set
        }
    }

#if DEBUGENABLE == 1
    printSensorInformation();
#endif
}

uint32_t SensorManager::getRecurrenceWithIndex(ParameterType index)
{
    for (int i = 0; i < currentSize; ++i)
    {
        if (sensors[i].parameter == index)
        {
            return recurrence[i];
        }
    }
}

void SensorManager::initAll()
{
    for (int i = 0; i < currentSize; ++i)
    {
        sensors[i].sensor->init();
    }
}

void SensorManager::testAll()
{
    for (int i = 0; i < currentSize; ++i)
    {
        sensors[i].sensor->test();
    }
}

void SensorManager::readAll()
{
    for (int i = 0; i < currentSize; ++i)
    {
        sensors[i].sensor->read(sensors[i].parameter);
        last_read[i] = RTCSingleton::rtc.getEpoch();
    }
}

void SensorManager::loop()
{
    // Initialize state and iteration counters
    static ManagingStates currentState = ManagingStates::INITIALIZATION;
    static int iterationCount = 0;

    switch (currentState)
    {
    case ManagingStates::INITIALIZATION:
        // Initialize one sensor at a time
        if (iterationCount < currentSize)
        {
            if (sensors[iterationCount].sensor->initiated != true)
            {
                sensors[iterationCount].sensor->init();
            }
            iterationCount++;
        }
        else
        {
            currentState = ManagingStates::TESTING; // Move to TESTING state after initialization
            iterationCount = 0;                     // Reset iteration counter
        }
        break;

    case ManagingStates::TESTING:
        // Test one sensor at a time
        if (iterationCount < currentSize)
        {
            if (sensors[iterationCount].sensor->testSucces != true)
            {
                sensors[iterationCount].sensor->test();
            }
            iterationCount++;
        }
        else
        {
            currentState = ManagingStates::READING; // Move to READING state after testing all sensors
            iterationCount = 0;                     // Reset iteration counter
        }
        break;

    case ManagingStates::READING:
        // Read one sensor at a time
        if (iterationCount < currentSize)
        {
            if (recurrence[iterationCount] > 0 && (RTCSingleton::rtc.getEpoch() - last_read[iterationCount]) >= recurrence[iterationCount])
            {
                value[iterationCount] = sensors[iterationCount].sensor->readValue(sensors[iterationCount].parameter);
                last_read[iterationCount] = RTCSingleton::rtc.getEpoch();
                if (alarmCallback)
                {
                    alarmCallback();
                }
            }
            iterationCount++;
        }
        else
        {
            currentState = ManagingStates::WAITING; // Move to WAITING state after reading all sensors
            iterationCount = 0;                     // Reset iteration counter
        }
        break;

    case ManagingStates::WAITING:
        // Check if any recurrence has expired
        for (int i = 0; i < currentSize; ++i)
        {
            if (recurrence[i] > 0 && (RTCSingleton::rtc.getEpoch() - last_read[i]) >= recurrence[i])
            {
                // Recurrence has expired for at least one sensor
                currentState = ManagingStates::READING; // Transition to READING state
                break;
            }
        }
        break;

    default:
        break;
    }
}

float SensorManager::getValue(ParameterType parameter)
{
    for (int i = 0; i < currentSize; i++)
    {
        if (parameter == sensors[i].parameter)
        {
            return value[i];
        }
    }
}