
//EXERCÍCIO 01, 1

//piscar a cada segundo, e parar com o LED aceso se o usuário pressionar o botão

//por algum motivo, no meu arduíno HIGH deixa o LED apagado, LOW deixa o LED aceso, 
// e !digitalRead(A2) significa que o botão A2 foi apertado

#define LED_PIN 10
  
void setup ()
{
  // Enable pin 13 for digital output
  pinMode(LED_PIN, OUTPUT);

  pinMode(5, INPUT);
  pinMode(A2, INPUT_PULLUP);
}
  
void loop()
{  
  // Turn on the LED
  digitalWrite(LED_PIN, HIGH);  
  // Wait one second (1000 milliseconds)
  delay(1000);                  
  // Turn off the LED
  digitalWrite(LED_PIN, LOW);   
  // Wait one second
  delay(1000);

  int but = digitalRead(A2);
 
  if(!but)
  {
    digitalWrite(LED_PIN, LOW);
    while(1);
  }
  
}
