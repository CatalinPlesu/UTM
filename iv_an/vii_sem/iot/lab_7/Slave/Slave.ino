/**********
   SLAVE
**********/

#include <Arduino.h>
#include <Wire.h>

#include "ds18b20.h"

#define SLAVE_ADDRESS 0x09

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

/********************************************************
   Functions propotypes
********************************************************/
static void requestEvent(void);
static byte calculateChecksum(Packet packet);
static void printPacket(Packet packet);

void setup(void)
{
   Serial.begin(9600);
   Wire.begin(SLAVE_ADDRESS);
   Wire.onRequest(requestEvent);

   DS18B20Init();

   Serial.print("Test");
}

void loop(void)
{

}

void requestEvent(void)
{
   Packet packet;

   for (int i = 0; i < BUFFER_SIZE; i++)
   {
      packet.startChar = START_CHAR;
      packet.counter = i;
      packet.senderID = 2;
      packet.receiverID = 3;
      packet.packageType = 4;
      packet.payload = temperatureBuffer[i];
      packet.checksum = calculateChecksum(packet);
      packet.endChar = END_CHAR;

      printPacket(packet);

      Wire.write((byte *)&packet, sizeof(Packet));
   }
}

byte calculateChecksum(Packet packet)
{
   return packet.counter + packet.senderID + packet.receiverID + packet.packageType + byte(packet.payload);
}

void printPacket(Packet packet) {
  Serial.println("Packet sended:");
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