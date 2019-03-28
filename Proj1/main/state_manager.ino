#include "pindefs.h"
#include "time_manager.h"

int currentState = 0;

void set_state(int state){
  currentState = state;
  Serial.println(currentState);
}

void next_state(){
  currentState = (currentState + 1) % 5;
  Serial.println(currentState);
}

void button_changed(int pin, int v){
  switch(pin){
    case KEY1:
      
      break;
    case KEY2:
      break;
    case KEY3:
      break;
  }
}

