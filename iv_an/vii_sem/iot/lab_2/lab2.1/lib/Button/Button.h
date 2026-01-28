#ifndef BUTTON_H_
#define BUTTON_H_

#include "Arduino.h"
#include "Timer.h"

#define BUTTON_01 14
#define BUTTON_02 12
#define BUTTON_03 13


#define BUTTON_NOT_PRESSED 0xFFFFU

enum Buttons {
  Btn1 = 0,
  Btn2 = 1,
  Btn3 = 2,
  BtnCnt
};
typedef enum Buttons Buttons;

typedef enum {
  BUTTON_IDLE,        // Button is not pressed
  BUTTON_DEBOUNCING,  // Button state is being debounced
  BUTTON_WAITING,     // Waiting to see if the button is pressed and released or held for more than the desired time
  BUTTON_PRESSED,     // Button was released after a short press
  BUTTON_HELD,        // Button is still being held but wasn't released
}ButtonStates;

typedef struct {
  uint16_t state;
  ButtonStates buttonStates;
  uint8_t pin;
  Timer timer;
} Button;

void vDoButtonInit();
ButtonStates eDoReadButtonState(Buttons button);



#endif