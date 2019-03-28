#include "pindefs.h"
#include "main.h"

int minutes = 0;
int hours = 0;

void timer_init(){
  timer_set(60000);
}

void timer_expired(){
  minutes++;
  if(minutes == 60){
    minutes = 0;
    hours++;
    if(hours == 24){
      hours = 0;
    }
  }
  timer_set(60000)
}

void change_minutes(bool up){
  if(up){
    minutes = (minutes + 1) % 60;
  }
  else{
    minutes = (minutes - 1) % 60;
  }
}

void change_hours(bool up){
  if(up){
    hours = (hours + 1) % 24;
  }
  else{
    hours = (hours - 1) % 24;
  }
}


