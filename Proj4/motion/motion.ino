int light1 = A0;
int light2 = A1;

unsigned long time1 = 0;
unsigned long time2 = 0;
unsigned long timeSerial = 0;
unsigned long timeDetected = 0;
int lightTolerance1 = 250;
int lightTolerance2 = 250;

void setup() {
  // put your setup code here, to run once:
  pinMode(light1, INPUT);
  pinMode(light2, INPUT);
  Serial.begin(9600);
  Serial.setTimeout(500);

  int lightValue1 = analogRead(light1);
  int lightValue2 = analogRead(light2);
  for(int i = 0; i < 4; i++){
    delay(500);
    lightValue1 += analogRead(light1);
    lightValue2 += analogRead(light2);
  }

  lightTolerance1 = lightValue1/10;
  lightTolerance2 = lightValue2/10;

  Serial.println("Tol1: " + String(lightTolerance1));
  Serial.println("Tol2: " + String(lightTolerance2));
}

void loop() {
  // put your main code here, to run repeatedly:
  int lightValue1 = analogRead(light1);
  int lightValue2 = analogRead(light2);


  if(lightValue1 < lightTolerance1 && millis() - timeDetected > 1000){
    time1 = millis();
  }
  if(lightValue2 < lightTolerance2 && millis() - timeDetected > 1000){
    time2 = millis();
  }

  if(time1 > time2 && time1 - time2 < 500 && millis() - timeDetected > 1000){
    // right to left
    Serial.println("left");
//    Serial.println("1: " + String(lightValue1) + "\t2: " + String(lightValue2));
//    Serial.println("Times: " + String(time1) + "\t" + String(time2));
    timeDetected = millis();
    time1 = 0;
    time2 = 0;
  }
  else if(time1 < time2 && time2 - time1 < 500 && millis() - timeDetected > 1000){
    // left to right
    Serial.println("right");
//    Serial.println("1: " + String(lightValue1) + "\t2: " + String(lightValue2));
//    Serial.println("Times: " + String(time1) + "\t" + String(time2));
    
    timeDetected = millis();
    time1 = 0;
    time2 = 0;
  }

  if(millis() - timeSerial > 500){
    timeSerial = millis();
  }
}
