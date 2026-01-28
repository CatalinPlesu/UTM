/***********
   MASTER
***********/

#include <Arduino.h>
#include <Wire.h>

#define SLAVE_ADDRESS 0x09

#define BUFFER_SIZE 2

#define PACKET_LENGTH sizeof(Packet)

#define START_CHAR '<'
#define END_CHAR '>'

typedef struct
{
   byte startChar;
   byte counter;
   byte senderID;
   byte receiverID;
   byte packageType;
   float payload;
   byte checksum;
   byte endChar;
} Packet;

// float temperatureBuffer[BUFFER_SIZE] = {0.0f, 0.0f, 0.0f};
float temperatureBuffer[BUFFER_SIZE] = {0.0f,0.0f};

/********************************************************
   Functions propotypes
********************************************************/
static byte calculateChecksum(Packet packet);
static void printBuffer(void);
static void printPacket(Packet packet);

void setup()
{
   Serial.begin(9600);
   Wire.begin();
}

void loop()
{   
   Wire.beginTransmission(SLAVE_ADDRESS);
   Wire.requestFrom(SLAVE_ADDRESS, PACKET_LENGTH * BUFFER_SIZE);

   Packet packet;

   Serial.print("Requested: ");
   Serial.println(PACKET_LENGTH * BUFFER_SIZE);
   Serial.print("Recieved: ");
   Serial.println(Wire.available());

   for (int i = 0; i < BUFFER_SIZE; i++)
   {
      Wire.readBytes((byte *)&packet, PACKET_LENGTH);

      if (packet.startChar == START_CHAR && packet.endChar == END_CHAR)
      {
         if (packet.checksum == calculateChecksum(packet))
         {
            temperatureBuffer[i] = packet.payload;
         }
         else
         {
            Serial.println("Checksum error!");
         }
      }
      else
      {
        Serial.println("Invalid packet!");
      }

      printPacket(packet);
   }

   Wire.endTransmission();

   delay(10000);
}

byte calculateChecksum(Packet packet)
{
   return packet.counter + packet.senderID + packet.receiverID + packet.packageType + byte(packet.payload);
}

void printBuffer(void)
{
   Serial.println("Distantele citite de pe I2C:");
   for (int i = 0; i < BUFFER_SIZE; i++)
   {
      Serial.print(temperatureBuffer[i]);
      Serial.print("*C ");
   }

   Serial.println();
}

void printPacket(Packet packet) {
  Serial.println("Packet received:");
  Serial.print("startChar: ");
  Serial.println(packet.startChar);
  Serial.print("counter: ");
  Serial.println(packet.counter);
  Serial.print("senderID: ");
  Serial.println(packet.senderID);
  Serial.print("receiverID: ");
  Serial.println(packet.receiverID);
  Serial.print("packageType: ");
  Serial.println(packet.packageType);
  Serial.print("payload: ");
  Serial.println(packet.payload);
  Serial.print("checksum: ");
  Serial.println(packet.checksum);
  Serial.print("Calc checksum: ");
  Serial.println(calculateChecksum(packet));
  Serial.print("endChar: ");
  Serial.println(packet.endChar);
  Serial.println(); // Linie goală pentru separare
}