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
      drawTableBackGround(offscreenSurface);
      drawLegend(offscreenSurface);
      roads.draw(offscreenSurface);
      rivers.draw(offscreenSurface);
      buildings.draw(offscreenSurface);
      grid.draw(offscreenSurface);
      models.get(0).run(offscreenSurface);
      models.get(0).updateGlobalPop(0);
      models.get(0).updateCarPop();
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
      p.image(bg,0,0,displayWidth,displayHeight);
    }
  }
  
  void drawLegend(PGraphics p) {
    p.fill(#FFFFFF);
    p.textAlign(RIGHT); 
    p.textSize(10);
    p.text("FRAMERATE: " + int(frameRate) + " fps", width-30, 30);
    p.text("model 0: " + int(models.get(0).agents.size())  + models.get(0).type , width-30, 50);
    p.text("cars : " + int(models.get(0).getNbCars()) , width-30, 70);
    //p.text("model 1:" + int(models.get(1).agents.size()) + models.get(1).type , width-30, 70);
    p.text("Living/Working:" + int(GetTotalLivingWorkingNumber().x) +"/"+int(GetTotalLivingWorkingNumber().y), width-30, 90);
    p.textAlign(LEFT); 
    if(keystoneMode){
      p.text("Keystone: [L] load keystone - [S] save keystone  ", 30, 30);
    }else{
      p.text("[A] Agent - [B] Building - [R] Road - [U] Usage - [H] Heatmap", 30, 30);
      p.text("[I] Interaction (Mouse) (and [F] Leap)) - [K] keystone", 30, 50);
    }
    p.textAlign(CENTER);
    p.textSize(10);
    p.fill(0);
    p.text("UrbanABM InnovaCity - LLL & GAME IT - 2018 ", 0, height*0.99);
    p.text(" © Arnaud Grignard 2018 ", width*0.95, height*0.99);
 }
 
  public PVector GetTotalLivingWorkingNumber(){
    PVector tmp  = new PVector (0,0);
    for (int i=0;i<models.size();i++){
      for (int j=0;j<models.get(i).agents.size();j++){
        if(models.get(i).agents.get(j).usage.equals("living")){
          tmp.x++;
        }else{
          tmp.y++;
        }
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