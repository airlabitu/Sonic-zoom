import processing.serial.*;

import oscP5.*;
import netP5.*;

import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

OscP5 oscP5;
NetAddress myRemoteLocation;

//Serial myPort0;  // Create object from Serial class
//Serial myPort1;  // Create object from Serial class
String val;     // Data received from the serial port

Serial ports [] = new Serial[4];
int values [] = new int[4];
int channels [] = new int[4];


int encoderValues[] = {10, 50, 200, 255};

boolean mapping = false; // MIDI mapping state

void setup()
{
  size(225, 350);
  fill(255);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",9997);
  
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, -1, "Bus 1"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
  
  
  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  int count = 0;
  for (int i = 0; i < Serial.list().length; i++){
    println(i, Serial.list()[i]);
    if ((Serial.list()[i].indexOf("/dev/tty.usbmodem") != -1 || Serial.list()[i].indexOf("/dev/ttyACM") != -1) && count < 4) {
      ports[count] = new Serial(this, Serial.list()[i], 9600);
      println("Added serial port: ", Serial.list()[i], "at index ", count);
      count++;
    }
  }
}

void draw()
{
  
  for (int i = 0; i<4; i++){
    if (ports[i] == null) {
      println("Port ", i, "skipped");
      continue;
    }
    int c;

    while(ports[i].available()>0){
    c = ports[i].read();
    if ((c>='0') && (c<='9')) {
      values[i] = 10*values[i] + c - '0';
    } else {
      if (c=='c') channels[i] = values[i];
      else if (c=='w') {
        //DmxSimple.write(channel, value);
        //println("port", i, channels[i], values[i]);
        encoderValues[i] = values[i];
        println(int(map(values[i], 0, 255, 0, 6)));
        ports[i].write(""+int(map(values[i], 0, 255, 0, 6))); // Send LED indicator data back to the Arduino
        OscMessage myMessage;
        if (channels[i]==0) myMessage = new OscMessage("/sensor0");
        else if (channels[i]==1) myMessage = new OscMessage("/sensor1");
        else if (channels[i]==2) myMessage = new OscMessage("/sensor2");
        else if (channels[i]==3) myMessage = new OscMessage("/sensor3");
        else myMessage = new OscMessage("/errro");
        
        //myMessage.add(channel); // add an int to the osc message
        myMessage.add(values[i]);
  
        // send the message
        oscP5.send(myMessage, myRemoteLocation);
        
        // MIDI send
        if (!mapping){
          myBus.sendControllerChange(0, i, int(map(values[i], 0, 255, 0, 100)));
          myBus.sendControllerChange(0, i, int(map(values[i], 0, 255, 0, 100)));
          myBus.sendControllerChange(0, i, int(map(values[i], 0, 255, 0, 100)));
          myBus.sendControllerChange(0, i, int(map(values[i], 0, 255, 0, 100)));
        }
        
        
      }
      values[i] = 0;
    }
    }
  }
  
  // Draw GUI stuff
  background(0);
  fill(255);
  for (int i = 0; i < 4; i++){
    noFill();
    stroke(255);
    rect(25+i*50, height-75-255, 25, 255); // fader outline box
    fill(255);
    rect(25+i*50, height-75-encoderValues[i], 25, encoderValues[i]); // fader
    text(""+i, 25+9+i*50, height-50); // wheel index
    //println(25+(i+1)*50, height-25-encoderValues[i], 25, encoderValues[i]);
  }
  
  if (mapping){
    fill(255, 100, 100, 200);
    rect(width*0.05, height*0.25, width*0.9, height*0.35);
    fill(255);
    text("MIDI mapping mode", width*0.1, height*0.325);
    text("Press key 0 to map wheel 0", width*0.15, height*0.4);
    text("Press key 1 to map wheel 1", width*0.15, height*0.45);
    text("Press key 2 to map wheel 2", width*0.15, height*0.5);
    text("Press key 3 to map wheel 0", width*0.15, height*0.55);
  }
  
  text("MIDI mapping mode (m) :" + mapping, 25, height-20); 
}
  

  
  
// for mapping midi messages to vol channels in Ableton Live
void keyReleased(){
  println(char(4));
  if (key == 'm') mapping = !mapping; // toggle midi mapping mode
  
  if (mapping){ // ready to send midi control change messages if mapping mode is active
    String keyString = ""+key;
    for (int i = 0; i < 10; i++){ // making sure we map a number 0-9, must corrospond to a channel we send will be sending midi out on
      if (keyString.equals(""+i)) myBus.sendControllerChange(0, i, 0);
    }
  }
}
  
