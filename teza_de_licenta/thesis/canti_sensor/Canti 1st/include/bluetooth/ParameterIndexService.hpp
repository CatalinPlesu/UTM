#ifndef ParameterIndexService_H
#define ParameterIndexService_H

#include <BLEService.h>
#include <BLECharacteristic.h>

#define PARAMETER_INDEX_SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define INDEX_CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

class ParameterIndexService {
public:
    ParameterIndexService(BLEServer *pServer);
    void noitify();
private:
    BLEService *pService;
    BLECharacteristic *pCharacteristic;
};

#endif
