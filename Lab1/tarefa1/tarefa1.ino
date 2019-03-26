
//TAREFA 1

//piscar o LED a cada 1 segundo
//botão1: acelerar o pisca-pisca a cada pressionada
//botão2: desacelerar a cada pressionada
//botão 1+2 menos de 500 ms: parar de piscar


//por algum motivo, no meu arduíno HIGH deixa o LED apagado, LOW deixa o LED aceso, 
// e !digitalRead(A2) significa que o botão A2 foi apertado

#define LED_PIN 10

void setup() {
  // put your setup code here, to run once:
  // Enable pin 13 for digital output
  pinMode(LED_PIN, OUTPUT);

  pinMode(5, INPUT);
  pinMode(A1, INPUT_PULLUP);
  pinMode(A2, INPUT_PULLUP);
  
}

unsigned long int old = millis();
bool LED_State = true;
//começamos com delay de 1 segundo
int LED_delay = 1000;

unsigned int last_pressed1 = 0;
unsigned int last_pressed2 = 1000;

void loop() {
  // put your main code here, to run repeatedly:
  unsigned long int now = millis();
  if(now >= old + LED_delay)
  {
    old = now;
    LED_State = !LED_State;
    digitalWrite(LED_PIN, LED_State);
  }

  int but1 = digitalRead(A1);
  int but2 = digitalRead(A2);


  //se botão 1 pressionado agora e não foi pressionado nos últimos 500ms
  if(!but1 && last_pressed1 + 200 < now)
  {
    last_pressed1 = now;
    //acelera pisca-pisca
    LED_delay = max(LED_delay - 100, 100);
    
  }

  if(!but2 && last_pressed2 + 200 < now)
  {
    last_pressed2 = now;
    //desacelera pisca-pisca
    LED_delay = LED_delay + 100;
  }

  //se botões 1 e 2 foram apertados com menos de 500ms de intervalo,
  if(abs(last_pressed1 - last_pressed2) <= 500)
  {
    //pára de piscar(mantendo o LED do jeito que está)
    while(1);
  }

  

}
