#include <Arduino.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <AccelStepper.h>

const int relay_pin = 16; // Define the pin to which the LED is connected

LiquidCrystal_I2C lcd(0x27, 16, 2); // I2C address for LCD

// Defines the number of steps per revolution
const int stepsPerRevolution = 2048;

// Create an instance of AccelStepper class
AccelStepper stepper(4, 14, 12, 13, 15);

int motorSpeed = 0; // Stepper motor speed
int motorDirection = 1;

void executeCommand(String command);

void setup() {
  Serial.begin(9600);
  pinMode(relay_pin, OUTPUT);
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Arduino Control");
  lcd.setCursor(0, 1);
  lcd.print("System");
  stepper.setMaxSpeed(1000); // Adjust to your motor's specifications
  stepper.setAcceleration(100); // Adjust to your motor's specifications
}

uint64_t motor_delay = 0;

void loop() {
  motor_delay += 1;

  if (Serial.available() > 0) {
    String command = Serial.readStringUntil('\n'); // Read the command until a newline character '\n'
    executeCommand(command);
  }

  stepper.runSpeed();
}

void executeCommand(String command) {
  if (command == "light on") {
    digitalWrite(relay_pin, HIGH); // Turn on the light
    lcd.clear();
    lcd.print("Bec: ON");
  } else if (command == "light off") {
    digitalWrite(relay_pin, LOW); // Turn off the light
    lcd.clear();
    lcd.print("Bec: OFF");
  } else if (command.startsWith("motor")) {
    int speed = command.substring(6).toInt(); // Extract speed from the "motor n" command
    #define abs_max_speed 250
    if (speed >= -abs_max_speed && speed <= abs_max_speed) {
      stepper.stop();
      motorSpeed = speed; // Set the stepper motor speed
      stepper.setSpeed(motorSpeed);
      lcd.clear();
      lcd.print("Motor: ON");
      lcd.setCursor(0, 1);
      lcd.print("Speed: " + String(motorSpeed));
    } else {
      lcd.clear();
      lcd.print("Comanda motor invalida");
    }
  } else {
    lcd.clear();
    lcd.print("Comanda invalida");
  }
}
