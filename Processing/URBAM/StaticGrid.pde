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
    xllcorner= float(split(lines[2], ' '))[5];
    yllcorner= float(split(lines[3], ' '))[5];
    cellsize = float(split(lines[4], ' '))[6];    
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
    //colorMap.put(0,#000000);colorMap.put(999,#000000);colorMap.put(1,color(230, 0, 255, 255));colorMap.put(9,color(230, 0, 255, 255));colorMap.put(19,color(230, 0, 255, 255));colorMap.put(43,color(0, 230, 230, 255));colorMap.put( 63,color(0, 230, 230, 255));colorMap.put(126,color(0, 230, 230, 255));colorMap.put(138,color(0, 230, 0, 255));
   
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
      block.walkabilityToOfficeweight= 1;
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
        block.walkabilityToOfficeweight= 0;
        for (Block tmpBlock : blocks) {
          float dist = tmpBlock.location.dist(block.location);
          if (dist<wakability) {
            float tempCal =  ( dist/wakability) ;
            //Easing 
            float sqt = sqrt(tempCal);
            tempCal= (sqt / (2.0f * (sqt - tempCal) + 0.5f)) ;
            if (tempCal<tmpBlock.walkabilityToOfficeweight) {
                tmpBlock.walkabilityToOfficeweight= tempCal;
            }; 
          }
        }
      }
      //Wakability to Home HeatMap
      if(block.id==43 || block.id==63 || block.id==126){
        block.walkabilityToOfficeweight= 0;
        for (Block tmpBlock : blocks) {
          float dist = tmpBlock.location.dist(block.location);
          if (dist<wakability) {
            float tempCal =  ( dist/wakability) ;
            //Easing 
            float sqt = sqrt(tempCal);
            tempCal= (sqt / (2.0f * (sqt - tempCal) + 0.5f)) ;
            if (tempCal<tmpBlock.walkabilityToOfficeweight) {
                tmpBlock.walkabilityToOfficeweight= tempCal;
            }; 
          }
        }
      }
    }
  }
    
  public void draw(PGraphics p){
    if(drawer.showStaticGrid){
      for (Block block : blocks) {
        block.display(p);
        /*p.rectMode(CORNER);
        switch(tagViz) {
            case 'E':
            break;
            case 'T':
            p.fill(colorMap.get(block.id));
            p.rect (xllcorner + block.location.x* block.size + block.size * 0.2,yllcorner+block.location.y* block.size + block.size * 0.2, block.size- block.size * 0.2, block.size- block.size * 0.2);
            break;
            case 'W':
              if(block.id== 43 || block.id== 63 || block.id== 126 ){           
                p.fill(colorMap.get(block.id));
                p.rect (xllcorner + block.location.x* block.size + block.size * 0.2,yllcorner+block.location.y* block.size + block.size * 0.2, block.size- block.size * 0.2, block.size- block.size * 0.2);
            
              }
            break;
            case 'P':
              if(block.id== 138){
                p.fill(colorMap.get(block.id));
                p.rect (xllcorner + block.location.x* block.size + block.size * 0.2,yllcorner+block.location.y* block.size + block.size * 0.2, block.size- block.size * 0.2, block.size- block.size * 0.2);
              }
            break;
        }  */  
        
      }
      /*for (int i=0; i<ncols; i++) {
        for (int j=0; j<nrows; j++) {
            p.rectMode(CORNER);
            switch(tagViz) {
            case 'E':
            break;
            case 'T':
              p.fill(colorMap.get(blocks[j][i]));
              p.rect (xllcorner + i*cellsize + cellsize * 0.2,yllcorner+j*cellsize + cellsize * 0.2, cellsize- cellsize * 0.2, cellsize- cellsize * 0.2);
              break;
            case 'W':
              if(blocks[j][i]== 43 || blocks[j][i]== 63 || blocks[j][i]== 126 ){
                p.fill(colorMap.get(blocks[j][i]));
                p.rect (xllcorner + i*cellsize + cellsize * 0.2,yllcorner+j*cellsize + cellsize * 0.2, cellsize- cellsize * 0.2, cellsize- cellsize * 0.2);
              }
            break;
            case 'P':
              if(blocks[j][i]== 138){
                p.fill(colorMap.get(blocks[j][i]));
                p.rect (xllcorner + i*cellsize + cellsize * 0.2,yllcorner+j*cellsize + cellsize * 0.2, cellsize- cellsize * 0.2, cellsize- cellsize * 0.2);
              }
            break;
            }
       }
      }*/
    }
  }
}

public class Block{
  PVector location;
  float size;
  int id;
  float parkWeight;
  float walkabilityToOfficeweight;
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
            case 'W':
            if (walkabilityToOfficeweight<0.5) {
              c = lerpColor(legoGrid.c1, legoGrid.c2, walkabilityToOfficeweight*2);
              } else {
              c = lerpColor(legoGrid.c2, legoGrid.c3, (walkabilityToOfficeweight-0.5)*2);
            }
            p.fill(c);
            p.rect (location.x,location.y, size*0.8, size*0.8);
            if(id==0 || id==9 || id==19 || id==43 || id==63 || id==126){
              p.fill(legoGrid.colorMap.get(id));
              p.rect (location.x+size/4,location.y+size/4, size*0.3, size*0.3);
            }
            break;
      }
      
  }
}
