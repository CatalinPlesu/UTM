#include "Shell.h"

char inputBuffer[BUFFER_SIZE];
int inputIndex = 0;
CommandType currentCommand = CMD_NONE; // Initialize as an invalid command
int motorSpeed = 0; // Variable to store the motor speed
bool relayState = false; // Variable to store the relay state

static void processCommand(const char* command);

void  shell_init() {
  Serial.begin(115200); // Set the baud rate to your preference
}

void shell_read() {
  // Check if there is serial data available to read
  if (Serial.available() > 0) {
    char incomingByte = Serial.read(); // Read the incoming byte

    // Check if it's a newline character, indicating the end of a command
    if (incomingByte == '\n') {
      inputBuffer[inputIndex] = '\0'; // Null-terminate the string
      processCommand(inputBuffer);    // Process the received command
      inputIndex = 0;                // Reset the input index
    } else {
      // Add the character to the input buffer if it's not a newline
      if (inputIndex < BUFFER_SIZE - 1) {
        inputBuffer[inputIndex++] = incomingByte;
      }
    }
  }

  // Your non-blocking code here
}
static void print_help_message()
{
    Serial.println("Available Commands:");
    Serial.println("  - light on: Turn on the light.");
    Serial.println("  - light off: Turn off the light.");
    Serial.println("  - motor [speed]: Control the motor speed (-100 to 100).");
    Serial.println("  - help: Display available commands.");
}
static void processCommand(const char* command) {
  if (strcmp(command, "help") == 0) {
    // Implement your logic to display help instructions
    print_help_message();
  }
  // Check for "relay on" command
  if (strcmp(command, "light on") == 0 && currentCommand != CMD_LIGHT) {
    currentCommand = CMD_LIGHT;
    relayState = true; // Set relay state to ON
    // Implement your logic to turn on the relay here
  }
  // Check for "relay off" command
  else if (strcmp(command, "light off") == 0 && currentCommand != CMD_LIGHT) {
    currentCommand = CMD_LIGHT;
    relayState = false; // Set relay state to OFF
    // Implement your logic to turn off the relay here
  }
  // Check for "motor" command with a value
  else if (strncmp(command, "motor", 5) == 0 && currentCommand != CMD_MOTOR) {
    int newValue = atoi(command + 6); // Extract the value after "motor "
    currentCommand = CMD_MOTOR;
    motorSpeed = newValue; // Update the motor speed
    // Implement your logic to control the motor with the 'motorSpeed' here
  }
  // Handle unrecognized commands here
  else {
    currentCommand = CMD_NONE; // Set to an invalid command
    Serial.println("Unrecognized command");
    print_help_message();
  }
}

CommandType shell_check_cmd() {
  CommandType old_cmd = currentCommand;
  currentCommand = CMD_NONE;
  return old_cmd;
}

bool shell_check_light()
{
  return relayState;
}

i8 shell_check_speed()
{
  return motorSpeed;
}