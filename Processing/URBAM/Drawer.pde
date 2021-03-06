import deadpixel.keystone.*;

public class Drawer{
  Keystone ks;
  CornerPinSurface[] surface = new CornerPinSurface[nbProjector];
  PGraphics offscreenSurface;
  PGraphics subSurface;
  public boolean showBG = true,
                 showAgent = false,
                 showAgentOnGrid = false,
                 showBuilding = false,
                 showRoad=false,
                 showViewCube=false,
                 showMagicTrackPad=true,
                 showSlider=false,
                 keystoneMode=false,
                 showLegend=false,
                 showInteractiveGrid=false,
                 showStaticGrid=true,
                 showContinousHeatMap=false,
                 showCollisionPotential=false,
                 showCongestedRoad=false,
                 showMoBike=false,
                 showUrbanLens=false,
                 showParticleSystem=false;
  HashMap<Integer,String> viewText;
  HashMap<Integer,Integer> QR_ID;

  Drawer(PApplet parent){
    ks = new Keystone(parent);
    offscreenSurface = createGraphics(playGroundWidth, playGroundHeight, P3D);
    viewText = new HashMap<Integer,String>();
    viewText.put(-1,"Default");viewText.put(0,"LANDUSE");viewText.put(1,"JOBS2HOME");viewText.put(2,"HOME2JOBS");viewText.put(3,"PARKS");viewText.put(4,"CONGESTION");viewText.put(5,"BIKES SHARE");viewText.put(6,"INTERACTION");
    QR_ID = new HashMap<Integer,Integer>();
    QR_ID.put(0,0);QR_ID.put(1,9);QR_ID.put(2,19);QR_ID.put(3,43);QR_ID.put(4,63);QR_ID.put(5,126);

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
      //  offscreenSurface.background(#C7D2E0);
      drawTableBackGround(offscreenSurface);
      grid.draw(offscreenSurface);
      if(drawer.showContinousHeatMap){
        aggregatedHeatmap.draw(offscreenSurface);
      }
      if(drawer.showMoBike){
        aggregatedHeatmap2.draw(offscreenSurface);
      }
      legoGrid.draw(offscreenSurface);
      if(drawer.showInteractiveGrid){// && tagViz != 'H'){
        drawTags(offscreenSurface);
      }
      if(showLegend){
        drawLegend(offscreenSurface);
      }
      roads.draw(offscreenSurface);
      buildings.draw(offscreenSurface); 
     
      if(ABM){
        model.run(offscreenSurface);
        if(updateDynamicPop){
          model.updateGlobalPop();
          model.updateLocalPop();
        }
      }
      if(updateInteractivePop){
        
      }
      //drawMagicTrackPad(offscreenSurface);

    
      offscreenSurface.endDraw();
      for (int i=0; i<nbProjector;i++){
        subSurface.beginDraw();
        subSurface.clear();
        subSurface.image(offscreenSurface, -(playGroundWidth/nbProjector)*i, 0);
        subSurface.endDraw();
        surface[i].render(subSurface);
      }
      
  }
  void drawTags(PGraphics p){
    p.rectMode(CORNER);
    p.fill(#000000);
    p.rect (tags.startPoint.x,tags.startPoint.y, tags.wideCount*tags.unit, tags.highCount*tags.unit);
    udpR.updateGridValue();
    if(initiateGrid == false){
      tags.instantiateAgentFromGrid();
      initiateGrid=true;
    }
    tags.UpdateAndDraw(p);
    if(drawer.showAgentOnGrid){
      tags.displayMicroPop(p);
    }
    messageDelta= false;
    mouseClicked = false;
    started = true;
  } 
  void drawTableBackGround(PGraphics p) {
    //p.fill(125);  
    //p.rect(0, 0, displayWidth, displayHeight);
    if(showBG){
      //tint(255, 100);
      p.image(bg,0,0,displayWidth,displayHeight);
    }
  }
  
  void drawMagicTrackPad(PGraphics p){
    if(showMagicTrackPad && currentView !=-1){
      p.rectMode(CORNER);
      p.fill(#FFFFFF);
      p.rect (1025*sizeScale,355*sizeScale, 63*sizeScale, 45*sizeScale);
      p.fill(#000000);
      p.textAlign(CENTER); 
      p.textSize(9); 
      p.text(viewText.get(currentView), 1025*sizeScale + (63/2)*sizeScale, 355*sizeScale + (45/2+45/8)*sizeScale);
    }
  }
    
  void drawABMInfo(PGraphics p){
    p.textAlign(RIGHT); 
    
    p.ellipse(width-50, 40, 10, 10);
    p.text("Moving people : " + int(model.getNbMovingPeople()), width-70, 43);
    
    p.ellipse(width-50, 60, 10, 10);
    p.text("Static people : " + int(model.getNbStaticPeople()), width-70, 63);
        
    p.noStroke();
    p.fill(model.livingColor);
    p.ellipse(width-50, 100, 10, 10);
    p.fill(#FFFFFF);
    p.text("Living: " + int(GetTotalLivingWorkingNumber().x), width-70, 103);
    
    p.fill(model.workingColor);
    p.ellipse(width-50, 120, 10, 10);
    p.fill(#FFFFFF);
    p.text("Working: " + int(GetTotalLivingWorkingNumber().y), width-70, 123);
    
    p.text("Total: " + int(model.agents.size())  + model.type , width-70, 150);
  }
  
  void drawLegend(PGraphics p) {
    p.fill(#FFFFFF);
    p.textSize(10); 
    p.textAlign(LEFT); 
    if(keystoneMode){
      p.text("Keystone: [L] load keystone - [S] save keystone  ", 30, 30);
    }else{
      
      if(tagsInteraction){
        p.text("[d] delta 1 - [f] delta 2 - [l] - Display Grid string - [w] - Normal Interaction", 30, 50);
      }else{
        p.text("Simulation: [a] Agent - [z] Grid Agent - [b] Building - [c] Collision Potential - [d] Density - [j] Mobike - [x] Particle ", 30, 30);
        p.text("Grid: [e] Empty - [t] type - [p] Park  -[o] Office  - [r] Residential  - [n] Road Network", 30, 50);
        p.text("Interaction: [g] static grid: " + showStaticGrid + " - [i] Interactive Grid: " +  showInteractiveGrid +  " - [v] ViewCube: " +  showViewCube + "- [m] map: " + showBG, 30, 70); 
      }  
      p.noStroke();
      p.fill(model.livingColor);
      p.ellipse(50, 100, 10, 10);
      p.fill(#FFFFFF);
      p.text("Living", 70, 103);
    
      p.fill(model.workingColor);
      p.ellipse(50, 120, 10, 10);
      p.fill(#FFFFFF);
      p.text("Working", 70, 123);
      
      p.text("Settings : [k] keystone - [l] load keystone - [s] save keystone - [space] legend - [w] tags interaction", width - 500, 25);
      p.text("fps: " + int(frameRate) + " fps", width-100, 50);
    }
    p.textAlign(CENTER);
    p.textSize(10);
    //p.text("UrbanSim InnovaCity - LLL & GAME IT - 2018 ", 0, height*0.99);
    p.text(" © LLL 2018 ", width*0.96, height*0.99);
 }
 
  public PVector GetTotalLivingWorkingNumber(){
    PVector tmp  = new PVector (0,0);
    for (int j=0;j<model.agents.size();j++){
      if(model.agents.get(j).usage.equals("living")){
        tmp.x++;
      }else{
        tmp.y++;
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
  public void toggleAgentOnGrid() { showAgentOnGrid = !showAgentOnGrid; }
  public void toggleBuilding() { showBuilding = !showBuilding;}
  public void toggleRoad() { showRoad = !showRoad;}
  public void toggleViewCube() { showViewCube = !showViewCube;}
  public void toggleSlider() { showSlider = !showSlider;}
  public void toggleLegend() { showLegend = !showLegend;}
  public void toggleStaticGrid() { showStaticGrid = !showStaticGrid;}
  public void toggleInteractiveGrid() { showInteractiveGrid = !showInteractiveGrid;}
  public void toggleInstantHeatMap() { showContinousHeatMap=!showContinousHeatMap;}
  public void toggleCollisionPotential() { showCollisionPotential=!showCollisionPotential;}
  public void toggleMagicTrackpad() { showMagicTrackPad=!showMagicTrackPad;} 
  public void toggleCongestedRoad() { showCongestedRoad=!showCongestedRoad;} 
  public void toggleMoBike() { showMoBike=!showMoBike;} 
  public void toggleUrbanLens() { showUrbanLens=!showUrbanLens;}
  public void toggleParticleSystem() { showParticleSystem=!showParticleSystem;}
}
