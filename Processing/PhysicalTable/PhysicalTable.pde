Drawer drawer;

public int displayWidth = 1000;
public int displayHeight = 500;

public int playGroundWidth = displayWidth;
public int playGroundHeight = displayHeight;
PImage bg;

void setup(){
  fullScreen(P3D, SPAN);
  //size(displayWidth, displayHeight, P3D);
  drawer = new Drawer(this);
  bg = loadImage("data/Table_Video_Frame_Template_4k.jpg");
  drawer.initSurface();
} 

void draw(){
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
    drawer.ks.toggleCalibration();
    break;  
  case 'l':
    drawer.ks.load();
    break; 
  case 's':
    drawer.ks.save();
    break;
  }
}