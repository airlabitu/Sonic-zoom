/*
 * Code by AIR LAB @halfdan hauch jensen (halj@itu.dk)
 * 
 * Based on example from this page:
 * https://wiki.dfrobot.com/Wind_Speed_Sensor_Voltage_Type_0-5V__SKU_SEN0170
 * 
 * Connect the voltage signal wire to Arduino analog interface: 
 * 
 * Wiring:
 * Yellow cable <----> A0
 * Black cable  <----> GND
 * Red cable    <----> vin
 * 
 * Using the AIR LAB serial protocol that can be found here:
 * https://github.com/airlabitu/sandbox/tree/master/AIR_LAB_serial_protocol
*/

 void setup()
 {
   Serial.begin(9600);
 }

 void loop()
 {
   
   int sensorValue = analogRead(A0);
   float outvoltage = sensorValue * (5.0 / 1023.0);

   // sensor voltage
   
   // outValue is 100 times larger than original, in ordser to send the value as 'int' without significant data loss
   int outValue = int(outvoltage*100);                                      
   
   Serial.print(1); // channel
   Serial.print('c');
   Serial.print(outValue); // value
   Serial.print('w');

   // wind level
   int level = 6*outvoltage;//The level of wind speed is proportional to the output voltage.
   Serial.print(2); // channel
   Serial.print('c');
   Serial.print(level); // value
   Serial.print('w');
   
   delay(50); // small delay for minimizing data stream load
 }
