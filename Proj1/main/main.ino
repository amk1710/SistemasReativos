#include "pindefs.h"

int buttonStates[3];
int lastButtonStates[3] = {HIGH, HIGH, HIGH};
int lastButtonReadings[3] = {HIGH, HIGH, HIGH};


unsigned long lastDebounceTimes[3] = {0, 0, 0};
unsigned long debounceDelay = 50;

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
}

void loop() {
  // put your main code here, to run repeatedly:

  unsigned int now = millis();

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
  }
  else if(buttonStates[2] == LOW && buttonStates[2] != lastButtonStates[2]){
    Serial.println("Chave 3");
  }
  else if(buttonStates[1] == LOW && buttonStates[1] != lastButtonStates[1]){
    Serial.println("Chave 2");
  }
  else if(buttonStates[0] == LOW && buttonStates[0] != lastButtonStates[0]){
    Serial.println("Chave 1");
  }
  else // No buttons pressed
  {
    // Create logic for 10 seconds without pressing buttons
  }
  
  for(i = 0; i < 3; i++)
  {
    lastButtonReadings[i] = buttonReadings[i];
    lastButtonStates[i] = buttonStates[i];
  }
  
}
