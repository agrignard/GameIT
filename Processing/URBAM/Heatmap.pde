public class Heatmap {
  int[][] heatmapCells;
  int heatMapcellSize = playGroundWidth/100;
  ArrayList<String> heatmapTypesPerCategory;
    
  
  Heatmap(){
    heatmapCells = new int[width/heatMapcellSize][height/heatMapcellSize];
    heatmapTypesPerCategory = new ArrayList<String>(Arrays.asList("R","Restaurant","Night","GP","Cultural","Shopping","HS","Uni","O"));
    for (int x=0; x<width/heatMapcellSize; x++) {
      for (int y=0; y<height/heatMapcellSize; y++) {
        heatmapCells[x][y] = 0;
      }
    }
  }
  
  public void draw(PGraphics p){
    if(drawer.showHeatmap || (cf.currentHeatMapType!=null)){
     drawHeatmap(p);
    }
    if(drawer.showHeatmap){
      if(frameCount % 100 ==0){
        computeHeatMap();
      }
      drawHeatmap(p);
    }
  }
  
  public void drawHeatmap(PGraphics p){
    for (int x=0; x<width/heatMapcellSize; x++) {
      for (int y=0; y<height/heatMapcellSize; y++) {
        p.rectMode(CORNER);
        p.fill(lerpColor(#FFFFFF, #00FF00, heatmapCells[x][y]/10.0));
        p.noStroke();
        p.rect (x*heatMapcellSize,y*heatMapcellSize, heatMapcellSize, heatMapcellSize);
        p.rectMode(CENTER);
      }
    }
  }
  
  
  public void computeHeatMap(){
    for (int x=0; x<width/heatMapcellSize; x++) {
      for (int y=0; y<height/heatMapcellSize; y++) {
        heatmapCells[x][y]= model.getAgentInsideROI(new PVector(x*heatMapcellSize,y*heatMapcellSize),heatMapcellSize).size();
      }
    }
  }
    
  public void computeHeatMapType(String type){
    for (int x=0; x<width/heatMapcellSize; x++) {
      for (int y=0; y<height/heatMapcellSize; y++) {
        heatmapCells[x][y]= buildings.getBuildingInsideROIWithType(new PVector(x*heatMapcellSize,y*heatMapcellSize),heatMapcellSize,type).size(); 
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
