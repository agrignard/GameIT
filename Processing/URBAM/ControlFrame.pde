import controlP5.*;
 
class ControlFrame extends PApplet {
 
  int w, h;
  PApplet parent;
  ControlP5 cp5;
  DropdownList d1;
  int currentHeatMap;
 
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
     // create a DropdownList, 
  d1 = cp5.addDropdownList("Heatmaps").setPosition(100, 100);       
  customize(d1); // customize the first list
  }
  
  void customize(DropdownList ddl) {
    ddl.setBackgroundColor(color(190));
    ddl.setItemHeight(20);
    ddl.setBarHeight(15);
    ddl.getCaptionLabel().set("HeatMaps");
    for (int i=0;i<40;i++) {
      ddl.addItem("HeatMap "+i, i);
     }
    ddl.setColorBackground(color(60));
    ddl.setColorActive(color(255, 128));
}
 
  void draw() {
    background(20);
    pushMatrix();
    popMatrix();
  }
  
  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isGroup()) {
      // check if the Event was triggered from a ControlGroup
      println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    } 
    else if (theEvent.isController()) {
      println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
      currentHeatMap = int(theEvent.getController().getValue());
    }
  }
 
}
