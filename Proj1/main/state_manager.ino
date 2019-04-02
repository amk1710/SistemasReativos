#include "pindefs.h"
#include "time_manager.h"

#define NUM_STATES 7
#define BLINK_INTERVAL 750

int currentState = 0;

unsigned int lastDisplayBlink = 0;
bool blinkState = false;

int get_state(){
  return currentState;
}

void state_manager_init() {
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

void write_display(unsigned int now){
  switch(currentState){
    case 0:
      write_time();
      break;
    case 1:
      write_time();
      break;
    case 2:
      write_alarm();
      break;
    case 3:
      if(now - lastDisplayBlink > BLINK_INTERVAL){
        blinkState = !blinkState;
        lastDisplayBlink = now;
      }
      if(blinkState){
        write_time_hours();
      }
      write_time_minutes();
      break;
    case 4:
      if(now - lastDisplayBlink > BLINK_INTERVAL){
        blinkState = !blinkState;
        lastDisplayBlink = now;
      }
      if(blinkState){
        write_time_minutes();
      }
      write_time_hours();
      break;
    case 5:
      if(now - lastDisplayBlink > BLINK_INTERVAL){
        blinkState = !blinkState;
        lastDisplayBlink = now;
      }
      if(blinkState){
        write_alarm_hours();
      }
      write_alarm_minutes();
      break;
    case 6:
      if(now - lastDisplayBlink > BLINK_INTERVAL){
        blinkState = !blinkState;
        lastDisplayBlink = now;
      }
      if(blinkState){
        write_alarm_minutes();
      }
      write_alarm_hours();
      break;
  }
}

