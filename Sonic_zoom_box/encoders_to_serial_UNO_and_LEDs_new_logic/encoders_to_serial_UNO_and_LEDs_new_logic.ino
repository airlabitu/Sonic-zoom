#include <Encoder.h>
#include <FastLED.h>

#define NUM_LEDS 6
#define DATA_PIN 7
// Define the array of leds
CRGB leds[NUM_LEDS];

int value = 0;
int channel;

// UNO pins with interrupt: 2, 3

Encoder enc(2, 3); // sensor0

long newReading = 0;

long encVal = -999;


String data;

long timer;
int interval = 10;

char val;

int encoderFixedScale;
int scale = 5000;
long min = 0;
long max = 255;

void setup() 
{
  //initialize serial communications at a 9600 baud rate
  Serial.begin(9600);

  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);
  leds[0] = CRGB(255,0,0);
  FastLED.show();
}

void loop()
{
  
  if (Serial.available()) { // If data is available to read,
     
     val = Serial.read(); // read it and store it in val

    // turn of all
    for (int i = 0; i < 6; i++){
      leds[i] = CRGB(0,0,0);
    }
    
    // turn on the needed ones
    for (int i = 0; i < val-48; i++){
      leds[i] = CRGB(0,255,0);
    }
    FastLED.show();
    
   }
         
   



newReading = enc.read();
//Serial.println(newReading);
//delay(10);

if (newReading != encVal){
  if (newReading < min){
    min = newReading;
    max = min+scale;
  }
  else if (newReading > max){
    max = newReading;
    min = max - scale;
  }
  
  encoderFixedScale = (int)map(newReading, min, max, 0, scale);
  
  /*
  Serial.print(min);
  Serial.print(" , ");
  Serial.print(max);
  Serial.print(" , ");
  Serial.print(newReading);
  Serial.print(" , ");
  Serial.println(encoderFixedScale);
  */

  encVal = newReading;
  data = String(int(map(encoderFixedScale, 0, 5000, 0, 255)));

}

if (millis() > timer + interval){
  timer = millis();
  Serial.println("3c"+data+"w");  
}

}
