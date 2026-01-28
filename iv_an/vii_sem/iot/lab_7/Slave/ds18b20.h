#ifndef DS18B20_H
#define DS18B20_H

#define DS18B20_PIN 5
#define DS18B20_READ_INTERVAL 10000

#define BUFFER_SIZE 2

typedef enum {
  enRequestTemp,
  enReadTemp
} TE_TEMP_STATE;

extern volatile float temperatureBuffer[BUFFER_SIZE];


extern void DS18B20Init(void);
extern void DS18B20ReadTemp(void);
extern void DS18B20ReadAddress(void);
extern void printAddress(uint8_t* deviceAddress);

#endif