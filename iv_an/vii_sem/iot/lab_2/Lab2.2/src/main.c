#include "esp_common.h"
#include "esp_system.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include "gpio.h"
#include "uart.h"
#include <stdio.h>

// User defined libraries
#include "Config.h"
#include "uArduino.h"
#include "Button.h"
#include "Led.h"
#include "Timer.h"


Timer IntermitentLedTimer;
Timer IdleWaitTimer;

enum AppState {
    Led1On = 0,
    Led2Intermittent = 1,
    Led12Police = 2,
};

typedef enum AppState AppState;

AppState appState = Led1On;
ButtonStates btnState[BtnCnt];

void vDoSetupPinsDirection(void);
void vDoButtonTask(void *pvParameters);
void vDoIntermittentLEDTask(void *pvParameters);
void vDoReadRecurrenceTask(void *pvParameters);
void vDoPoliceLightTask(void *pvParameters);
void vDoIdleTask(void *pvParameters);


/**
 * @brief This function is required by the esp8266 rtos sdk, is the main function.
 */
void user_init(void)
{
    // Lower the baud rate 
    UART_SetBaudrate(UART0, 9600);

    // Init the fake arduino library
    ArduinoInit();

    // Set pin directions for Leds and Buttons
    vDoSetupPinsDirection();

    // Init software timers
    timer_init(&IntermitentLedTimer, 1000);
    timer_init(&IdleWaitTimer, 1000);

    // Create tasks
    xTaskCreate(vDoButtonTask, "ButtonTask", 256, NULL, 1, NULL);
    xTaskCreate(vDoIntermittentLEDTask, "IntermittentLEDTask", 256, NULL, 2, NULL);
    xTaskCreate(vDoReadRecurrenceTask, "ReadRecurrenceTask", 256, NULL, 1, NULL);
    xTaskCreate(vDoPoliceLightTask, "PoliceLightTask", 256, NULL, 1, NULL);
    xTaskCreate(vDoIdleTask, "IdleTask", 256, NULL, 0, NULL);
}

/**
 * @brief Initializes the GPIO pin directions for LEDs and buttons.
 */
void vDoSetupPinsDirection(void)
{
    vDoLedInit();
    vDoButtonInit();
}

/**
 * @brief Monitors button presses and toggles LED states accordingly.
 */
void vDoButtonTask(void *pvParameters)
{
    while (1)
    {
        btnState[Btn1] = eDoReadButtonState(Btn1);
        if (btnState[Btn1] == BUTTON_PRESSED)
        {
            if (appState == Led1On)
            {
                appState = Led2Intermittent;
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

        vTaskDelay(10 / portTICK_RATE_MS);
    }
}

/**
 * @brief Manages the intermittent blinking of an LED.
 */
void vDoIntermittentLEDTask(void *pvParameters)
{
    while (1)
    {
        if (appState == Led2Intermittent)
        {
            if (timer_expired(&IntermitentLedTimer))
            {
                vDoLedToggle(Led2);
                timer_reset(&IntermitentLedTimer);
            }
        }

        vTaskDelay(10 / portTICK_RATE_MS);
    }
}

/**
 * @brief Reads button states and adjusts the intermittent LED timer interval.
 */
void vDoReadRecurrenceTask(void *pvParameters)
{
    while (1)
    {
        btnState[Btn2] = eDoReadButtonState(Btn2);
        btnState[Btn3] = eDoReadButtonState(Btn3);
        if (btnState[Btn2] == BUTTON_PRESSED)
        {
            timer_init(&IntermitentLedTimer, timer_get_interval(&IntermitentLedTimer) + 100);
        }

        if (btnState[Btn3] == BUTTON_PRESSED)
        {
            timer_init(&IntermitentLedTimer, timer_get_interval(&IntermitentLedTimer) - 100);

            if (timer_get_interval(&IntermitentLedTimer) > 60000)
                timer_init(&IntermitentLedTimer, 50);
        }

        vTaskDelay(10 / portTICK_RATE_MS);
    }
}

/**
 * @brief Simulates a police light pattern with LEDs based on button input.
 */
void vDoPoliceLightTask(void *pvParameters)
{
    while (1)
    {
        if (btnState[Btn1] == BUTTON_HELD)
        {
            if (appState == Led12Police)
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
            if (eDoGetLedState(Led1) == LED_ON && eDoGetLedState(Led2) == LED_ON)
            {
                vDoLedToggle(Led2);
            }
            vDoLedToggle(Led1);
            vDoLedToggle(Led2);
            timer_reset(&IntermitentLedTimer);
        }

        vTaskDelay(10 / portTICK_RATE_MS);
    }
}

/**
 * @brief Periodically prints debug information about the application state.
 */
void vDoIdleTask(void *pvParameters)
{
    while (1)
    {
        // Print debug info on the serial monitor
        printf("------------------------\n");
        printf("App state: %d\n", appState);

        // Print LED states
        for (int i = 0; i < LedCnt; i++) {
            LedState ledState = eDoGetLedState(i);
            const char* ledStateStr;

            switch (ledState) {
                case LED_OFF:
                    ledStateStr = "OFF";
                    break;
                case LED_ON:
                    ledStateStr = "ON";
                    break;
                default:
                    ledStateStr = "UNKNOWN";
                    break;
            }

            printf("Led%d state: %s\n", i + 1, ledStateStr);
        }

        // Print button states
        for (int i = 0; i < BtnCnt; i++) {
            ButtonStates btn = btnState[i];
            const char* btnStateStr;

            switch (btn) {
                case BUTTON_IDLE:
                    btnStateStr = "IDLE";
                    break;
                case BUTTON_DEBOUNCING:
                    btnStateStr = "DEBOUNCING";
                    break;
                case BUTTON_WAITING:
                    btnStateStr = "WAITING";
                    break;
                case BUTTON_PRESSED:
                    btnStateStr = "PRESSED";
                    break;
                case BUTTON_HELD:
                    btnStateStr = "HELD";
                    break;
                default:
                    btnStateStr = "UNKNOWN";
                    break;
            }

            printf("Button%d state: %s\n", i + 1, btnStateStr);
        }
        printf("Intermittent led delay: %d\n", (uint32)timer_get_interval(&IntermitentLedTimer));

        vTaskDelay(1000 / portTICK_RATE_MS);
    }
}
