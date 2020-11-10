int GRAPH_COLOR_SCALE=1;

float MAX_ABSOLUTE_CURRENT=0;
float INPUT_CURRENT=0;
float RELUCTANCE=0;

float VOLTAGE_VALUE=5;
String[] lines;
int cordinates[][];
float currents[][];
float voltages[];
String resistances[];
String types[];

void setup() {

  size(1100, 500); 
  background(255);
  strokeWeight(5);
  for(int i=0;i<500;i+=5){
    int c[]=getColorOnScale(i/500.0);
    stroke(c[0],c[1],c[2]);
    point(1050,500-i);
  }
  lines = loadStrings("resistorsInSeries1.txt");
  cordinates=new int[lines.length][2];
  currents= new float[lines.length][4];
  voltages = new float[lines.length];
  resistances= new String[lines.length];  
  types= new String[lines.length]; 
  
  for (int i = 0; i < lines.length; i++) {
    String d[]= lines[i].split(":");       
    resistances[i]=d[1];
    cordinates[i][0]= Integer.valueOf(d[2]);
    cordinates[i][1]= Integer.valueOf(d[3]);
    voltages[i]=Float.valueOf(d[4].replace(',', '.'));
    currents[i][0]=Float.valueOf(d[5].replace(',', '.'));
    currents[i][0]=Float.valueOf(d[6].replace(',', '.'));
    currents[i][0]=Float.valueOf(d[7].replace(',', '.'));
    currents[i][0]=Float.valueOf(d[8].replace(',', '.'));
    types[i]=d[9];    
  }
  find_max_abs_current_and_input_current();
  calculate_reluctance();
  println("VOLTAGE: "+VOLTAGE_VALUE+"\nMAX CURRENT PASSING THROUGH A NODE: "+MAX_ABSOLUTE_CURRENT+"\nINPUT CURRENT: "+INPUT_CURRENT+"\nRELUCTANCE: "+RELUCTANCE);
  
  strokeWeight(5);
  
}  





void draw() {
 for(int i=0;i<lines.length;i++){
     int c[]=getColorOnScale( log_scale(calculate_node_current_POSITIVE(i),MAX_ABSOLUTE_CURRENT,GRAPH_COLOR_SCALE));
     stroke(c[0],c[1],c[2]);
     point(cordinates[i][0],cordinates[i][1]);    
  }
  for(int i=0;i<lines.length;i++){
     int c[]=getColorOnScale( log_scale(voltages[i],5,GRAPH_COLOR_SCALE));
     stroke(c[0],c[1],c[2]);
     point(500+cordinates[i][0],cordinates[i][1]);
    
  }
}

int[] getColorOnScale(float logicPercentage){
  if(logicPercentage>1||logicPercentage<0)logicPercentage=0;
  
  int RGB[]={0,0,0};
  RGB[0]=(int)(255.0f*logicPercentage);
  RGB[1]=200-(int)(255.0f*logicPercentage);
  RGB[2]=125+(int)(255.0f*logicPercentage)%100;
  return RGB ;
  
}
float log_scale(float x,float y,int tenToPower){
  if(x>y)x=y;
  float rate=x/y;
  float logic_percentage=(log(rate*pow(10,tenToPower)) / log(10))/tenToPower;
  if(logic_percentage>=0 && logic_percentage<=1)return logic_percentage;
  else return 0;
  
}
void find_max_abs_current_and_input_current() {
  for (int i=0; i<lines.length; i++) {
    boolean isVoltage= true;
    float input_currents_sum=0;
    
    for (int j=0; j<4; j++) {
      
      if (currents[i][j]<0) isVoltage=false;
      input_currents_sum+=currents[i][j];
      
      if (abs(currents[i][j])>MAX_ABSOLUTE_CURRENT) {
        MAX_ABSOLUTE_CURRENT=abs(currents[i][j]);
      }
      
    }

    if (isVoltage) INPUT_CURRENT+=input_currents_sum;
  }
}

void calculate_reluctance(){
   RELUCTANCE=VOLTAGE_VALUE/INPUT_CURRENT;
}

float calculate_node_current_POSITIVE(int parent_node){
  float sum=0;
 for(int i=0;i<4;i++){
   if(currents[parent_node][i]>0)sum+=currents[parent_node][i];
 }
  return sum;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  GRAPH_COLOR_SCALE+=e;
  if(GRAPH_COLOR_SCALE<1)GRAPH_COLOR_SCALE=1;
  else if(GRAPH_COLOR_SCALE>11)GRAPH_COLOR_SCALE=11;
}
