import controlP5.*;
 
class ControlFrame extends PApplet {
 
  int w, h;
  PApplet parent;
  ControlP5 cp5;
  DropdownList d1;
  DropdownList d2;
  String currentHeatMap;
  String currentHeatMapType;
 
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
  d1 = cp5.addDropdownList("HeatmapsHome").setPosition(50, 100);       
  customize(d1,"HeatMaps from Home to"); 
  
  d2 = cp5.addDropdownList("HeatmapsJobs").setPosition(250, 100);       
  customize(d2,"HeatMaps from Jobs to"); 
  }
  
  void customize(DropdownList ddl, String title) {
    ddl.setBackgroundColor(color(190));
    ddl.setItemHeight(20);
    ddl.setBarHeight(15);
    ddl.getCaptionLabel().set(title);
    for (int i=0;i<heatmap.heatmapTypesPerCategory.size();i++) {
      ddl.addItem(heatmap.heatmapTypesPerCategory.get(i), i);
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
      println("event from controller string : "+d1.getItem(int(theEvent.getController().getValue())).get("name").toString());
      currentHeatMap = theEvent.getController().toString();
      currentHeatMapType= d1.getItem(int(theEvent.getController().getValue())).get("name").toString();
      //currentHeatMapType = int(theEvent.getController().getValue());  
      //currentHeatMapType = cp5.get(ScrollableList.class, "HeatmapsHome").getItem(int(theEvent.getController().getValue())).get("name").toString();
    }
  }
 
}
