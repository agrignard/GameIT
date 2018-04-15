public class Grid {
  int[][] cells;
  int cellSize = playGroundWidth/10;
  
  Grid(){
    cells = new int[width/cellSize][height/cellSize];
      // Initialization of cells
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        float state = random (100);
        cells[x][y] = int(state); // Save state of each cell
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
        }
      }
        p.fill(255);
      p.rect (int(mouseX/cellSize)*cellSize, int(mouseY/cellSize)*cellSize, cellSize, cellSize);
    }
  }
}