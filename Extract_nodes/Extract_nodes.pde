PImage M1_0;
PrintWriter writer;

void setup(){
  size(500,500);
  M1_0 = loadImage("M1_0.png");
  writer = createWriter("pointData.txt");
 
  
  image(M1_0,0,0);
  
}

boolean a=true;
void draw(){  
  extractNodes(1,20,20);  
}

int lastCord[]={0,0};
int nodeCounter=0;
boolean allIsExtracted= false;

boolean extractNodes(int numberOfNodesToExtract, int dx, int dy){
  if(lastCord[0]>495){lastCord[0]=0; lastCord[1]+=dy;}
  if(lastCord[1]>495){ if(!allIsExtracted){println("finished, number of nodes=",nodeCounter, "estimated mesh memory requirement =",pow(nodeCounter,2)*64.0/pow(1023,2), "MB");allIsExtracted=true; writer.flush(); writer.close();}  return false;}
  
  strokeWeight(10);
  
  
  for(int i=0;i<numberOfNodesToExtract;i++){    
    int r= (int)red(get(lastCord[0],lastCord[1]));
    int g= (int)green(get(lastCord[0],lastCord[1]));
    int b= (int)blue(get(lastCord[0],lastCord[1]));
    if(r>120 && r<135 && g>120 && g<135 && b>120 && b<135){//grey ( boundary)
      stroke(255,0,0);
      point(lastCord[0],lastCord[1]);
      
    }else{
      if(r>245 && g <10 && b < 10){//red
      stroke(255);
      point(lastCord[0],lastCord[1]); 
      writer.print(nodeCounter+",RESISTANCE_LOW,"+lastCord[0]+","+lastCord[1]+",-1"+",-2"+",-2"+",-2"+",-2"+",TYPE_VOLTAGE;");
      nodeCounter++;
      }  
      else if(r<10 && g <10 && b > 240){//blue
      stroke(255);
      point(lastCord[0],lastCord[1]); 
      writer.print(nodeCounter+",RESISTANCE_LOW,"+lastCord[0]+","+lastCord[1]+",-1"+",-2"+",-2"+",-2"+",-2"+",TYPE_GROUND;");
      nodeCounter++;
      } 
      else if(r+g+b>735){//white
      stroke(0,255,0);
      point(lastCord[0],lastCord[1]); 
      writer.print(nodeCounter+",RESISTANCE_HIGH,"+lastCord[0]+","+lastCord[1]+",-2"+",-2"+",-2"+",-2"+",-2"+",TYPE_ORDINARY;");
      nodeCounter++;
   
      } else if(r+g+b <15){//black
      stroke(125,125,125);
      point(lastCord[0],lastCord[1]);  
      writer.print(nodeCounter+",RESISTANCE_LOW,"+lastCord[0]+","+lastCord[1]+",-2"+",-2"+",-2"+",-2"+",-2"+",TYPE_ORDINARY;");
      nodeCounter++;      
      }               
      
    }    
     lastCord[0]+=dx;
     if(lastCord[0]>500)break;
  }
  
  
  
  return true;
  
}

/*void mouseClicked(){
   int r= (int)red(get(mouseX,mouseY));
    int g= (int)green(get(mouseX,mouseY));
    int b= (int)blue(get(mouseX,mouseY));
    println(r,g,b);  
}*/
