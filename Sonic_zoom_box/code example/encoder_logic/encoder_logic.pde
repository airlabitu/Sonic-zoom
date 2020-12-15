long encoder = 0;
int encoderFixedScale;
int scale = 255;
long min = 0;
long max = 255;
int step = 1;



void setup(){
  size(100, 300);
}

void draw(){
  background(0);
  rect(25, height-25-encoderFixedScale, 50, encoderFixedScale);
}

void keyPressed(){
  
  if (key == '+') encoder+=step;
  else if (key == '-') encoder-=step;
  
  if (encoder < min){
    min = encoder;
    max = min+scale;
  }
  else if (encoder > max){
    max = encoder;
    min = max - scale;
  }
  
  encoderFixedScale = (int)map(encoder, min, max, 0, scale);
  
  println(min, max, encoder, encoderFixedScale);
  
}
