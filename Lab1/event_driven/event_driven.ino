//TAREFA 3 - API (event_driven.ino)

#include <limits.h>
#include "event_driven.h"
#include "app.h"

//variáveis globais
unsigned long int old = millis();
unsigned long int timer_step = UINT_MAX;

int callbackButtons[3] = {0, 0, 0};
int buttonLastState[3] = {0, 0, 0};

//funções de registro:

void button_listen(int pin)
{
  //"pin" passado deve gerar notificações
  switch(pin)
  {
    case A1:
      callbackButtons[0] = pin;
      break;
    case A2:
      callbackButtons[1] = pin;
	  break;
    case A3:
      callbackButtons[2] = pin;
	  break;
  }
  
}

void timer_set(int ms)
{
  //timer deve expirar após ms milisegundos
  timer_step = abs(ms);
}


//Programa Principal
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  
  app_init();
  pinMode(A1, INPUT_PULLUP);
  pinMode(A2, INPUT_PULLUP);
  pinMode(A3, INPUT_PULLUP);

}

void loop() {
  // put your main code here, to run repeatedly:
  unsigned long int now = millis();
  if(now >= old + timer_step)
  {
    old = now;
    timer_expired();
  }

  int but[3];
  but[0] = digitalRead(A1);
  but[1] = digitalRead(A2);
  but[2] = digitalRead(A3);
  
  for(int i = 0; i < 3; i++)
  {
    if(but[i] != buttonLastState[i])
    {
      if(callbackButtons[i])
      {
        button_changed(callbackButtons[i], but[i]);
      }
      buttonLastState[i] = but[i];
    }
  }

}
