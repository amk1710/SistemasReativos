#include "pindefs.h"
byte state = HIGH;

unsigned int button1 = 0, button2 = 0;

volatile int counter = 0;

volatile int buttonChanged = 0;

void pciSetup (byte pin) {
  *digitalPinToPCMSK(pin) |= bit (digitalPinToPCMSKbit(pin));  // enable pin
  PCIFR  |= bit (digitalPinToPCICRbit(pin)); // clear any outstanding interruptjk
  PCICR  |= bit (digitalPinToPCICRbit(pin)); // enable interrupt for the group
}

void timerSetup () {
   TIMSK2 = (TIMSK2 & B11111110) | 0x01;
   TCCR2B = (TCCR2B & B11111000) | 0x07;
}

void setup() {
   pinMode(LED1, OUTPUT); digitalWrite(LED1, state);
   pinMode(LED2, OUTPUT); digitalWrite(LED2, state);
   pinMode(LED3, OUTPUT); digitalWrite(LED3, state);
   pinMode(LED4, OUTPUT); digitalWrite(LED4, state);
   pinMode (KEY1, INPUT_PULLUP);
   pinMode (KEY2, INPUT_PULLUP);
   timerSetup();
   pciSetup(KEY1); pciSetup(KEY2);

   Serial.begin(9600);
}
 
void loop() {
  if (counter>50) {
    state = !state;
    digitalWrite(LED1, state);
    counter = 0;
  }

  if(buttonChanged == 1){
    if(abs((signed)(button1 - button2)) < 500){
      while(1);
    }
    buttonChanged = 0;
  }
}
 
ISR(TIMER2_OVF_vect){
   counter++;
}

ISR (PCINT1_vect) { // handle pin change interrupt for A0 to A5 here
  buttonChanged = 1;
  if(digitalRead(KEY1) == LOW){
    button1 = millis();
  }

  if(digitalRead(KEY2) == LOW){
    button2 = millis();
  }
}
