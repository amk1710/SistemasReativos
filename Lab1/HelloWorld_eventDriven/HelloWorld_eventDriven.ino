
//programação do app usando os eventos disponibilizados

#include <limits.h>

#include "event_driven.h"
#include "app.h"


#define LED_PIN 10

//realiza setup definido pelo app
void app_init(void)
{
  pinMode(LED_PIN, OUTPUT);
  pinMode(5, INPUT);

  timer_set(1000);
  button_listen(A1);
}

bool but_bool = LOW;
//notifica que pin mudou para v
void button_changed(int pin, int v)
{
  if(v == but_bool)
  {
    digitalWrite(LED_PIN, LOW);
    timer_set(UINT_MAX);
  }
  
}

bool LED_State = true;
//notifica que o timer expirou
void timer_expired(void)
{
  LED_State = !LED_State;
  digitalWrite(LED_PIN, LED_State);
}
