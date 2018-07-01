public class Heatmap {
  int[][] heatmapCells;
  int heatMapcellSize = playGroundWidth/100;
  ArrayList<String> heatmapTypesPerCategory,heatmapTypesFromHome, heatmapTypesFromJob;
    
  
  Heatmap(){
    heatmapCells = new int[width/heatMapcellSize][height/heatMapcellSize];
    heatmapTypesPerCategory = new ArrayList<String>(Arrays.asList("R","Restaurant","Night","GP","Cultural","Shopping","HS","Uni","O"));
    heatmapTypesFromHome = new ArrayList<String>(Arrays.asList("Jobs","Parks & Recreation","Amenities","Schools","Public Transportation"));
    heatmapTypesFromJob = new ArrayList<String>(Arrays.asList("Housing","Parks & Recreation","Amenities","Schools","Public Transportation"));
    for (int x=0; x<width/heatMapcellSize; x++) {
      for (int y=0; y<height/heatMapcellSize; y++) {
        heatmapCells[x][y] = 0;
      }
    }
  }
  
  public void draw(PGraphics p){
    /*if(drawer.showHeatmap || (cf.currentHeatMap!=null)){
     //computeHeatMapType(p,cf.currentHeatMapType);
      switch(cf.currentHeatMapType) {
        case 0:
          computeHeatMapType(p,"R");
          break;
        case 1:
          computeHeatMapType(p,"Restaurant");
          break;
        case 2:
          computeHeatMapType(p,"Night");
          break; 
        case 3:
          computeHeatMapType(p,"GP");
          break; 
        case 4:
          computeHeatMapType(p,"Cultural");
          break;
        case 5:
          computeHeatMapType(p,"Shopping");
          break; 
        case 6:
          computeHeatMapType(p,"HS");
          break; 
        case 7:
          computeHeatMapType(p,"Uni");
          break;
        case 8:
          computeHeatMapType(p,"O");
          break; 
      }
        drawHeatMapsLegend(p,new PVector(100,height*0.9));
    }*/
    if(drawer.showHeatmap){
      computeHeatMap(p);
    }
  }
  
  
  public void computeHeatMap(PGraphics p){
    for (int x=0; x<width/heatMapcellSize; x++) {
          for (int y=0; y<height/heatMapcellSize; y++) {
            p.rectMode(CORNER);
            float nbPeople= model.getAgentInsideROI(new PVector(x*heatMapcellSize,y*heatMapcellSize),heatMapcellSize).size();
            p.fill(lerpColor(#000000, #0000FF, nbPeople/10.0));
            p.noStroke();
            p.rect (x*heatMapcellSize,y*heatMapcellSize, heatMapcellSize, heatMapcellSize);
            p.rectMode(CENTER);
      }
    }
  }
    
  
  
  public void computeHeatMapType(PGraphics p,String type){
    for (int x=0; x<width/heatMapcellSize; x++) {
      for (int y=0; y<height/heatMapcellSize; y++) {
        p.rectMode(CORNER);
        float nbBuilding= buildings.getBuildingInsideROIWithType(new PVector(x*heatMapcellSize,y*heatMapcellSize),heatMapcellSize,type).size(); 
        model.getAgentInsideROI(new PVector(x*heatMapcellSize,y*heatMapcellSize),heatMapcellSize).size();
        p.fill(lerpColor(#000000, #0000FF, nbBuilding));
        p.noStroke();
        p.rect (x*heatMapcellSize,y*heatMapcellSize, heatMapcellSize, heatMapcellSize);
        p.rectMode(CENTER);
      }
    }
  }
    
  public void drawHeatMapsLegend(PGraphics p, PVector pos){
    p.fill(#FFFFFF);
    p.textAlign(RIGHT); 
    p.textSize(10);
    p.ellipse(pos.x, pos.y, 10, 10);
    p.text("Density", pos.x+70, pos.y+5);
  }
}
