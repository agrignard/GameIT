Drawer drawer;
PhysicalInterface buttons;

public int displayWidth = 3000;
public int displayHeight = 2000;

public int playGroundWidth = displayWidth;
public int playGroundHeight = displayHeight;
PImage backgroundImage;

void setup(){
  //fullScreen(P3D, SPAN);
  size(displayWidth, displayHeight, P3D);
  drawer = new Drawer(this);
  bgImage = loadImage("data/GIS/Background/AndorraBG_HR.jpg");
} 

void draw(){
  drawScene();
}

/* Draw ------------------------------------------------------ */
void drawScene() {
  drawer.drawSurface();
}