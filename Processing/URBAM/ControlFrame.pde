import controlP5.*;
 
class ControlFrame extends PApplet {
 
  int w, h;
  PApplet parent;
  ControlP5 cp5;
  Slider s;
 
  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
 
  public void settings() {
    size(w, h, P2D);
  }
 
  public void setup() {
    cp5 = new ControlP5(this);
    s= cp5.addSlider("s1").setPosition(40,40).setRange(0,1).plugTo(parent,"s1");
  }
 
  void draw() {
    background(20);
    pushMatrix();
    /*translate(width/2, height/2);
    rotate(frameCount*0.05);
    fill(255,0,0);
    rect(0,0,100,100);*/
    popMatrix();
  }
 
}
