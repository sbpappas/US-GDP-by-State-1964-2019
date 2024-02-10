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
int animationCount;
int currentIndex = 1964;
int frames = 300;
int displayDuration = frames; // in milliseconds
int lastDisplayTime;
boolean paused = false;
float circleX;
float circleY;
float mapped_grp;
int yearTracker;


void setup() {
  size(1000, 800);
  background(255);
  textSize = 12;
  //table = loadTable("DOSE_V2.csv", "header");
  table = loadTable("DOSE_V2.csv", "header");
  stage = "start";
  lastDisplayTime = millis();
}

void draw(){
  color startColor = color(191, 252, 242); 
  color endColor = color(255, 253, 208); 

  drawGradientBackground(startColor, endColor);
  if (stage == "start"){
     animationCount = 0;
     fill(0);
     stroke(0);
     strokeWeight(4);
     textSize(30);
     textAlign(CENTER);
     rectMode(CORNER);
     text("Choose your visualization of US GDP by state from 1964-2019", width/2, height/6 -50);
     fill(250, 200, 200);
     rectMode(CENTER);
     if ((mouseX < width/4 +175) && (mouseX > width/4-175) && (mouseY <650) && mouseY >150){
       fill(250,142, 247);
     }
     rect(width/4, 400, 350, 500);
     //rect(.5 * width/4, height/4, 300, 300);
     fill(0);
     text("Bar chart", width/4, 400);
     fill(200, 200, 250);
     //rect(20+ 2* width/4, height/4, 300, 300);
     if ((mouseX < 3*width/4 +175) && (mouseX > 3*width/4-175) && (mouseY <650) && mouseY >150){
      fill(142,243,247);
     }
     rect(3*width/4, 400, 350, 500);
     fill(0);
     text("Animation", 3*width/4, 400);
     strokeWeight(1);
     
  }
  if (stage == "animation"){
      animationSetup();
      animatedYears();
      animate();
  }
  if (stage == "stats"){
    pullStatsPage();
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
            yearTracker = year;
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
           text("$66,000", 15, (height-130)/4 +90);
           text("$44,000", 15, 2*(height-130)/4 +90);
           text("$22,000", 15, 3*(height-130)/4 +90);
           
           
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
}

void keyPressed() {
  if (key == 'b' || key == 'B') {
    stage = "start";
  }
  if (key == 'p' || key == 'P'){
    if (paused == false){
       displayDuration = Integer.MAX_VALUE; 
       paused = true;
    }
    else if (paused == true){
      paused = false;
      displayDuration = frames;
    }
  }
  if (stage == "stats" && (key == 'x' || key == 'X')){
     stage = "bar"; 
  }
}

void mouseMoved() {
  if (stage == "start"){
     if ((mouseX < width/4 +175) && (mouseX > width/4-175) && (mouseY <650) && mouseY >150){
       fill(0);
       //rect(200,200, 10,10);
     }
     else if ((mouseX < 3*width/4 +175) && (mouseX > 3*width/4-175) && (mouseY <650) && mouseY >150){
       
     }
  }
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
  if (stage == "bar"){
    if (hoveredStateIndex != -1) {
        clickedState = usStatesLong[hoveredStateIndex];
        //println("Clicked on: " + clickedState);
        fill(255);
        noStroke();
        rect(0,100,width, height);
        stroke(0);
    }
    if (mouseX>x && mouseX<x+barwidth && mouseY > height/3){
      stage = "stats";
    }
  }
  if (stage == "animate"){
     if (isMouseInsideCircle(circleX, circleY, mapped_grp)) {
    fill(255, 0, 0); // Red color
    text("Circle clicked!", 20, 20);
  } 
  }
}


void highlightBar(){ //hgihlights bar when hovered over
  if (mouseX >= x && mouseX < x+barwidth){
         fill(20, 200, 200);
         if (mousePressed && mouseY > height/2){
            stage = "stats";
         }
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
  textAlign(TOP, CENTER);
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
  textAlign(CENTER);
  textSize(24);
  text("USA Gross Regional Product PER CAPITA by State 1964-2019", width/2, 150);
  text(clickedState, width/2, 180);
  textSize(12);
  text("Press 'b' to go back", width/2, 210);
  text("Click on a bar to see more info", width/2, 230);
  stroke(0); 
}

void animationSetup(){
  fill(0);
  textSize(20);
      textAlign(CENTER);
      text("USA Gross Regional Product by State from 1964-2019", width/2, 30);
      textSize(12);
      text("Press 'b' to go back", width/2, 50);
      text("Press 'p' to pause/play", width/2, 65);
      textAlign(LEFT);
      textSize(15);
      text("% of GRP from Services", 20, height/5-20);
      text("GRP Per Capita", 900, height-55);
      text("80%", 8, height/5);
      text("20%", 8, height-40);
      text("50%", 8, 2*(height - height/5 - 40)/4 + height/5);
      text("65%", 8, (height - height/5 - 40)/4 + height/5);
      text("35%", 8, 3*(height - height/5 - 40)/4 + height/5);
      //x-axis
      textAlign(CENTER);
      text("$100,000", 880, height-20);
      text("$0", 40, height-20);
      text("$25,000", 220, height-20);
      text("$50,000", 440, height-20);
      text("$75,000", 660, height-20);
      //vert lines
      
      
      strokeWeight(5);
      stroke(0);
      line(40, height/5, 40, height-40);
      line(40, height-40, width-70, height-40);
      strokeWeight(2);
      stroke(0, 90);
      line(880, height-40, 880, height/5);
      line(660, height-40, 660, height/5);
      line(440, height-40, 440, height/5);
      line(220, height-40, 220, height/5);
      
      line(40, height/5, width-70, height/5);
      line(40, (height - height/5 - 40)/4 + height/5, width-70, (height - height/5 - 40)/4 + height/5);
      line(40, 2*(height - height/5 - 40)/4 + height/5, width-70, 2*(height - height/5 - 40)/4 + height/5);
      line(40, 3*(height - height/5 - 40)/4 + height/5, width-70, 3*(height - height/5 - 40)/4 + height/5);
}

void animate(){
     for (TableRow row : table.rows()) {
       String country = row.getString("country");
       if (country.equals("USA")){
         int year = row.getInt("year");
         if (year == currentIndex){
           grp = row.getFloat("grp_pc_usd");
           ag = row.getFloat("ag_grp_pc_usd");
           man =  row.getFloat("man_grp_pc_usd");
           services =  row.getFloat("serv_grp_pc_usd");
           float pop = row.getFloat("pop");
           String state = row.getString("region");
           mapped_grp = map(grp, 0, 100000, 1, 70);
           //float xAxis = map(pop, 0, 40000000, 0, 800);
           //float xAxis = map(man/grp, 0, 1, 0, 800);
           float xAxis = map(grp, 0, 90000, 0, 800);
           float yAxis = map(services/grp, 0.2, 0.8, 0, 400);
           fill(30, 200, 200, 100);
           circleX = xAxis + 40;
           circleY = height-40-yAxis;
           ellipse(xAxis + 40, height-40-yAxis, mapped_grp, mapped_grp);
           
           textAlign(CENTER, CENTER);
           textSize(12);
           fill(0);
           text(getStateIndex(state), xAxis + 40, height-40-yAxis);
         }
       }
     }
   
}

void animatedYears(){
  textAlign(CENTER, CENTER);
      textSize(152);
      fill(0, 100);
      text(currentIndex, width/2, height/4 + 25);
    
      // Check if it's time to move on to the next entry
      if (millis() - lastDisplayTime > displayDuration) {
        currentIndex++;
        lastDisplayTime = millis();
    
        // Reset the index when all entries are displayed
        if (currentIndex >= 2020) {
          currentIndex = 1964;
        }
      }
}

String getStateIndex(String targetState) {
  for (int i = 0; i < usStates.length; i++) {
    if (usStatesLong[i].equals(targetState)) {
      return usStates[i]; // Return the index when the target state is found
    }
  }
  return "D.C.";
}

boolean isMouseInsideCircle(float circleX, float circleY, float circleRadius) {
  // Calculate the distance between the mouse position and the center of the circle
  float distance = dist(mouseX, mouseY, circleX, circleY);
  
  // Check if the distance is less than the radius of the circle
  return distance < circleRadius;
}

void pullStatsPage() {
  color startColor = color(1, 75, 103); 
  color endColor = color(79, 1, 103); 
  drawGradientBackground(startColor, endColor);
  fill(255);
  textSize(20);
  textAlign(CENTER);
  text("Press x to return to the graph", width/2, 50);
  textSize(40);
  text("Economic Breakdown of " + clickedState + " in " + yearTracker, width/2, 100);

  float tableX = width / 2 - 300; 
  float tableY = 200;
  float cellWidth = 200; 
  float cellHeight = 40; 
  float lineHeight = tableY + cellHeight;
  textSize(18);
  text("Category", tableX + cellWidth / 2, tableY);
  text("Nominal Value", tableX + 3 * cellWidth / 2, tableY);
  text("2015 Inflation Adjusted Values", tableX + 5 * cellWidth / 2, tableY);
  textSize(14);
  for (TableRow row : table.rows()) {
    String country = row.getString("country");
    if (country.equals("USA")) {
      String region = row.getString("region");
      if (region.equals(clickedState)) {
        int year = row.getInt("year");
        if (year == yearTracker) {
          float s_grp = row.getFloat("grp_pc_usd");
          float s_ag = row.getFloat("ag_grp_pc_usd");
          float s_man = row.getFloat("man_grp_pc_usd");
          float s_services = row.getFloat("serv_grp_pc_usd");
          float i_grp = row.getFloat("grp_pc_usd_2015");
          float i_ag = row.getFloat("ag_grp_pc_usd_2015");
          float i_man = row.getFloat("man_grp_pc_usd_2015");
          float i_services = row.getFloat("serv_grp_pc_usd_2015");

          // Displaying data in a table
          text("Total GRP", tableX + cellWidth / 2, lineHeight);
          text(nf(s_grp, 0, 2), tableX + 3 * cellWidth / 2, lineHeight);
          text(nf(i_grp, 0, 2), tableX + 5 * cellWidth / 2, lineHeight);

          lineHeight += cellHeight;

          text("GRP From Agriculture", tableX + cellWidth / 2, lineHeight);
          text(nf(s_ag, 0, 2), tableX + 3 * cellWidth / 2, lineHeight);
          text(nf(i_ag, 0, 2), tableX + 5 * cellWidth / 2, lineHeight);

          lineHeight += cellHeight;

          text("GRP From Manufacturing", tableX + cellWidth / 2, lineHeight);
          text(nf(s_man, 0, 2), tableX + 3 * cellWidth / 2, lineHeight);
          text(nf(i_man, 0, 2), tableX + 5 * cellWidth / 2, lineHeight);

          lineHeight += cellHeight;

          text("GRP From Services", tableX + cellWidth / 2, lineHeight);
          text(nf(s_services, 0, 2), tableX + 3 * cellWidth / 2, lineHeight);
          text(nf(i_services, 0, 2), tableX + 5 * cellWidth / 2, lineHeight);
        }
      }
    }
  }
}

void drawGradientBackground(color c1, color c2) {
  for (int i = 0; i < height; i++) {
    // Calculate the interpolation factor based on the vertical position
    float inter = map(i, 0, height, 0, 1);

    // Blend the two colors
    color c = lerpColor(c1, c2, inter);

    // Set the color and draw a horizontal line
    stroke(c);
    line(0, i, width, i);
  }
}

//options: have a "adjusted for inflation" option on animation
//click on a bar and reveal more info
