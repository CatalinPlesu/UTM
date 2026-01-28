#ifndef KEYBOARD_H
#define KEYBOARD_H

/* Define keyboard pins */
#define ROW_1    D1
#define ROW_2    D2
#define ROW_3    D3
#define ROW_4    D4
#define COLUMN_1 D5
#define COLUMN_2 D6
#define COLUMN_3 D7
#define COLUMN_4 D8

/* Define keyboard size */
#define ROWS     4
#define COLUMNS  4

extern char KeyboardRead(void);

#endif