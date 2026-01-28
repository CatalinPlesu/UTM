#ifndef PASSWORGMNG_H
#define PASSWORGMNG_H

#define PASSW_LENGHT 4
#define PASSW_ATEMPTS 3

enum class State {
  InitState    = 0,
  ReadKeyboard = 1,
  VerifyPass   = 2,
  Succes       = 3,
  Fail         = 4,
  SafeState    = 5
};

typedef State PassMngState;

extern void PasswordInit(char InitPass[]);
extern void PasswordManagement(void);

#endif