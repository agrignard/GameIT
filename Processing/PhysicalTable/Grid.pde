public class Grid {
  int[][] cells;
  int cellSize = playGroundWidth/20;
  
  Grid(){
    cells = new int[width/cellSize][height/cellSize];
      // Initialization of cells
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        float state = random (100);
        cells[x][y] = 0; // Save state of each cell
      }
    }
  }
  
  public void draw(PGraphics p){
    if(drawer.showgrid){
      for (int x=0; x<width/cellSize; x++) {
        for (int y=0; y<height/cellSize; y++) {
          p.stroke(153);
          p.noFill();
          p.rect (x*cellSize, y*cellSize, cellSize, cellSize);
          if(cells[x][y]==1){
            p.fill(255,0,0);
            p.rect (x*cellSize, y*cellSize, cellSize, cellSize);
          }
        }
      }
      p.rectMode(CENTER);
      p.fill(255);
      p.rect (mouseX, mouseY, cellSize*2, cellSize*2);
      PVector toCompare= new PVector(mouseX,mouseY);
      for (int i=0;i<buildings.buildings.size();i++){
        if(((buildings.buildings.get(i).getVertex(0).x<toCompare.x-100) ||(buildings.buildings.get(i).getVertex(0).x)>toCompare.x+100) ||
        ((buildings.buildings.get(i).getVertex(0).y<toCompare.y-100) || (buildings.buildings.get(i).getVertex(0).y)>toCompare.y+100))
    
        {
          //p.fill(255,0,0);
          //p.shape(buildings.buildings.get(i), 0, 0);
        }
        else{
          p.fill(255,0,0);
          p.shape(buildings.buildings.get(i), 0, 0);
        }
        
      }
    }
  }
}