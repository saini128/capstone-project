#include <ESP8266WiFi.h>
#include <ThingSpeak.h>

const char* ssid = "thinkpad";
const char* password = "0000000000";
//adding channel id insted of 0000
const unsigned long channelID = 0000;

int ledPin = D2;
int offPin = D0; // Change this to the pin connected to the LED

WiFiClient client; // Declare the WiFi client object

void setup() {
  pinMode(ledPin, OUTPUT);
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");
}

void loop() {
  if (ThingSpeakReadValue(channelID, 1) == 1) {
    digitalWrite(ledPin, HIGH);
    digitalWrite(offPin, LOW); // Turn the LED on
    Serial.println("Unlocked !!");
  } else {
    digitalWrite(ledPin, LOW);
    digitalWrite(offPin, HIGH); // Turn the LED off
    Serial.println("Locked !!");
  }
  delay(5000); // Check the channel data every 5 seconds
  Serial.println(ThingSpeakReadValue(channelID, 1));
}

float ThingSpeakReadValue(unsigned long channel, unsigned int field) {
  ThingSpeak.begin(client);
  float value = ThingSpeak.readFloatField(channel, field);
  return value;
}