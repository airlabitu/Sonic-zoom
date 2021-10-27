/*
* 
* Serial to midi sketch for the Sonic Zoom installations anemometer sensor
* 
* Code by AIR LAB (airlab.itu.dk) @halfdan hauch jensen (halj@itu.dk)
*
*/

import controlP5.*;
import processing.serial.*;

import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

Serial myPort;                       // The serial port
int[] serialInArray = new int[3];    // Where we'll put what we receive


// Serial protocol variables
int value = 0;
int channel;

boolean serialEnabled = false;

// sensor values
int windSpeed = 0;
int windLevel = 0;

int speed_mapping_max = 1;
int level_mapping_max = 1;

boolean flagWindSpeed = false;
boolean flagWindLevel = false;

// MIDI notes loop
long timer;
int interval = 2000;
int pitch;
int velocity;
int noteState = 0;

ControlP5 cp5;


void setup() {  
  
  size(400, 200);
  
  // print the serial list with indexes
  for (int i = 0; i < Serial.list().length; i++) println(i, Serial.list()[i]);
  println();
  
  // automatic choosing the right index in the serial list, if not working check the board name
  
  if (serialEnabled){
    String portName = "";
    for (int i = 0; i < Serial.list().length; i++){
      if (Serial.list()[i].equals("/dev/tty.usbmodem145201")) portName = Serial.list()[i];
    }
    myPort = new Serial(this, portName, 9600); // setup the serial connection
  }
  
  
  
  
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, -1, "Bus 1"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
  
  
  cp5 = new ControlP5(this);
  
  cp5.addSlider("wind_speed")
     .setRange(0,500)
     .setValue(0)
     .setPosition(50,50)
     .setSize(100,10);
     
  cp5.addSlider("wind_level")
     .setRange(0,30)
     .setValue(0)
     .setPosition(50,75)
     .setSize(100,10);
  
  cp5.addSlider("speed_mapping_max")
     .setRange(1,500)
     .setValue(200)
     .setPosition(50,125)
     .setSize(100,10)
     .plugTo(this);
     
  cp5.addSlider("level_mapping_max")
     .setRange(1,30)
     .setValue(2)
     .setPosition(50,150)
     .setSize(100,10)
     .plugTo(this);
     
  
}

void draw() {
  background(0);
  
  if (flagWindSpeed){
    flagWindSpeed = false;
    myBus.sendControllerChange(0, 4, constrain(int(map(windSpeed, 0, speed_mapping_max, 0, 127)), 0, 127));
    cp5.getController("wind_speed").setValue(windSpeed);
    println("MIDI speed", constrain(int(map(windSpeed, 0, speed_mapping_max, 0, 127)), 0, 127));
  }
  
  if (flagWindLevel){
    flagWindLevel = false;
    myBus.sendControllerChange(0, 5, constrain(int(map(windLevel, 0, level_mapping_max, 0, 127)), 0, 127));
    cp5.getController("wind_level").setValue(windLevel);
    println("MIDI level", constrain(int(map(windLevel, 0, level_mapping_max, 0, 127)), 0, 127));
  }
  
  
  if (millis() > timer + interval) {
    timer = millis();

    if (noteState == 0) {
    //if (interval == 2000) {
      pitch = int(random(0, 127));
      velocity = int(random(0, 127));
      myBus.sendNoteOn(0, pitch, velocity); // Send a Midi noteOn
      noteState = 1;
      interval = int(random(30, 100));
      println("ON", pitch, velocity);
    } 
    else if (noteState == 1) {
    //else if (interval == 200) {
      myBus.sendNoteOff(0, pitch, velocity); // Send a Midi nodeOff
      noteState = 0;
      //interval = 2000;
      interval = constrain(int(map(windSpeed, 0, speed_mapping_max, 2000, 0)), 0, 2000);
      println("OFF", pitch, velocity, interval, windSpeed);
      
    }
  }
  
}

void wind_speed(int theFlag){
  windSpeed = theFlag;
}

// event function called by processing when receiving new serial data
void serialEvent(Serial myPort) {
  
  // read a byte from the serial port:
  int inByte = myPort.read();
  
   
  if ((inByte>='0') && (inByte<='9')) {
    value = 10*value + inByte - '0';
  } else {
    if (inByte=='c') channel = value;
    else if (inByte=='w') {
      //println("Done reading", channel, value);  // here we have the full data message saved in 'channel' and 'value'
      if (channel == 1) {
        windSpeed = value;
        flagWindSpeed = true;
        //myBus.sendControllerChange(0, 4, int(map(windSpeed, 0, speed_mapping_max, 0, 127)));
      }
      
      else if (channel == 2) {
        windLevel = value;
        flagWindLevel = true;
        //myBus.sendControllerChange(0, 5, int(map(windLevel, 0, level_mapping_max, 0, 127)));
      }
    }
    value = 0;
  }
  
  
  
  
}
