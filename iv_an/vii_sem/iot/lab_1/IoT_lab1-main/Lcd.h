#ifndef LCD_H
#define LCD_H

/* Define LCD */
#define LCD_ADDRESS 0x27
#define LCD_COLUMNS 16
#define LCD_ROWS    2

extern void LcdInit(void);
extern void LcdPrint(const String &text);
extern void LcdSetCursor(uint8_t x, uint8_t y);
extern void LcdCursorBlinkOn(void);
extern void LcdCursorBlinkOff(void);
extern void LcdClearDisplay(void);

#endif