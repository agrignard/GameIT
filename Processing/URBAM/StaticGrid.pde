public class StaticGrid {
  int ncols;
  int nrows;         
  float xllcorner;
  float yllcorner;
  float cellsize;
  float NODATA_value;
  int[][] blocks;
  String type;
  HashMap<Integer,Integer> colorMap = new HashMap<Integer,Integer>();

   
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
    blocks= new int[nrows][ncols];
    colorMap = new HashMap<Integer,Integer>();
    //colorMap.put(0,#000000);colorMap.put(999,#000000);colorMap.put(1,#ff00ff);colorMap.put(9,#b802ff);colorMap.put(19,#a200ff);colorMap.put(43,#00ffff);colorMap.put( 63,#0099ff);colorMap.put(126,#00ffd5);colorMap.put(138,#a2ff00);
    colorMap.put(0,#000000);colorMap.put(999,#000000);colorMap.put(1,color(230, 0, 255, 255));colorMap.put(9,color(230, 0, 255, 255));colorMap.put(19,color(230, 0, 255, 255));colorMap.put(43,color(0, 230, 230, 255));colorMap.put( 63,color(0, 230, 230, 255));colorMap.put(126,color(0, 230, 230, 255));colorMap.put(138,color(0, 230, 0, 255));
   
    for (int i = 0 ; i < lines.length -6; i++) {
      float[] nums = float(split(lines[i+6], ' '));
      for (int j = 0 ; j < nums.length-1; j++) {
        //mirrored
        //blocks[(nrows-1)-i][j] = int(nums[j]);
        blocks[i][j] = int(nums[j]);
        
      }
    }
  }
    
  public void draw(PGraphics p){
    for (int i=0; i<ncols; i++) {
      for (int j=0; j<nrows; j++) {
          p.rectMode(CORNER);
          switch(tagViz) {
          case 'E':
          break;
          case 'T':
            p.fill(colorMap.get(blocks[j][i]));
            p.rect (xllcorner + i*cellsize,yllcorner+j*cellsize, cellsize, cellsize);
            break;
          case 'W':
            if(blocks[j][i]== 43 || blocks[j][i]== 63 || blocks[j][i]== 126 ){
              p.fill(colorMap.get(blocks[j][i]));
              p.rect (xllcorner + i*cellsize,yllcorner+j*cellsize, cellsize, cellsize);
            }
          break;
          case 'P':
            if(blocks[j][i]== 138){
              p.fill(colorMap.get(blocks[j][i]));
              p.rect (xllcorner + i*cellsize,yllcorner+j*cellsize, cellsize, cellsize);
            }
          break;
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
