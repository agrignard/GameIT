import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Map; 
import java.util.Iterator; 
import deadpixel.keystone.*; 
import hypermedia.net.*; 
import ai.pathfinder.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class UrbanABM extends PApplet {

Drawer drawer;
public int nbProjector=3;
public int displayWidth = PApplet.parseInt(1920)*nbProjector;
public int displayHeight = PApplet.parseInt(1080)*nbProjector;

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

public void setup() {
  
  width=displayWidth;
  height=displayHeight;
  //smooth(3);
  //size(displayWidth, displayHeight, P3D);
  drawer = new Drawer(this);
  bg = loadImage("data/Table_Video_Frame_Template_4k.jpg");
  drawer.initSurface();

  roads = new RoadNetwork("GIS/RoadNetwork/LLL_Roads.geojson");
  rivers = new RoadNetwork("GIS/RoadNetwork/LLL_Rivers.geojson");
  buildings = new Buildings("GIS/Buildings.geojson");
  models = new ArrayList<ABM>();
  models.add(new ABM(roads, "car", 10));
  models.get(0).initModel();
  models.add(new ABM(rivers, "people", 100));
  models.get(1).initModel();
  grid = new Grid();
  interfaceLeap = new InterFace();
  sliderHandler = new SliderHandler();
} 

public void draw() {
  drawScene();
}

/* Draw ------------------------------------------------------ */
public void drawScene() {
  if (!drawer.timelapse) {
    background(0);
  }
  drawer.drawSurface();
}


public void keyPressed() {
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
  case 'i':  
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
    models.get(1).initModel();
    break;
  case 'u':  
    drawer.toggleUsage();
    break;
  }
}



/* ABM CLASS ------------------------------------------------------------*/
public class ABM {
  private RoadNetwork map;
  private String type;
  private ArrayList<Agent> agents;
  private ArrayList<String> profiles;
  private ArrayList<Integer> colors;
  HashMap<String, Integer> colorProfiles; 
  int nbPeoplePerProfile;
  ABM(RoadNetwork _map, String _type, int _nbPeoplePerProfile) {
    map=_map;
    type=_type;
    nbPeoplePerProfile= _nbPeoplePerProfile;
    agents = new ArrayList<Agent>();
    profiles = new ArrayList<String>();
    colors = new ArrayList<Integer>();
    colors.add(0xffFFFFB2);
    colors.add(0xffFFFFB2);
    colors.add(0xff0B5038);
    colors.add(0xff8CAB13);
    colors.add(0xffFFFFFF);
    colors.add(0xffFECC5C);
    colors.add(0xffFD8D3C);
    colors.add(0xffF03B20);
    colors.add(0xffBD0026);
    colors.add(0xffFF0000);
    profiles.add("Young Children");
    profiles.add("High School");
    profiles.add("Home maker");
    profiles.add("Retirees");
    profiles.add("Artist");
    profiles.add("College"); 
    profiles.add("Young professional");
    profiles.add("Mid-career workers");
    profiles.add("Executives"); 
    profiles.add("Workforce");
    colorProfiles = new HashMap<String, Integer>();
    colorProfiles.put(profiles.get(0), colors.get(0));
    colorProfiles.put(profiles.get(1), colors.get(1));
    colorProfiles.put(profiles.get(2), colors.get(2));
    colorProfiles.put(profiles.get(3), colors.get(3));
    colorProfiles.put(profiles.get(4), colors.get(4));
    colorProfiles.put(profiles.get(5), colors.get(5));
    colorProfiles.put(profiles.get(6), colors.get(6));
    colorProfiles.put(profiles.get(7), colors.get(7));
    colorProfiles.put(profiles.get(8), colors.get(8));
    colorProfiles.put(profiles.get(9), colors.get(9));
  }

  public void initModel() {
    agents.clear();
    createAgents(nbPeoplePerProfile,type);
  }

