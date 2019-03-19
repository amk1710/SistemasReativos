//EXERCÍCIO 01, 2


//piscar a cada segundo, e parar com o LED aceso se o usuário pressionar o botão
//versão usando millis, em vez de delay

//por algum motivo, no meu arduíno HIGH deixa o LED apagado, LOW deixa o LED aceso, 
// e !digitalRead(A2) significa que o botão A2 foi apertado

#define LED_PIN 10

//o tempo de piscar em milissegundos
#define BLINK_TIME 1000

void setup() {
  // put your setup code here, to run once:
  
  // Enable pin 13 for digital output
  pinMode(LED_PIN, OUTPUT);

  pinMode(5, INPUT);
  pinMode(A2, INPUT_PULLUP);

}

unsigned long int old = millis();
bool LED_State = true;

void loop() {
  // put your main code here, to run repeatedly:
  unsigned long int now = millis();
  if(now >= old + BLINK_TIME)
  {
    old = now;
    LED_State = !LED_State;
    digitalWrite(LED_PIN, LED_State);
  }

  int but = digitalRead(A2);
  if(!but)
  {
    digitalWrite(LED_PIN, LOW);
    while(1);
  }

}
