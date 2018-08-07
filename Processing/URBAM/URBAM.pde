Drawer drawer;
public int nbProjector=1;
public float sizeScale= 1.0;
public int displayWidth = int(1920*sizeScale)*nbProjector;
public int displayHeight = int(1080*sizeScale)*nbProjector;

public int playGroundWidth = displayWidth;
public int playGroundHeight = displayHeight;
String city="Hanghzhou";
PImage bg;
JSONObject JSONBounds;
RoadNetwork roads;
Buildings buildings;
ABM model;
Grid grid;
ContinousHeatmap aggregatedHeatmap;
ContinousHeatmap aggregatedHeatmap2;
StaticGrid legoGrid;
SliderHandler sliderHandler;
ControlFrame cf;
InteractiveTagTable tags;
UDPReceiver udpR;
int currentView=-1;
boolean iterativeMode=false;
int nbView=7;
boolean ABM=true;
boolean updateDynamicPop=false;
boolean updateInteractivePop=true;
boolean initiateGrid = false;

//INTERFACE VARIABLES
boolean messageDelta = false;
boolean mouseClicked = false;
char tagViz = 'E';
boolean started = false;
boolean tagsInteraction=false;

///////////VIDEO Stuff////////////
import codeanticode.syphon.*;
SyphonServer server;
/////////////////////////////////
void settings() {
  //size(displayWidth, displayHeight, P3D);
  fullScreen(P3D, 0);
}

void setup() {
  frameRate(30);
  width=displayWidth;
  height=displayHeight;
  drawer = new Drawer(this);
  bg = loadImage("data/GIS/"+city+"/Table_Video_Frame_Template_4k_BG_No building.png");
  drawer.initSurface();
  JSONBounds = loadJSONObject("GIS/"+city+"/Bounds.geojson");
  roads = new RoadNetwork("GIS/"+city+"/LLL_Roads.geojson");
  buildings = new Buildings("GIS/"+city+"/LLL_Buildings.geojson");
  aggregatedHeatmap = new ContinousHeatmap(0, 0, width, height);
  aggregatedHeatmap.setBrush("HeatMap/heatmapBrush.png", 80);
  aggregatedHeatmap.addGradient("hot", "HeatMap/cold_transp.png");
  aggregatedHeatmap2 = new ContinousHeatmap(0, 0, width, height);
  aggregatedHeatmap2.setBrush("HeatMap/heatmapBrush.png", 80);
  aggregatedHeatmap2.addGradient("cold", "HeatMap/hot_transp.png");
  model = new ABM(roads);
  model.initModel();
  grid = new Grid();
  legoGrid = new StaticGrid(loadStrings("data/Grid/LegoGrid_Block_LLL_5x5.asc"));
  sliderHandler = new SliderHandler();
  tags = new InteractiveTagTable();
  udpR = new UDPReceiver();
  udpR.oldMessage = udpR.messageIn ;
  //cf = new ControlFrame(this,400,400,"box");
  tags.setupInteractiveTagTable();
  ///////////CREATE MASKING FOR MISSING GRID PIECES/////////////
  udpR.maskParts = udpR.messageMask.split(" ");
  //////////////////////////////////////////////////////////////
  updateCurrentState(-1);
  
  //syphon
  server = new SyphonServer(this, "grid");
} 

void draw() {
  drawScene();
}

/* Draw ------------------------------------------------------ */
void drawScene() {
  //background(#C7D2E0);
  background(0);
  drawer.drawSurface();
  //syphon
  server.sendScreen();

}

