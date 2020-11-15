PImage stator;
PImage rotor;
PImage coils;

void setup(){
size(500,500);
background(255);
stator=loadImage("stator_png.png");
rotor=loadImage("rotor.png");
imageMode(CENTER);


for(int i=0;i<=180;i+=20){
  rotor_at_angle(i);
  saveFrame("angle"+i+".png");
}
frameRate(5);
}


float angle=0;
void draw(){ 
 rotor_at_angle(angle);
 angle+=20;
 
}

void rotor_at_angle(float angle){
  background(255);
  translate(width/2, height/2);
  rotate(radians(angle));
  image(rotor,0,0); 
  rotate(-radians(angle));
  image(stator,0,0); 
  translate(-width/2, -height/2);
}
