int GRAPH_COLOR_SCALE=2;

double MAX_ABSOLUTE_CURRENT=0;
double INPUT_CURRENT=0;
double RELUCTANCE=0;

double VOLTAGE_VALUE=5;
String[] lines;
int cordinates[][];
double currents[][];
double voltages[];
String resistances[];
String types[];

void setup() {

  size(1100, 500); 
  background(255);
  strokeWeight(5);
  for (int k=0; k<10; k++) {
    for (int i=0; i<500; i+=5) {
      int c[]=getColorOnScale2(i/500.0);
      stroke(c[0], c[1], c[2]);
      point(1050+k, 500-i);
    }
  }
  lines = loadStrings("angle180.txt");
  cordinates=new int[lines.length][2];
  currents= new double[lines.length][4];
  voltages = new double[lines.length];
  resistances= new String[lines.length];  
  types= new String[lines.length]; 

  for (int i = 0; i < lines.length; i++) {
    String d[]= lines[i].split(":");       
    resistances[i]=d[1];
    cordinates[i][0]= Integer.valueOf(d[2]);
    cordinates[i][1]= Integer.valueOf(d[3]);
    voltages[i]=Double.valueOf(d[4].replace(',', '.'));
    currents[i][0]=Double.valueOf(d[5].replace(',', '.'));
    currents[i][1]=Double.valueOf(d[6].replace(',', '.'));
    currents[i][2]=Double.valueOf(d[7].replace(',', '.'));
    currents[i][3]=Double.valueOf(d[8].replace(',', '.'));
    types[i]=d[9];
  }
  find_max_abs_current_and_input_current();
  calculate_reluctance();
  println("VOLTAGE: "+VOLTAGE_VALUE+"\nMAX CURRENT PASSING THROUGH A NODE: "+MAX_ABSOLUTE_CURRENT+"\nINPUT CURRENT: "+INPUT_CURRENT+"\nRELUCTANCE: "+RELUCTANCE);

  strokeWeight(5);
}  





void draw() {
  for (int i=0; i<lines.length; i++) {
    int c[]=getColorOnScale2( (float)log_scale(calculate_node_current_POSITIVE(i), MAX_ABSOLUTE_CURRENT, GRAPH_COLOR_SCALE));
    stroke(c[0], c[1], c[2]);
    point(cordinates[i][0], cordinates[i][1]);
  }
  for (int i=0; i<lines.length; i++) {
    int c[]=getColorOnScale2( (float)log_scale(voltages[i], 5, GRAPH_COLOR_SCALE));
    stroke(c[0], c[1], c[2]);
    point(500+cordinates[i][0], cordinates[i][1]);
  }
}

int[] getColorOnScale1(double logicPercentage) {
  if (logicPercentage>1||logicPercentage<0)logicPercentage=0;

  int RGB[]={0, 0, 0};
  RGB[0]=(int)(255.0f*logicPercentage);
  RGB[1]=200-(int)(255.0f*logicPercentage);
  RGB[2]=125+(int)(255.0f*logicPercentage)%100;
  return RGB ;
}
int[] getColorOnScale2(float logicPercentage) {
  if (logicPercentage<0)logicPercentage=0;
  else if (logicPercentage>1)logicPercentage=1;

  int rgb[]={0, 0, 0};
  float radian=2*PI*logicPercentage*0.83;
  rgb[0]=(int) ((cos(radian+2)+1)*0.5*255);
  rgb[1]=(int) ((cos(radian+4)+1)*0.5*255);
  rgb[2]=(int) ((cos(radian)+1)*0.5*255);
  return rgb;
}

double log_scale(double x, double y, int tenToPower) {
  if (x>y)x=y;
  double rate=x/y;
  double logic_percentage=(log((float)rate*pow(10, tenToPower)) / log(10))/tenToPower;
  if (logic_percentage>=0 && logic_percentage<=1)return logic_percentage;
  else return 0;
}
void find_max_abs_current_and_input_current() {
  for (int i=0; i<lines.length; i++) {
    boolean isVoltage= true;
    double input_currents_sum=0;

    for (int j=0; j<4; j++) {
      print(currents[i][j]+" ");
      if (currents[i][j]<0) isVoltage=false;
      input_currents_sum+=currents[i][j];      
      if (ABS(currents[i][j])>MAX_ABSOLUTE_CURRENT) {
        MAX_ABSOLUTE_CURRENT=ABS(currents[i][j]);
      }
    }
    println();
    if (isVoltage) INPUT_CURRENT+=input_currents_sum;
  }
}

void calculate_reluctance() {
  RELUCTANCE=VOLTAGE_VALUE/INPUT_CURRENT;
}

double calculate_node_current_POSITIVE(int parent_node) {
  double sum=0;
  for (int i=0; i<4; i++) {
    if (currents[parent_node][i]>0)sum+=currents[parent_node][i];
  }
  return sum;
}
double ABS(double a) {
  if (a>0)return a;
  else return -a;
}
void mouseWheel(MouseEvent event) {
  double e = event.getCount();
  GRAPH_COLOR_SCALE+=e;
  if (GRAPH_COLOR_SCALE<1)GRAPH_COLOR_SCALE=1;
  else if (GRAPH_COLOR_SCALE>11)GRAPH_COLOR_SCALE=11;
}