void keyTyped() {
  if(tagsInteraction){
    delay(50);
  if (key == 'd') {
    //test message delta
    udpR.messageIn = 
      "i 138 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 138 -1 -1 -1 -1 460 43 63 43 645 -2 -2 -2 -2 -2 -2 -2 -2 -2 "+
      "-2 -2 -2 -2 138 -2 -2 -2 -2 -1 0 126 9 19 -1 -1 -1 138 43 63 43 0 63 0 43 460 126 43 138 0 138 -2 "+
      "-2 -2 -2 -1 63 126 0 0 126 19 126 9 0 126 43 -1 -1 138 63 63 19 19 19 43 63 63 63 0 296 63 -1 -2 "+
      "-2 -2 -1 -1 -1 -1 -1 -1 9 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -2 "+
      "-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 138 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 19 "+
      "9 126 19 -1 0 63 0 -1 19 43 126 126 645 306 176 400 -1 138 0 63 126 19 63 126 0 0 0 138 -1 138 126 126 "+
      "9 0 63 988 0 19 0 19 126 715 563 126 0 0 682 43 -1 138 469 375 0 126 63 0 988 63 0 0 43 306 0 43 "+
      "0 126 0 996 43 126 126 0 9 682 63 9 606 43 126 460 138 138 0 0 126 126 0 0 306 0 43 126 0 0 43 -1 "+
      "645 138 0 43 63 799 9 126 176 0 63 563 19 126 126 19 375 138 176 715 126 43 126 -1 0 400 126 43 0 43 0 -1 "+
      "-1 -1 138 9 138 126 375 43 138 488 488 126 126 375 19 126 9 138 43 988 715 0 0 563 138 296 63 126 0 0 996 -1 "+
      "-1 -1 -1 0 138 0 0 138 138 43 43 126 400 296 43 126 126 176 126 126 0 0 126 63 0 0 63 0 0 19 488 -1 "+
      "-1 -1 -1 -1 126 -1 -1 -1 -1 43 43 126 0 0 606 296 138 682 19 296 996 375 63 873 460 0 0 43 827 606 606 -1 "+
      "-1 -1 -1 -1 -1 -1 -1 138 -1 -1 -1 -1 -1 715 873 43 9 138 63 400 682 799 827 -1 -1 -1 -1 -1 -1 138 -1 43 "+
      "63 63 63 63 63 19 63 138 63 43 43 0 9 9 -1 -1 138 126 43 0 43 43 63 19 0 0 -1 -1 -1 -1 -1 43 "+
      "799 19 19 63 19 19 19 138 375 9 0 0 43 43 -1 -1 126 138 19 19 19 63 63 19 63 19 19 19 63 63 0 96 "+
      "0 63 0 126 460 9 9 138 43 126 9 126 43 126 -1 -1 19 138 63 63 63 0 138 63 63 0 0 63 63 43 43 63 "+
      "63 126 9 0 0 400 19 138 43 43 126 0 126 138 -1 138 0 138 63 0 0 0 63 63 0 0 0 0 19 43 0 9 "+
      "126 0 63 799 19 715 63 43 43 43 9 138 0 43 -1 -1 0 19 138 0 138 19 0 0 19 19 19 19 138 43 0 138 "+
      "63 126 63 0 19 0 19 138 0 996 138 43 9 43 -1 -1 43 19 138 0 0 0 0 0 0 0 19 0 0 0 0 138 "+
      "138 63 138 19 19 0 63 138 126 606 63 43 0 43 -1 -1 469 0 0 138 138 0 0 0 0 0 0 0 400 0 873 63 "+
      "63 9 43 43 0 138 63 138 126 19 19 138 0 43 -1 -1 43 43 -1 -1 138 0 0 0 0 0 0 0 0 0 176 9 "+
      "19 0 63 63 0 460 63 138 126 0 9 138 43 0 -1 -1 19 9 -1 -1 63 138 138 0 0 0 0 0 0 0 469 9 "+
      "9 63 19 0 873 138 63 306 -1 -1 -1 -1 43 0 -1 -1 19 0 19 63 63 63 43 138 138 0 0 0 0 63 0 0 "+
      "126 9 63 126 126 63 -1 -1 -1 -1 -1 138 -1 0 -1 -1 19 9 19 19 19 19 19 19 126 138 138 138 126 -1 -1 0 "+
      "306 0 138 -1 -1 -1 -1 -1 -1 -1 -1 138 -1 9 -1 -1 63 0 19 19 19 19 19 19 126 126 -1 138 138 -1 -1 19 "+
      "0 0 63 -1 -1 -1 -1 138 -1 0 -1 138 0 63 -1 -1 63 63 375 19 19 19 19 19 -1 -1 -1 -1 138 138 -1";
    println("Test Message Delta");
  }

  if (key == 'f') {
    //test message delta
    udpR.messageIn = 
      "i -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 138 -1 -1 -1 -1 460 43 63 43 645 -2 -2 -2 -2 -2 -2 -2 -2 -2 "+
      "-2 -2 -2 -2 138 -2 -2 -2 -2 -1 0 126 9 19 -1 -1 -1 138 43 63 43 0 63 0 43 460 126 43 138 0 138 -2 "+
      "-2 -2 -2 -1 63 126 0 0 126 19 126 9 0 126 43 -1 -1 138 63 63 19 19 19 43 63 63 63 0 296 63 -1 -2 "+
      "-2 -2 -1 -1 -1 -1 -1 -1 9 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -2 "+
      "-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 19 "+
      "9 126 19 -1 0 63 0 -1 19 43 126 126 645 306 176 400 -1 0 0 63 126 19 63 126 0 0 0 138 -1 138 126 126 "+
      "9 0 63 988 0 19 0 19 126 715 563 126 0 0 682 43 -1 0 469 375 0 126 63 0 988 63 0 0 43 306 0 43 "+
      "0 126 0 996 43 126 126 0 9 682 63 9 606 43 126 460 0 0 0 0 126 126 0 0 306 0 43 126 0 0 43 -1 "+
      "645 138 0 43 63 799 9 126 176 0 63 563 19 126 126 19 375 0 176 715 126 43 126 -1 0 400 126 43 0 43 0 -1 "+
      "-1 -1 138 9 138 126 375 43 138 488 488 126 126 375 19 126 9 0 43 988 715 0 0 563 138 296 63 126 0 0 996 -1 "+
      "-1 -1 -1 0 138 0 0 138 138 43 43 126 400 296 43 126 126 176 126 126 0 0 126 63 0 0 63 0 0 19 488 -1 "+
      "-1 -1 -1 -1 126 -1 -1 -1 -1 43 43 126 0 0 606 296 138 682 19 296 996 375 63 873 460 0 0 43 827 606 606 -1 "+
      "-1 -1 -1 -1 -1 -1 -1 138 -1 -1 -1 -1 -1 715 873 43 9 138 63 400 682 799 827 -1 -1 -1 -1 -1 -1 138 -1 43 "+
      "63 63 63 63 63 19 63 138 63 43 43 0 9 9 -1 -1 138 126 43 0 43 43 63 19 0 0 -1 -1 -1 -1 -1 43 "+
      "799 19 19 63 19 19 19 138 375 9 0 0 43 43 -1 -1 126 138 19 19 19 63 63 19 63 19 19 19 63 63 0 96 "+
      "0 63 0 126 460 9 9 138 43 126 9 126 43 126 -1 -1 19 138 63 63 63 0 138 63 63 0 0 63 63 43 43 63 "+
      "63 126 9 0 0 400 19 138 43 43 126 0 126 138 -1 138 0 138 63 0 0 0 63 63 0 0 0 0 19 43 0 9 "+
      "126 0 63 799 19 715 63 43 43 43 9 138 0 43 -1 -1 0 19 138 0 138 19 0 0 19 19 19 19 138 43 0 138 "+
      "63 126 63 0 19 0 19 138 0 996 138 43 9 43 -1 -1 43 19 138 0 0 0 0 0 0 0 19 0 0 0 0 138 "+
      "138 63 138 19 19 0 63 138 126 606 63 43 0 43 -1 -1 469 0 0 138 138 0 0 0 0 0 0 0 400 0 873 63 "+
      "63 9 43 43 0 138 63 138 126 19 19 138 0 43 -1 -1 43 43 -1 -1 138 0 0 0 0 0 0 0 0 0 176 9 "+
      "19 0 63 63 0 460 63 138 126 0 9 138 43 0 -1 -1 19 9 -1 -1 63 138 138 0 0 0 0 0 0 0 469 9 "+
      "9 63 19 0 873 138 63 306 -1 -1 -1 -1 43 0 -1 -1 19 0 19 63 63 63 43 138 138 0 0 0 0 63 0 0 "+
      "126 9 63 126 126 63 -1 -1 -1 -1 -1 138 -1 0 -1 -1 19 9 19 19 19 19 19 19 126 138 138 138 126 -1 -1 0 "+
      "306 0 138 -1 -1 -1 -1 -1 -1 -1 -1 138 -1 9 -1 -1 63 0 19 19 19 19 19 19 126 126 -1 138 138 -1 -1 19 "+
      "0 0 63 -1 -1 -1 -1 138 -1 0 -1 138 0 63 -1 -1 63 63 375 19 19 19 19 138 -1 -1 -1 -1 138 138 -1";
    println("Test Message Delta");
  }

  if (key == 'l') {
    int count = 0;
    for (int x = 0; x < tags.tagList.size(); x++) {     
      if (count>tags.wideCount-1) {
        print(tags.tagList.get(x).tagID);
        println(" \"+");
        print("\"");
        count = 0;
      } else {
        print(tags.tagList.get(x).tagID);
        print(" ");
      }

      count++;
    }
  }
  if (key == 'w'){
    tagsInteraction=!tagsInteraction;
  }
  }
  else{
  if(key == '0' || key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9'){
    updateCurrentState(key-48);
  }else{
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
    case 'w':
      tagsInteraction=!tagsInteraction;
      break;
    case ' ':  
      drawer.toggleLegend();
      break;
    case 'a':   
      drawer.toggleAgent();
      break;
    case 'z':   
      drawer.toggleAgentOnGrid();
      break;
    case 'b':  
      drawer.toggleBuilding();
      break;
    case 'n':  
      drawer.toggleRoad();
      break;
    case 'v':  
      drawer.toggleViewCube();
      break;
    case 'h':  
      tagViz = 'H';
      break;
    case 'm':  
      drawer.toggleBG();
      break; 
    case 'i':  
      drawer.toggleInteractiveGrid();
      break;
    case 'g':  
      drawer.toggleStaticGrid();
      break;
    case 'd':
      drawer.toggleInstantHeatMap();
      break;
    case 'e':
      tagViz = 'E';
      messageDelta = true;
      break;
    case 'p':
      tagViz = 'P';
      messageDelta = true;
      break;
    case 'o':
      tagViz = 'O';
      messageDelta = true;
      break;
    case 't':
      tagViz = 'T';
      break;
    case 'r':
      tagViz = 'R';
      messageDelta = true;
      break;
    case 'c':
      drawer.toggleCollisionPotential();
      break;
    case 'x':
      drawer.toggleMagicTrackpad();
      break;
    case 'q':
      drawer.toggleCongestedRoad();
      break;
    case 'j':
      drawer.toggleMoBike();
      break;
    case 'u':
      drawer.toggleUrbanLens();
      break;
}
  }
  }
}


