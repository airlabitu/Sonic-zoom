import processing.serial.*;

import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

//Serial myPort0;  // Create object from Serial class
//Serial myPort1;  // Create object from Serial class
//Serial myPort2;  // Create object from Serial class
//Serial myPort3;  // Create object from Serial class
String val;     // Data received from the serial port

Serial ports [] = new Serial[4];
int values [] = new int[4];
int channels [] = new int[4];

/*
int value0 = 0;
int value1 = 0;
int channel0;
int channel1;
*/


int encoderValues[] = {10, 50, 200, 255};


void setup()
{
  size(225, 300);
  fill(255);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",9997);
  
  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  int count = 0;
  for (int i = 0; i < Serial.list().length; i++){
    println(i, Serial.list()[i]);
    if (Serial.list()[i].indexOf("/dev/tty.usbmodem") != -1 && count < 4) {
      ports[count] = new Serial(this, Serial.list()[i], 9600);
      println("Added serial port: ", Serial.list()[i], "at index ", count);
      count++;
    }
  }
  //println(Serial.list());
  //String portName = Serial.list()[4]; //change the 0 to a 1 or 2 etc. to match your port
  
  /*
  ports[0] = new Serial(this, Serial.list()[4], 9600);
  ports[1] = new Serial(this, Serial.list()[5], 9600);
  ports[2] = new Serial(this, Serial.list()[6], 9600);
  ports[3] = new Serial(this, Serial.list()[7], 9600);
  */
  
  //myPort0 = new Serial(this, Serial.list()[4], 9600);
  //myPort1 = new Serial(this, Serial.list()[5], 9600);
  
  //println(Serial.list());
}

void draw()
{
  
  /*
  for (int i = 0; i<4; i++){
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
        
      }
      values[i] = 0;
    }
    }
  }
  */
  background(0);
  for (int i = 0; i < 4; i++){
    rect(25+i*50, height-25-encoderValues[i], 25, encoderValues[i]);
    //println(25+(i+1)*50, height-25-encoderValues[i], 25, encoderValues[i]);
  }
  
  /*
  
  int c1;
  
  while(myPort1.available()>0){
  c1 = myPort1.read();
  if ((c1>='0') && (c1<='9')) {
    value1 = 10*value1 + c1 - '0';
  } else {
    if (c1=='c') channel1 = value1;
    else if (c1=='w') {
      //DmxSimple.write(channel, value);
      println("myPort1", channel1, value1);
      
      OscMessage myMessage;
      if (channel==0) myMessage = new OscMessage("/sensor0");
      else if (channel==1) myMessage = new OscMessage("/sensor1");
      else if (channel==2) myMessage = new OscMessage("/sensor2");
      else if (channel==3) myMessage = new OscMessage("/sensor3");
      else myMessage = new OscMessage("/errro");
      
      //myMessage.add(channel); // add an int to the osc message
      myMessage.add(value);

      //send the message
      oscP5.send(myMessage, myRemoteLocation); 
      
    }
    value1 = 0;
  }
  */
  }
  
  
  
