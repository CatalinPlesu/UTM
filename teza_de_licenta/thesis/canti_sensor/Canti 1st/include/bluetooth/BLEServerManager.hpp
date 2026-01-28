#ifndef BLE_SERVER_MANAGER_HPP
#define BLE_SERVER_MANAGER_HPP

#include <BLEServer.h>

class MyServerCallbacks : public BLEServerCallbacks
{
    void onConnect(BLEServer *pServer);
    void onDisconnect(BLEServer *pServer);
};

class BLEServerManager {
private:
    BLEServer *pServer;
    MyServerCallbacks *pCallbacks;

public:
    BLEServerManager();
    void startAdvertising();
    void loopCycle();
    BLEServer* getServer();
};




#endif
