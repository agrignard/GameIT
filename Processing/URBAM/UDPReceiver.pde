import hypermedia.net.*;


public class UDPReceiver{

UDP udp;  // define the UDP object
int udpPort = 15800; //UDP Port 15800  
int index;

//boolean messageDelta = false;
String[] oldSplitParts;
String oldMessage = "";

String[] splitParts;

String[] maskParts;

String messageMask = 

  "i -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 138 -1 -1 -1 -1 460 43 63 43 645 -2 -2 -2 -2 -2 -2 -2 -2 -2 "+
  "-2 -2 -2 -2 138 -2 -2 -2 -2 -1 0 126 9 19 -1 -1 -1 138 43 63 43 0 63 0 43 460 126 43 138 0 138 -2 "+
  "-2 -2 -2 -1 63 126 0 0 126 19 126 9 0 126 43 -1 -1 138 63 63 19 19 19 43 63 63 63 0 296 63 -1 -2 "+
  "-2 -2 -1 -1 -1 -1 -1 -1 9 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -2 "+
  "-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 138 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 19 "+
  "9 126 19 -1 0 63 0 -1 19 43 126 126 645 306 176 400 -1 138 0 63 126 19 63 126 0 0 0 138 -1 138 126 126 "+
  "9 0 63 988 0 19 0 19 126 715 563 126 0 0 682 43 -1 138 469 375 0 126 63 0 988 63 0 0 43 306 0 43 "+
  "0 126 0 996 43 126 126 0 9 682 63 9 606 43 126 460 996 138 0 0 126 126 0 0 306 0 43 126 0 0 43 -1 "+
  "645 138 0 43 63 799 9 126 176 0 63 563 19 126 126 19 375 138 176 715 126 43 126 -1 0 400 126 43 0 43 0 -1 "+
  "-1 -1 138 9 138 126 375 43 138 488 488 126 126 375 19 126 9 138 43 988 715 0 0 563 138 296 63 126 0 0 996 -1 "+
  "-1 -1 -1 0 138 0 0 138 138 43 43 126 400 296 43 126 126 176 126 126 0 0 126 63 0 0 63 0 0 19 488 -1 "+
  "-1 -1 -1 -1 126 -1 -1 -1 -1 43 43 126 0 0 606 296 138 682 19 296 996 375 63 873 460 0 0 43 827 606 606 -1 "+
  "-1 -1 -1 -1 -1 -1 -1 138 -1 -1 -1 -1 -1 715 873 43 9 138 63 400 682 799 827 -1 -1 -1 -1 -1 -1 138 -1 43 "+
  "63 63 63 63 63 19 63 138 63 43 43 0 9 9 -1 -1 138 126 43 0 43 43 63 19 0 0 -1 -1 -1 -1 -1 43 "+
  "799 19 19 63 19 19 19 138 375 9 0 0 43 43 -1 -1 126 138 19 19 19 63 63 19 63 19 19 19 63 63 0 96 "+
  "0 63 0 126 460 9 9 138 43 126 9 126 43 126 -1 -1 19 138 63 63 63 0 0 63 63 0 0 63 63 43 43 63 "+
  "63 126 9 0 0 400 19 138 43 43 126 0 126 138 -1 138 0 138 63 0 0 0 63 63 0 0 0 0 19 43 0 9 "+
  "126 0 63 799 19 715 63 43 43 43 9 138 0 43 -1 -1 0 19 138 0 138 19 0 0 19 19 19 19 138 43 0 138 "+
  "63 126 63 0 19 0 19 138 0 996 138 43 9 43 -1 -1 43 19 138 0 0 0 0 0 0 0 19 0 0 0 0 138 "+
  "138 63 138 19 19 0 63 138 126 606 63 43 0 43 -1 -1 469 0 0 138 138 0 0 0 0 0 0 0 400 0 873 63 "+
  "63 9 43 43 0 138 63 138 126 19 19 138 0 43 -1 -1 43 43 -1 -1 138 0 0 0 0 0 0 0 0 0 176 9 "+
  "19 0 63 63 0 460 63 138 126 0 9 138 43 0 -1 -1 19 9 -1 -1 63 138 138 0 0 0 0 0 0 0 469 9 "+
  "9 63 19 0 873 138 63 306 -1 -1 -1 -1 43 0 -1 -1 19 0 19 63 63 63 43 138 138 0 0 0 0 63 0 0 "+
  "126 9 63 126 126 63 -1 -1 -1 -1 -1 138 -1 0 -1 -1 19 9 19 19 19 19 19 19 126 138 138 138 126 -1 -1 0 "+
  "306 0 138 -1 -1 -1 -1 -1 -1 -1 -1 138 -1 9 -1 -1 63 0 19 19 19 19 19 19 126 126 -1 138 138 -1 -1 19 "+
  "0 0 63 -1 -1 -1 -1 -1 -1 0 -1 138 0 63 -1 -1 63 63 375 19 19 19 19 19 -1 -1 -1 -1 138 138 -1";

String messageIn = 

