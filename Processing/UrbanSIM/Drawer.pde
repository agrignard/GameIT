import deadpixel.keystone.*;

public class Drawer{
  Keystone ks;
  CornerPinSurface[] surface = new CornerPinSurface[nbProjector];
  PGraphics offscreenSurface;
  PGraphics subSurface;
  //int nbProjector=1;
  
  public boolean showBG = true,
                 showAgent = true,
                 showBuilding = false,
                 showRoad=false,
                 useLeap=false,
                 showInteraction=false,
                 showSlider=false,
                 keystoneMode=false,
                 showUsage=false,
                 showHeatmap=false,
                 showMobilityHeatmap=false;
  
  
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
      grid.draw(offscreenSurface);
      drawTableBackGround(offscreenSurface);
      drawLegend(offscreenSurface);
      roads.draw(offscreenSurface);
      buildings.draw(offscreenSurface);
      
      model.run(offscreenSurface);
      model.updateGlobalPop(0);
      model.updateLocalPop(0);
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
  
  void drawTableBackGround(PGraphics p) {
    //p.fill(125);  
    //p.rect(0, 0, displayWidth, displayHeight);
    if(showBG){
      p.tint(255, 100);
      p.image(bg,0,0,displayWidth,displayHeight);
    }
  }
  
  void drawLegend(PGraphics p) {
    p.fill(#FFFFFF);
    p.textAlign(RIGHT); 
    p.textSize(10);
   
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

    p.textAlign(LEFT); 
    if(keystoneMode){
      p.text("Keystone: [L] load keystone - [S] save keystone  ", 30, 30);
    }else{
      p.text("[A] Agent - [B] Building - [R] Road - [U] Usage - [H] Heatmap - [J] Mobility Heatmap", 30, 30);
      p.text("[G] Interaction (Mouse) (and [F] Leap)) - [K] keystone", 30, 50);
      p.text("FRAMERATE: " + int(frameRate) + " fps", 30, 70);
    }
    p.textAlign(CENTER);
    p.textSize(10);
    p.fill(0);
    p.text("UrbanABM InnovaCity - LLL & GAME IT - 2018 ", 0, height*0.99);
    p.text(" © Arnaud Grignard 2018 ", width*0.95, height*0.99);
    
    
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
  public void toggleLeap() { useLeap = !useLeap;}
  public void toggleInteraction() { showInteraction = !showInteraction;}
  public void toggleSlider() { showSlider = !showSlider;}
  public void toggleUsage() { showUsage = !showUsage;}
  public void toggleHeatmap() { showHeatmap = !showHeatmap;}
  public void toggleMobilityHeatmap() { showMobilityHeatmap = !showMobilityHeatmap;}
  
  
  
  
}