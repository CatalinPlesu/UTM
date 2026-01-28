#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h>

const char* ssid = "Pixel_5207";
const char* password = "catalinp";
const char* mqtt_server = "io.adafruit.com";
const int mqtt_port = 1883;
const char* USERNAME = "fakecc";  // Replace with your Adafruit IO username
const char* AIO_KEY = "aio_MkFg764tVkeEsvoEMBR6SPC2NnQY";  // Replace with your Adafruit IO key

const char* TOPIC_ADC = "fakecc/feeds/adc";  // Replace with your ADC topic
const char* TOPIC_YELLOW = "fakecc/feeds/yellow";  // Replace with your yellow LED topic
const char* TOPIC_RED = "fakecc/feeds/red";  // Replace with your red LED topic
const char* TOPIC_GREEN = "fakecc/feeds/green";  // Replace with your green LED topic

const int buttonPin = 5;
const int yellowLedPin = 14;
const int greenLedPin = 12;
const int redLedPin = 13;
const int adcPin = A0;
int adc_val = 0;

WiFiClient espClient;
PubSubClient mqtt(espClient);

unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE	(50)
char msg[MSG_BUFFER_SIZE];
int value = 0;

void setup();
void setup_wifi();
void reconnect();
void callback(char* topic, byte* payload, unsigned int length);
void loop();

void setup_wifi() {

  delay(10);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  randomSeed(micros());

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");

  // Convert the payload to a string
  String message = "";
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  message.trim(); // Remove any leading/trailing spaces or line breaks

  Serial.print("Payload: ");
  Serial.println(message);

  if (strcmp(topic, TOPIC_YELLOW) == 0) {
    if (message.equals("ON")) {
      digitalWrite(yellowLedPin, LOW); // Turn on Yellow LED
    } else if (message.equals("OFF")) {
      digitalWrite(yellowLedPin, HIGH); // Turn off Yellow LED
    }
  } else if (strcmp(topic, TOPIC_RED) == 0) {
    if (message.equals("ON")) {
      digitalWrite(redLedPin, LOW); // Turn on Red LED
    } else if (message.equals("OFF")) {
      digitalWrite(redLedPin, HIGH); // Turn off Red LED
    }
  } else if (strcmp(topic, TOPIC_GREEN) == 0) {
    if (message.equals("ON")) {
      digitalWrite(greenLedPin, LOW); // Turn on Green LED
    } else if (message.equals("OFF")) {
      digitalWrite(greenLedPin, HIGH); // Turn off Green LED
    }
  }
}

void reconnect() {
  while (!mqtt.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Create a random client ID
    String clientId = "ESP8266Client-";
    clientId += String(random(0xffff), HEX);
    // Attempt to connect
     if (mqtt.connect(clientId.c_str(), USERNAME, AIO_KEY)) {
      Serial.println("connected");
      mqtt.subscribe(TOPIC_YELLOW);
      mqtt.subscribe(TOPIC_RED);
      mqtt.subscribe(TOPIC_GREEN);
    } else {
      Serial.print("failed, rc=");
      Serial.print(mqtt.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

unsigned long previousMillis = 0;
const long interval = 10000;
const unsigned long connectionCheckInterval = 5000; // Check MQTT connection every 5 seconds
unsigned long previousConnectionCheck = 0;

void setup() {
  pinMode(greenLedPin, OUTPUT);
  digitalWrite(greenLedPin, HIGH);
  pinMode(yellowLedPin, OUTPUT);
  digitalWrite(yellowLedPin, HIGH);
  pinMode(redLedPin, OUTPUT);
  digitalWrite(redLedPin, HIGH);
  Serial.begin(9600);
  setup_wifi();
  mqtt.setServer(mqtt_server, mqtt_port);
  mqtt.setCallback(callback);
  mqtt.setKeepAlive(60);
  mqtt.setSocketTimeout(60);
}

int lastRead = 0;
int lastValue = 0;

void loop() {

  if (!mqtt.connected()) {
    reconnect();
  }
  mqtt.loop();

  unsigned long now = millis();
  if(now - lastRead > 100)
  {
    lastValue = adc_val;
    adc_val = analogRead(adcPin);
    lastRead = now;
  }

  if (now - lastMsg > 5000 || (abs(lastValue - adc_val) > 50 && now - lastMsg > 1000)) {
    lastMsg = now;
    mqtt.publish(TOPIC_ADC, String(adc_val).c_str());
  }
}