  "i -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 138 -1 -1 -1 -1 460 43 63 43 645 -2 -2 -2 -2 -2 -2 -2 -2 -2 "+
  "-2 -2 -2 -2 138 -2 -2 -2 -2 -1 0 126 9 19 -1 -1 -1 138 43 63 43 0 63 0 43 460 126 43 138 0 138 -2 "+
  "-2 -2 -2 -1 63 126 0 0 126 19 126 9 0 126 43 -1 -1 138 63 63 19 19 19 43 63 63 63 0 296 63 -1 -2 "+
  "-2 -2 -1 -1 -1 -1 -1 -1 9 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -2 "+
  "-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 138 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 19 "+
  "9 126 19 -1 0 63 0 -1 19 43 126 126 645 306 176 400 -1 138 0 63 126 19 63 126 0 0 0 138 -1 138 126 126 "+
  "9 0 63 988 0 19 0 19 126 715 563 126 0 0 682 43 -1 138 469 375 0 126 63 0 988 63 0 0 43 306 0 43 "+
  "0 126 0 996 43 126 126 0 9 682 63 9 606 43 126 460 996 138 0 0 126 126 0 0 306 0 43 126 0 0 43 -1 "+
  "645 138 0 43 63 799 9 126 176 0 63 563 19 126 126 19 375 138 176 715 126 43 126 -1 0 400 126 43 0 43 0 -1 "+
  "-1 -1 138 9 138 126 375 43 138 488 488 126 126 375 19 126 9 138 43 988 715 0 0 563 138 296 63 126 0 0 996 -1 "+
  "-1 -1 -1 0 138 0 0 138 138 43 43 126 400 296 43 126 126 176 126 126 0 0 126 63 0 0 63 0 0 19 488 -1 "+
  "-1 -1 -1 -1 126 -1 -1 -1 -1 43 43 126 0 0 606 296 138 682 19 296 996 375 63 873 460 0 0 43 827 606 606 -1 "+
  "-1 -1 -1 -1 -1 -1 -1 138 -1 -1 -1 -1 -1 715 873 43 9 138 63 400 682 799 827 -1 -1 -1 -1 -1 -1 138 -1 43 "+
  "63 63 63 63 63 19 63 138 63 43 43 0 9 9 -1 -1 138 126 43 0 43 43 63 19 0 0 -1 -1 -1 -1 -1 43 "+
  "799 19 19 63 19 19 19 138 375 9 0 0 43 43 -1 -1 126 138 19 19 19 63 63 19 63 19 19 19 63 63 0 96 "+
  "0 63 0 126 460 9 9 138 43 126 9 126 43 126 -1 -1 19 138 63 63 63 0 0 63 63 0 0 63 63 43 43 63 "+
  "63 126 9 0 0 400 19 138 43 43 126 0 126 138 -1 138 0 138 63 0 0 0 63 63 0 0 0 0 19 43 0 9 "+
  "126 0 63 799 19 715 63 43 43 43 9 138 0 43 -1 -1 0 19 138 0 138 19 0 0 19 19 19 19 138 43 0 138 "+
  "63 126 63 0 19 0 19 138 0 996 138 43 9 43 -1 -1 43 19 138 0 0 0 0 0 0 0 19 0 0 0 0 138 "+
  "138 63 138 19 19 0 63 138 126 606 63 43 0 43 -1 -1 469 0 0 138 138 0 0 0 0 0 0 0 400 0 873 63 "+
  "63 9 43 43 0 138 63 138 126 19 19 138 0 43 -1 -1 43 43 -1 -1 138 0 0 0 0 0 0 0 0 0 176 9 "+
  "19 0 63 63 0 460 63 138 126 0 9 138 43 0 -1 -1 19 9 -1 -1 63 138 138 0 0 0 0 0 0 0 469 9 "+
  "9 63 19 0 873 138 63 306 -1 -1 -1 -1 43 0 -1 -1 19 0 19 63 63 63 43 138 138 0 0 0 0 63 0 0 "+
  "126 9 63 126 126 63 -1 -1 -1 -1 -1 138 -1 0 -1 -1 19 9 19 19 19 19 19 19 126 138 138 138 126 -1 -1 0 "+
  "306 0 138 -1 -1 -1 -1 -1 -1 -1 -1 138 -1 9 -1 -1 63 0 19 19 19 19 19 19 126 126 -1 138 138 -1 -1 19 "+
  "0 0 63 -1 -1 -1 -1 -1 -1 0 -1 138 0 63 -1 -1 63 63 375 19 19 19 19 19 -1 -1 -1 -1 138 138 -1";

  
UDPReceiver(){
  udp = new UDP( this, udpPort ); //from Termite desktop
  udp.listen( true );

}
void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  messageIn = new String( data );
  // print the result
  //println( "receive: \""+messageIn+"\" from "+ip+" on port "+port );
}

void updateGridValue(){
  ///////////////Only parse values if something changed/////////////
  if (!messageIn.equals(oldMessage) || !started) {
    oldSplitParts = oldMessage.split(" ");
    oldMessage = messageIn;
    splitParts = messageIn.split(" ");

    if (splitParts.length == oldSplitParts.length) {
      messageDelta = true;
      println("Delta found in message");
    }
  }
  index = 0;

  //If a delta was detected then update the tag ID's
  if (messageDelta) {
    for (LLLTag mod : tags.tagList) {
      index++; //Skip first item for indexing eg. i

      int maskID = parseInt(maskParts[index]);
      if (maskID==-2) {
        mod.tagID = -2;
        //println("Found a -2 void");
      } else {
        mod.tagID = parseInt(splitParts[index]);
      }


      //compare to old list to find out if there is a delta
      if (!splitParts[index].equals( oldSplitParts[index])) {
        mod.delta = true;
        println("found delta piece");
      }
    }
  }

  //reset iterration count
  index = 0;
}



}
