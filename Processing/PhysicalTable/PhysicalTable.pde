Drawer drawer;
public int nbProjector=1;
public int displayWidth = int(1920)*nbProjector;
public int displayHeight = int(1080)*nbProjector;

public int playGroundWidth = displayWidth;
public int playGroundHeight = displayHeight;
PImage bg;
RoadNetwork roads;
Buildings buildings;
ABM model;
Grid grid;
InterFace interfaceLeap;


  
void setup(){
  //fullScreen(P3D);
  width=displayWidth;
  height=displayHeight;
  size(displayWidth, displayHeight, P3D);
  drawer = new Drawer(this);
  bg = loadImage("data/Table_Video_Frame_Template_4k.jpg");
  drawer.initSurface();
  roads = new RoadNetwork("GIS/RoadNetwork/LLL_rivers.geojson");
  //roads = new RoadNetwork("GIS/RoadNetwork/LLL_Roads.geojson");
  buildings = new Buildings("GIS/Buildings.geojson");
  model = new ABM(roads);
  model.initModel();
  grid = new Grid();
  interfaceLeap = new InterFace();
} 

void draw(){
  drawScene();
}

/* Draw ------------------------------------------------------ */
void drawScene() {
  if(!drawer.timelapse){
    background(0);
  }
  drawer.drawSurface();
}


void keyPressed() {
  switch(key) {
    //Keystone trigger  
  case 'k':
    drawer.toggleKeystone();
    break;  
  case 'l':
    drawer.ks.load();
    break; 
  case 's':
    if (drawer.keystoneMode){
      drawer.ks.save();
    }
     else{
       drawer.toggleSlider();
     }
    break;
  case 'a':   
    drawer.toggleAgent();
    break;
  case 'b':  
    drawer.toggleBuilding();
    break;
  case 'g':  
    drawer.toggleGrid();
    break;
  case ' ':  
    drawer.toggleBG();
    break; 
  case 'i': 
    drawer.toggleInteraction();
    break;
  case 'r':  
    drawer.toggleRoad();
    break;
  case 't':  
    drawer.toggleTimelapse();
    break;
  }
}