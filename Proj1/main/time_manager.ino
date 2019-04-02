#include "pindefs.h"
#include "main.h"

#define MOD(X,Y) ((X % Y) + Y) % Y

#define LATCH_DIO 4
#define CLK_DIO 7
#define DATA_DIO 8

/* Segment byte maps for numbers 0 to 9 */
const byte SEGMENT_MAP[] = {0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0X80, 0X90};
/* Byte maps to select digit 1 to 4 */
const byte SEGMENT_SELECT[] = {0xF1, 0xF2, 0xF4, 0xF8};

int minutes = 0;
int hours = 0;
int alarm_min = 0;
int alarm_h = 0;

void timer_init() {
  timer_set(6000);
  pinMode(LATCH_DIO, OUTPUT);
  pinMode(CLK_DIO, OUTPUT);
  pinMode(DATA_DIO, OUTPUT);
}

void timer_expired() {
  minutes++;
  if (minutes == 60) {
    minutes = 0;
    hours++;
    if (hours == 24) {
      hours = 0;
    }
  }
  timer_set(6000);
}

void change_minutes(bool up, bool alarm) {
  if (!alarm) {
    if (up) {
      minutes = MOD((minutes + 1), 60);
    }
    else {
      minutes = MOD((minutes - 1), 60);
    }
  }
  else {
    if (up) {
      alarm_min = MOD((alarm_min + 1), 60);
    }
    else {
      alarm_min = MOD((alarm_min - 1), 60);
    }
  }
}

void change_hours(bool up, bool alarm) {
  if (!alarm) {
    if (up) {
      hours = MOD((hours + 1), 24);
    }
    else {
      hours = MOD((hours - 1), 24);
    }
  }
  else {
    if (up) {
      alarm_h = MOD((alarm_h + 1), 24);
    }
    else {
      alarm_h = MOD((alarm_h - 1), 24);
    }
  }
}

/* Write a decimal number between 0 and 9 to one of the 4 digits of the display */
void WriteNumberToSegment(byte Segment, byte Value) {
  digitalWrite(LATCH_DIO, LOW);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_MAP[Value]);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_SELECT[Segment] );
  digitalWrite(LATCH_DIO, HIGH);
}

void write_time() {
  write_time_hours();
  write_time_minutes();
}

void write_alarm() {
  write_alarm_hours();
  write_alarm_minutes();
}

void write_time_hours(){
  WriteNumberToSegment(0, hours/10);
  WriteNumberToSegment(1, hours%10);
}

void write_time_minutes(){
  WriteNumberToSegment(2, minutes/10);
  WriteNumberToSegment(3, minutes%10);
}

void write_alarm_hours(){
  WriteNumberToSegment(0, alarm_h/10);
  WriteNumberToSegment(1, alarm_h%10);
}

void write_alarm_minutes(){
  WriteNumberToSegment(2, alarm_min/10);
  WriteNumberToSegment(3, alarm_min%10);
}

