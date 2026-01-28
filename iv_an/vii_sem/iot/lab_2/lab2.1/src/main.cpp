#include <Arduino.h>

#include "Button.h"
#include "Led.h"
#include "Timer.h"

Timer IntermitentLedTimer;
Timer IdleWaitTimer;

enum AppState {
  Led1On = 0,
  Led2Intermitent = 1,
  Led12Police = 2,
};
typedef enum AppState AppState;

//Set the default app state as Led 1 on
AppState appState = Led1On;
//Variable to store state of button 1 so it won't be lost if one of two functions reads it
ButtonStates button1State;

void inline vDoSetupPinsDirection(void);

void vDoButtonTask(void);
void vDoIntermittentLEDTask(void);
void vDoReadRecurrenceTask(void);
void vDoPoliceLightTask(void);
void vDoIdleTask(void);

/**
 * @brief This function is called by Arduino framework and is executed at startup.
 */
void setup() {
  vDoSetupPinsDirection();

  timer_init(&IntermitentLedTimer, 1000);
  timer_init(&IdleWaitTimer, 1000);

  Serial.begin(9600);
  Serial.println();
}

/**
 * @brief This function is called ciclicaly by arduino framework, with unknown recurrency.
 */
void loop() {
  // button1 is read here because it is required in 2 places
  // in the case of the call in 2 places one call might consume the undesired output, which is desired by the other call.
  button1State = eDoReadButtonState(Btn1);

  vDoButtonTask();
  vDoIntermittentLEDTask();
  vDoReadRecurrenceTask();
  vDoPoliceLightTask();
  vDoIdleTask();
}

/**
 * @brief This function calls the init functions for led and button pins.
 */
void inline vDoSetupPinsDirection(void)
{
  vDoLedInit();
  vDoButtonInit();
}

/**
 * @brief This function is for lab 2, condition 1
 * When a button 1 was pressed the appState changes between 2 tasks
 */
void vDoButtonTask(void)
{
  if( button1State == BUTTON_PRESSED)
  {
    if(appState == Led1On)
    {
      appState = Led2Intermitent;
      vDoLedOff(Led1);
      vDoLedOn(Led2);
    }
    else
    {
      appState = Led1On;
      vDoLedOn(Led1);
      vDoLedOff(Led2);
    }
  }
}

/**
 * @brief This function is for lab 2, condition 2
 * When is the turn of intermitent led task, the led 2 is toggled with an sw timer
 */
void vDoIntermittentLEDTask(void)
{
  if(appState == Led2Intermitent){

    if (timer_expired(&IntermitentLedTimer))
    {
      vDoLedToggle(Led2);
      timer_reset(&IntermitentLedTimer);
    }

  }
}

/**
 * @brief This function is for lab 2, condition 3
 * Increases or decreases task 2 recurrency.
 */
void vDoReadRecurrenceTask(void)
{
 if( eDoReadButtonState(Btn2) == BUTTON_PRESSED)
  {
    timer_init(&IntermitentLedTimer, timer_get_interval(&IntermitentLedTimer) + 100);
  }
  if( eDoReadButtonState(Btn3) == BUTTON_PRESSED)
  {
    timer_init(&IntermitentLedTimer, timer_get_interval(&IntermitentLedTimer) - 100);
    if (timer_get_interval(&IntermitentLedTimer) > 60000)
      timer_init(&IntermitentLedTimer, 50);
  }
}

/**
 * @brief This function is for lab 2, an suplimentar task for +1 point
 * When button 1 is held, it triggers policelighttask, which intermitent switches between both leds.
 */
void vDoPoliceLightTask(void)
{
 if( button1State == BUTTON_HELD)
  {
    if(appState == Led12Police)
    {
      appState = Led1On;
      vDoLedOn(Led1);
      vDoLedOff(Led2);
    }
    else 
    {
      appState = Led12Police;
    }
  }

  if (timer_expired(&IntermitentLedTimer) && appState == Led12Police)
  {
    if(eDoGetLedState(Led1) == LED_ON && eDoGetLedState(Led2) == LED_ON)
    {
      vDoLedToggle(Led2);
    }
    vDoLedToggle(Led1);
    vDoLedToggle(Led2);
    timer_reset(&IntermitentLedTimer);
  }
}

/**
 * @brief Idle task, prints debug info on serial monitor.
 */
void vDoIdleTask(void)
{

  if (timer_expired(&IdleWaitTimer))
  {
    Serial.printf("------------------------\n");
    Serial.printf("App state: %d\n", appState);
    Serial.printf("Led1 state: %d\n", eDoGetLedState(Led1));
    Serial.printf("Led2 state: %d\n", eDoGetLedState(Led2));
    Serial.printf("Intermitent led delay: %d\n", (uint32)timer_get_interval(&IntermitentLedTimer));

    timer_reset(&IdleWaitTimer);
  }
}
