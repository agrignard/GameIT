public class LegoGrid {
  int ncols;
  int nrows;         
  float xllcorner;
  float yllcorner;
  float cellsize;
  float NODATA_value;

  int[][] blocks;
  int n=160;
  color c;
  
  
  LegoGrid(String[] lines){
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
        //println(nums[j]);
        //println("i:" + i + " j:" + j);
        blocks[i][j] = int(nums[j]);
      }
    }
  }
  
  LegoGrid(  int _ncols, int _nrows, int _xllcorner, int _yllcorner, int _cellsize, int _NODATA_value){
    ncols=_ncols;
    nrows=_nrows;
    xllcorner= _xllcorner;
    yllcorner= _yllcorner;
    cellsize = _cellsize;
    NODATA_value = _NODATA_value;
    blocks = new int[n][n/2];
    for (int x=0; x<n; x++) {
      for (int y=0; y<n/2; y++) {
        blocks[x][y] = 0;
      }
    }
  }
  
  public void draw(PGraphics p){
    for (int i=0; i<ncols; i++) {
      for (int j=0; j<nrows; j++) {
            p.rectMode(CORNER);
            p.stroke(#AAAAAA);
            p.fill(blocks[j][i],0,0);
            //p.fill(random(255), random(255), random(255));
            //p.fill(random(255), random(255), random(255));
            p.rect (xllcorner + i*cellsize,yllcorner+j*cellsize, cellsize, cellsize);
          }
        }
  }
}
