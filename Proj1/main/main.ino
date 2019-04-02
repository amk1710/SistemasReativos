#include "pindefs.h"
#include "state_manager.h"

int timerDelay = 60000;
unsigned int timerStart = 0;

int buttonStates[3];
int lastButtonStates[3] = {HIGH, HIGH, HIGH};
int lastButtonReadings[3] = {HIGH, HIGH, HIGH};


unsigned long lastDebounceTimes[3] = {0, 0, 0};
unsigned long debounceDelay = 50;

unsigned int lastPressTime = 0;

void timer_set(int ms){
  timerDelay = ms;
  timerStart = millis();
}

void setup() {
  // put your setup code here, to run once:
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  pinMode(KEY3, INPUT_PULLUP);
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  pinMode(LED4, OUTPUT);
  //pinMode(BUZZ, OUTPUT);

  Serial.begin(9600);

  timer_init();
}

void loop() {
  // put your main code here, to run repeatedly:

  unsigned int now = millis();

  if(now - timerStart >= timerDelay){
    timer_expired();
  }

  // Detecting buttons pressed
  int buttonReadings[3] = 
  {
    digitalRead(KEY1),
    digitalRead(KEY2),
    digitalRead(KEY3)
  };

  int i;

  for(i = 0; i < 3; i++)
  {

    if(buttonReadings[i] != lastButtonReadings[i]){
      lastDebounceTimes[i] = now;
    }
    
    if((now - lastDebounceTimes[i]) > debounceDelay){
      if(buttonReadings[i] != buttonStates[i]){
        buttonStates[i] = buttonReadings[i];
      }
    }
  }

  // Buttons logic
  if(buttonStates[0] == LOW && buttonStates[2] == LOW
    && (buttonStates[0] != lastButtonStates[0] || buttonStates[2] != lastButtonStates[2])){
    Serial.println("Chaves 1 e 3");
    set_state(0);
    lastPressTime = now;
  }
  else if(buttonStates[2] == LOW && buttonStates[2] != lastButtonStates[2]){
    Serial.println("Chave 3");
    next_state();
    lastPressTime = now;
  }
  else if(buttonStates[1] == LOW && buttonStates[1] != lastButtonStates[1]){
    Serial.println("Chave 2");
    change_time(true);
    lastPressTime = now;
  }
  else if(buttonStates[0] == LOW && buttonStates[0] != lastButtonStates[0]){
    Serial.println("Chave 1");
    change_time(false);
    lastPressTime = now;
  }
  else if(now - lastPressTime > 10000) // No buttons pressed
  {
    Serial.println("Não apertou");
    set_state(0);
    lastPressTime = now;
  }
  
  for(i = 0; i < 3; i++)
  {
    lastButtonReadings[i] = buttonReadings[i];
    lastButtonStates[i] = buttonStates[i];
  }
  
}
