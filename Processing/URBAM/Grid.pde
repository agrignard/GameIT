public class Grid {
  int[][] cells;
  int cellSize = playGroundWidth/20;
  PVector curActiveGridPos;
  
  Grid(){
    cells = new int[width/cellSize][height/cellSize];
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0;
      }
    }
    curActiveGridPos = new PVector(0,0);
  }
  
  public void draw(PGraphics p){
   if(drawer.showViewCube){
      p.noFill();      
      p.fill(255);
      p.rect (mouseX, mouseY, cellSize, cellSize,cellSize/20);
      curActiveGridPos.x=mouseX;
      curActiveGridPos.y=mouseY;
      drawViewCubeMicroSquare(p, mouseX,mouseY);     
    }
  }
  
  
  public void DrawMicroGrid(PGraphics p, int x, int y){
    p.rectMode(CENTER);    
    int gridSize = 16;
    for (int i=0; i<gridSize; i++) {
      for (int j=0; j<gridSize; j++) {   
        p.stroke(125);
        p.noFill();
        p.rect (x+i*cellSize/gridSize-cellSize/2+gridSize/2,y+j*cellSize/gridSize-cellSize/2+gridSize/2, cellSize/gridSize, cellSize/gridSize);            
      }
    }
  }
  
  public void drawViewCubeMicroSquare(PGraphics p, int x, int y){
      p.rectMode(CENTER);      
      //Draw ViewCube Area
      p.stroke(255,0,0,125);
      p.strokeWeight(2);
      p.fill(255,255,255,125);
      p.rect (x, y, cellSize, cellSize,cellSize/20);
      p.noStroke();
      
      //Draw Agent inside ViewCube Area
      PVector toCompare= new PVector(x,y);
      ArrayList<Agent> tmp2 = model.getAgentInsideROI(toCompare,cellSize);
      for (int i=0;i<tmp2.size();i++){
         p.noStroke();
         p.fill(tmp2.get(i).myProfileColor);
         p.ellipse(tmp2.get(i).pos.x, tmp2.get(i).pos.y, tmp2.get(i).size, tmp2.get(i).size);
      }
  }
}
