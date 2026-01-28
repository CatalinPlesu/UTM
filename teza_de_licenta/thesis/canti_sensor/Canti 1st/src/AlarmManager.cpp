#include "AlarmManager.hpp"
#include <SensorManager.hpp>
#include <debug.h>

SensorManager *sensorManager4 = nullptr;

#define ALARM_SNOOZE_TIME (5 * 60)

// Array to store alarms
RTC_DATA_ATTR Alarm alarms[MAX_ALARMS][MAX_PARAMETERS_PER_ALARM];
RTC_DATA_ATTR uint8_t triggered[MAX_ALARMS] = {};
RTC_DATA_ATTR bool enabled[MAX_ALARMS] = {};
RTC_DATA_ATTR uint64_t snoozeUntil[MAX_ALARMS] = {};

bool new_data = false;

Buzzer *b = nullptr;

AlarmManager::AlarmManager()
{
    sensorManager4 = &SensorManager::getInstance();
    sensorManager4->setAlarmCallback(std::bind(&AlarmManager::onSensorRead, this));
    // Initialize alarms
    for (int i = 0; i < MAX_ALARMS; ++i)
    {
        for (int j = 0; j < MAX_PARAMETERS_PER_ALARM; ++j)
        {
            alarms[i][j].parameterIndex = ParameterType::NONE;
        }
        enabled[i] = false; // Initially, all alarms are disabled
        triggered[i] = 0;   // Initially, all alarms are not triggered
    }
    new_data = false;
}

void AlarmManager::setBuzzer(Buzzer *_b)
{
    b = _b;
}

void AlarmManager::onSensorRead()
{
    new_data = true;
    DEBUG("On sensor read\n");
}

void AlarmManager::setAlarm(uint8_t alarmIndex, ParameterType parameter, IntervalType intervalType, float lowerValue, float upperValue)
{
    // Find the first available slot for the parameter index
    int availableSlot = -1;
    for (int i = 0; i < MAX_PARAMETERS_PER_ALARM; ++i)
    {
        if (alarms[alarmIndex][i].parameterIndex == ParameterType::NONE || alarms[alarmIndex][i].parameterIndex == parameter)
        {
            availableSlot = i;
            break;
        }
    }

    // If no available slot was found, return without setting the alarm
    if (availableSlot == -1)
    {
        return;
    }

    // Populate the found slot with the alarm configuration
    alarms[alarmIndex][availableSlot].parameterIndex = parameter;
    alarms[alarmIndex][availableSlot].intervalType = intervalType;
    alarms[alarmIndex][availableSlot].lowerValue = lowerValue;
    alarms[alarmIndex][availableSlot].upperValue = upperValue;
}

Alarm AlarmManager::getAlarm(uint8_t alarmIndex, ParameterType parameter)
{
    Alarm emptyAlarm;                                // Create an empty alarm to return if the alarm is not found
    emptyAlarm.parameterIndex = ParameterType::NONE; // Set the parameter index to NONE for the empty alarm

    // Iterate through the alarms for the specified alarm index
    for (int i = 0; i < MAX_PARAMETERS_PER_ALARM; ++i)
    {
        // Check if the parameter index matches the specified parameter
        if (alarms[alarmIndex][i].parameterIndex == parameter)
        {
            // Return the alarm if found
            return alarms[alarmIndex][i];
        }
    }

    // If the alarm is not found, return the empty alarm
    return emptyAlarm;
}

void AlarmManager::enableAlarm(uint8_t alarmIndex)
{
    if (alarmIndex < MAX_ALARMS)
    {
        enabled[alarmIndex] = true;
    }
    printAlarms();
}

void AlarmManager::disableAlarm(uint8_t alarmIndex)
{
    if (alarmIndex < MAX_ALARMS)
    {
        enabled[alarmIndex] = false;
    }
    printAlarms();
}

