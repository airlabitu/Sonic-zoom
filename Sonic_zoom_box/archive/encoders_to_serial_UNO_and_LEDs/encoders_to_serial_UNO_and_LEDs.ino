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

float outStep = 0.5;
long newReading = 0;

long encVal = -999;

float outputVal = 0;

String data;

long timer;
int interval = 5;

char val;

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


/*
       if (val == '0') leds[0] = CRGB(val,0,0);
       else if (val == '1') leds[1] = CRGB(val,0,0);
       else if (val == '2') leds[2] = CRGB(val,0,0);
       else if (val == '3') leds[3] = CRGB(val,0,0);
       else if (val == '4') leds[4] = CRGB(val,0,0);
       else if (val == '5') leds[5] = CRGB(val,0,0);
       */
         
   



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
