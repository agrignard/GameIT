Drawer drawer;
public int nbProjector=1;
public int displayWidth = int(1920)*nbProjector;
public int displayHeight = int(1080)*nbProjector;

public int playGroundWidth = displayWidth;
public int playGroundHeight = displayHeight;
String city="Hanghzhou";
PImage bg;
JSONObject JSONBounds;
RoadNetwork roads;
Buildings buildings;
ABM model;
Grid grid;
Heatmap heatmap;
LegoGrid legoGrid;
LegoGrid interactiveGrid;
InterFace interfaceLeap;
SliderHandler sliderHandler;

void setup() {
  //fullScreen(P3D, 2);
  width=displayWidth;
  height=displayHeight;
  size(displayWidth, displayHeight, P3D);
  drawer = new Drawer(this);
  bg = loadImage("data/GIS/"+city+"/background.png");
  drawer.initSurface();
  JSONBounds = loadJSONObject("GIS/"+city+"/Bounds.geojson");
  roads = new RoadNetwork("GIS/"+city+"/Roads.geojson");
  buildings = new Buildings("GIS/"+city+"/Buildings.geojson");
  model = new ABM(0,roads, "people", 100);
  model.initModel();
  grid = new Grid();
  heatmap = new Heatmap();
  legoGrid = new LegoGrid(loadStrings("data/Grid/legoGridUnit.asc"),"regular");
  interactiveGrid = new LegoGrid(loadStrings("data/Grid/InteractiveGrid.asc"),"interactive");
  interfaceLeap = new InterFace();
  sliderHandler = new SliderHandler();
} 

void draw() {
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
  case 'j':  
    drawer.toggleMobilityHeatmap();
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
  case 'm':  
    model.initModel();
    break;
  case 'u':  
    drawer.toggleUsage();
    break;
  case 'z':  
    drawer.toggleLegend();
    break;
  case 'q':  
    drawer.toggleInteractiveGrid();
    break;
  case 'w':  
    drawer.toggleLegoGrid();
    break;
  }
}
