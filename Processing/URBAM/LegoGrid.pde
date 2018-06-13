public class LegoGrid {
  int ncols;
  int nrows;         
  int xllcorner;
  int yllcorner;
  int cellsize;
  int NODATA_value;

  int[][] blocks;
  int n=160;
  color c;
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
            //p.fill(random(255), random(255), random(255));
            //p.fill(random(255), random(255), random(255));
            p.rect (xllcorner + i*cellsize,yllcorner+j*cellsize, cellsize, cellsize);
          }
        }
  }
}