void doubleClicked(MouseEvent evt){
  currentView=-1;
  iterativeMode=!iterativeMode;
}

void mouseClicked(MouseEvent evt) {
  if (evt.getCount() == 2) doubleClicked(evt);
  boolean editPark = false;
  if(editPark){
    println(mouseX + " "  + mouseY);
    float testDistance = 99999999; 
    mouseClicked = true;
    PVector tempMouseP = new PVector(mouseX-(tags.unit/2), mouseY-(tags.unit/2), 0);
    float proximityThreshold = 180 * tags.scaleWorld; //This is the proximity threshold of the neighbouring tags that will be impacted by this change in animation/
  
    int trackloop = 0;
    int indexFound = 0;
    int neighbours = 0;
  
    for (LLLTag tag : tags.tagList) {
  
      float distance = tempMouseP.dist(tag.point);
  
      if ( distance<testDistance) {
        testDistance = tempMouseP.dist(tag.point);
        indexFound = trackloop;
        // println(tempMouseP.dist(tag.point));
      };
  
      if ( distance<proximityThreshold) {
        neighbours++;
        tag.animateWave((1.0f- distance/proximityThreshold ));//feed distance ratio to animation wave
      };
      trackloop++;
    }
    print("Neighbours found: ");
    println(neighbours);
    tags.tagList.get(indexFound).tagID = 138;
  }else{
    if(iterativeMode){
    if (mouseButton == LEFT) {
      currentView  = (currentView + 1) % nbView;
      updateCurrentState(currentView);
    } else if (mouseButton == RIGHT) {
      currentView  = (currentView - 1) % nbView;
      if(currentView < 0){
        currentView=nbView-1;
      }
      updateCurrentState(currentView);
      
  }
  }else{
    updateCurrentState(-1);
  }  
  }
}

