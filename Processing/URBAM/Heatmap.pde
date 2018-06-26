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
        drawHeatMapsLegend(p,new PVector(100,height*0.9));
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
