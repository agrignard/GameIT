public class LegoGrid {
  int ncols;
  int nrows;         
  float xllcorner;
  float yllcorner;
  float cellsize;
  float NODATA_value;
  int[][] blocks;
  String type;

   
  LegoGrid(String[] lines, String _type){
    ncols= int(split(lines[0], ' '))[9];
    nrows= int(split(lines[1], ' '))[9];
    xllcorner= float(split(lines[2], ' '))[5];
    yllcorner= float(split(lines[3], ' '))[5];
    cellsize = float(split(lines[4], ' '))[6];    
    NODATA_value = float(split(lines[5], ' '))[2];
    println("---------- Reading ASCII GRID --------------");
    println("nrows" + nrows);
    println("ncols" + ncols);
    println("xllcorner" + xllcorner);
    println("yllcorner" + yllcorner);
    println("cellsize" + cellsize);
    println("NODATA_value" + NODATA_value);
    blocks= new int[nrows][ncols];
    for (int i = 0 ; i < lines.length -6; i++) {
      float[] nums = float(split(lines[i+6], ' '));
      for (int j = 0 ; j < nums.length-1; j++) {
        //mirrored
        //blocks[(nrows-1)-i][j] = int(nums[j]);
        blocks[i][j] = int(nums[j]);
        
      }
    }
    type=_type;
  }
    
  public void draw(PGraphics p){
    for (int i=0; i<ncols; i++) {
      for (int j=0; j<nrows; j++) {
        if (type.equals("regular") && drawer.showLegoGrid){
          //p.stroke(#AAAAAA);
          p.rectMode(CORNER);
          p.fill(50+blocks[j][i]*10,0,0);
          p.rect (xllcorner + i*cellsize,yllcorner+j*cellsize, cellsize, cellsize);
        }
        if (type.equals("interactive") && drawer.showInteractiveGrid){
          p.rectMode(CORNER);
          p.stroke(#AAAAAA);
          p.fill(blocks[j][i],0,0);
          p.rect (xllcorner + i*(cellsize + cellsize/4),yllcorner+j*(cellsize+cellsize/4), cellsize, cellsize);
        } 
     }
    }
  }
}

public class Block{
  PVector location;
  int size;
  int id;
  int data;
  
   Block(PVector l, int _size, int _id, int _data) {
    location = l.copy();
    size = _size;
    id= _id;
    data= _data;
  }
  void run(){
  }
  
  void display(PGraphics p){
    p.fill(data*10);
      p.rect(location.x, location.y, size, size); 
  }
}
