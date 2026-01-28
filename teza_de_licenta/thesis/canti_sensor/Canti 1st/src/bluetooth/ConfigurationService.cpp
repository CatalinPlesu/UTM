#include "bluetooth/ConfigurationService.hpp"
#include <BLE2902.h>
#include <debug.h>
#include <SensorManager.hpp>
#include <RTCSingleton.hpp>
#include <AlarmManager.hpp>

union char32
{
    uint8_t c[4];
    int32_t integer;
    uint64_t longInt;
    float_t real;
};
char32 converter;

enum Commands
{
    Reset = 0x00,
    Recurrence = 0xF1,
    ResetRecurrence = 0xF2,
    AlarmCmd = 0xA0,
    AlarmDisable = 0xB0,
    AlarmDelete = 0xD0,
    AlarmEnable = 0xE0,
    Unixtime = 0xEE,
};
Commands comState = Commands::Reset;

std::string getCommandString(Commands command)
{
    switch (command)
    {
    case Reset:
        return "Reset";
    case Recurrence:
        return "Recurrence";
    case ResetRecurrence:
        return "ResetRecurrence";
    case AlarmCmd:
    case AlarmCmd + 1:
    case AlarmCmd + 2:
        return "AlarmCmd";
    case AlarmDisable:
    case AlarmDisable + 1:
    case AlarmDisable + 2:
        return "AlarmDisable";
    case AlarmDelete:
    case AlarmDelete + 1:
    case AlarmDelete + 2:
        return "AlarmDelete";
    case AlarmEnable:
    case AlarmEnable + 1:
    case AlarmEnable + 2:
        return "AlarmEnable";
    case Unixtime:
        return "Unixtime";
    default:
        return "Unknown";
    }
}

enum RecurrenceStates
{
    RecurrenceInitState,
    RecurrenceSelectedParameter,
    WriteValue,
    ReadValue
};
RecurrenceStates recurrenceState = RecurrenceStates::RecurrenceInitState;

enum AlarmSettingStates
{
    AlarmInitState,
    AlarmSelectedParameter,
    WriteIntervalType,
    WriteLowerLimit,
    WriteUpperLimit,
    ReadIntervalType,
    ReadLowerLimit,
    ReadUpperLimit,
};
AlarmSettingStates alarmStates = AlarmSettingStates::AlarmSelectedParameter;
uint8_t alarmId = 0;
float lowerValue;
float upperValue;
int interval;
uint64_t epoch;

SensorManager *sensorManager2 = nullptr;
AlarmManager *alarmManager1 = nullptr;

ParameterType parameter = ParameterType::NONE;
IntervalType intervalType = IntervalType::DISABLED_INTERVAL;

class ConfigCharacteristicCallback : public BLECharacteristicCallbacks
{
    void onWrite(BLECharacteristic *pCharacteristic);
    void onRead(BLECharacteristic *pCharacteristic);
};

