Drawer drawer;
public int nbProjector=1;
public int displayWidth = int(1920)*nbProjector;
public int displayHeight = int(1080)*nbProjector;

public int playGroundWidth = displayWidth;
public int playGroundHeight = displayHeight;
PImage bg;
RoadNetwork roads;
RoadNetwork rivers;
Buildings buildings;
ArrayList<ABM> models;
Grid grid;
InterFace interfaceLeap;
SliderHandler sliderHandler;

void setup() {
  //fullScreen(P3D, SPAN);
  width=displayWidth;
  height=displayHeight;
  //smooth(3);
  size(displayWidth, displayHeight, P3D);
  drawer = new Drawer(this);
  bg = loadImage("data/Table_Video_Frame_Template_4k.jpg");
  drawer.initSurface();

  roads = new RoadNetwork("GIS/RoadNetwork/LLL_Roads.geojson");
  rivers = new RoadNetwork("GIS/RoadNetwork/LLL_Rivers.geojson");
  buildings = new Buildings("GIS/Buildings.geojson");
  models = new ArrayList<ABM>();
  models.add(new ABM(roads, "people", 100));
  models.get(0).initModel();
  //models.add(new ABM(rivers, "people", 100));
  //models.get(1).initModel();
  grid = new Grid();
  interfaceLeap = new InterFace();
  sliderHandler = new SliderHandler();
} 

void draw() {
  drawScene();
}

/* Draw ------------------------------------------------------ */
void drawScene() {
  if (!drawer.timelapse) {
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
    drawer.ks.save();
    break;
  case 'a':   
    drawer.toggleAgent();
    break;
  case 'b':  
    drawer.toggleBuilding();
    break;
  case 'g':  
    drawer.toggleInteraction();
    break;
  case 'h':  
    drawer.toggleHeatmap();
    break;
  case ' ':  
    drawer.toggleBG();
    break; 
  case 'f': 
    drawer.toggleLeap();
    break;
  case 'r':  
    drawer.toggleRoad();
    break;
  case 't':  
    drawer.toggleTimelapse();
  case 'm':  
    models.get(0).initModel();
    //models.get(1).initModel();
    break;
  case 'u':  
    drawer.toggleUsage();
    break;
  }
}