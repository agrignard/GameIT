public class StaticGrid {
  int ncols;
  int nrows;         
  float xllcorner;
  float yllcorner;
  float cellsize;
  float NODATA_value;
  //int[][] blocks;
  ArrayList<Block> blocks;
  
  String type;
  HashMap<Integer,Integer> colorMap = new HashMap<Integer,Integer>();
  int walkabilityDistance = 10;
  color c1 = color(0, 255, 0);
  color c2 = color(255, 255, 0);
  color c3 = color(255, 0, 0);

   
  StaticGrid(String[] lines){
    ncols= int(split(lines[0], ' '))[9];
    nrows= int(split(lines[1], ' '))[9];
    xllcorner= float(split(lines[2], ' '))[5]*sizeScale;
    yllcorner= float(split(lines[3], ' '))[5]*sizeScale;
    cellsize = float(split(lines[4], ' '))[6]*sizeScale;    
    NODATA_value = float(split(lines[5], ' '))[2];
    /*println("---------- Reading ASCII GRID --------------");
    println("nrows" + nrows);
    println("ncols" + ncols);
    println("xllcorner" + xllcorner);
    println("yllcorner" + yllcorner);
    println("cellsize" + cellsize);
    println("NODATA_value" + NODATA_value);*/
    //blocks= new int[nrows][ncols];
    blocks = new ArrayList<Block>();
    colorMap = new HashMap<Integer,Integer>();
    colorMap.put(999,color(0, 80, 80, 200));colorMap.put(0,#ff00ff);colorMap.put(9,#b802ff);colorMap.put(19,#a200ff);
    colorMap.put(43,#00ffff);colorMap.put( 63,#0099ff);colorMap.put(126,#00ffd5);colorMap.put(138,#a2ff00);
   
    for (int i = 0 ; i < lines.length -6; i++) {
      float[] nums = float(split(lines[i+6], ' '));
      for (int j = 0 ; j < nums.length-1; j++) {
        //mirrored
        //blocks[(nrows-1)-i][j] = int(nums[j]);
        if(int(nums[j]) != -2 && j!=0){
          float highwaySpacer = 0;
          if (j>58) {
          highwaySpacer= 14.175*.2;
          }
          Block tempBlock = new Block(new PVector(xllcorner + j*cellsize + highwaySpacer, yllcorner + i*cellsize), cellsize,int(nums[j]));
          blocks.add(tempBlock);
        }
        //blocks[i][j] = int(nums[j]);
      }
    }
    updateWeight();
  }
  
  public void updateWeight(){
    float wakability = 130;
    for (Block block : blocks) {
      block.parkWeight= 1;//random(100)/100.0;
      block.walkabilityToOfficeWeight= 1;
      block.walkabilityToHomeWeight = 1;
      //Park HeatMap
      if(block.id == 138){
        block.parkWeight= 0;
        for (Block tmpBlock : blocks) {
          float dist = tmpBlock.location.dist(block.location);
          if (dist<wakability) {
            float tempCal =  ( dist/wakability) ;
            //Easing 
            float sqt = sqrt(tempCal);
            tempCal= (sqt / (2.0f * (sqt - tempCal) + 0.5f)) ;
            if (tempCal<tmpBlock.parkWeight) {
                tmpBlock.parkWeight= tempCal;
            }; 
          }
        }
      }
      //Wakability to Office HeatMap
      if(block.id==43 || block.id==63 || block.id==126){
        block.walkabilityToOfficeWeight= 0;
        for (Block tmpBlock : blocks) {
          float dist = tmpBlock.location.dist(block.location);
          if (dist<wakability) {
            float tempCal =  ( dist/wakability) ;
            //Easing 
            float sqt = sqrt(tempCal);
            tempCal= (sqt / (2.0f * (sqt - tempCal) + 0.5f)) ;
            if (tempCal<tmpBlock.walkabilityToOfficeWeight) {
                tmpBlock.walkabilityToOfficeWeight= tempCal;
            }; 
          }
        }
      }
      //Wakability to Home HeatMap
      if(block.id==0 || block.id==9 || block.id==19){
        block.walkabilityToHomeWeight= 0;
        for (Block tmpBlock : blocks) {
          float dist = tmpBlock.location.dist(block.location);
          if (dist<wakability) {
            float tempCal =  ( dist/wakability) ;
            //Easing 
            float sqt = sqrt(tempCal);
            tempCal= (sqt / (2.0f * (sqt - tempCal) + 0.5f)) ;
            if (tempCal<tmpBlock.walkabilityToHomeWeight) {
                tmpBlock.walkabilityToHomeWeight= tempCal;
            }; 
          }
        }
      }
      // Traffic HeatMap
      block.trafficWeight = model.getAgentInsideROI(block.location,int(block.size)).size()/2.0;
    }
  }
    
  public void draw(PGraphics p){
    if(drawer.showStaticGrid){
      for (Block block : blocks) {
        block.display(p);
    }
  }
}

public class Block{
  PVector location;
  float size;
  int id;
  float parkWeight;
  float walkabilityToOfficeWeight;
  float walkabilityToHomeWeight;
  float trafficWeight;
  color c = color(255, 255, 255);
  Block(PVector l, float _size, int _id) {
    location = l.copy();
    size = _size;
    id= _id;
  }
  
  void display(PGraphics p){
      p.rectMode(CORNER);
      switch(tagViz) {
            case 'E':
            break;
            case 'T':
            p.fill(legoGrid.colorMap.get(id));
            p.rect (location.x,location.y, size*0.8, size*0.8);
            break;
            case 'P':
            
            if (parkWeight<0.5) {
              c = lerpColor(legoGrid.c1, legoGrid.c2, parkWeight*2);
              } else {
              c = lerpColor(legoGrid.c2, legoGrid.c3, (parkWeight-0.5)*2);
            }
            p.fill(c);
            p.rect (location.x,location.y, size*0.8, size*0.8);
            break;
            case 'O':
            if (walkabilityToOfficeWeight<0.5) {
              c = lerpColor(legoGrid.c1, legoGrid.c2, walkabilityToOfficeWeight*2);
              } else {
              c = lerpColor(legoGrid.c2, legoGrid.c3, (walkabilityToOfficeWeight-0.5)*2);
            }
            p.fill(c);
            p.rect (location.x,location.y, size*0.8, size*0.8);
            if(id==0 || id==9 || id==19 || id==43 || id==63 || id==126){
              p.fill(legoGrid.colorMap.get(id));
              p.rect (location.x+size/4,location.y+size/4, size*0.3, size*0.3);
            }
            break;
           case 'R':
            if (walkabilityToHomeWeight<0.5) {
              c = lerpColor(legoGrid.c1, legoGrid.c2, walkabilityToHomeWeight*2);
              } else {
              c = lerpColor(legoGrid.c2, legoGrid.c3, (walkabilityToHomeWeight-0.5)*2);
            }
            p.fill(c);
            p.rect (location.x,location.y, size*0.8, size*0.8);
            if(id==0 || id==9 || id==19 || id==43 || id==63 || id==126){
              p.fill(legoGrid.colorMap.get(id));
              p.rect (location.x+size/4,location.y+size/4, size*0.3, size*0.3);
            }
            break;
           case 'H':
            if(frameCount % 60 ==0){
              trafficWeight = model.getAgentInsideROI(location,int(size)).size()/2.0;
            }
            if (trafficWeight<0.5) {
              c = lerpColor(legoGrid.c1, legoGrid.c2, trafficWeight*2);
              } else {
              c = lerpColor(legoGrid.c2, legoGrid.c3, (trafficWeight-0.5)*2);
              } 
            p.fill(c,150);
            p.rect (location.x,location.y, size*0.8, size*0.8);
        }
      }
  }  
}
