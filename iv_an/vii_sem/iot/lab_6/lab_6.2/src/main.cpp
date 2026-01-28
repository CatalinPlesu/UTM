#include <Arduino.h>

typedef enum SemaphoreStates {
  Red = 0,
  YellowToGreen,
  Green,
  YellowToRed,
}SemaphoreStates;

typedef struct {
  SemaphoreStates next;
  int delay;
}SemaphoreStatesConfig;

#define delaytime 100
SemaphoreStatesConfig semaphoreTransitions[] = {
  [Red]           = {YellowToGreen, 15}, 
  [YellowToGreen] = {Green, 5}, 
  [Green]         = {YellowToRed, 15}, 
  [YellowToRed]   = {Red, 5}, 
};

SemaphoreStates semaphoreState = YellowToRed;

const int yellowLedPin = 14;
const int greenLedPin = 12;
const int redLedPin = 13;

#define LED_ON  0
#define LED_OFF 1

void allLedsOff()
{
  digitalWrite(greenLedPin, LED_OFF);
  digitalWrite(yellowLedPin, LED_OFF);
  digitalWrite(redLedPin, LED_OFF);
}

void semaphoreStateMachine()
{
  semaphoreState = semaphoreTransitions[semaphoreState].next;
  allLedsOff();
  switch (semaphoreState)
  {
  case Red:
    digitalWrite(redLedPin, LED_ON);
    break;
  case YellowToGreen:
    digitalWrite(yellowLedPin, LED_ON);
    break;
  case Green:
    digitalWrite(greenLedPin, LED_ON);
    break;
  case YellowToRed:
    digitalWrite(yellowLedPin, LED_ON);
    break;
  
  default:
    break;
  }
  delay(semaphoreTransitions[semaphoreState].delay * delaytime);
}

void setup() {
  pinMode(greenLedPin, OUTPUT);
  pinMode(yellowLedPin, OUTPUT);
  pinMode(redLedPin, OUTPUT);
  allLedsOff();
  Serial.begin(9600);
}


void loop() {

  semaphoreStateMachine();

  #define xPLOT
  #ifndef PLOT
  // Print state changes only when they occur
  static SemaphoreStates previous = semaphoreState;
  if (semaphoreState != previous) {
    Serial.print("Semaphore State: ");
    switch (semaphoreState) {
      case Red:
        Serial.println("Red");
        break;
      case YellowToGreen:
        Serial.println("YellowToGreen");
        break;
      case Green:
        Serial.println("Green");
        break;
      case YellowToRed:
        Serial.println("YellowToRed");
        break;
      default:
        break;
    }
    previous = semaphoreState;
  }
  #else
  Serial.println(semaphoreState);
  #endif
}
