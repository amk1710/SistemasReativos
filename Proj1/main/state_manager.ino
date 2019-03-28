#include "pindefs.h"

int currentState = 0;

void set_state(int state){
  currentState = state;
  Serial.println(currentState);
}

void next_state(){
  currentState = (currentState + 1) % 5;
  Serial.println(currentState);
}

