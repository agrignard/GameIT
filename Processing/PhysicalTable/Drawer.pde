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
                 showRoad=true,
                 showInteraction=false,
                 timelapse=false,
                 showgrid=false,
                 showSlider=false,
                 keystoneMode=false;
  
  
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
      if(!drawer.timelapse){
        offscreenSurface.clear();
        offscreenSurface.background(0);
      }
      
      drawTableBackGround(offscreenSurface);
      drawLegend(offscreenSurface);
      drawInteraction(offscreenSurface);
      roads.draw(offscreenSurface);
      buildings.draw(offscreenSurface);
      model.run(offscreenSurface);
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
    p.text(int(model.agents.size()) + " agents" , width-30, 50);
    p.textAlign(LEFT); 
    if(keystoneMode){
      p.text("Keystone: [L] load keystone - [S] save keystone  ", 30, 30);
    }else{
      p.text("[A] Agent - [B] Building - [G] Grid - [K] keystone - [R] Road - [S] Slider - [T] Timelapse - [I] Interaction", 30, 30);
    }
    p.textAlign(CENTER); 
    p.text("InnovaCity - LLL & GAME IT - 2018 ", width/2, height);
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
  public void toggleInteraction() { 
    showInteraction = !showInteraction;
    for (int x=0; x<width/grid.cellSize; x++) {
        for (int y=0; y<height/grid.cellSize; y++) {
          grid.cells[x][y]=0;
        }
      }
  }
  public void toggleTimelapse() { timelapse = !timelapse;}
  public void toggleGrid() { showgrid = !showgrid;}
  public void toggleSlider() { showSlider = !showSlider;}
  
  
}