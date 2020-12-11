#include <Encoder.h>

// UNO pins with interrupt: 2, 3

Encoder enc(2, 3); // sensor0

float outStep = 0.5;
long newReading = 0;

long encVal = -999;

float outputVal = 0;

String data;

long timer;
int interval = 5;


void setup() 
{
  //initialize serial communications at a 9600 baud rate
  Serial.begin(9600);
}

void loop()
{



newReading = enc.read();
//Serial.println(newReading);
//delay(10);

if (newReading != encVal){
  
  if (newReading > encVal){ 
    if (outputVal+outStep <= 255) outputVal+=outStep;
  }
  else if (newReading < encVal){
    if (outputVal-outStep >= 0) outputVal-=outStep;
  }
  encVal = newReading;
  data = String(int(outputVal));
  //Serial.println(outputVal);
}

if (millis() > timer + interval){
  timer = millis();
  Serial.println("0c"+data+"w");  
}

}
