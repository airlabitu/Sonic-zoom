import processing.serial.*;

import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port

int value = 0;
int channel;



void setup()
{
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",9997);
  
  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  println(Serial.list());
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  println(Serial.list());
}

void draw()
{
  
  int c;

  while(myPort.available()>0){
  c = myPort.read();
  if ((c>='0') && (c<='9')) {
    value = 10*value + c - '0';
  } else {
    if (c=='c') channel = value;
    else if (c=='w') {
      //DmxSimple.write(channel, value);
      println(channel, value);
      
      OscMessage myMessage;
      if (channel==0) myMessage = new OscMessage("/sensor0");
      else if (channel==1) myMessage = new OscMessage("/sensor1");
      else if (channel==2) myMessage = new OscMessage("/sensor2");
      else if (channel==3) myMessage = new OscMessage("/sensor3");
      else myMessage = new OscMessage("/errro");
      
      //myMessage.add(channel); /* add an int to the osc message */
      myMessage.add(value);

      /* send the message */
      oscP5.send(myMessage, myRemoteLocation); 
    }
    value = 0;
  }
  }
}
