#include "pindefs.h"
#include "state_manager.h"

int timerDelay = 60000;
unsigned int timerStart = 0;

bool alarmOn = false;
int alarmDelay = 0;
unsigned int alarmStart = 0;

int buttonStates[3];
int lastButtonStates[3] = {HIGH, HIGH, HIGH};
int lastButtonReadings[3] = {HIGH, HIGH, HIGH};


unsigned long lastDebounceTimes[3] = {0, 0, 0};
unsigned long debounceDelay = 50;

unsigned int lastPressTime = 0;

bool permitLongPress[3] = {false, true, false};

//usada para limitar click continuo nas chaves a intervalos específicos
#define PRESS_REFRESH 160
int pressTime[3] = {0, 0, 0};


void timer_set(int ms){
  timerDelay = ms;
  timerStart = millis();
}

void alarm_set(int ms){
  alarmDelay = ms;
  alarmStart = millis();
  alarmOn = true;
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
  pinMode(BUZZ, OUTPUT);
  digitalWrite(BUZZ, HIGH);

  Serial.begin(9600);

  state_manager_init();
  timer_init();
}

void loop() {
  // put your main code here, to run repeatedly:

  unsigned int now = millis();
  bool dontBlink = false;

  if(now - timerStart >= timerDelay){
    timer_expired();
  }

  if(alarmOn && now - alarmStart >= alarmDelay){
    alarmOn = false;
    alarm_expired(now);
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
      
      //caso mudar de botão
      if(buttonReadings[i] != buttonStates[i]){
        buttonStates[i] = buttonReadings[i];
      }
    }
  }


  //permite 

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
  //para o botão 2: levanta e exigência de o botão estar anteriormente em HIGH, mas limita a interação a tantas por intervalo de tempo
  //o resultado disso é permitir pressionar o botão para circular as horas, porém numa velocidade controlada pelo valor PRESS_REFRESH
  else if(buttonStates[1] == LOW && (now - lastPressTime) > PRESS_REFRESH){
    Serial.println("Chave 2");
    change_time(true);
    lastPressTime = now;
    dontBlink = true;
  }
  //para o botão 1: levanta e exigência de o botão estar anteriormente em HIGH, mas limita a interação a tantas por intervalo de tempo
  else if(buttonStates[0] == LOW && (now - lastPressTime) > PRESS_REFRESH){
    Serial.println("Chave 1");
    change_time(false);
    lastPressTime = now;
    dontBlink = true;
  }
  else if(now - lastPressTime > 10000) // No buttons pressed
  {
    Serial.println("Não apertou");
    reset_state();
    lastPressTime = now;
  }
  
  for(i = 0; i < 3; i++)
  {
    lastButtonReadings[i] = buttonReadings[i];
    lastButtonStates[i] = buttonStates[i];
  }

  write_display(now, dontBlink);
  
}
