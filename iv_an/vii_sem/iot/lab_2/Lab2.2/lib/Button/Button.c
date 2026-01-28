#include "Button.h"

Button buttons[BtnCnt] =
{
[Btn1] = { 0xFFFF, BUTTON_IDLE, BUTTON_01, {0, 1000}},
[Btn2] = { 0xFFFF, BUTTON_IDLE, BUTTON_02, {0, 1000}},
[Btn3] = { 0xFFFF, BUTTON_IDLE, BUTTON_03, {0, 1000}}
};

/**
 * @brief Init all the button pins as pullups
 */
void vDoButtonInit()
{
  // Set button pins as input with internal pull-up resistors
  for (int i = 0; i < BtnCnt; i++)
  {
    pinMode(buttons[i].pin, INPUT_PULLUP);
  }
}

/**
 * @brief State machine to debounce, and detect the stae of the led.
 */
ButtonStates eDoReadButtonState(Buttons button)
{
  // Read button pin state (low is when pressed)
  bool bPinState = digitalRead(buttons[button].pin);
  // Shift state to place new read at the lsb
  buttons[button].state <<= 1;
  // Adds the new read state to the state variable
  buttons[button].state |= bPinState;

  switch (buttons[button].buttonStates)
  {
    case BUTTON_IDLE:
      if (buttons[button].state != BUTTON_NOT_PRESSED)
      {
        buttons[button].buttonStates = BUTTON_DEBOUNCING;
      }
      break;

    case BUTTON_DEBOUNCING:
      if (buttons[button].state == 0)
      {
        buttons[button].buttonStates = BUTTON_WAITING;
        timer_reset(&buttons[button].timer);        
      }
      break;

    case BUTTON_WAITING:
      if (buttons[button].state == BUTTON_NOT_PRESSED)
      {
        buttons[button].buttonStates = BUTTON_PRESSED;
      }
      if (timer_expired(&buttons[button].timer))
      {
        buttons[button].buttonStates = BUTTON_HELD;
      }
      break;

    case BUTTON_PRESSED:
        buttons[button].buttonStates = BUTTON_IDLE;
      break;

    case BUTTON_HELD:
        if(buttons[button].state == BUTTON_NOT_PRESSED)
        {
          buttons[button].buttonStates = BUTTON_IDLE;
        }
      break;

    default:
      //shouldn't be reached
      if (buttons[button].state == BUTTON_NOT_PRESSED)
      {
        buttons[button].buttonStates = BUTTON_IDLE;
      }
    break;
  }

  return buttons[button].buttonStates;
}