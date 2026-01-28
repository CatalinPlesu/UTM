#include <Arduino.h>
#include <stdint.h>
#include <Wire.h>
#include "LiquidCrystal_I2C.h"
#include "Config.h"
#include "Light.h"
// #include "Motor.h"
#include "Shell.h"
// #include "ULN2003.h"
#include <Stepper.h>

const u8 relayPin = 5; // Replace with the actual pin number for the relay
const u8 in1 = 3;    // In1 pin for L298 motor driver
const u8 in2 = 8;    // In2 pin for L298 motor driver
const u8 in3 = 7;    // In1 pin for L298 motor driver
const u8 in4 = 9;    // In2 pin for L298 motor driver
//const u8 enablePin = 7; // Enable pin for L298 motor driver
const u8 lcd_address = 0x27;
const u8 columns = 16;
const u8 rows = 2;

u32 u32TaskCntMain = 0;
u32 u32TaskCntIdle = 0;
u32 u32TaskCntLcd = 0;
u32 u32TaskCntShell = 0;
u32 u32TaskCntLight = 0;
u32 u32TaskCntMotor = 0;

// LiquidCrystal_I2C lcd(lcd_address, columns, rows);
Relay relay;
// L298 motor;

bool lcd_update = true;

void lcd_task()
{
    // lcd.clear();
    // lcd.setCursor(0, 0);
    // lcd.print("Light state: ");
    // lcd.print(light_get_state(&relay));
    // lcd.setCursor(0, 1);
    // lcd.print("Motor speed: ");
    // lcd.print(shell_check_speed());

    Serial.print("Light state: ");
    Serial.println(light_get_state(&relay));
    Serial.print("Motor speed: ");
    Serial.println(shell_check_speed());
    u32TaskCntLcd++;
}

#define STEPS 32
Stepper stepper(STEPS, in1, in2, in3, in4);
u8 step = 1;

void setup() {
  //shell_init();
  Serial.begin(115200);
  Serial.println("Setup function");
  // init drivers
  relay = relay_new(relayPin, NORMALLY_CLOSED);
  //motor = l298_new(in1Pin, in11Pin, in2Pin, in21Pin);
  //motor = l298_new(in1Pin, in2Pin, enablePin);
  //motor = l298_new(&stepper);
  stepper.setSpeed(0);
  
  // init abstraction layer
  light_init(&relay);
  //motor_init(&motor);

  // lcd.init();
  // lcd.backlight();
}

u32 motorStepDelay = 0;
void loop() {
  u32TaskCntMain++;
  motorStepDelay++;

  shell_read();
  u32TaskCntShell++;

  CommandType cmd = shell_check_cmd();
  if( cmd == CMD_LIGHT)
  {
    if(shell_check_light())
    {
      light_on(&relay);
    }else
    {
      light_off(&relay);
    }
    u32TaskCntLight++; 
    lcd_update = true;
    Serial.println("light");
  }
    else if( cmd == CMD_MOTOR)
  {
    //motor_set_speed(&motor, shell_check_speed());
    i8 speed = shell_check_speed();
    if (speed < 0)
    {
      stepper.setSpeed(-speed);
      step = -1;
    }
    else
    {
      stepper.setSpeed(speed);
      step = 1;
    }
    u32TaskCntMotor++;
    lcd_update = true;
    Serial.println("motor");
  }

  if(lcd_update)
  {
    lcd_task();
    lcd_update = false;
  }

  if (0)
  {
    stepper.step(step);
  }
}
