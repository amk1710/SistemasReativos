#include "pindefs.h"
#include "main.h"

#define MOD(X,Y) ((X % Y) + Y) % Y

int minutes = 0;
int hours = 0;
int alarm_min = 0;
int alarm_h = 0;

void timer_init(){
  timer_set(6000);
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
  Serial.print(hours);
  Serial.print(":");
  Serial.println(minutes);
  timer_set(6000);
}

void change_minutes(bool up, bool alarm){
  if(!alarm){
    if(up){
      minutes = MOD((minutes + 1),60);
    }
    else{
      minutes = MOD((minutes - 1),60);
    } 
    Serial.print(hours);
    Serial.print(":");
    Serial.println(minutes);
  }
  else{
    if(up){
      alarm_min = MOD((alarm_min + 1),60);
    }
    else{
      alarm_min = MOD((alarm_min - 1),60);
    }
    Serial.print(alarm_h);
    Serial.print(":");
    Serial.println(alarm_min);
  }
}

void change_hours(bool up, bool alarm){
  if(!alarm){
    if(up){
      hours = MOD((hours + 1),24);
    }
    else{
      hours = MOD((hours - 1),24);
    } 
    Serial.print(hours);
    Serial.print(":");
    Serial.println(minutes);
  }
  else{
    if(up){
      alarm_h = MOD((alarm_h + 1),24);
    }
    else{
      alarm_h = MOD((alarm_h - 1),24);
    }
    Serial.print(alarm_h);
    Serial.print(":");
    Serial.println(alarm_min);
  }
}