  public void updatePop() { 
    if (frameCount % 30 == 0) {
      if(sliderHandler.globalSliders.get(0)>sliderHandler.tmpSliders.get(0)){
        addNAgentsPerUsage((int)((sliderHandler.globalSliders.get(0) - sliderHandler.tmpSliders.get(0))*100.0f)*500/100, "living");
        sliderHandler.tmpSliders.set(0,sliderHandler.globalSliders.get(0));
      }
      if(sliderHandler.globalSliders.get(0)<sliderHandler.tmpSliders.get(0)){
        removeNAgentsPerUsage(PApplet.parseInt((sliderHandler.tmpSliders.get(0) - sliderHandler.globalSliders.get(0))*100.0f)*500/100, "living");
        sliderHandler.tmpSliders.set(0,sliderHandler.globalSliders.get(0));
      }
      if(sliderHandler.globalSliders.get(1)>sliderHandler.tmpSliders.get(1)){
        addNAgentsPerUsage(PApplet.parseInt((sliderHandler.globalSliders.get(1) - sliderHandler.tmpSliders.get(1))*100.0f)*500/100, "working");
        sliderHandler.tmpSliders.set(1,sliderHandler.globalSliders.get(1));
      }
      if(sliderHandler.globalSliders.get(1)<sliderHandler.tmpSliders.get(1)){
        removeNAgentsPerUsage(PApplet.parseInt((sliderHandler.tmpSliders.get(1) - sliderHandler.globalSliders.get(1))*100.0f)*500/100, "living");
        sliderHandler.tmpSliders.set(1,sliderHandler.globalSliders.get(1));
      }
    }
  }

  public void run(PGraphics p) {
      for (int i=0;i<agents.size();i++) {
           agents.get(i).move();
           agents.get(i).draw(p);
           updatePop();
      }
  }

  public void addNAgentsPerUsage(int num, String usage) {
    for (int i = 0; i < num; i++) {
      if (usage.equals("living")) {
        agents.add( new Agent(map, profiles.get(PApplet.parseInt(random(4))), "people", "living"));
      } else {
        agents.add( new Agent(map, profiles.get(5+PApplet.parseInt(random(4))), "people", "working"));
      }
    }
  }

  public void removeNAgentsPerUsage(int num, String usage) {
    Iterator<Agent> ag = agents.iterator();
    int i=0;
    while (ag.hasNext()) { 
      Agent tmpAg = ag.next();
      
      if (usage.equals(tmpAg.usage)) { 
        if (i<num) { 
          ag.remove();
          i++;
        }
      }
    }
  }  


  public void addNAgentPerProfiles(int num, String profile, String usage) {
    println("I want to add" + num + " agent of profile " + profile);
    for (int i = 0; i < num; i++) {
      agents.add( new Agent(map, profile, "people",usage));
    }
  }

  public void removeNAgentsPerProfiles(int n, String profile) {
    Iterator<Agent> ag = agents.iterator();
    while (ag.hasNext()) { 
      Agent tmpAg = ag.next();
      int i=0;
      if (profile.equals(tmpAg.profile)) { 
        if (i<n) { 
          ag.remove();
          i++;
        }
      }
    }
  }

  public void createAgents(int num,String type) {
    for (int i = 0; i < num; i++) {
      for (int j=0; j<profiles.size()/2; j++) {
        agents.add( new Agent(map, profiles.get(j), type, "living"));
      }
      for (int j=5; j<profiles.size(); j++) {
        agents.add( new Agent(map, profiles.get(j), type, "working"));
      }
    }
  }
}

public class Agent {
  private RoadNetwork map;
  private String profile;
  private String type;
  private String usage;
  private int myUsageColor;
  private int myProfileColor;
  private PVector pos;
  private float size;
  private float speed;
  private Node srcNode, destNode, toNode;
  private ArrayList<Node> path;
  private PVector dir;  
  //map<string,rgb> color_per_type <- [ "High School Student"::#FFFFB2, "College student"::#FECC5C,"Young professional"::#FD8D3C,  "Mid-career workers"::#F03B20, "Executives"::#BD0026, "Home maker"::#0B5038, "Retirees"::#8CAB13];


  Agent(RoadNetwork _map, String _profile, String _type, String _usage) {
    map=_map;
    type=_type;
    profile=_profile;
    usage=_usage;
    srcNode =  (Node) map.graph.nodes.get(PApplet.parseInt(random(map.graph.nodes.size())));
    destNode =  (Node) map.graph.nodes.get(PApplet.parseInt(random(map.graph.nodes.size())));
    pos= new PVector(srcNode.x, srcNode.y);
    path=null;
    dir = new PVector(0.0f, 0.0f);
    myProfileColor= (int)(models.get(0).colorProfiles.get(profile));
    myUsageColor = (usage.equals("working")) ? 0xff165E93 : 0xffF4A528;
    
    if(type.equals("car")){
      speed= 0.3f + random(0.5f);
      size= 5 + random(5);
    }
    if (type.equals("people")){
      speed= 0.05f + random(0.1f);
      size= 1 + random(5);
    }
    
  }


