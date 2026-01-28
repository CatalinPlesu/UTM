#include "bluetooth/ParameterIndexService.hpp"
#include <BLE2902.h>
#include <SensorManager.hpp>
#include <debug.h>

SensorManager *sensorManager1 = nullptr;

class IndexCharacteristicCallback : public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic);
    void onRead(BLECharacteristic *pCharacteristic);
};

void IndexCharacteristicCallback::onWrite(BLECharacteristic *pCharacteristic) {
    // Get the value written to the characteristic
    std::string value = pCharacteristic->getValue();
    DEBUG("%s", value);
    sensorManager1->getSupportedParameter(true); // Get the sensor value from SensorManager
    // Handle the received value (parse, process, etc.)
    // For example, if you expect a string:
    // Serial.println("Received value: " + value);
}

void IndexCharacteristicCallback::onRead(BLECharacteristic *pCharacteristic) {
    // Read the value of the characteristic
    // This depends on how you store the value you want to read
    // For example, if you have a sensor value to send:
    int sensorValue = sensorManager1->getSupportedParameter(); // Get the sensor value from SensorManager
    pCharacteristic->setValue(sensorValue);
    pCharacteristic->notify();
}

ParameterIndexService::ParameterIndexService(BLEServer *pServer) {
    // Initialize the service
    pService = pServer->createService(PARAMETER_INDEX_SERVICE_UUID);

    sensorManager1 = &SensorManager::getInstance();

    // Create a characteristic
    pCharacteristic = pService->createCharacteristic(
        INDEX_CHARACTERISTIC_UUID,
        BLECharacteristic::PROPERTY_READ |
        BLECharacteristic::PROPERTY_WRITE |
        BLECharacteristic::PROPERTY_NOTIFY |
        BLECharacteristic::PROPERTY_INDICATE
    );
    // Set characteristic callbacks
    pCharacteristic->setCallbacks(new IndexCharacteristicCallback());
   // Create Client Characteristic Configuration Descriptor (CCC) for characteristic
    pCharacteristic->addDescriptor(new BLE2902());
    // Create Characteristic User Description Descriptor for characteristic
    BLEDescriptor pDescriptorUserDescription(BLEUUID((uint16_t)0x2901));
    pDescriptorUserDescription.setValue("index");
    pCharacteristic->addDescriptor(&pDescriptorUserDescription);

    pService->start();
}

void ParameterIndexService::noitify(){
    pCharacteristic->notify();
}