String stage; //start, bar, or animation
Table table;
float barwidth = width/70;
float x;
int count;
float max;
String regionChoice;
float grp;
float ag;
float man;
float services;
String[] usStates = {
  "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
  "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
  "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
  "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
  "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"
};
String[] usStatesLong = {
  "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia",
  "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
  "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey",
  "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
  "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"
};
int hoveredStateIndex = -1; // -1 indicates no hover
String clickedState = "";
int textSize;
int hoveredYear = -1; // Initialize hoveredYear to -1



void setup() {
  size(1000, 800);
  background(255);
  textSize = 12;
  //table = loadTable("DOSE_V2.csv", "header");
  table = loadTable("DOSE_V2.csv", "header");
  stage = "start";
}

void draw(){
  background(255);
  if (stage == "start"){
     fill(0);
     textSize(30);
     textAlign(CENTER);
     text("Choose your visualization of US GDP by state from 1964-2019", width/2, height/6);
     fill(250, 200, 200);
     rect(.5 * width/4, height/4, 300, 300);
     fill(0);
     text("Bar chart", 40 + width/4, 150 + height/4);
     fill(200, 200, 250);
     rect(20+ 2* width/4, height/4, 300, 300);
     fill(0);
     text("Animation", 160 + 2*width/4, 150 + height/4);
     
  }
  
  if (stage == "bar"){
    fill(0);
    text("Pick a state from above!", 400,760);
    textSize = 12;
    stateAbbs();
     
    x = 0.0;
    barwidth = width/60; 
    drawKey();
    for (TableRow row : table.rows()) {
       String country = row.getString("country");
       if (country.equals("USA")){
         grp = row.getFloat("grp_pc_usd");
         ag = row.getFloat("ag_grp_pc_usd");
         man =  row.getFloat("man_grp_pc_usd");
         services =  row.getFloat("serv_grp_pc_usd");
         String region = row.getString("region");
         
         if(region.equals(clickedState)){
           x+=barwidth;
           float mappedGRP = map(grp, 0, 100000, 0, height-50);
           float mappedAg = map(ag, 0, 100000, 0, height-50);
           float mappedMan = map(man, 0, 100000, 0, height-50);
           float mappedServ = map(services, 0, 100000, 0, height-50);
           int year = row.getInt("year");
           
           if (mouseX >= x && mouseX < x + barwidth) {
            fill(0);
            text(year, mouseX + 20, mouseY -20);
           }
           
           //draw axes here
           fill(0);
           strokeWeight(5);
           stroke(0);
           line(10,height-30, width-10, height-30);
           line(10, 100, 10, height-30);
           stroke(0,10);
           strokeWeight(1);
           line(10,(height-130)/4 +100, width-10, (height-130)/4 +100);
           line(10,2*(height-130)/4 +100, width-10, 2*(height-130)/4 +100);
           line(10,3*(height-130)/4 +100, width-10, 3*(height-130)/4 +100);
           strokeWeight(1);
           stroke(0);
           textAlign(CENTER);
           text("Time: 1964-2019", width/2, height-11);
           textAlign(LEFT);
           text("GRP Per Capita", 20, 140);
           
           
           
           rectMode(CORNERS);
           //rect(x,height,x+barwidth,height-mappedGRP);
           fill(color(30,100,250));
           highlightBar();
           rect(x, height-30, x+barwidth, height-30-mappedServ);
           fill(color(230,30,30));
           highlightBar();
           rect(x, height-30-mappedServ, x+barwidth, height-30-mappedServ-mappedMan);
           fill(color(30,230,30));
           highlightBar();
           rect(x, height-30-mappedServ-mappedMan, x+barwidth, height-30-mappedMan-mappedServ-mappedAg);
         }   
       }
     }
  }
  
  if (stage == "animation"){
    
  }
}

void mouseMoved() {
  // Check if the mouse is over any state
  hoveredStateIndex = -1;
  for (int i = 0; i < usStates.length; i++) {
    float xPos = map(i % (usStates.length / 2), 0, usStates.length / 2, 0, width - 100);
    float yPos = map(i / (usStates.length / 2), 0, 2, 0, height / 10);
    
    if (mouseX > xPos + 50 && mouseX < xPos + 50 + textWidth(usStates[i]) && mouseY > yPos + 15 && mouseY < yPos + 15 + textSize) {
      //println("coors: " + (xPos+50) + "  " + (xPos+50+textWidth(usStates[i])) + "  "+ (yPos+20) + " " + (yPos +20+textSize));
      //fill(30, 230, 30, 10);
      //rect(xPos+50,  yPos+15,xPos+50+textWidth(usStates[i]), yPos +15+textSize);
      hoveredStateIndex = i;
      //println(hoveredStateIndex);
      break; // Exit the loop once a state is found
    }
  }
}

void mousePressed() {
  if (stage == "start"){
    if (mouseX > 20+ 2* width/4 && mouseX < 320+ 2* width/4 && mouseY >height/4 && mouseY < height/4+300){
      stage = "animation";
    }
    if (mouseX > .5 * width/4 && mouseX < 300 + .5 * width/4 && mouseY >height/4 && mouseY < height/4+300){
     stage = "bar";
    }
  }
  
  if (hoveredStateIndex != -1) {
      clickedState = usStatesLong[hoveredStateIndex];
      //println("Clicked on: " + clickedState);
      fill(255);
      noStroke();
      rect(0,100,width, height);
      stroke(0);
  }
  if (mouseX>x && mouseX<x+barwidth){
    for (TableRow row : table.rows()) {
       String country = row.getString("country");
       if (country.equals("USA")){
          grp = row.getFloat("grp_pc_usd");
          ag = row.getFloat("ag_grp_pc_usd");
          man =  row.getFloat("man_grp_pc_usd");
          services =  row.getFloat("serv_grp_pc_usd");
       }
    }
    text(grp + " " + ag + " " + man,mouseX, mouseY);
  }
}

void highlightBar(){ //hgihlights bar when hovered over
  if (mouseX >= x && mouseX < x+barwidth){
         fill(20, 200, 200);
   }  
}

void drawKey(){ //draws the color key for bar chart
  fill(color(30,100,250));
  rectMode(CENTER);
  rect(width/5, 90, 20,20);
  fill(color(230,30,30));
  rect(2*width/5, 90, 20,20);
  fill(color(30,230,30));
  rect(3*width/5, 90, 20,20);
  fill(0);
  textSize(17);
  text("Agriculture", 3*width/5+20, 90);
  text("Manufacturing", 2*width/5+20, 90);
  text("Services", width/5+20, 90);
  rectMode(CORNERS);
}

void stateAbbs() { //draws the state abreviations at the top
   textSize = 12;
  for (int i = 0; i < usStates.length; i++) {
    float xPos = map(i % (usStates.length / 2), 0, usStates.length / 2, 0, width - 100);
    float yPos = map(i / (usStates.length / 2), 0, 2, 0, height / 10);
    
    textAlign(TOP, CENTER);
    fill(0);
    if (i == hoveredStateIndex) {
      fill(30, 130, 250); // Highlight color when hovered
    }
    text(usStates[i], xPos + 50, yPos + 20);
  }
  
  stroke(0); 
}

//DONEmake color key
//DONE make a mode selector start page
//make text on demand
//title, axes, axis titles
//make "select a state"
//make a true value, not 'per capita' option
//make other visualiation with a button to change

//potentially change fonts?
