#include <SPI.h>
#include <Ethernet.h>
#include <PubSubClient.h>

//Definicoes de IP, mascara de rede e gateway
byte mac[] = {
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED
};
IPAddress ip(192, 168, 1, 110);       //Define o endereco IP
IPAddress gateway(192, 168, 1, 1);  //Define o gateway
IPAddress subnet(255, 255, 255, 0); //Define a máscara de rede

// Make sure to leave out the http and slashes!
const char* mqttServer = "test.mosquitto.org";

// Ethernet and MQTT related objects
EthernetClient ethClient;
PubSubClient mqttClient(ethClient);

// Function prototypes
void subscribeReceive(char* topic, byte* payload, unsigned int length);

int light1 = A0;
int light2 = A1;

unsigned long time1 = 0;
unsigned long time2 = 0;
unsigned long timeDetected = 0;
int lightTolerance1 = 250;
int lightTolerance2 = 250; 

void setup() {
  // put your setup code here, to run once:
  pinMode(light1, INPUT);
  pinMode(light2, INPUT);
  Serial.begin(9600);

  //Inicializa a interface de rede
  Ethernet.begin(mac, ip);
  delay(4000);

  int lightValue1 = analogRead(light1);
  int lightValue2 = analogRead(light2);
  for (int i = 0; i < 4; i++) {
    delay(500);
    lightValue1 += analogRead(light1);
    lightValue2 += analogRead(light2);
  }

  lightTolerance1 = lightValue1 / 10;
  lightTolerance2 = lightValue2 / 10;

  Serial.println("Tol1: " + String(lightTolerance1));
  Serial.println("Tol2: " + String(lightTolerance2));

  // Set the MQTT server to the server stated above ^
  mqttClient.setServer(mqttServer, 1883);

  // Attempt to connect to the server with the ID "myClientID"
  if (mqttClient.connect("myClientID"))
  {
    Serial.println("Connection has been established, well done");

    // Establish the subscribe event
    mqttClient.setCallback(subscribeReceive);
  }
  else
  {
    Serial.println("Looks like the server connection failed...");
  }
  int lightTolerance1 = 250;
  int lightTolerance2 = 250; 
}

void loop() {
  // This is needed at the top of the loop!
  mqttClient.loop();

  // Ensure that we are subscribed to the topic "MakerIOTopic"
  mqttClient.subscribe("BubbleGame");

  // put your main code here, to run repeatedly:
  int lightValue1 = analogRead(light1);
  int lightValue2 = analogRead(light2);


  if (lightValue1 < lightTolerance1 && millis() - timeDetected > 1000) {
    time1 = millis();
  }
  if (lightValue2 < lightTolerance2 && millis() - timeDetected > 1000) {
    time2 = millis();
  }

  if (time1 > time2 && time1 - time2 < 500 && millis() - timeDetected > 1000) {
    // right to left
    Serial.println("left");
    //    Serial.println("1: " + String(lightValue1) + "\t2: " + String(lightValue2));
    //    Serial.println("Times: " + String(time1) + "\t" + String(time2));

    // Attempt to publish a value to the topic "MakerIOTopic"
    if (mqttClient.publish("BubbleGame", "left"))
    {
      Serial.println("Publish message success");
    }
    else
    {
      Serial.println("Could not send message :(");
    }


    timeDetected = millis();
    time1 = 0;
    time2 = 0;
  }
  else if (time1 < time2 && time2 - time1 < 500 && millis() - timeDetected > 1000) {
    // left to right
    Serial.println("right");
    //    Serial.println("1: " + String(lightValue1) + "\t2: " + String(lightValue2));
    //    Serial.println("Times: " + String(time1) + "\t" + String(time2));

    // Attempt to publish a value to the topic "MakerIOTopic"
    if (mqttClient.publish("BubbleGame", "right"))
    {
      Serial.println("Publish message success");
    }
    else
    {
      Serial.println("Could not send message :(");
    }

    timeDetected = millis();
    time1 = 0;
    time2 = 0;
  }

  // Dont overload the server!
  //delay(4000);
}

void subscribeReceive(char* topic, byte* payload, unsigned int length)
{
  // Print the topic
  Serial.print("Topic: ");
  Serial.println(topic);

  // Print the message
  Serial.print("Message: ");
  for (int i = 0; i < length; i ++)
  {
    Serial.print(char(payload[i]));
  }

  // Print a newline
  Serial.println("");
}

