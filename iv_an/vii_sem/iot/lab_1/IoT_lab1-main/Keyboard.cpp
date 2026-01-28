#include <Keypad.h>

#include "Keyboard.h"

char keymap[ROWS][COLUMNS] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};

byte RowPins[ROWS]    = {ROW_1   , ROW_2   , ROW_3   , ROW_4   };
byte ColPins[COLUMNS] = {COLUMN_1, COLUMN_2, COLUMN_3, COLUMN_4};

Keypad CustomKeypad = Keypad(makeKeymap(keymap), RowPins, ColPins, ROWS, COLUMNS);

char KeyboardRead(void){
  return CustomKeypad.getKey();
}