  public void draw(PGraphics p) {
    if (drawer.showAgent) {
      if(type.equals("people")){
        p.noStroke();
        if (drawer.showUsage) {
          p.fill(myUsageColor);
        } else {
          p.fill(myProfileColor);
        }
      p.ellipse(pos.x, pos.y, size, size);
      }
      if(type.equals("car")){
        p.stroke(myProfileColor);
        //p.strokeWeight(2);
        p.noFill();
        p.ellipse(pos.x, pos.y, size, size);
      }
    }
  }

  // CALCULATE ROUTE --->
  private boolean calcRoute(Node origin, Node dest) {
    // Agent already in destination --->
    if (origin == dest) {
      toNode=origin;
      return true;
      // Next node is available --->
    } else {
      ArrayList<Node> newPath = map.graph.aStar( origin, dest);
      if ( newPath != null ) {
        path = newPath;
        toNode = path.get( path.size()-2 );
        return true;
      }
    }
    return false;
  }

  public void move() {
    if (path == null) {
      calcRoute( srcNode, destNode );
    }
    PVector toNodePos= new PVector(toNode.x, toNode.y);
    PVector destNodePos= new PVector(destNode.x, destNode.y);
    dir = PVector.sub(toNodePos, pos);  // Direction to go
    // Arrived to node -->
    if ( dir.mag() < dir.normalize().mult(speed).mag() ) {
      // Arrived to destination  --->
      if ( path.indexOf(toNode) == 0 ) {  
        pos = destNodePos;
        // Not destination. Look for next node --->
      } else {  
        srcNode = toNode;
        toNode = path.get( path.indexOf(toNode)-1 );
      }
      // Not arrived to node --->
    } else {
      //distTraveled += dir.mag();
      pos.add( dir );
      //posDraw = PVector.add(pos, dir.normalize().mult(type.getStreetOffset()).rotate(HALF_PI));
    }
  }
}
public class Buildings{
  
  ArrayList<PShape> buildings;
  HashMap<String,Integer> hm = new HashMap<String,Integer>();
  
  Buildings (String GeoJSONfile){
    buildings = new ArrayList<PShape>();
    hm = new HashMap<String,Integer>();
    hm.put("Restaurant",0xff2B6A89);hm.put("Night",0xff1B2D36);hm.put("Restaurant",0xff2B6A89);hm.put("GP",0xff244251);hm.put( "Cultural",0xff2A7EA6);
    hm.put("Shopping",0xff1D223A);hm.put("HS",0xffFFFC2F);hm.put("Uni",0xff807F30);hm.put(  "O",0xff545425);
    hm.put("R",0xff222222);hm.put("Park",0xff24461F);
    JSONObject JSON = loadJSONObject(GeoJSONfile);
    JSONArray JSONpolygons = JSON.getJSONArray("features");
    
    for(int i=0; i<JSONpolygons.size(); i++) {
      JSONObject props = JSONpolygons.getJSONObject(i).getJSONObject("properties");
      String type = props.isNull("type") ? "null" : props.getString("type");
      String usage = props.isNull("Usage") ? "null" : props.getString("Usage");
      String scale = props.isNull("Scale") ? "null" : props.getString("Scale");
      String category = props.isNull("Category") ? "null" : props.getString("Category");
            
      JSONArray polygons = JSONpolygons.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
      for(int j=0; j<polygons.size(); j++) {
        JSONArray points= polygons.getJSONArray(j);
        PShape s = createShape();
        s.beginShape();
        s.fill(hm.get(category));
        s.noStroke();       
        for(int k=0; k<points.size(); k++) {
          PVector pos = roads.toXY(points.getJSONArray(k).getFloat(1),points.getJSONArray(k).getFloat(0));
          s.vertex(pos.x,pos.y);
        }
        s.endShape(CLOSE);
        buildings.add(s);
      }
    }
  }
  
