
//programação do app usando os eventos disponibilizados

//piscar o LED a cada 1 segundo
//botão1: acelerar o pisca-pisca a cada pressionada
//botão2: desacelerar a cada pressionada
//botão 1+2 em menos de 500 ms: parar de piscar

#include <limits.h>

#include "event_driven.h"
#include "app.h"

#define LED_PIN 10

int LED_delay = 1000;
int last_pressed1 = 0;
int last_pressed2 = 1000;
bool LED_State = true;
bool stopBlinking = false;

//realiza setup definido pelo app
void app_init(void)
{
  pinMode(LED_PIN, OUTPUT);
  pinMode(5, INPUT);

  timer_set(1000);
  button_listen(A1);
  button_listen(A2);

  Serial.begin(9600);
}

bool but_bool = LOW;
//notifica que pin mudou para v
void button_changed(int pin, int v)
{
  unsigned int now = millis();
  if(pin == A1 && v == but_bool)
  {
    if(last_pressed1 + 200 < now)
    {
      //acelera pisca-pisca
      LED_delay = max(LED_delay - 100, 100);
      timer_set(LED_delay);  
    }
    last_pressed1 = now;
  }
  else if(pin == A2 && v == but_bool)
  {
    if(last_pressed2 + 200 < now)
    {
      //acelera pisca-pisca
      LED_delay = LED_delay + 100;
      timer_set(LED_delay);  
    }
    last_pressed2 = now;
  }

  //se botões 1 e 2 foram apertados com menos de 500ms de intervalo,
  if(abs(last_pressed1 - last_pressed2) <= 500)
  {
    //pára de piscar(mantendo o LED do jeito que está)
    stopBlinking = true;
  }
  
  
}

//notifica que o timer expirou
void timer_expired(void)
{
  if(!stopBlinking)
  {
    LED_State = !LED_State;
    digitalWrite(LED_PIN, LED_State);  
  }
  
}
