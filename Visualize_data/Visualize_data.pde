
String[] lines;
int cordinates[][];
float currents[][];
float voltages[];
String resistances[];
String types[];

void setup(){
  
  size(1000,500); 
  background(255);
  
  lines = loadStrings("DATA_TEXT_1800.txt");
  cordinates=new int[lines.length][2];
  currents= new float[lines.length][4];
  voltages = new float[lines.length];
  resistances= new String[lines.length];  
  types= new String[lines.length]; 

  for (int i = 0 ; i < lines.length; i++) {
        String d[]= lines[i].split(":");       
        resistances[i]=d[1];
        cordinates[i][0]= Integer.valueOf(d[2]);
        cordinates[i][1]= Integer.valueOf(d[3]);
        voltages[i]=Float.valueOf(d[4]);
        currents[i][0]=Float.valueOf(d[5].replace(',','.'));
        currents[i][0]=Float.valueOf(d[6].replace(',','.'));
        currents[i][0]=Float.valueOf(d[7].replace(',','.'));
        currents[i][0]=Float.valueOf(d[8].replace(',','.'));
        types[i]=d[9];      
     }
}  




void draw(){
  
  
}

void find_max_abs_current(){
  
  
}
