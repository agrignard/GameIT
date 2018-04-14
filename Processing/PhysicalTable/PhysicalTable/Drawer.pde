import deadpixel.keystone.*;

public class Drawer{
  Keystone ks;
  int nbProjector = 3;
  CornerPinSurface[] surface = new CornerPinSurface[nbProjector];
  PGraphics offscreenSurface;
  PGraphics subSurface;
  
  
  Drawer(PApplet parent){
    ks = new Keystone(parent);
    offscreenSurface = createGraphics(playGroundWidth, playGroundHeight, P2D);
  }
  
  void initSurface(){
    for (int i=0; i<=nbProjector;i++){
      surface[i] = ks.createCornerPinSurface((int)playGroundWidth/nbProjector, (int)playGroundHeight, 50);
    }
    subSurface = createGraphics(playGroundWidth/nbProjector, playGroundHeight, P2D);
  }
  
  void drawSurface(){
      offscreenSurface.beginDraw();
      offscreenSurface.clear();
      drawTableBackGround(offscreenSurface);
      offscreenSurface.endDraw();
      for (int i=0; i<=nbProjector;i++){
        subSurface.beginDraw();
        subSurface.clear();
        subSurface.image(offscreenSurface, -(playGroundWidth/2)*i, 0);
        subSurface.endDraw();
        surface[i].render(subSurface);
      }
  }
  
  void drawTableBackGround(PGraphics p) {
    p.fill(125);  
    p.rect(0, 0, displayWidth, displayHeight);
  }
}