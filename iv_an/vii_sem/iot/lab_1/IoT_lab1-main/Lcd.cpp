#include <Wire.h>
#include <LiquidCrystal_I2C.h>

#include "Lcd.h"

LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);

void LcdInit(void){
  Wire.begin();
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);
}

void LcdPrint(const String &text){
  char charArray[text.length() + 1];
  text.toCharArray(charArray, text.length() + 1);
  lcd.printstr(charArray);
}

void LcdSetCursor(uint8_t x, uint8_t y){
  lcd.setCursor(x, y);
}

void LcdCursorBlinkOn(void){
  lcd.blink_on();
}

void LcdCursorBlinkOff(void){
  lcd.blink_off();
}

void LcdClearDisplay(void){
  lcd.clear();
}