void ConfigCharacteristicCallback::onWrite(BLECharacteristic *pCharacteristic)
{
    std::string value = pCharacteristic->getValue();
    int data;
    // Check if the received value is empty or not
    if (value.empty())
    {
        // Invalid command
        DEBUG("Empty command\n");
        DEBUG("State Cmd: %d\n", comState);
        comState = Reset;
        return;
    }

    // Extract the command byte
    if (value.length() == 1 && comState == Commands::Reset)
    {
        Commands cmd = static_cast<Commands>(value[0]);
        DEBUG("This is a command, received %d - %s\n", cmd, getCommandString(cmd).c_str());
        // Update command state based on the received command
        switch (cmd)
        {
        case Recurrence:
            comState = Recurrence;
            recurrenceState = RecurrenceStates::RecurrenceInitState;
            break;
        case ResetRecurrence:
            comState = ResetRecurrence;
            // Handle reset recurrence command
            break;
        case AlarmCmd:
            alarmId = 0;
            alarmStates = AlarmInitState;
            comState = AlarmCmd;
            break;
        case AlarmCmd + 1:
            alarmId = 1;
            alarmStates = AlarmInitState;
            comState = AlarmCmd;
            break;
        case AlarmCmd + 2:
            alarmId = 2;
            alarmStates = AlarmInitState;
            comState = AlarmCmd;
            break;
        case AlarmDisable:
            alarmManager1->disableAlarm(0);
            comState = Reset;
            break;
        case AlarmDisable + 1:
            alarmManager1->disableAlarm(1);
            comState = Reset;
            break;
        case AlarmDisable + 2:
            alarmManager1->disableAlarm(2);
            comState = Reset;
            break;
        case AlarmDelete:
            alarmManager1->deleteAlarm(0);
            comState = Reset;
            break;
        case AlarmDelete + 1:
            alarmManager1->deleteAlarm(1);
            comState = Reset;
            break;
        case AlarmDelete + 2:
            alarmManager1->deleteAlarm(2);
            comState = Reset;
            break;
        case AlarmEnable:
            alarmManager1->enableAlarm(0);
            comState = Reset;
            break;
        case AlarmEnable + 1:
            alarmManager1->enableAlarm(1);
            comState = Reset;
            break;
        case AlarmEnable + 2:
            alarmManager1->enableAlarm(2);
            comState = Reset;
            break;
        case Unixtime:
            DEBUG("This is Unixtime command\n");
            comState = Unixtime;
            // Handle Unix time command
            break;
        default:
            // Handle invalid commands
            DEBUG("Invalid command %d\n", comState);
            comState = Reset;
            return;
        }
    }
    else if (value.length() >= 1 && comState == Commands::Recurrence)
    {
        // Handle commands based on the current state
        switch (recurrenceState)
        {
        case RecurrenceStates::RecurrenceInitState:
            parameter = static_cast<ParameterType>(value[0]);
            recurrenceState = RecurrenceSelectedParameter;
            break;
        case RecurrenceStates::RecurrenceSelectedParameter:
            for (int i = 0; i < 4; i++)
            {
                converter.c[i] = value[i];
            }
            sensorManager2->setRecurrenceWithIndex(parameter, converter.integer);
            recurrenceState = RecurrenceInitState;
            comState = Commands::Reset;
            break;
        default:
            // Handle invalid states
            break;
        }
    }
    else if (value.length() >= 1 && comState == Commands::ResetRecurrence)
    {
        parameter = static_cast<ParameterType>(value[0]);
        sensorManager2->setRecurrenceWithIndex(parameter, DEFAULT_RECURRENCE);
        comState = Commands::Reset;
    }
    else if (value.length() >= 1 && comState == Commands::AlarmCmd)
    {
        switch (alarmStates)
        {
        case AlarmSettingStates::AlarmInitState:
            parameter = static_cast<ParameterType>(value[0]);
            alarmStates = AlarmSelectedParameter;
            break;
        case AlarmSettingStates::AlarmSelectedParameter:
            intervalType = static_cast<IntervalType>(value[0]);
            alarmStates = WriteIntervalType;
            break;
        case AlarmSettingStates::WriteIntervalType:
        {
            for (int i = 0; i < 4; i++)
            {
                converter.c[i] = value[i];
            }
            lowerValue = converter.real;
            alarmStates = WriteLowerLimit;
            break;
        }
        case AlarmSettingStates::WriteLowerLimit:
        {
            for (int i = 0; i < 4; i++)
            {
                converter.c[i] = value[i];
            }
            upperValue = converter.real;
            DEBUG("Setting alarm: Alarm ID: %d, Parameter: %s, Interval Type: %s, Lower Value: %f, Upper Value: %f\n",
                  alarmId, parameterTypeToString(parameter).c_str(), printIntervalType(intervalType).c_str(), lowerValue, upperValue);
            alarmManager1->setAlarm(alarmId, parameter, intervalType, lowerValue, upperValue);
            alarmStates = AlarmInitState;
            comState = Commands::Reset;
            break;
        }
        default:
            // Handle invalid states
            DEBUG("Invalid state\n");
            break;
        }
    }
    else if (value.length() >= 8 && comState == Commands::Unixtime)
    {
        for (int i = 0; i < 8; i++)
        {
            converter.c[i] = value[i];
        }
        epoch = converter.longInt;
        DEBUG("Old epoch %ld\n", RTCSingleton::rtc.getEpoch());
        DEBUG("Seting new epoch %ld\n", epoch);
        RTCSingleton::rtc.setTime(epoch);
        comState = Commands::Reset;
    }
}