  public void draw(PGraphics p){
    if (drawer.showBuilding){ 
      for (int i=0;i<buildings.size();i++){
        p.shape(buildings.get(i), 0, 0);
      }
    }
  }
  
  
}


public class Drawer{
  Keystone ks;
  CornerPinSurface[] surface = new CornerPinSurface[nbProjector];
  PGraphics offscreenSurface;
  PGraphics subSurface;
  //int nbProjector=1;
  
  public boolean showBG = true,
                 showAgent = true,
                 showBuilding = false,
                 showRoad=true,
                 useLeap=false,
                 timelapse=false,
                 showInteraction=false,
                 showSlider=false,
                 keystoneMode=false,
                 showUsage=false,
                 showHeatmap=false;
  
  
  Drawer(PApplet parent){
    ks = new Keystone(parent);
    offscreenSurface = createGraphics(playGroundWidth, playGroundHeight, P3D);
  }
  
  public void initSurface(){
    for (int i=0; i<nbProjector;i++){
      surface[i] = ks.createCornerPinSurface((int)playGroundWidth/nbProjector, (int)playGroundHeight, 50);
    }
    subSurface = createGraphics(playGroundWidth/nbProjector, playGroundHeight, P3D);
  }
  
  public void drawSurface(){
      offscreenSurface.beginDraw();
      if(!drawer.timelapse){
        offscreenSurface.clear();
        offscreenSurface.background(0);
      }
      
      drawTableBackGround(offscreenSurface);
      drawLegend(offscreenSurface);
      
      drawInteraction(offscreenSurface);
      roads.draw(offscreenSurface);
      buildings.draw(offscreenSurface);
      models.get(0).run(offscreenSurface);
      models.get(1).run(offscreenSurface);
      grid.draw(offscreenSurface);
      
      //slider.draw(offscreenSurface);
      offscreenSurface.endDraw();
      for (int i=0; i<nbProjector;i++){
        subSurface.beginDraw();
        subSurface.clear();
        subSurface.image(offscreenSurface, -(playGroundWidth/nbProjector)*i, 0);
        subSurface.endDraw();
        surface[i].render(subSurface);
      }
  }
  
  public void drawTableBackGround(PGraphics p) {
    //p.fill(125);  
    //p.rect(0, 0, displayWidth, displayHeight);
    if(showBG){
      p.image(bg,0,0,displayWidth,displayHeight);
    }
  }
  
  public void drawLegend(PGraphics p) {
    p.fill(0xffFFFFFF);
    p.textAlign(RIGHT); 
    p.textSize(10);
    p.text("FRAMERATE: " + PApplet.parseInt(frameRate) + " fps", width-30, 30);
    p.text(PApplet.parseInt(models.get(0).agents.size()) + " cars" , width-30, 50);
    p.text(PApplet.parseInt(models.get(1).agents.size()) + " peoples" , width-30, 70);
    p.textAlign(LEFT); 
    if(keystoneMode){
      p.text("Keystone: [L] load keystone - [S] save keystone  ", 30, 30);
    }else{
      p.text("[A] Agent - [B] Building - [R] Road - [U] Usage - [H] Heatmap - [T] Timelapse", 30, 30);
      p.text("[I] Interaction (Mouse) (and [F] Leap)) - [K] keystone", 30, 50);
    }
    p.textAlign(CENTER);
    p.textSize(10);
    p.text("UrbanABM InnovaCity - LLL & GAME IT - 2018 ", 0, height*0.99f);
    p.text(" \u00a9 Arnaud Grignard 2018 ", width*0.95f, height*0.99f);
 }
 
 
public void drawInteraction(PGraphics p){
  
}
 
  public void toggleKeystone() { 
    keystoneMode = !keystoneMode; 
    drawer.ks.toggleCalibration();
  } 
  public void toggleBG() { showBG = !showBG; }
  public void toggleAgent() { showAgent = !showAgent; }
  public void toggleBuilding() { showBuilding = !showBuilding;}
  public void toggleRoad() { showRoad = !showRoad;}
  public void toggleLeap() { useLeap = !useLeap;}
  public void toggleTimelapse() { timelapse = !timelapse;}
  public void toggleInteraction() { showInteraction = !showInteraction;}
  public void toggleSlider() { showSlider = !showSlider;}
  public void toggleUsage() { showUsage = !showUsage;}
  public void toggleHeatmap() { showHeatmap = !showHeatmap;}
  
  
  
  
}
public class Grid {
  int[][] cells;
  int cellSize = playGroundWidth/20;
  int[][] heatmapCells;
  int heatMapcellSize = playGroundWidth/50;
  
