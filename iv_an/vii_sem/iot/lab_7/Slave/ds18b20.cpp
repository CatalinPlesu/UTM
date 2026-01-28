#ifndef DS18B20_C
#define DS18B20_C

#include <OneWire.h>
#include <TimerOne.h>

#include "ds18b20.h"

OneWire oneWire(DS18B20_PIN);

byte sensorAddresses[BUFFER_SIZE][8] = {
  {0x28, 0xF5, 0xA3, 0x49, 0xF6, 0x41, 0x3C, 0x97},
  {0x28, 0x6F, 0xDE, 0x81, 0xE3, 0xE1, 0x3C, 0xDC}
};

volatile float temperatureBuffer[BUFFER_SIZE] = {0.0f, 0.0f};

TE_TEMP_STATE eTempState = enRequestTemp;

static void printBuffer(void);

void DS18B20Init(void){
  oneWire.reset();
  for (int i = 0; i < BUFFER_SIZE; i++) {
    oneWire.select(sensorAddresses[i]);
    oneWire.write(0x4E);
    oneWire.write(0);
  }

  DS18B20ReadAddress();

  // Timer1.initialize((DS18B20_READ_INTERVAL < 100 ? 100 : DS18B20_READ_INTERVAL) * 1000); // Convertim intervalul în microsecunde
  Timer1.initialize(1000 * 1000);
  Timer1.attachInterrupt(DS18B20ReadTemp);
  Timer1.start();
}

void DS18B20ReadTemp(void){
  byte data[9];
  int16_t rawTemperature = 0;

  switch (eTempState) {
    case enRequestTemp:
      for (int i = 0; i < BUFFER_SIZE; i++) {  // Modificare pentru a itera prin ambii senzori
        oneWire.reset();
        oneWire.select(sensorAddresses[i]);
        oneWire.write(0x44);  // Inițiază comanda de convertire la senzorul curent
      }
      
      eTempState = enReadTemp;
    break;
    
    case enReadTemp:
      for (int i = 0; i < BUFFER_SIZE; i++) {
        //Serial.println("Onewire address:");
        //printAddress(sensorAddresses[i]);
        oneWire.reset();
        oneWire.select(sensorAddresses[i]);
        oneWire.write(0xBE);

        for (int i = 0; i < 9; i++) {
          data[i] = oneWire.read();
        }
        
        rawTemperature = ((int16_t)data[1] << 8) | data[0];
        temperatureBuffer[i] = (float)rawTemperature / 16;
      }

      //printBuffer();

      eTempState = enRequestTemp;
    break;
  }
}

void DS18B20ReadAddress(void) {
  oneWire.reset_search();
  uint8_t deviceAddress[BUFFER_SIZE][8];
  uint8_t addressIndex = 0;

  Serial.println("\nAdresele senzorilor DS18B20 conectați:");

  while (oneWire.search(deviceAddress[addressIndex])) {
    Serial.print("Adresa: ");
    printAddress(deviceAddress[addressIndex]);
  }
}

void printAddress(uint8_t* deviceAddress) {
  for (uint8_t i = 0; i < 8; i++) {
    if (deviceAddress[i] < 16) {
      Serial.print("0");
    }
    Serial.print(deviceAddress[i], HEX);
    if (i < 7) {
      Serial.print(":");
    }
  }
  Serial.println();
}

void printBuffer(void)
{
   Serial.println("\nDistantele salvate in buffer:");
   for (int i = 0; i < BUFFER_SIZE; i++)
   {
      Serial.print(temperatureBuffer[i]);
      Serial.print("*C ");
   }

   Serial.println();
}

#endif