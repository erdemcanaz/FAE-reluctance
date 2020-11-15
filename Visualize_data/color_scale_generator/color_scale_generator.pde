void setup() {
  size(300,100);
}


int counter=0;
void draw() {
  
  strokeWeight(3);
  for(int i=0;i<100;i++){    
    int rgb[]=RGB(i/100.0);
    stroke(rgb[0],rgb[1],rgb[2]);
    point(i*3,counter%100);
    
  }
  counter++;
}

int[] RGB(float logic_percentage) {
  if(logic_percentage<0)logic_percentage=0;
  else if(logic_percentage>1)logic_percentage=1;
  
  int rgb[]={0, 0, 0};
  float radian=2*PI*logic_percentage*0.83;
  rgb[0]=(int) ((cos(radian+2)+1)*0.5*255);
  rgb[1]=(int) ((cos(radian+4)+1)*0.5*255);
  rgb[2]=(int) ((cos(radian)+1)*0.5*255);
  return rgb;
}