  Grid(){
    cells = new int[width/cellSize][height/cellSize];
    heatmapCells = new int[width/heatMapcellSize][height/heatMapcellSize];
      // Initialization of cells
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0;
      }
    }
  }
  
  public void draw(PGraphics p){
    
    if(drawer.showHeatmap){
        for (int x=0; x<width/heatMapcellSize; x++) {
          for (int y=0; y<height/heatMapcellSize; y++) {
            p.rectMode(CENTER);
            PVector ratio = getLinvingAndWorkingInsideROI(models.get(0),new PVector(x*heatMapcellSize,y*heatMapcellSize),heatMapcellSize);
            p.fill(ratio.x*20,ratio.y*20,0);
            p.noStroke();
            p.rect (x*heatMapcellSize,y*heatMapcellSize, heatMapcellSize, heatMapcellSize);            
          }
        }
    }
    if(drawer.showInteraction){
      p.fill(0,0,0,100);
      p.rect(width/2,height/2,width,height);
      p.noFill();      
      if(drawer.useLeap){
        for (int x=0; x<width/cellSize; x++) {
          for (int y=0; y<height/cellSize; y++) {
            p.stroke(125);
            p.noFill();
            p.rect (x*cellSize+cellSize/2, y*cellSize+cellSize/2, cellSize, cellSize);
            if(cells[x][y]==1){
              if(drawer.useLeap){
                 drawMicroSquare(p, x*cellSize+cellSize/2,y*cellSize+cellSize/2);
              }
           }
         }
       }
      }
      else{
         p.fill(255);
         p.rect (mouseX, mouseY, cellSize, cellSize);
         drawMicroSquare(p, mouseX,mouseY);
      }      
    }
  }
  
  
  public void drawMicroSquare(PGraphics p, int x, int y){
    p.rectMode(CENTER);
      p.fill(255);
      p.rect (x, y, cellSize, cellSize);
      PVector toCompare= new PVector(x,y);
      PVector ratio = getLinvingAndWorkingInsideROI(models.get(0),toCompare,cellSize);
      ArrayList<PShape> tmp = getBuildingInsideROI(toCompare,cellSize);
      for (int i=0;i<tmp.size();i++){
        p.fill(255,0,0);
        p.shape(tmp.get(i), 0, 0);
      }
      ArrayList<Agent> tmp2 = getAgentInsideROI(models.get(0),toCompare,cellSize);
      for (int i=0;i<tmp2.size();i++){
        p.fill(255,0,0);
         p.ellipse(tmp2.get(i).pos.x, tmp2.get(i).pos.y, tmp2.get(i).size, tmp2.get(i).size);
      }
  }
  
  public ArrayList<PShape> getBuildingInsideROI(PVector pos, int size){
    ArrayList<PShape> tmp = new ArrayList<PShape>();
    for (int i=0;i<buildings.buildings.size();i++){
        if(((buildings.buildings.get(i).getVertex(0).x>pos.x-size/2) && (buildings.buildings.get(i).getVertex(0).x)<pos.x+size/2) &&
        ((buildings.buildings.get(i).getVertex(0).y>pos.y-size/2) && (buildings.buildings.get(i).getVertex(0).y)<pos.y+size/2))
        {
          tmp.add(buildings.buildings.get(i));
        }       
      }
    return tmp;
  }
  
  public ArrayList<Agent> getAgentInsideROI(ABM model,PVector pos, int size){
    ArrayList<Agent> tmp = new ArrayList<Agent>();
    for (int i=0;i<model.agents.size();i++){
        if(((model.agents.get(i).pos.x>pos.x-size/2) && (model.agents.get(i).pos.x)<pos.x+size/2) &&
        ((model.agents.get(i).pos.y>pos.y-size/2) && (model.agents.get(i).pos.y)<pos.y+size/2))
        {
          tmp.add(model.agents.get(i));
        }       
      }
    return tmp;
  }
  
  public PVector getLinvingAndWorkingInsideROI(ABM model,PVector pos, int size){
    PVector tmp = new PVector();
    for (int i=0;i<model.agents.size();i++){
        if(((model.agents.get(i).pos.x>pos.x-size/2) && (model.agents.get(i).pos.x)<pos.x+size/2) &&
        ((model.agents.get(i).pos.y>pos.y-size/2) && (model.agents.get(i).pos.y)<pos.y+size/2))
        {
          if(model.agents.get(i).usage.equals("living")){
            tmp.x++;
          }else{
            tmp.y++;
          }
        }       
      }
    return tmp;
  }
}
// import UDP library


