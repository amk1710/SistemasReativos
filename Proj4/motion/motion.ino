int light1 = A0;
int light2 = A1;
int light3 = A2;
int light4 = A3;

unsigned long time1 = 0;
unsigned long time2 = 0;
unsigned long time3 = 0;
unsigned long time4 = 0;
unsigned long timeDetected = 0;
unsigned long movementTimeTolerance = 250;
int lightTolerance1 = 250;
int lightTolerance2 = 250;
int lightTolerance3 = 250;
int lightTolerance4 = 250;

void setup() {
  // put your setup code here, to run once:
  pinMode(light1, INPUT);
  pinMode(light2, INPUT);
  pinMode(light3, INPUT);
  pinMode(light4, INPUT);
  Serial.begin(9600);
  Serial.setTimeout(100);

  int lightValue1 = analogRead(light1);
  int lightValue2 = analogRead(light2);
  int lightValue3 = analogRead(light3);
  int lightValue4 = analogRead(light4);
  for(int i = 0; i < 4; i++){
    delay(500);
    lightValue1 += analogRead(light1);
    lightValue2 += analogRead(light2);
    lightValue3 += analogRead(light3);
    lightValue4 += analogRead(light4);
  }

  lightTolerance1 = lightValue1/5*3/4;
  lightTolerance2 = lightValue2/5*3/4;
  lightTolerance3 = lightValue3/5*3/4;
  lightTolerance4 = lightValue4/5*3/4;

  //Serial.println("Tol1: " + String(lightTolerance1));
  //Serial.println("Tol2: " + String(lightTolerance2));
}

void loop() {
  // put your main code here, to run repeatedly:
  int lightValue1 = analogRead(light1);
  int lightValue2 = analogRead(light2);
  int lightValue3 = analogRead(light3);
  int lightValue4 = analogRead(light4);


  if(lightValue1 < lightTolerance1 && millis() - timeDetected > 1000){
    time1 = millis();
  }
  if(lightValue2 < lightTolerance2 && millis() - timeDetected > 1000){
    time2 = millis();
  }

  if(lightValue3 < lightTolerance3 && millis() - timeDetected > 1000){
    time3 = millis();
  }
  if(lightValue4 < lightTolerance4 && millis() - timeDetected > 1000){
    time4 = millis();
  }

  if(time1 > time2 && time1 - time2 < 500 && millis() - timeDetected > movementTimeTolerance){
    // right to left
    Serial.println("l");
//    Serial.println("1: " + String(lightValue1) + "\t2: " + String(lightValue2));
//    Serial.println("Times: " + String(time1) + "\t" + String(time2));
    timeDetected = millis();
    time1 = 0;
    time2 = 0;
    time3 = 0;
    time4 = 0;
    
  }
  else if(time1 < time2 && time2 - time1 < 500 && millis() - timeDetected > movementTimeTolerance){
    // left to right
    Serial.println("r");
//    Serial.println("1: " + String(lightValue1) + "\t2: " + String(lightValue2));
//    Serial.println("Times: " + String(time1) + "\t" + String(time2));
    
    timeDetected = millis();
    time1 = 0;
    time2 = 0;
    time3 = 0;
    time4 = 0;
  }
  else if(time3 < time4 && time4 - time3 < 500 && millis() - timeDetected > movementTimeTolerance){
    // bottom to top
    Serial.println("u");
//    Serial.println("1: " + String(lightValue1) + "\t2: " + String(lightValue2));
//    Serial.println("Times: " + String(time1) + "\t" + String(time2));
    
    timeDetected = millis();
    time1 = 0;
    time2 = 0;
    time3 = 0;
    time4 = 0;
  }
  else if(time4 < time3 && time3 - time4 < 500 && millis() - timeDetected > movementTimeTolerance){
    // top to bottom
    Serial.println("d");
//    Serial.println("1: " + String(lightValue1) + "\t2: " + String(lightValue2));
//    Serial.println("Times: " + String(time1) + "\t" + String(time2));
    
    timeDetected = millis();
    time1 = 0;
    time2 = 0;
    time3 = 0;
    time4 = 0;
  }


}

