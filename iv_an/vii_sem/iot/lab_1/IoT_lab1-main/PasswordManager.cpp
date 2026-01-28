#include "LedControl.h"
#include "Lcd.h"
#include "PasswordManager.h"
#include "Keyboard.h"

static char buffer[PASSW_LENGHT+1];
static char pass[PASSW_LENGHT+1];
static PassMngState CurrentState;
static uint8_t lenght;
static uint8_t atempts;

String AtemptsMessage = "Atempts: ";
String PassMessage    = "Enter pass: ";

static inline void SetState(PassMngState NewState){
  CurrentState = NewState;
}

static inline void ResetPassword(void){
  CurrentState = PassMngState::InitState;
  lenght = 0;
  atempts = PASSW_ATEMPTS;
}

void PasswordInit(char InitPass[]){
  strcpy(pass, InitPass);
  ResetPassword();
}

void PasswordManagement(void){
  switch (CurrentState) {
    case PassMngState::InitState:
        LcdClearDisplay();
        LcdSetCursor(0,1);
        LcdPrint(AtemptsMessage + String(atempts));
        LcdSetCursor(0,0);
        LcdPrint(PassMessage);
        LcdCursorBlinkOn();
        SetState(PassMngState::ReadKeyboard);
      break;
    case PassMngState::ReadKeyboard:
        if(lenght < PASSW_LENGHT){
          char symbol = KeyboardRead();
          if(symbol){
            buffer[lenght] = symbol;
            LcdPrint("*");
            lenght++;
          }
        } else{
          lenght = 0;
          LcdCursorBlinkOff();
          SetState(PassMngState::VerifyPass);
        }
      break;
    case PassMngState::VerifyPass:
        LcdSetCursor(0,1);
        if(strcmp(buffer, pass) == 0){
          SetState(PassMngState::Succes);
        } else{
          SetState(PassMngState::Fail);
        }
      break;
    case PassMngState::Succes:
        LcdPrint("Correct password");
        ResetPassword();
        delay(1000);
        SetState(PassMngState::InitState);
      break;
    case PassMngState::Fail:
        LcdPrint("Wrong password");
        atempts--;
        if(atempts > 0){
          delay(1000);
          SetState(PassMngState::InitState);
        }else{
          LcdClearDisplay();
          LcdSetCursor(0,0);
          LcdPrint("System blocked !");
          SetState(PassMngState::SafeState);
        }
      break;
    case PassMngState::SafeState:
        
      break;
  }
}