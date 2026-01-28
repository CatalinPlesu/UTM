#ifndef ALARMMANAGER_H
#define ALARMMANAGER_H
#include <stdint.h>
#include "sensor/ParameterTypes.hpp"
#include "buzzer.hpp"
#include <string>

#define MAX_ALARMS 3
#define MAX_PARAMETERS_PER_ALARM 8
#define ALARM_TRIGGER_CYCLES 5

// Enum for interval type
enum IntervalType
{
    DISABLED_INTERVAL,
    INSIDE,
    OUTSIDE
};

std::string printIntervalType(IntervalType type);

typedef struct Alarm
{
    ParameterType parameterIndex;
    IntervalType intervalType;
    float lowerValue;
    float upperValue;
} Alarm;

class AlarmManager
{
public:
    // Static method to get the singleton instance
    static AlarmManager &getInstance()
    {
        static AlarmManager instance;
        return instance;
    }

    void printAlarms();

    // Method to set the buzzer
    void setBuzzer(Buzzer *_b);

    // Method to set an alarm
    void setAlarm(uint8_t alarmIndex, ParameterType parameter, IntervalType intervalType, float lowerValue = 0.0f, float upperValue = 0.0f);

    Alarm getAlarm(uint8_t alarmIndex, ParameterType parameter);

    // Method to enable an alarm
    void enableAlarm(uint8_t alarmIndex);

    // Method to disable an alarm
    void disableAlarm(uint8_t alarmIndex);

    // Method to delete an alarm
    void deleteAlarm(uint8_t alarmIndex);

    // Alarm loop, emits the alarm if alarm was triggered
    void loop();

    void onSensorRead();

    void snoozeTriggeredAalarms();

private:
    // Private constructor to prevent instantiation
    AlarmManager();
    // Private copy constructor and assignment operator to prevent cloning
    AlarmManager(const AlarmManager &) = delete;
    AlarmManager &operator=(const AlarmManager &) = delete;
    // Private destructor to prevent deletion
    ~AlarmManager() = default;
};

#endif