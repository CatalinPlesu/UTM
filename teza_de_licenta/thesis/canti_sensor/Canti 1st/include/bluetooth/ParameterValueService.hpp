#ifndef ParameterValueService_H
#define ParameterValueService_H

#include <BLEService.h>
#include <BLECharacteristic.h>

#define PARAMETER_VALUE_SERVICE_UUID "f35d596b-fff1-466d-97d8-ba175cd0a674"
#define VALUE_CHARACTERISTIC_UUID "105158d4-fe10-4286-9a9f-4f3372788892"

class ParameterValueService {
public:
    ParameterValueService(BLEServer *pServer);
    void noitify();
private:
    BLEService *pService;
    BLECharacteristic *pCharacteristic;
};

#endif
