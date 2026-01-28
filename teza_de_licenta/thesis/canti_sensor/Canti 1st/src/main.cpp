#include <math.hpp>
#ifndef PIO_UNIT_TESTING
#include <debug.h>
#include <BLEDevice.h>
#include <esp_sleep.h>
#include <Wire.h>

#include "bluetooth/BLEServerManager.hpp"
#include <SensorManager.hpp>
#include <RTCSingleton.hpp>
#include <buzzer.hpp>
#include <AlarmManager.hpp>

#define SDA_PIN 8
#define SCL_PIN 9
#define BUZZER_PIN 5

BLEServerManager *pServerManager = nullptr;
SensorManager *sensorManager = nullptr;
Buzzer *buzzer = new Buzzer(BUZZER_PIN);
AlarmManager *alarmManager = nullptr;

#define GMT_OFFSET (3600 * 3)

void setup()
{
  DEBUGINIT(115200);
#ifdef DEBUGENABLE
int usb_tries = 0;
  while (!USBSerial && usb_tries < 10)
  {
    delay(20);
    usb_tries+=1;

  }
#endif
  DEBUG("Setup started\n");
  DEBUG("CPU Frequency - %dMhz\n", getCpuFrequencyMhz());

  Wire.setPins(SDA_PIN, SCL_PIN);

  // Create the BLE Device
  BLEDevice::init("Canti 1");
  // Initialize the BLE server manager
  pServerManager = new BLEServerManager();
  // Start advertising
  pServerManager->startAdvertising();

  RTCSingleton::rtc.offset = GMT_OFFSET;
  RTCSingleton::rtc.setTime(BUILD_TIMESTAMP + 30);

  sensorManager = &SensorManager::getInstance();
  alarmManager = &AlarmManager::getInstance();
  alarmManager->setBuzzer(buzzer);

  DEBUG("%d %d %d", RTCSingleton::rtc.getYear(), RTCSingleton::rtc.getMonth(), RTCSingleton::rtc.getDay());

  // alarmManager.enableAlarm(0);
  //   // Set wake-up time to 60 seconds (in microseconds)
  // esp_sleep_enable_timer_wakeup(60 * 1000000);
  // delay(1000);
  // DEBUG("Entering Light Sleep mode...");
  // esp_light_sleep_start();
  // DEBUG("Exited Light Sleep mode");
  buzzer->init();
  buzzer->enable();
}

uint64_t last_read_main = 0;

void loop()
{
  delay(500);
  pServerManager->loopCycle();
  sensorManager->loop();
  alarmManager->loop();
  if (last_read_main == 0 || last_read_main + 15000 < millis())
  {
    TIMESTAMP();
    float temperature = sensorManager->getValue(TEMPERATURE);
    float battery = sensorManager->getValue(BATTERY);
    float humidity = sensorManager->getValue(HUMIDITY);
    float pressure = sensorManager->getValue(PRESSURE);
    float altitude = sensorManager->getValue(ALTITUDE);
    float iaq = sensorManager->getValue(VOCS);
    float lux = sensorManager->getValue(ILLUMINATION);
    float db = sensorManager->getValue(NOISE);
    DEBUG("bat: %20f\n", battery);
    DEBUG("temp: %19f\n", temperature);
    DEBUG("hum: %20f\n", humidity);
    DEBUG("pre: %20f\n", pressure);
    DEBUG("alt: %20f\n", altitude);
    DEBUG("iaq: %20f\n", iaq);
    DEBUG("lux: %20f\n", lux);
    DEBUG("dbA: %20f\n", db);
    last_read_main = millis();
    TIMESTAMP();
  }
}

#endif
