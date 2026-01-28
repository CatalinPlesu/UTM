#include "bluetooth/ParameterValueService.hpp"
#include <BLE2902.h>
#include <SensorManager.hpp>
#include <debug.h>

SensorManager *sensorManager3 = nullptr;
ParameterType p = ParameterType::NONE;

class ValueCharacteristicCallback : public BLECharacteristicCallbacks
{
    void onWrite(BLECharacteristic *pCharacteristic);
    void onRead(BLECharacteristic *pCharacteristic);
};

void ValueCharacteristicCallback::onWrite(BLECharacteristic *pCharacteristic)
{
    // Get the value written to the characteristic
    std::string value = pCharacteristic->getValue();
    p = static_cast<ParameterType>(value[0]);
}

void ValueCharacteristicCallback::onRead(BLECharacteristic *pCharacteristic)
{
    ParameterType currentParameter = static_cast<ParameterType>(pCharacteristic->getValue()[0]);
    float sensorValue = sensorManager3->getValue(currentParameter);
    pCharacteristic->setValue(sensorValue);
    pCharacteristic->notify();
}

ParameterValueService::ParameterValueService(BLEServer *pServer)
{
    sensorManager3 = &SensorManager::getInstance();

    // Initialize the service
    pService = pServer->createService(PARAMETER_VALUE_SERVICE_UUID);

    // Create a characteristic
    pCharacteristic = pService->createCharacteristic(
        VALUE_CHARACTERISTIC_UUID,
        BLECharacteristic::PROPERTY_READ |
            BLECharacteristic::PROPERTY_WRITE |
            BLECharacteristic::PROPERTY_NOTIFY |
            BLECharacteristic::PROPERTY_INDICATE);

    // Set characteristic callbacks
    pCharacteristic->setCallbacks(new ValueCharacteristicCallback());

    // Create Client Characteristic Configuration Descriptor (CCC) for characteristic
    pCharacteristic->addDescriptor(new BLE2902());

    // Create Characteristic User Description Descriptor for characteristic
    BLEDescriptor pDescriptorUserDescription(BLEUUID((uint16_t)0x2901));
    pDescriptorUserDescription.setValue("value");
    pCharacteristic->addDescriptor(&pDescriptorUserDescription);

    pService->start();
}

void ParameterValueService::noitify()
{
    pCharacteristic->notify();
}