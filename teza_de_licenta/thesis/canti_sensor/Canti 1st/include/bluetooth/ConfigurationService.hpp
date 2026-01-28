#ifndef ConfigurationService_H
#define ConfigurationService_H

#include <BLEService.h>
#include <BLECharacteristic.h>

#define CONFIGURATION_SERVICE_UUID "cc944d76-a6b6-4a01-b7f8-77b02967f31f"
#define CONFIG_CHARACTERISTIC_UUID "eda3d727-1b71-45d6-a07e-a0ea41fb0298"

class ConfigurationService {
public:
    ConfigurationService(BLEServer *pServer);
    void noitify();
private:
    BLEService *pService;
    BLECharacteristic *pCharacteristic;
};

#endif