UDP udp;  // define the UDP object

public class InterFace{
 InterFace(){
   // create a new datagram connection on port 6000
  // and wait for incomming message
  udp = new UDP( this, 12999 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
 }
 
// void receive( byte[] data ) {       // <-- default handler
public void receive( byte[] data, String ip, int port ) {  // <-- extended handler
    // get the "real" message =
  // forget the ";\n" at the end <-- !!! only for a communication with Pd !!!
  data = subset(data, 0, data.length-2);
  String message = new String( data );
  String[] list = split(message, ',');
  if(drawer.useLeap){
    for (int x=0; x<width/grid.cellSize; x++) {
        for (int y=0; y<height/grid.cellSize; y++) {
          grid.cells[x][y]=0;
        }
      }
  grid.cells[PApplet.parseInt(list[1])][PApplet.parseInt(list[2])]=1;
  }
  
  
  // print the result
  println( "receive: \""+message+"\" from "+ip+" on port "+port );
}
}

public class SliderHandler{
  ArrayList<Float> globalSliders;
  ArrayList<Float> tmpSliders;
  String newMsg = "";
  
  SliderHandler(){
    // create a new datagram connection on port 6000
    // and wait for incomming message
    udp = new UDP( this, 11999 );

    //udp.log( true );     // <-- printout the connection activity
    udp.listen( true );
   
    globalSliders = new ArrayList<Float> ();
    globalSliders.add(0.5f);
    globalSliders.add(0.5f);
    
    
    tmpSliders = new ArrayList<Float> ();
    tmpSliders.add(0.5f);
    tmpSliders.add(0.5f);
    
  }
  
  /**
 * To perform any action on datagram reception, you need to implement this 
 * handler in your code. This method will be automatically called by the UDP 
 * object each time he receive a nonnull message.
 * By default, this method have just one argument (the received message as 
 * byte[] array), but in addition, two arguments (representing in order the 
 * sender IP address and his port) can be set like below.
 */
// void receive( byte[] data ) {       // <-- default handler
public void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  // get the "real" message =
  // forget the ";\n" at the end <-- !!! only for a communication with Pd !!!
  data = subset(data, 0, data.length-2);
  String message = new String( data );
   
  newMsg = "receive: " + message +" from "+ip+" on port "+port;
  println(newMsg);
  String[] list = split(newMsg, ' ');
  //println("yo" + float(list[3]));
  if(list[1].equals("/slider00")){
    globalSliders.set(0,PApplet.parseFloat(list[2]));
  }
  if(list[1].equals("/slider01")){
    globalSliders.set(1,PApplet.parseFloat(list[2]));
  }
  
}
  
}
  

