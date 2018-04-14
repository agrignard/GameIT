Drawer drawer;

public int displayWidth = 1920;
public int displayHeight = 1080;

public int playGroundWidth = displayWidth;
public int playGroundHeight = displayHeight;
PImage bg;
RoadNetwork roads;
ABM model;

void setup(){
  //fullScreen(P3D, SPAN);
  size(displayWidth, displayHeight, P3D);
  drawer = new Drawer(this);
  bg = loadImage("data/Table_Video_Frame_Template_4k.jpg");
  drawer.initSurface();
  roads = new RoadNetwork("GIS/RoadNetwork/LLL_Roads.geojson");
  model = new ABM(roads);
  model.initModel();
} 

void draw(){
  drawScene();
}

/* Draw ------------------------------------------------------ */
void drawScene() {
  background(0);
  drawer.drawSurface();
}


void keyPressed() {
  switch(key) {
    //Keystone trigger  
  case 'k':
    drawer.ks.toggleCalibration();
    break;  
  case 'l':
    drawer.ks.load();
    break; 
  case 's':
    drawer.ks.save();
    break;
  }
}