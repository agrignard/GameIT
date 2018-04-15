import java.util.Map;
import controlP5.*;
public class Slider{


  ControlP5 cp5;
  PVector pos;
  PVector size;
  int sliderSize;
  
  Slider(PApplet parent){
    cp5 = new ControlP5(parent);
    pos = new PVector(width*0.7,0);
    size = new PVector(400,300);
    sliderSize = int(size.y)/20;
    int i=0;
    for (Map.Entry me : model.profiles.entrySet()) {
        cp5.addSlider((String)me.getKey())
        .setPosition(pos.x, i*sliderSize)
        .setRange(0, 100)
        .setSize(int(size.x*0.9),sliderSize)
        .setValue(50)
        .setColorBackground((int)me.getValue())
        .setColorValue((int)me.getValue());
        i++;
    }
  }
  
  
  public int[] getSlidersValue(){
    int [] slidersValues = new int[10];
    int i=0;
    for (Map.Entry me : model.profiles.entrySet()){
      slidersValues[i]=int(cp5.getValue((String)me.getKey()));
      i++;
    } 
    return slidersValues;
  }
  
  
  public void draw(PGraphics p){ 
    if(drawer.showSlider){
      //p.fill(255);
      //p.rect(pos.x, pos.y,size.x,size.y);

    }
  }


}