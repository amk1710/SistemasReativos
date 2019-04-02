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

void change_time(bool up){
  if(currentState == 3){  // Time set hours
    change_hours(up, false);
  }
  else if(currentState == 4){ // Time set minutes
    change_minutes(up, false);
  }
  else if(currentState == 5){ // Alarm set hours
    change_hours(up, true);
  }
  else if(currentState == 6){ // Alarm set minutes
    change_minutes(up, true);
  }
}

