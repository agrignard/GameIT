public class Grid {
  int[][] cells;
  int cellSize = playGroundWidth/50;
  
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
    if(drawer.showHeatmap){
        for (int x=0; x<width/cellSize; x++) {
          for (int y=0; y<height/cellSize; y++) {
            p.rectMode(CENTER);
            PVector ratio = getLinvingAndWorkingInsideROI(models.get(0),new PVector(x*cellSize,y*cellSize),cellSize);
            p.fill(ratio.x*20,ratio.y*20,0);
            p.noStroke();
            p.rect (x*cellSize,y*cellSize, cellSize, cellSize);
            //p.ellipse (x*cellSize,y*cellSize, cellSize, cellSize);
            if(cells[x][y]==1){
              p.fill(255,0,0);
              p.rect (x*cellSize, y*cellSize, cellSize, cellSize);
            }
          }
        }
    }
    if(drawer.showgrid){
      p.rectMode(CENTER);
      p.fill(255);
      p.rect (mouseX, mouseY, cellSize*5, cellSize*5);
      PVector toCompare= new PVector(mouseX,mouseY);
      ArrayList<PShape> tmp = getBuildingInsideROI(toCompare,100);
      for (int i=0;i<tmp.size();i++){
        p.fill(255,0,0);
        p.shape(tmp.get(i), 0, 0);
      }
      ArrayList<Agent> tmp2 = getAgentInsideROI(models.get(0),toCompare,100);
      for (int i=0;i<tmp2.size();i++){
        p.fill(255,0,0);
       p.ellipse(tmp2.get(i).pos.x, tmp2.get(i).pos.y, tmp2.get(i).size, tmp2.get(i).size);
      }
      
      PVector ratio = getLinvingAndWorkingInsideROI(models.get(0),toCompare,100);
      p.noFill();
      //p.fill(ratio.x*10,ratio.y*10,0);
      p.rect (mouseX, mouseY, cellSize*5, cellSize*5);
    }
  }
  
  public ArrayList<PShape> getBuildingInsideROI(PVector pos, int size){
    ArrayList<PShape> tmp = new ArrayList<PShape>();
    for (int i=0;i<buildings.buildings.size();i++){
        if(((buildings.buildings.get(i).getVertex(0).x>pos.x-size) && (buildings.buildings.get(i).getVertex(0).x)<pos.x+size) &&
        ((buildings.buildings.get(i).getVertex(0).y>pos.y-size) && (buildings.buildings.get(i).getVertex(0).y)<pos.y+size))
        {
          tmp.add(buildings.buildings.get(i));
        }       
      }
    return tmp;
  }
  
  public ArrayList<Agent> getAgentInsideROI(ABM model,PVector pos, int size){
    ArrayList<Agent> tmp = new ArrayList<Agent>();
    for (int i=0;i<model.agents.size();i++){
        if(((model.agents.get(i).pos.x>pos.x-size) && (model.agents.get(i).pos.x)<pos.x+size) &&
        ((model.agents.get(i).pos.y>pos.y-size) && (model.agents.get(i).pos.y)<pos.y+size))
        {
          tmp.add(model.agents.get(i));
        }       
      }
    return tmp;
  }
  
  public PVector getLinvingAndWorkingInsideROI(ABM model,PVector pos, int size){
    PVector tmp = new PVector();
    for (int i=0;i<model.agents.size();i++){
        if(((model.agents.get(i).pos.x>pos.x-size) && (model.agents.get(i).pos.x)<pos.x+size) &&
        ((model.agents.get(i).pos.y>pos.y-size) && (model.agents.get(i).pos.y)<pos.y+size))
        {
          if(model.agents.get(i).usage.equals("living")){
            tmp.x++;
          }else{
            tmp.y++;
          }
        }       
      }
    return tmp;
  }
}