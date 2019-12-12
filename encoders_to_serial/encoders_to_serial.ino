#include <Encoder.h>

// mega ADK pins with interrupt: 2,3,18,19,20,21

Encoder enc0(2, 4); // sensor0
Encoder enc1(3, 5); // sensor1
Encoder enc2(18, 17); // sensor2
Encoder enc3(21, 22); // sensor3

int outStep = 10;
long newReading0 = 0;
long newReading1 = 0;
long newReading2 = 0;
long newReading3 = 0;

long enc0val = -999;
long enc1val = -999;
long enc2val = -999;
long enc3val = -999;

int outputVal0 = 0;
int outputVal1 = 0;
int outputVal2 = 0;
int outputVal3 = 0;

String data;

void setup() 
{
  /*
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);
  pinMode(A4, INPUT);
  */
  //initialize serial communications at a 9600 baud rate
  Serial.begin(9600);
}

void loop()
{



newReading0 = enc0.read();

if (newReading0 != enc0val){
  if (newReading0 > enc0val){ 
    if (outputVal0+outStep <= 255) outputVal0+=outStep;
  }
  else if (newReading0 < enc0val){
    if (outputVal0-outStep >= 0) outputVal0-=outStep;
  }
  enc0val = newReading0;
  data = String(outputVal0);
  Serial.print("0c"+data+"w");
  delay(5);

  //Serial.print("0: ");
  //Serial.println(outputVal0);  
}



newReading1 = enc1.read();

if (newReading1 != enc1val){
  if (newReading1 > enc1val){ 
    if (outputVal1+outStep <= 255) outputVal1+=outStep;
  }
  else if (newReading1 < enc1val){
    if (outputVal1-outStep >= 0) outputVal1-=outStep;
  }
  enc1val = newReading1;
  data = String(outputVal1);
  Serial.print("1c"+data+"w");
  delay(5);
  //Serial.print("1: ");
  //Serial.println(outputVal1);  
}



newReading2 = enc2.read();

if (newReading2 != enc2val){
  if (newReading2 > enc2val){ 
    if (outputVal2+outStep <= 255) outputVal2+=outStep;
  }
  else if (newReading2 < enc2val){
    if (outputVal2-outStep >= 0) outputVal2-=outStep;
  }
  enc2val = newReading2;
  data = String(outputVal2);
  Serial.print("2c"+data+"w");
  delay(5);
  //Serial.print("2: ");
  //Serial.println(outputVal2);  
}






newReading3 = enc3.read();

if (newReading3 != enc3val){
  if (newReading3 > enc3val){ 
    if (outputVal3+outStep <= 255) outputVal3+=outStep;
  }
  else if (newReading3 < enc3val){
    if (outputVal3-outStep >= 0) outputVal3-=outStep;
  }
  enc3val = newReading3;
  data = String(outputVal3);
  Serial.print("3c"+data+"w");
  delay(5);
  //Serial.print("3: ");
  //Serial.println(outputVal3);  
}



/*
data = String(map(analogRead(A0),0,1023,0,255));
Serial.print("0c"+data+"w");
delay(5);

data = String(map(analogRead(A1),0,1023,0,255));
Serial.print("1c"+data+"w");
delay(5);

data = String(map(analogRead(A2),0,1023,0,255));
Serial.print("2c"+data+"w");
delay(5);

data = String(map(analogRead(A3),0,1023,0,255));
Serial.print("3c"+data+"w");
delay(5);
*/

delay(100);
}
