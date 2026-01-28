#ifndef SHELL_H
#define SHELL_H

#include <Arduino.h>
#include "Config.h"

#define BUFFER_SIZE 64

typedef enum {
  CMD_NONE,
  CMD_LIGHT,
  CMD_MOTOR
} CommandType;

void shell_init();
void shell_read();
CommandType shell_check_cmd();
bool shell_check_light();
i8   shell_check_speed();

#endif // SHELL_H
