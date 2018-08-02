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
  //FIXME: Will be reuse for the viewcube
  /*if(drawer.useLeap){
    for (int x=0; x<width/grid.cellSize; x++) {
        for (int y=0; y<height/grid.cellSize; y++) {
          grid.cells[x][y]=0;
        }
      }
  grid.cells[int(list[1])][int(list[2])]=1;
  }*/
  
  
  // print the result
  println( "receive: \""+message+"\" from "+ip+" on port "+port );
}
}

public class SliderHandler{
  ArrayList<Integer> globalSliders;
  ArrayList<Integer> tmpGlobalSliders;
  ArrayList<Integer> localSliders;
  ArrayList<Integer> tmpLocalSliders;
  String newMsg = "";
  
  SliderHandler(){
    // create a new datagram connection on port 6000
    // and wait for incomming message
    udp = new UDP( this, 11999 );

    //udp.log( true );     // <-- printout the connection activity
    udp.listen( true );
   
    globalSliders = new ArrayList<Integer> ();
    globalSliders.add(50);
    globalSliders.add(50);
    
    
    tmpGlobalSliders = new ArrayList<Integer> ();
    tmpGlobalSliders.add(50);
    tmpGlobalSliders.add(50);  
    
    
    localSliders = new ArrayList<Integer> ();
    localSliders.add(50);
    localSliders.add(50);
    localSliders.add(50);
    localSliders.add(50);
    localSliders.add(50);
    localSliders.add(50);
    localSliders.add(50);
    localSliders.add(50);
    localSliders.add(50);
    localSliders.add(50);
    
    
    tmpLocalSliders = new ArrayList<Integer> ();
    tmpLocalSliders.add(50);
    tmpLocalSliders.add(50);
    tmpLocalSliders.add(50);
    tmpLocalSliders.add(50); 
    tmpLocalSliders.add(50);
    tmpLocalSliders.add(50); 
    tmpLocalSliders.add(50);
    tmpLocalSliders.add(50); 
    tmpLocalSliders.add(50);
    tmpLocalSliders.add(50); 
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
  tags.updateTagDensity();
  println(newMsg);
  String[] list = split(newMsg, ' ');
  if(int(list[2])==10){
    globalSliders.set(0,int(list[3]));
  }
  if(int(list[2])==11){
    globalSliders.set(1,int(list[3]));
  }
  
  for (int i=0;i<sliderHandler.localSliders.size();i++){
    if(int(list[2])==i){
      localSliders.set(i,int(list[3]));
    }     
 }
}
  
}
