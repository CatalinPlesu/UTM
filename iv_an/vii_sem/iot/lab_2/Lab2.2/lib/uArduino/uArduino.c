#include "uArduino.h"

#include "esp_common.h"
#include "esp_system.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include "gpio.h"
#include <stdio.h>

// Global variable to store milliseconds, to emulate the millis() function for arduino
volatile unsigned long milliseconds = 0;
os_timer_t my_timer;

/**
 * @brief This function is a timer callback which increments the milliseconds value
 */
void my_timer_callback(void *arg) {
    milliseconds += 25;
}

/**
 * @brief This function initialize the sw timer which increments the milliseconds
 */
void ArduinoInit() {
    // Initialize the timer
    os_timer_setfn(&my_timer, (os_timer_func_t *)my_timer_callback, NULL);
    os_timer_arm(&my_timer, 25, 1); // 25ms period, repeat
}

/**
 * @brief This function returns the elapsed time since the startup of the mcu
 */
unsigned long millis()
{
    return milliseconds;
}

/**
 * @brief This function sets the pin mode
 */
void pinMode(uint8_t pin, uint8_t mode) {
    GPIO_ConfigTypeDef gpioConfig;
    gpioConfig.GPIO_Pin = (uint16)(1 << pin);

    if (mode == INPUT_PULLUP) {
        gpioConfig.GPIO_Mode = GPIO_Mode_Input;
        gpioConfig.GPIO_Pullup = GPIO_PullUp_EN;
        gpioConfig.GPIO_IntrType = GPIO_PIN_INTR_DISABLE;  // Disable interrupts for simplicity
        gpio_config(&gpioConfig);
    } else if (mode == OUTPUT) {
        GPIO_AS_OUTPUT(gpioConfig.GPIO_Pin);
    }

}

/**
 * @brief This function reads an digital pin
 */
int digitalRead(uint8_t pin) {
    return GPIO_INPUT_GET(pin);
}

/**
 * @brief This function writes an digital pin
 */
void digitalWrite(uint8_t pin, uint8_t value) {
    GPIO_OUTPUT_SET(pin, value);
}