void mouseMoved() {
  if(drawer.showUrbanLens){
    String s = "TMT,"+(displayWidth-mouseX)+","+(displayHeight-mouseY)+","+displayWidth+","+displayHeight+",0,0,0,0,";
    //println("sending " + s + "to " + "127.0.0.1" + " port:" + 11969);
    // UDP Local 
      udpR.udp.send(s,"127.0.0.1",11969);
    //UDP Router
    //udpR.udp.send(s,"192.168.0.189",17999);
  }
}

void updateCurrentState(int slideID){
  switch(slideID) {
    case -1:
      drawer.showAgent=true;
      drawer.showAgentOnGrid=true;
      drawer.showBG=true;
      drawer.showStaticGrid=false;
      drawer.showInteractiveGrid=true;
      drawer.showBuilding=false;
      drawer.showCollisionPotential=false;
      drawer.showContinousHeatMap=false;
      drawer.showRoad=false;
      drawer.showMoBike=false;
      tagViz = 'T';
      break;
    case 0:
      drawer.showAgent=false;
      drawer.showAgentOnGrid=true;
      drawer.showBG=false;
      drawer.showStaticGrid=true;
      drawer.showInteractiveGrid=true;
      drawer.showBuilding=false;
      drawer.showCollisionPotential=false;
      drawer.showContinousHeatMap=false;
      drawer.showRoad=false;
      drawer.showMoBike=false;
      tagViz = 'T';
      break;
    case 1:
      drawer.showAgent=false;
      drawer.showAgentOnGrid=false;
      drawer.showBG=false;
      drawer.showStaticGrid=true;
      drawer.showInteractiveGrid=true;
      drawer.showBuilding=false;
      drawer.showCollisionPotential=false;
      drawer.showContinousHeatMap=false;
      drawer.showRoad=false;
      drawer.showMoBike=false;
      tagViz = 'O';
      break;
    case 2:
      drawer.showAgent=false;
      drawer.showAgentOnGrid=false;
      drawer.showBG=false;
      drawer.showStaticGrid=true;
      drawer.showInteractiveGrid=true;
      drawer.showBuilding=false;
      drawer.showCollisionPotential=false;
      drawer.showContinousHeatMap=false;
      drawer.showRoad=false;
      drawer.showMoBike=false;
      tagViz = 'R';
      break;
    case 3:
      drawer.showAgent=false;
      drawer.showAgentOnGrid=false;
      drawer.showBG=false;
      drawer.showStaticGrid=true;
      drawer.showInteractiveGrid=true;
      drawer.showBuilding=false;
      drawer.showCollisionPotential=false;
      drawer.showContinousHeatMap=false;
      drawer.showRoad=false;
      drawer.showMoBike=false;
      tagViz = 'P';
      break;
    case 4:
      drawer.showAgent=true;
      drawer.showAgentOnGrid=true;
      drawer.showBG=false;
      drawer.showStaticGrid=true;
      drawer.showInteractiveGrid=false;
      drawer.showBuilding=false;
      drawer.showCollisionPotential=false;
      drawer.showContinousHeatMap=false;
      drawer.showRoad=false;
      drawer.showMoBike=false;
      tagViz = 'H';
      break;
    case 5:
      drawer.showAgent=true;
      drawer.showAgentOnGrid=true;
      drawer.showBG=false;
      drawer.showStaticGrid=false;
      drawer.showInteractiveGrid=true;
      drawer.showBuilding=false;
      drawer.showCollisionPotential=false;
      drawer.showContinousHeatMap=false;
      drawer.showRoad=false;
      drawer.showMoBike=true;
      break;
    case 6:
      drawer.showAgent=true;
      drawer.showAgentOnGrid=true;
      drawer.showBG=false;
      drawer.showStaticGrid=false;
      drawer.showInteractiveGrid=true;
      drawer.showBuilding=false;
      drawer.showCollisionPotential=true;
      drawer.showContinousHeatMap=true;
      drawer.showRoad=false;
      drawer.showMoBike=false;
      break;
    }
}
