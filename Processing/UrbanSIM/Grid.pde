public class Grid {
  int[][] cells;
  int cellSize = playGroundWidth/20;
  int[][] heatmapCells;
  int heatMapcellSize = playGroundWidth/50;
  
  Grid(){
    cells = new int[width/cellSize][height/cellSize];
    heatmapCells = new int[width/heatMapcellSize][height/heatMapcellSize];
      // Initialization of cells
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0;
      }
    }
  }
  
  public void draw(PGraphics p){
    
    if(drawer.showHeatmap){
        for (int x=0; x<width/heatMapcellSize; x++) {
          for (int y=0; y<height/heatMapcellSize; y++) {
            p.rectMode(CENTER);
            PVector ratio = getLinvingAndWorkingInsideROI(models.get(0),new PVector(x*heatMapcellSize,y*heatMapcellSize),heatMapcellSize);
            p.fill(ratio.x*50,ratio.y*50,0);
            p.noStroke();
            p.rect (x*heatMapcellSize,y*heatMapcellSize, heatMapcellSize, heatMapcellSize);            
          }
        }
    }
    if(drawer.showInteraction){
      p.fill(0,0,0,100);
      p.rect(width/2,height/2,width,height);
      p.noFill();      
      if(drawer.useLeap){
        for (int x=0; x<width/cellSize; x++) {
          for (int y=0; y<height/cellSize; y++) {
            p.stroke(125);
            p.noFill();
            p.rect (x*cellSize+cellSize/2, y*cellSize+cellSize/2, cellSize, cellSize);
            if(cells[x][y]==1){
              if(drawer.useLeap){
                 drawMicroSquare(p, x*cellSize+cellSize/2,y*cellSize+cellSize/2);
              }
           }
         }
       }
      }
      else{
         p.fill(255);
         p.rect (mouseX, mouseY, cellSize, cellSize,cellSize/20);
         drawMicroSquare(p, mouseX,mouseY);
      }      
    }
  }
  
  
  public void drawMicroSquare(PGraphics p, int x, int y){
      p.rectMode(CENTER);
      boolean showMicroGrid=false;
      int gridSize = 16;
      if (showMicroGrid){
        for (int i=0; i<gridSize; i++) {
          for (int j=0; j<gridSize; j++) {
           
            p.stroke(125);
            p.noFill();
            p.rect (x+i*cellSize/gridSize-cellSize/2+gridSize/2,y+j*cellSize/gridSize-cellSize/2+gridSize/2, cellSize/gridSize, cellSize/gridSize);            
          }
        }
      }
    
      
      p.fill(255);
      p.rect (x, y, cellSize, cellSize,cellSize/20);
      PVector toCompare= new PVector(x,y);
      ArrayList<PShape> tmp = getBuildingInsideROI(toCompare,cellSize);
      for (int i=0;i<tmp.size();i++){
        p.fill(255,0,0);
        p.shape(tmp.get(i), 0, 0);
        createStaticAgent(p,tmp.get(i));
      }
      ArrayList<Agent> tmp2 = getAgentInsideROI(models.get(0),toCompare,cellSize);
      for (int i=0;i<tmp2.size();i++){
         p.fill(255,0,0);
         p.fill(tmp2.get(i).myProfileColor);
         p.ellipse(tmp2.get(i).pos.x, tmp2.get(i).pos.y, tmp2.get(i).size, tmp2.get(i).size);
      }
      /*tmp2 = getAgentInsideROI(models.get(1),toCompare,cellSize);
      for (int i=0;i<tmp2.size();i++){
         p.fill(255,0,0);
         p.fill(tmp2.get(i).myProfileColor);
         p.ellipse(tmp2.get(i).pos.x, tmp2.get(i).pos.y, tmp2.get(i).size, tmp2.get(i).size);
      }*/
  }
  
  public void createStaticAgent(PGraphics p,PShape shape){
    //if(frameCount %30 ==0){
    PVector pos = shape.getVertex(0);//int(random(shape.getVertexCount())));
    p.fill(#FF0000);
    //p.fill(models.get(0).colors.get(int(random(9))));
    //models.get(0).agents.add( new Agent(0, roads, models.get(0).profiles.get(int(random(models.get(0).profiles.size()))), "people", "living"));
    p.ellipse(pos.x,pos.y,10,10); 
    //}
    //p.ellipse(pos.x,pos.y,10,10); 
  }
  
  public ArrayList<PShape> getBuildingInsideROI(PVector pos, int size){
    ArrayList<PShape> tmp = new ArrayList<PShape>();
    for (int i=0;i<buildings.buildings.size();i++){
        if(((buildings.buildings.get(i).getVertex(0).x>pos.x-size/2) && (buildings.buildings.get(i).getVertex(0).x)<pos.x+size/2) &&
        ((buildings.buildings.get(i).getVertex(0).y>pos.y-size/2) && (buildings.buildings.get(i).getVertex(0).y)<pos.y+size/2))
        {
          tmp.add(buildings.buildings.get(i));
        }       
      }
    return tmp;
  }
  
  public ArrayList<Agent> getAgentInsideROI(ABM model,PVector pos, int size){
    ArrayList<Agent> tmp = new ArrayList<Agent>();
    for (int i=0;i<model.agents.size();i++){
        if(((model.agents.get(i).pos.x>pos.x-size/2) && (model.agents.get(i).pos.x)<pos.x+size/2) &&
        ((model.agents.get(i).pos.y>pos.y-size/2) && (model.agents.get(i).pos.y)<pos.y+size/2))
        {
          tmp.add(model.agents.get(i));
        }       
      }
    return tmp;
  }
  
  public PVector getLinvingAndWorkingInsideROI(ABM model,PVector pos, int size){
    PVector tmp = new PVector();
    for (int i=0;i<model.agents.size();i++){
        if(((model.agents.get(i).pos.x>pos.x-size/2) && (model.agents.get(i).pos.x)<pos.x+size/2) &&
        ((model.agents.get(i).pos.y>pos.y-size/2) && (model.agents.get(i).pos.y)<pos.y+size/2))
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