void AlarmManager::deleteAlarm(uint8_t alarmIndex)
{
    if (alarmIndex < MAX_ALARMS)
    {
        // Reset alarm configuration
        for (int i = 0; i < MAX_PARAMETERS_PER_ALARM; ++i)
        {
            alarms[alarmIndex][i].parameterIndex = ParameterType::NONE;
            alarms[alarmIndex][i].intervalType = IntervalType::DISABLED_INTERVAL;
            alarms[alarmIndex][i].lowerValue = 0.0f;
            alarms[alarmIndex][i].upperValue = 0.0f;
        }
        enabled[alarmIndex] = false;
        triggered[alarmIndex] = 0;
    }
}

void AlarmManager::snoozeTriggeredAalarms()
{
    // Snooze all triggered alarms
    for (int i = 0; i < MAX_ALARMS; ++i)
    {
        if (triggered[i] > 0)
        {
            // Set the snoozeUntil time to current epoch time plus snooze time
            snoozeUntil[i] = RTCSingleton::rtc.getEpoch() + ALARM_SNOOZE_TIME;
            triggered[i] = 0; // Reset triggered status
        }
    }
}

void AlarmManager::loop()
{
    if (new_data)
    {
        DEBUG("Evaluating alarm condition\n");
        // Check if any alarm is triggered
        for (int i = 0; i < MAX_ALARMS; ++i)
        {
            if (enabled[i] == false)
            {
                continue;
            }
            triggered[i] = ALARM_TRIGGER_CYCLES;
            for (int j = 0; j < MAX_PARAMETERS_PER_ALARM; ++j)
            {
                if (alarms[i][j].parameterIndex != ParameterType::NONE)
                {
                    float sensorValue = sensorManager4->getValue(alarms[i][j].parameterIndex);
                    if (alarms[i][j].intervalType == INSIDE && sensorValue >= alarms[i][j].lowerValue && sensorValue <= alarms[i][j].upperValue)
                    {
                        // alarms[i][j].triggered = true;
                    }
                    else if (alarms[i][j].intervalType == OUTSIDE && (sensorValue < alarms[i][j].lowerValue || sensorValue > alarms[i][j].upperValue))
                    {
                        // alarms[i][j].triggered = true;
                    }
                    else
                    {
                        // If any parameter is not triggered, set the flag to false
                        triggered[i] = 0;
                    }
                }
            }
        }
        new_data = false;
    }

    // Check if any alarm is triggered
    for (int i = 0; i < MAX_ALARMS; ++i)
    {
        if (enabled[i] && RTCSingleton::rtc.getEpoch() >= snoozeUntil[i])
        {
            {
                // If all parameters are triggered, emit the alarm
                if (triggered[i] > 0)
                {
                    new_data = true;
                    b->playTune1();
                    triggered[i] -= 1;
                    DEBUG("Alarm %d trigers remainig %d\n", i, triggered[i]);
                }
            }
        }
    }
}

void AlarmManager::printAlarms()
{
    // Iterate through all alarms
    for (int i = 0; i < MAX_ALARMS; ++i)
    {
        // Print alarm slot and its status (enabled/disabled)
        DEBUG("Alarm Slot %d: %s\n", i, (enabled[i] ? "Enabled" : "Disabled"));

        // Print details of each parameter in the alarm
        for (int j = 0; j < MAX_PARAMETERS_PER_ALARM; ++j)
        {
            // Check if the parameter is set
            if (alarms[i][j].parameterIndex != ParameterType::NONE)
            {
                DEBUG("    Parameter: %s, Interval Type: %s, Lower Value: %.2f, Upper Value: %.2f\n",
                      parameterTypeToString(alarms[i][j].parameterIndex).c_str(), printIntervalType(alarms[i][j].intervalType).c_str(), alarms[i][j].lowerValue, alarms[i][j].upperValue);
            }
        }
    }
}

std::string printIntervalType(IntervalType type)
{
    std::string typeString;

    // Switch statement to convert enum values to strings
    switch (type)
    {
    case DISABLED_INTERVAL:
        typeString = "DISABLED";
        break;
    case INSIDE:
        typeString = "INSIDE";
        break;
    case OUTSIDE:
        typeString = "OUTSIDE";
        break;
    default:
        typeString = "UNKNOWN";
        break;
    }
    return typeString;
}