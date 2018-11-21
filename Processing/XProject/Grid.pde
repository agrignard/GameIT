// A class to describe a Grid made of Blocks

class Grid {
  ArrayList<Block> blocks;
  PVector origin;
  int w;
  int h;
  int blockSize;

  Grid(PVector location, int _w, int _h, int _blockSize) {
    origin = location;
    w=_w;
    h=_h;
    blockSize=_blockSize;
    blocks = new ArrayList<Block>();
  }
  
  void addBlock(PVector _location, int _blockSize, int _id){
     blocks.add(new Block(_location, _blockSize, utils.colorMap.get(currentState)));
 }
 
 void clear(){
   blocks.clear();
 }
 


  void run() {
    for (Block b: blocks) {
      b.run();
      b.display(offscreen);
    }
  }
}
