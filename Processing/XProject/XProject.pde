import deadpixel.keystone.*;
 public int displayWidth = 500;
public int displayHeight = 500;
 Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;
Utility utils;
int currentState=0;
ArrayList<ParticleSystem> systems;
Grid grid;


void setup(){
  fullScreen(P3D);
  //size(displayWidth, displayHeight, P3D);
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(displayWidth,displayHeight, 50);
  offscreen = createGraphics(displayWidth,displayHeight, P3D);
  utils= new Utility();
  systems = new ArrayList<ParticleSystem>();
  grid = new Grid(new PVector(displayWidth/2,displayHeight/2),5,5,40);
} 
 void draw(){

  drawScene(offscreen);
  
}
 void drawScene(PGraphics p) {
  background(0);
  p.beginDraw();
  p.clear();
  p.fill(#FFFFFF);
  p.rect(displayWidth/2, displayHeight/2, displayWidth, displayHeight);
  grid.run();
  drawCurrentState(p);
  p.endDraw();
  surface.render(p);
} 
 void keyPressed() {
  if(key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6'){
    updateCurrentState(key-48);
  } 
  switch(key) { 
  case 'k':
    ks.toggleCalibration();
    break;
  case 'l':
    ks.load();
    break;
  case 's':
    ks.save();
    break;
  }
}

void mouseClicked(MouseEvent evt) {
  if (evt.getCount() == 2) doubleClicked(evt);
}



void doubleClicked(MouseEvent evt){
  if(currentState == 1 || currentState == 2 || currentState == 3 || currentState == 4 || currentState == 5 || currentState == 6){
  grid.addBlock(new PVector (mouseX,mouseY), 40, currentState);
  }
}

void drawCurrentState(PGraphics p){
  p.rectMode(CENTER);
  p.fill(utils.colorMap.get(currentState));
  p.rect(0, 0, displayWidth*0.05, displayHeight*0.05);
}

void updateCurrentState(int id){
  currentState=id;
}
