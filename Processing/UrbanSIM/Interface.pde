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
  if(drawer.useLeap){
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

public class SliderHandler{
  ArrayList<Float> globalSliders;
  ArrayList<Float> tmpSliders;
  String newMsg = "";
  
  SliderHandler(){
    // create a new datagram connection on port 6000
    // and wait for incomming message
    udp = new UDP( this, 11999 );

    //udp.log( true );     // <-- printout the connection activity
    udp.listen( true );
   
    globalSliders = new ArrayList<Float> ();
    globalSliders.add(0.5);
    globalSliders.add(0.5);
    
    
    tmpSliders = new ArrayList<Float> ();
    tmpSliders.add(0.5);
    tmpSliders.add(0.5);
    
  }
  
  /**
 * To perform any action on datagram reception, you need to implement this 
 * handler in your code. This method will be automatically called by the UDP 
 * object each time he receive a nonnull message.
 * By default, this method have just one argument (the received message as 
 * byte[] array), but in addition, two arguments (representing in order the 
 * sender IP address and his port) can be set like below.
 */
// void receive( byte[] data ) {       // <-- default handler
void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  // get the "real" message =
  // forget the ";\n" at the end <-- !!! only for a communication with Pd !!!
  data = subset(data, 0, data.length-2);
  String message = new String( data );
   
  newMsg = "receive: " + message +" from "+ip+" on port "+port;
  println(newMsg);
  String[] list = split(newMsg, ' ');
  //println("yo" + float(list[3]));
  if(list[1].equals("/slider00")){
    globalSliders.set(0,float(list[2]));
  }
  if(list[1].equals("/slider01")){
    globalSliders.set(1,float(list[2]));
  }
  
}
  
}