#include "pindefs.h"
#include "time_manager.h"
#include "SevSeg.h"

#define NUM_STATES 7


int currentState = 0;

//SevSeg sevseg;

void state_manager_init() {
//  byte numDigits = 4;
//  byte digitPins[] = {};
//  byte segmentPins[] = {6, 5, 2, 3, 4, 7, 8, 9};
//  bool resistorsOnSegments = true;
//
//  byte hardwareConfig = COMMON_ANODE;
//  sevseg.begin(hardwareConfig, numDigits, digitPins, segmentPins, resistorsOnSegments);
//  sevseg.setBrightness(90);
}

void reset_state(){
  if(currentState >= 3 && currentState <= 6){
    set_state(0);
  }
}

void set_state(int state) {
  currentState = state;
  set_leds(currentState);
  Serial.print("Estado atual: ");
  Serial.println(currentState);
}

void next_state() {
  set_state((currentState + 1) % NUM_STATES);
  
}

void change_time(bool up) {
  if (currentState == 3) { // Time set hours
    change_hours(up, false);
  }
  else if (currentState == 4) { // Time set minutes
    change_minutes(up, false);
  }
  else if (currentState == 5) { // Alarm set hours
    change_hours(up, true);
  }
  else if (currentState == 6) { // Alarm set minutes
    change_minutes(up, true);
  }
}

void set_leds(int state){
  digitalWrite(LED1, HIGH);
  digitalWrite(LED2, HIGH);
  digitalWrite(LED3, HIGH);
  digitalWrite(LED4, HIGH);

  switch(state){
    case 1:
      digitalWrite(LED1, LOW);  
      break;
    case 2:
      digitalWrite(LED2, LOW);
      break;
    case 3:
      digitalWrite(LED3, LOW);
      break;
    case 4:
      digitalWrite(LED3, LOW);
      break;
    case 5:
      digitalWrite(LED4, LOW);
      break;
    case 6:
      digitalWrite(LED4, LOW);
      break;
  }
}

