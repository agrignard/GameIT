// import UDP library
import hypermedia.net.*;

UDP udp;  // define the UDP object

public class InterFace{
 InterFace(){
   // create a new datagram connection on port 6000
  // and wait for incomming message
  udp = new UDP( this, 12999 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
 }
 
// void receive( byte[] data ) {       // <-- default handler
void receive( byte[] data, String ip, int port ) {  // <-- extended handler
    // get the "real" message =
  // forget the ";\n" at the end <-- !!! only for a communication with Pd !!!
  data = subset(data, 0, data.length-2);
  String message = new String( data );
  String[] list = split(message, ',');
  if(drawer.showInteraction){
    for (int x=0; x<width/grid.cellSize; x++) {
        for (int y=0; y<height/grid.cellSize; y++) {
          grid.cells[x][y]=0;
        }
      }
  grid.cells[int(list[1])][int(list[2])]=1;
  }
  
  
  // print the result
  println( "receive: \""+message+"\" from "+ip+" on port "+port );
}
}