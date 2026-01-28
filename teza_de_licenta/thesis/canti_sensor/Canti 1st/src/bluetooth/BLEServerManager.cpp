#include <BLEDevice.h>
#include <Arduino.h>

#include "bluetooth/BLEServerManager.hpp"
#include "bluetooth/ParameterIndexService.hpp"
#include "bluetooth/ParameterValueService.hpp"
#include "bluetooth/ConfigurationService.hpp"
ParameterIndexService *paramIndexService = NULL;
ParameterValueService *paramValueService = NULL;
ConfigurationService *configurationService = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;

void MyServerCallbacks::onConnect(BLEServer *pServer)
{
    deviceConnected = true;
};

void MyServerCallbacks::onDisconnect(BLEServer *pServer)
{
    deviceConnected = false;
}

BLEServerManager::BLEServerManager()
{
    pServer = BLEDevice::createServer();
    pCallbacks = new MyServerCallbacks();
    pServer->setCallbacks(pCallbacks);

    // Create the BLE Services
    paramIndexService = new ParameterIndexService(pServer);
    paramValueService = new ParameterValueService(pServer);
    configurationService = new ConfigurationService(pServer);
}

void BLEServerManager::startAdvertising()
{
    BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
    pAdvertising->addServiceUUID(PARAMETER_INDEX_SERVICE_UUID);
    pAdvertising->addServiceUUID(PARAMETER_VALUE_SERVICE_UUID);
    pAdvertising->addServiceUUID(CONFIGURATION_SERVICE_UUID);
    pAdvertising->setScanResponse(false);
    pAdvertising->setMinPreferred(0x0);
    BLEDevice::startAdvertising();
}

BLEServer *BLEServerManager::getServer()
{
    return pServer;
}

void BLEServerManager::loopCycle()
{
    // notify changed value
    if (deviceConnected)
    {
        paramIndexService->noitify();
        paramValueService->noitify();
        delay(3); // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
    }
    // disconnecting
    if (!deviceConnected && oldDeviceConnected)
    {
        delay(500);               // give the bluetooth stack the chance to get things ready
        this->startAdvertising(); // restart advertising
        oldDeviceConnected = deviceConnected;
    }
    // connecting
    if (deviceConnected && !oldDeviceConnected)
    {
        // do stuff here on connecting
        oldDeviceConnected = deviceConnected;
    }
}
