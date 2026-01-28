#include <Arduino.h>

typedef enum ButtonStates {
  IDLE = 0,
  DEBOUNCING,
  PRESSED
}ButtonStates;

typedef struct {
  ButtonStates next;
  int input;
  int delay;
}ButtonStatesConfig;

ButtonStatesConfig buttonTransitions[] = {
  [IDLE] = {DEBOUNCING, 0, 0}, 
  [DEBOUNCING] = {PRESSED, 1, 100}, 
  [PRESSED] = {IDLE, 1, 100} 
};

typedef enum LedStates
{
  OFF = 0,
  ON
}LedStates;

typedef struct {
  LedStates next;
  ButtonStates input;
}LedStatesConfig;

LedStatesConfig ledTransitions[] = {
  [OFF] = {ON, PRESSED}, 
  [ON] = {OFF, PRESSED} 
};

ButtonStates buttonState = IDLE;
LedStates ledState = OFF;

const int buttonPin = 5;
const int yellowLedPin = 14;
const int greenLedPin = 12;
const int redLedPin = 13;

void buttonStateMachine(int input)
{
  if(buttonTransitions[buttonState].input == input){
    buttonState = buttonTransitions[buttonState].next;
  }
  delay(buttonTransitions[buttonState].delay);
}

void ledStateMachine(ButtonStates input)
{
  if (ledTransitions[ledState].input == input)
  {
    if(ledTransitions[ledState].next == OFF)
    {
      digitalWrite(greenLedPin, 1);
    }
    else {
      digitalWrite(greenLedPin, 0);
    }
    ledState = ledTransitions[ledState].next;
  }
}

unsigned long previousStateMachineTime = 0;
const unsigned long stateMachineInterval = 50;

void setup() {
  pinMode(buttonPin, INPUT_PULLUP);
  pinMode(greenLedPin, OUTPUT);
  pinMode(yellowLedPin, OUTPUT);
  pinMode(redLedPin, OUTPUT);
  digitalWrite(greenLedPin, 1);
  digitalWrite(yellowLedPin, 1);
  digitalWrite(redLedPin, 1);
  Serial.begin(9600);
}

void loop() {
  int buttonValue = digitalRead(buttonPin);

  //buttonStateMachine(buttonValue);
  //ledStateMachine(buttonState);


  unsigned long currentMillis = millis();

  // Verificarea pentru apelarea mașinilor de stări la fiecare 50 ms
  if (currentMillis - previousStateMachineTime >= stateMachineInterval) {
    int buttonValue = digitalRead(buttonPin);
    buttonStateMachine(buttonValue);
    ledStateMachine(buttonState);
    previousStateMachineTime = currentMillis;
  }

  #define xPLOT
  #ifndef PLOT
  // Print state changes only when they occur
  static ButtonStates previousButtonState = IDLE;
  static LedStates previousLedState = OFF;
  if (buttonState != previousButtonState || ledState != previousLedState) {
    Serial.print("Button State: ");
    switch (buttonState) {
      case IDLE:
        Serial.println("IDLE");
        break;
      case DEBOUNCING:
        Serial.println("DEBOUNCING");
        break;
      case PRESSED:
        Serial.println("PRESSED");
        break;
      default:
        break;
    }
    Serial.print("LED State: ");
    Serial.println(ledState == ON ? "ON" : "OFF");
    previousButtonState = buttonState;
    previousLedState = ledState;
  }
  #else
  Serial.print(buttonState);
  Serial.print(",");
  Serial.println(ledState);
  #endif
}
