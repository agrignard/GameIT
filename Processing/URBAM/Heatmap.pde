public class Heatmap {
  int[][] heatmapCells;
  int heatMapcellSize = playGroundWidth/100;
  
  Heatmap(){
    heatmapCells = new int[width/heatMapcellSize][height/heatMapcellSize];
    for (int x=0; x<width/heatMapcellSize; x++) {
      for (int y=0; y<height/heatMapcellSize; y++) {
        heatmapCells[x][y] = 0;
      }
    }
  }
  
  public void draw(PGraphics p){
    if(drawer.showHeatmap){
        for (int x=0; x<width/heatMapcellSize; x++) {
          for (int y=0; y<height/heatMapcellSize; y++) {
            p.rectMode(CORNER);
            //PVector ratio = model.getLinvingAndWorkingInsideROI(new PVector(x*heatMapcellSize,y*heatMapcellSize),heatMapcellSize);
            float nbPeople= model.getAgentInsideROI(new PVector(x*heatMapcellSize,y*heatMapcellSize),heatMapcellSize).size();
            //p.fill(lerpColor(model.workingColor, model.livingColor, nbPeople/10.0));
            p.fill(lerpColor(#000000, #0000FF, nbPeople/10.0));
            p.noStroke();
            p.rect (x*heatMapcellSize,y*heatMapcellSize, heatMapcellSize, heatMapcellSize);
            p.rectMode(CENTER);
          }
        }
    }
    if(drawer.showMobilityHeatmap){
        for (int x=0; x<width/heatMapcellSize; x++) {
          for (int y=0; y<height/heatMapcellSize; y++) {
            p.rectMode(CORNER);
            float nbCar = model.getAgentInsideROI(new PVector(x*heatMapcellSize,y*heatMapcellSize),heatMapcellSize,"car").size();
            if(nbCar>0){
              p.fill(lerpColor(#000000, #FF0000, nbCar/5.0));
              p.noStroke();
              p.rect (x*heatMapcellSize,y*heatMapcellSize, heatMapcellSize, heatMapcellSize);
            }
            
            float nbPeople = model.getAgentInsideROI(new PVector(x*heatMapcellSize,y*heatMapcellSize),heatMapcellSize,"people").size();
            if(nbPeople>0){
              p.fill(lerpColor(#000000, #00FF00, nbPeople/5.0));
              p.noStroke();
              p.rect (x*heatMapcellSize,y*heatMapcellSize, heatMapcellSize, heatMapcellSize);
              p.rectMode(CENTER);
            }   
          }
        }
    }
  }
}