public class RoadNetwork {
  private PVector size;
  private float scale;
  private PVector[] bounds;  // [0] Left-Top  [1] Right-Bottom
  private Pathfinder graph;
  /* <--- CONSTRUCTOR ---> */
  RoadNetwork(String GeoJSONfile) {

    ArrayList<Node> nodes = new ArrayList<Node>();
    
    // Load file -->
    JSONObject JSON = loadJSONObject(GeoJSONfile);
    JSONArray JSONlines = JSON.getJSONArray("features");
    

    JSONObject JSONBounds = loadJSONObject("GIS/Bounds.geojson");
    JSONArray JSONBoundslines = JSONBounds.getJSONArray("features");
    setBoundingBox(JSONBoundslines);
    
    // Import all nodes -->
    Node prevNode = null;
    for(int i=0; i<JSONlines.size(); i++) {
      
      JSONObject props = JSONlines.getJSONObject(i).getJSONObject("properties");
      String type = props.isNull("type") ? "null" : props.getString("type");
      String name = props.isNull("name") ? "null" : props.getString("name");
      boolean oneWay = props.isNull("oneway") ? false : props.getBoolean("oneway");
      
      JSONArray points = JSONlines.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
      for(int j=0; j<points.size(); j++) {
           // Point coordinates to XY screen position -->
        PVector pos = toXY(points.getJSONArray(j).getFloat(1), points.getJSONArray(j).getFloat(0));
        
        // Node already exists (same X and Y pos). Connect  -->
        Node existingNode = nodeExists(pos.x, pos.y, nodes);
        if(existingNode != null) {
          if(j>0) {
            prevNode.connect( existingNode);
            existingNode.connect(prevNode);
            //prevNode.connectBoth( existingNode, type, name, allowedAccess );
            //if(oneWay) existingNode.forbid(prevNode, RoadAgent.CAR);
          }
          prevNode = existingNode;
          
        // Node doesn't exist yet. Create it and connect -->
        } else {
          Node newNode = new Node(pos.x, pos.y);
          if(j>0) {
            prevNode.connect( newNode);
            newNode.connect( prevNode);
          }
          nodes.add(newNode);
          prevNode = newNode;
          
        }
      }
      }
      graph = new Pathfinder(nodes); 
    }

  private Node nodeExists(float x, float y, ArrayList<Node> nodes) {
    for(Node node : nodes) {
      if(node.x == x && node.y == y) {
        return node;
      }
    }
    return null;
  }
  
  // FIND NODES BOUNDS -->
  public void setBoundingBox(JSONArray JSONlines) {
    float minLat = Float.MAX_VALUE,
          minLng = Float.MAX_VALUE,
          maxLat = -Float.MAX_VALUE,
          maxLng = -Float.MAX_VALUE;
    for(int i=0; i<JSONlines.size(); i++) {
      JSONArray points = JSONlines.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
      for(int j=0; j<points.size(); j++) {
        float Lat = points.getJSONArray(j).getFloat(1);
        float Lng = points.getJSONArray(j).getFloat(0);
        if( Lat < minLat ) minLat = Lat;
        if( Lat > maxLat ) maxLat = Lat;
        if( Lng < minLng ) minLng = Lng;
        if( Lng > maxLng ) maxLng = Lng;
      }
    }
    
    // Conversion to Mercator projection -->
    PVector coordsTL = toWebMercator(minLat, minLng);
    PVector coordsBR = toWebMercator(maxLat, maxLng);
    this.bounds = new PVector[] { coordsTL, coordsBR };
    
    // Resize map keeping ratio -->
    float mapRatio = (coordsBR.x - coordsTL.x) / (coordsBR.y - coordsTL.y);
    this.size = mapRatio < 1 ? new PVector( height * mapRatio, height ) : new PVector( width , width / mapRatio ) ;
    this.scale = (coordsBR.x - coordsTL.x) / size.x;     
  }
 
  
    // CONVERT TO WEBMERCATOR PROJECTION
  private PVector toWebMercator( float lat, float lng ) {
    float RADIUS = 6378137f; // Earth Radius
    float sin = sin( radians(lat) );
    return new PVector(lng * radians(RADIUS), ( RADIUS / 2 ) * log( ( 1.0f + sin ) / ( 1.0f - sin ) ));
  }
  
    // LAT, LNG COORDINATES TO XY SCREEN POINTS -->
  private PVector toXY(float lat, float lng) {
    PVector projectedPoint = toWebMercator(lat, lng);
    return new PVector(
      map(projectedPoint.x, bounds[0].x, bounds[1].x, 0, size.x),
      map(projectedPoint.y, bounds[0].y, bounds[1].y, size.y, 0)
    );
  }
  
  public void draw(PGraphics p){ 
    if(drawer.showRoad){
      for(int i = 0; i < graph.nodes.size(); i++){
      Node tempN = (Node)graph.nodes.get(i);
      for(int j = 0; j < tempN.links.size(); j++){
        p.stroke(0xffAAAAAA); p.strokeWeight(1);
        p.line(tempN.x, tempN.y, ((Connector)tempN.links.get(j)).n.x, ((Connector)tempN.links.get(j)).n.y);
      }
    }
    }
      
  }
}  
  public void settings() {  fullScreen(P3D, SPAN); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "UrbanABM" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
