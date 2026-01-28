#ifndef SENSOR_MANAGER_H
#define SENSOR_MANAGER_H

#include "sensor/ParameterSensor.hpp"
#include <Arduino.h>

#define MAX_SENSORS 8

class SensorManager {
public:
    // Function to get the singleton instance
    static SensorManager& getInstance() {
        static SensorManager instance;
        return instance;
    }

    // Function to add a sensor to the manager
    void addSensor(ParameterType parameter, int recurrence, AbstractSensor* sensor);

    ParameterType getSupportedParameter(bool reset = false);

    // Function to set recurrence for a sensor with a given index
    void setRecurrenceWithIndex(ParameterType index, int recurrence);
    uint32_t getRecurrenceWithIndex(ParameterType index);

    // Function to begin reading for all sensors
    void initAll();
    void testAll();
    void readAll();

    // sensor manager loop function
    void loop();

    // Function to get the parameter type by index
    float getValue(ParameterType parameter);

    // Define a function type for the callback
    using AlarmCallback = std::function<void()>;

    // Function to set the callback function
    void setAlarmCallback(AlarmCallback callback) {
        alarmCallback = callback;
    }

private:
    SensorManager(); // Private constructor to prevent instantiation
    SensorData sensors[MAX_SENSORS]; // Array of SensorData
    int currentSize; // Current size of the array
    // Member variable to store the callback function pointer
    AlarmCallback alarmCallback = nullptr;
    void printSensorInformation();
    inline void printSensorInfo(int index);
};

enum class ManagingStates {
    INITIALIZATION,
    TESTING,
    READING,
    WAITING,
    NUM_STATES // Just to keep track of the number of states
};

#endif
