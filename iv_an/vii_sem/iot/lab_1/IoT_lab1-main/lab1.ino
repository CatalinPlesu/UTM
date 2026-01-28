/* Libraries include */
#include <Arduino.h>

/* Project files include */ 
#include "LedControl.h"
#include "Keyboard.h"
#include "Lcd.h"
#include "PasswordManager.h"

void setup() {
  Serial.begin(115200);

  LedInit();
  LcdInit();
  PasswordInit("1234");
}

void loop() {
  if (Serial.available() > 0) {
    String receivedMessage = Serial.readStringUntil('\n');

    if (receivedMessage.equals("led on")) {
      LedTurnOn(LED_PIN);
      Serial.write("\nLed turned on");
    } else if (receivedMessage.equals("led off")) {
      LedTurnOff(LED_PIN);
      Serial.write("\nLed turned off");
    } else{
        Serial.write("\nUnknown message !");
    }
  }

  PasswordManagement();
}