void ConfigCharacteristicCallback::onRead(BLECharacteristic *pCharacteristic)
{
    Alarm alarm;
    std::string value = pCharacteristic->getValue();
    DEBUG("comstate %d, recurencestate %d\n", comState, recurrenceState);
    if (comState == Commands::Recurrence && recurrenceState == RecurrenceSelectedParameter)
    {
        uint32_t recurrence = sensorManager2->getRecurrenceWithIndex(parameter);
        pCharacteristic->setValue(recurrence);
        pCharacteristic->notify();
        recurrenceState = RecurrenceInitState;
        comState = Commands::Reset;
    }
    else if (comState == Commands::AlarmCmd)
    {
        switch (alarmStates)
        {
        case AlarmSettingStates::AlarmSelectedParameter:
            alarmStates = ReadIntervalType;
            alarm = alarmManager1->getAlarm(alarmId, parameter);
            interval = alarm.intervalType;
            pCharacteristic->setValue(interval);
            pCharacteristic->notify();
            DEBUG("Interval type: %d\n", alarm.intervalType);
            break;
        case AlarmSettingStates::ReadIntervalType:
            alarm = alarmManager1->getAlarm(alarmId, parameter);
            pCharacteristic->setValue(alarm.lowerValue);
            pCharacteristic->notify();
            DEBUG("Lower value: %d\n", alarm.lowerValue);
            alarmStates = ReadLowerLimit;
            break;
        case AlarmSettingStates::ReadLowerLimit:
            alarm = alarmManager1->getAlarm(alarmId, parameter);
            pCharacteristic->setValue(alarm.upperValue);
            pCharacteristic->notify();
            DEBUG("Upper value: %d\n", alarm.upperValue);
            comState = Commands::Reset;
            break;
        default:
            // Handle invalid states
            DEBUG("Invalid state\n");
            break;
        }
    }
    else if (comState == Commands::Unixtime)
    {
        epoch = RTCSingleton::rtc.getEpoch();
        DEBUG("Current epoch %ld\n", epoch);
        pCharacteristic->setValue((uint8_t *)&epoch, 8);
        pCharacteristic->notify();
        comState = Commands::Reset;
    }
    else
    {
        DEBUG("Read\n");
        int value = comState;
        pCharacteristic->setValue(value);
        pCharacteristic->notify();
    }
}

ConfigurationService::ConfigurationService(BLEServer *pServer)
{
    sensorManager2 = &SensorManager::getInstance();
    alarmManager1 = &AlarmManager::getInstance();

    // Initialize the service
    pService = pServer->createService(CONFIGURATION_SERVICE_UUID);

    // Create a characteristic
    pCharacteristic = pService->createCharacteristic(
        CONFIG_CHARACTERISTIC_UUID,
        BLECharacteristic::PROPERTY_READ |
            BLECharacteristic::PROPERTY_WRITE |
            BLECharacteristic::PROPERTY_NOTIFY |
            BLECharacteristic::PROPERTY_INDICATE);

    // Set characteristic callbacks
    pCharacteristic->setCallbacks(new ConfigCharacteristicCallback());

    // Create Client Characteristic Configuration Descriptor (CCC) for characteristic
    pCharacteristic->addDescriptor(new BLE2902());

    // Create Characteristic User Description Descriptor for characteristic
    BLEDescriptor pDescriptorUserDescription(BLEUUID((uint16_t)0x2901));
    pDescriptorUserDescription.setValue("config");
    pCharacteristic->addDescriptor(&pDescriptorUserDescription);

    pService->start();
}

void ConfigurationService::noitify()
{
    pCharacteristic->notify();
}