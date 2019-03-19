

//programação do app usando os eventos disponibilizados


#include "event_driven.h"
#include "app.h"

#define LED_PIN 10

//realiza setup definido pelo app
void app_init(void)
{
  pinMode(LED_PIN, OUTPUT);

  pinMode(5, INPUT);

  timer_set(200);
  button_listen(A1);
  button_listen(A2);
  button_listen(A3);

}

//notifica que pin mudou para v
void button_changed(int pin, int v)
{
  Serial.println("---");
  Serial.println(pin);
  Serial.println(v);
  Serial.println("***");
  
}

bool LED_State = true;
//notifica que o timer expirou
void timer_expired(void)
{
  LED_State = !LED_State;
  digitalWrite(LED_PIN, LED_State);
}


