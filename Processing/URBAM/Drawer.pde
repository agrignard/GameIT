import deadpixel.keystone.*;

public class Drawer{
  Keystone ks;
  CornerPinSurface[] surface = new CornerPinSurface[nbProjector];
  PGraphics offscreenSurface;
  PGraphics subSurface;
  public boolean showBG = true,
                 showAgent = true,
                 showBuilding = false,
                 showRoad=false,
                 showViewCube=false,
                 showSlider=false,
                 keystoneMode=false,
                 showLegend=false,
                 showInteractiveGrid=false,
                 showStaticGrid=true,
                 showContinousHeatMap=false,
                 showCollisionPotential;
  
  
  Drawer(PApplet parent){
    ks = new Keystone(parent);
    offscreenSurface = createGraphics(playGroundWidth, playGroundHeight, P3D);
  }
  
  void initSurface(){
    for (int i=0; i<nbProjector;i++){
      surface[i] = ks.createCornerPinSurface((int)playGroundWidth/nbProjector, (int)playGroundHeight, 50);
    }
    subSurface = createGraphics(playGroundWidth/nbProjector, playGroundHeight, P3D);
  }
  
  void drawSurface(){
      offscreenSurface.beginDraw();
      offscreenSurface.clear();
      offscreenSurface.background(0);
      drawTableBackGround(offscreenSurface);
      grid.draw(offscreenSurface);
      aggregatedHeatmap.draw(offscreenSurface);
      legoGrid.draw(offscreenSurface);
      if(drawer.showInteractiveGrid && tagViz != 'H'){
        drawTags(offscreenSurface);
      }
      if(showLegend){
        drawLegend(offscreenSurface);
      }
      roads.draw(offscreenSurface);
      buildings.draw(offscreenSurface); 
      model.run(offscreenSurface);
      model.updateGlobalPop();
      model.updateLocalPop();
      model.updateCarPop();
      
      
      offscreenSurface.endDraw();
      for (int i=0; i<nbProjector;i++){
        subSurface.beginDraw();
        subSurface.clear();
        subSurface.image(offscreenSurface, -(playGroundWidth/nbProjector)*i, 0);
        subSurface.endDraw();
        surface[i].render(subSurface);
      }
      
  }
  void drawTags(PGraphics p){
    p.rectMode(CORNER);
    p.fill(#000000);
    p.rect (tags.startPoint.x,tags.startPoint.y, tags.wideCount*tags.unit, tags.highCount*tags.unit);
    udpR.updateGridValue();
    tags.UpdateAndDraw(p);
    messageDelta= false;
    mouseClicked = false;
    started = true;
  } 
  void drawTableBackGround(PGraphics p) {
    //p.fill(125);  
    //p.rect(0, 0, displayWidth, displayHeight);
    if(showBG){
      //tint(255, 100);
      p.image(bg,0,0,displayWidth,displayHeight);
    }
  }
  
  void drawABMInfo(PGraphics p){
    p.textAlign(RIGHT); 
    
   
    p.ellipse(width-50, 40, 10, 10);
    p.text("Moving people : " + int(model.getNbMovingPeople()), width-70, 43);
    
    p.ellipse(width-50, 60, 10, 10);
    p.text("Static people : " + int(model.getNbStaticPeople()), width-70, 63);
    
    p.stroke(#FFFFFF);
    p.strokeWeight(2);
    p.noFill();
    p.ellipse(width-50, 80, 10, 10);
    p.fill(#FFFFFF);
    p.text("Cars : " + int(model.getNbCars()), width-70, 83);
    
    p.noStroke();
    p.fill(model.livingColor);
    p.ellipse(width-50, 100, 10, 10);
    p.fill(#FFFFFF);
    p.text("Living: " + int(GetTotalLivingWorkingNumber().x), width-70, 103);
    
    p.fill(model.workingColor);
    p.ellipse(width-50, 120, 10, 10);
    p.fill(#FFFFFF);
    p.text("Working: " + int(GetTotalLivingWorkingNumber().y), width-70, 123);
    
    p.text("Total: " + int(model.agents.size())  + model.type , width-70, 150);
  }
  
  void drawLegend(PGraphics p) {
    p.fill(#FFFFFF);
    p.textSize(10); 
    p.textAlign(LEFT); 
    if(keystoneMode){
      p.text("Keystone: [L] load keystone - [S] save keystone  ", 30, 30);
    }else{
      
      if(tagsInteraction){
        p.text("[d] delta 1 - [f] delta 2 - [l] - Display Grid string - [4] - Normal Interaction", 30, 50);
      }else{
        p.text("Simulation: [a] Agent - [c] Collision Potential - [d] Density ", 30, 30);
        p.text("HeatMap: [e] No Heatmap - [t] type - [p] Park Heatmap -[o] Office Walkability - [r] Residential Walkability ", 30, 50);
        p.text("Interaction: [s] static grid: " + showStaticGrid + " - [i] Interactive Grid: " +  showInteractiveGrid + "- [v] ViewCube: " + showViewCube + "- [m] map: " + showBG, 30, 70);
        
      }
      
      p.noStroke();
      p.fill(model.livingColor);
      p.ellipse(50, 100, 10, 10);
      p.fill(#FFFFFF);
      p.text("Living", 70, 103);
    
      p.fill(model.workingColor);
      p.ellipse(50, 120, 10, 10);
      p.fill(#FFFFFF);
      p.text("Working", 70, 123);
      
      p.text("Settings : [1] keystone - [2] load keystone - [3] save keystone - [4] - Tags Interaction - [space] legend", width - 500, 25);
      p.text("fps: " + int(frameRate) + " fps", width-100, 50);
    }
    p.textAlign(CENTER);
    p.textSize(10);
    //p.text("UrbanSim InnovaCity - LLL & GAME IT - 2018 ", 0, height*0.99);
    p.text(" © LLL 2018 ", width*0.96, height*0.99);
 }
 
  public PVector GetTotalLivingWorkingNumber(){
    PVector tmp  = new PVector (0,0);
    for (int j=0;j<model.agents.size();j++){
      if(model.agents.get(j).usage.equals("living")){
        tmp.x++;
      }else{
        tmp.y++;
      }
    }
    return tmp;
  }
 
  public void toggleKeystone() { 
    keystoneMode = !keystoneMode; 
    drawer.ks.toggleCalibration();
  } 
  public void toggleBG() { showBG = !showBG; }
  public void toggleAgent() { showAgent = !showAgent; }
  public void toggleBuilding() { showBuilding = !showBuilding;}
  public void toggleRoad() { showRoad = !showRoad;}
  public void toggleViewCube() { showViewCube = !showViewCube;}
  public void toggleSlider() { showSlider = !showSlider;}
  public void toggleLegend() { showLegend = !showLegend;}
  public void toggleStaticGrid() { showStaticGrid = !showStaticGrid;}
  public void toggleInteractiveGrid() { showInteractiveGrid = !showInteractiveGrid;}
  public void toggleInstantHeatMap() { showContinousHeatMap=!showContinousHeatMap;}
  public void toggleCollisionPotential() { showCollisionPotential=!showCollisionPotential;}  
}
