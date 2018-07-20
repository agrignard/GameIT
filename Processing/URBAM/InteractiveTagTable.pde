/////////////////////////////////////////////////////////////////////////////////
///////////////////////////LLL CityScope Hack////////////////////////////////////
////////This software is not to be considered appropriate for future use/////////
////////This was a two day crash course in deploying an emergency viz////////////
////////THERE ARE LITTLE TO NO COMMENTS........./////////////////////////////////
////////Due to last minute debugging, some variables or HARDCODED////////////////
/////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////Carson 2018///////

public class InteractiveTagTable {
  ArrayList<LLLTag> tagList = new ArrayList<LLLTag>();
  //float unit = 11.95f;
  float unit = 14.175f;
  int wideCount=32;
  int highCount=26;
  PVector startPoint = new PVector(630, 35, 0);
  int scaleWorld = 1;
  
  
  InteractiveTagTable(){
    //setupInteractiveTagTable();
  }
  
  public void setupInteractiveTagTable(){
    unit = unit * scaleWorld;
    for (int y = 0; y < highCount; y++) {
    for (int x = 0; x < wideCount; x++) {     
      int type = parseInt(abs(random(0, 3))); //assign random type , either 0,1,2

      //Create new tag and account for street gaps and start location//
      float tagWeight = random(0, 800)/1000.0f;
      //float tagWeight = 0.9;

      //Here we add a spacer for the highways. The 0.2 
      //
      float highwaySpacer = 0;
      if (x>18) {
        highwaySpacer= unit*.2;
      }

      LLLTag tempTag = new LLLTag(x*unit+startPoint.x*scaleWorld +highwaySpacer, y*unit+startPoint.y*scaleWorld, type, unit*.8, unit*.8, tagWeight);
      tagList.add(tempTag);
      tempTag.refreshAllWeights();
      //tagList.add(new LLLTag(x*unit + random(-10,10), y*unit  + random(-10,10)));
    }
  }
  }
  
  
  public void UpdateAndDraw(){
    //println("tagViz" + tagViz);
    for (LLLTag mod : tagList) {
    udpR.index++;
    float calcWeights = 1.0f; //reset calcweights for each tag

    //Update Weights
    if (messageDelta || mouseClicked) {
      //println("udapteweights");
      /////Get distances to all other tags and run a calculation
      int calcsFound = 0;
      for (LLLTag mod2 : tagList) {

        float dist = mod2.point.dist(mod.point);

        //println(dist);

        switch(tagViz) {
        case 'E':
        break;
        case 'P': 
          //println("Parks");  // Does not execute
          if (mod2.tagID == 138) {
            if (dist<130) { //distance threshold for parks
              float tempCal =  ( dist/130.0f) ;

              //Easing 
              float sqt = sqrt(tempCal);
              tempCal= (sqt / (2.0f * (sqt - tempCal) + 0.5f)) ;


              if (tempCal<calcWeights) {
                calcWeights = tempCal;
                //println(tempCal);
              };
            }
          }

          if (mod.delta) {

            //println("Delta piece found");
            // println(dist);
            float proximityThreshold = 180 * scaleWorld; //This is the proximity threshold of the neighbouring tags that will be impacted by this change in animation/
            if ( dist<proximityThreshold) {
              // println("Animate wave ");

              mod2.animateWave((1.0f- dist/proximityThreshold ));//feed distance ratio to animation wave
            };
          }

          break;
        case 'W': 
          //println("Walkability"); 

          if (mod2.tagID==43 || mod2.tagID==63 || mod2.tagID==126) {
            if (dist<130) { //distance threshold for parks
              float tempCal =  ( dist/130.0f) ;

              //Easing 
              float sqt = sqrt(tempCal);
              tempCal= (sqt / (2.0f * (sqt - tempCal) + 0.3f)) ;


              if (tempCal<calcWeights) {
                calcWeights = tempCal;
                //println(tempCal);
              };
            }
          }

          if (mod.delta) {

            //println("Delta piece found");
            // println(dist);
            float proximityThreshold = 180 * scaleWorld; //This is the proximity threshold of the neighbouring tags that will be impacted by this change in animation/
            if ( dist<proximityThreshold) {
              // println("Animate wave ");

              mod2.animateWave((1.0f- dist/proximityThreshold ));//feed distance ratio to animation wave
            };
          }

          break;
        case 'T': 
          //println("Type");  // 
          break;
        default:
          // println("Nothing");   // Does not execute
          break;
        }
      }

      //reset delta


      //reconcile calcWeights with the number of values found
      switch(tagViz) {
      case 'P': 
        mod.delta = false;
        mod.updateWeight(calcWeights);
        mod.refreshAllWeights();

        break;
      case 'W': 
        mod.delta = false;
        mod.refreshAllWeights();
        mod.updateWeight(calcWeights);
        
        break;
      default:
        // println("Nothing");   // Does not execute
        break;
      }
      // println(calcWeights);

      //println("new delta found");
    }

    //mod.size = (parseFloat(iterrate)/parseFloat(count) * 3.0f) + 0.5f; //draw size based on list position

    mod.display(tagViz);

    //println(mod.tagType);
  }
  }
  
}

class LLLTag {
  color c1 = color(0, 255, 0);
  color c2 = color(255, 255, 0);
  color c3 = color(255, 0, 0);


  float x, y, rot, tagType, tagWidth, tagHeight, size;

  //Point object used for native dist calcs
  PVector point;

  int tagID = 0;

  boolean delta = false;

  //The heatmap weighting of this piece.
  float tagWeight = 1.0f;

  //variable to retain old tag weight value.
  float tagWeightOld = 1.0f;

  //Determine the number of inner voxel divisions
  int tagStuds = 4; //What is the square tag size in bounds eg. 4x4 would be 4

  //The inner 2D voxel array of this piece.
  ArrayList<LLLTagVoxel> tagVoxels = new ArrayList<LLLTagVoxel>();


  // Contructor
  LLLTag(float xTemp, float yTemp, int typeTemp, float sizeX, float sizeY, float weightTemp) {

    x = xTemp;
    y = yTemp;

    tagType = typeTemp;

    tagWidth = sizeX;
    tagHeight = sizeY;

    point = new PVector(x, y, 0);

    tagWeight = weightTemp;
    /////////////////////////////////
    //Iniatiate Inner 2D Voxel array
    /////////////////////////////////

    //nterior grid of 4x4
    for (int i=0; i<tagStuds; i++) {
      for (int j=0; j<tagStuds; j++) {
        //Calc block size and position
        float tempSize = tagWidth/4;

        color c = color(255, 255, 255);

        LLLTagVoxel newVoxel = new LLLTagVoxel(c, tempSize, new PVector(i*tempSize, j*tempSize));

        /////////////RANDOMIZE COLOR HEAT//////////////
        //  float tempWeight = random(0, tagWeight);
        // newVoxel.heatColorG(c1, c2, c3, tagWeight);
        ///////////////////////////////////////////////

        //init tageWeightColor
        newVoxel.heatColorG(c1, c2, c3, tagWeight);


        tagVoxels.add(newVoxel);
      }
    }
  }

  boolean updateWeights=false;
  // Custom method for updating the variables

  void updateWeight(float weightIn) {
    //Save old weight value for anitmation purposes
    tagWeightOld = tagWeight;
    //update weights
    tagWeight = weightIn;
  }

  void refreshAllWeights() {
    //update weights
    updateWeights = true;
  }

  void update() {
  }

  // Custom method for drawing the object
  void display(char tagVizIn) {
    noStroke();
    fill(255);
    ellipse(x, y, size, size);

    ////////////Draw Entire Piece////////////
    // fill(weight, 255, 255);
    // rect(x, y, tagWidth-1, tagHeight-1);

    if (tagID>-2) {

      switch(tagVizIn) {
      case 'P': 
        //Draw interior grid of 4x4
        for (int i=0; i<tagVoxels.size(); i++) {
          //Calc block size and position
          float tempSize = tagWidth/4;

          // tagVoxels.get(i).heatColorG(c1, c2, c3, tagWeight);

          /////////////RANDOMIZE COLOR HEAT//////////////
          //tagVoxels.get(i).heatColorG(c1, c2, c3, random(0, tagWeight));
          ///////////////////////////////////////////////

          ///////////////WAVE ANIMATION/////////////////
          float minValue = tagWeight -waveDistantRatio/2;
          float maxValue = tagWeight+waveDistantRatio/2;
          if (waveCount>=(0.08*16)) {
            waveStart = waveStart + 0.08f;

            if (waveStart>0 ) {
              //println("wave animation");
              waveCount = waveCount - 0.08f;
              /////////////RANDOMIZE COLOR HEAT//////////////

              if (minValue<0) {
                minValue = 0;
              }

              if (maxValue>1) {
                maxValue = 1;
              }

              tagVoxels.get(i).heatColorG(c1, c2, c3, random(minValue, maxValue));
              ///////////////////////////////////////////////
            }
            //println("Running Wave");
          } else if ( waveCount>=0  ) {
            tagVoxels.get(i).heatColorG(c1, c2, c3, tagWeight);
            waveCount = waveCount - 0.08f;
            // println("Finish Wave");
          }


          //////////////DWELL CODE////////////////
          else if (dwellRandom>7 ) {
            float dwellRatio = dwellRandom/dwellStart;

            if (waveDistantRatio>0.92) {
              dwellRandom = dwellRandom - 0.025f;
            } else {
              dwellRandom = dwellRandom - 0.05f;
            }

            minValue = tagWeight -((waveDistantRatio*dwellRatio)/2);
            maxValue = tagWeight+ ((waveDistantRatio * dwellRatio)/2);

            if (minValue<0) {
              minValue = 0;
            }

            if (maxValue>1) {
              maxValue = 1;
            }

            color tempC =tagVoxels.get(i).returnHeatColorG(c1, c2, c3, random(minValue, maxValue));
            tagVoxels.get(i).voxColor = tempC;
            // println("Dwell Random");
          }


          if (updateWeights) {
            tagVoxels.get(i).heatColorG(c1, c2, c3, tagWeight);
          }



          fill(tagVoxels.get(i).voxColor);

          rect(x+tagVoxels.get(i).point.x, y+tagVoxels.get(i).point.y, tempSize-0.0f, tempSize-0.0f);
        }//end Voxel Loop
        break;
      case 'W': 

        color cWalkCyan = color(0, 200, 200, 255);
        /* 
         color cW1 = color(230, 230, 0, 255);
         color cW2 = color(255, 102, 0, 255);
         color cW3 = color(210, 0, 0, 255);
         */

        /*     
         color cW1 = color(255, 255, 204);
         color cW2 = color(255, 255, 102);
         color cW3 = color(204, 0, 0);
         */

        color cW1 = color(0, 255, 0);
        color cW2 = color(255, 255, 0);
        color cW3 = color(255, 0, 0);

        //Draw interior grid of 4x4
        for (int i=0; i<tagVoxels.size(); i++) {
          //Calc block size and position
          float tempSize = tagWidth/4;

          // tagVoxels.get(i).heatColorG(c1, c2, c3, tagWeight);

          /////////////RANDOMIZE COLOR HEAT//////////////
          //tagVoxels.get(i).heatColorG(c1, c2, c3, random(0, tagWeight));
          ///////////////////////////////////////////////

          ///////////////WAVE ANIMATION/////////////////
          float minValue = tagWeight -waveDistantRatio/2;
          float maxValue = tagWeight+waveDistantRatio/2;
          if (waveCount>=(0.08*16)) {
            waveStart = waveStart + 0.08f;

            if (waveStart>0 ) {
              //println("wave animation");
              waveCount = waveCount - 0.08f;
              /////////////RANDOMIZE COLOR HEAT//////////////

              if (minValue<0) {
                minValue = 0;
              }

              if (maxValue>1) {
                maxValue = 1;
              }

              tagVoxels.get(i).heatColorG(cW1, cW2, cW3, random(minValue, maxValue));
              ///////////////////////////////////////////////
            }
            //println("Running Wave");
          } else if ( waveCount>=0  ) {
            tagVoxels.get(i).heatColorG(cW1, cW2, cW3, tagWeight);
            waveCount = waveCount - 0.08f;
            // println("Finish Wave");
          }


          //////////////DWELL CODE////////////////
          else if (dwellRandom>7 ) {
            float dwellRatio = dwellRandom/dwellStart;

            if (waveDistantRatio>0.92) {
              dwellRandom = dwellRandom - 0.025f;
            } else {
              dwellRandom = dwellRandom - 0.05f;
            }

            minValue = tagWeight -((waveDistantRatio*dwellRatio)/2);
            maxValue = tagWeight+ ((waveDistantRatio * dwellRatio)/2);

            if (minValue<0) {
              minValue = 0;
            }

            if (maxValue>1) {
              maxValue = 1;
            }

            color tempC =tagVoxels.get(i).returnHeatColorG(cW1, cW2, cW3, random(minValue, maxValue));
            tagVoxels.get(i).voxColor = tempC;
            // println("Dwell Random");
          }


          if (updateWeights) {
            tagVoxels.get(i).heatColorG(cW1, cW2, cW3, tagWeight);
          }



          fill(tagVoxels.get(i).voxColor);

          rect(x+tagVoxels.get(i).point.x, y+tagVoxels.get(i).point.y, tempSize-0.0f, tempSize-0.0f);
        }//end Voxel Loop

        //Override Offices

        if (tagID==43 || tagID==63 || tagID==126) {
          fill(0, 230, 230, 255);
          rect(x+tagWidth/3, y+tagWidth/3, tagWidth/3, tagHeight/3);
        }

        if (tagID==0 || tagID==9 || tagID==19) {
          fill(230, 0, 255, 255);
          rect(x+tagWidth/3, y+tagWidth/3, tagWidth/3, tagHeight/3);
        }

        break;
      case 'T': 
        //println("Type");  // Prints 
        fill(0, 80, 80, 200);

        if (tagID==138) {
          fill(0, 230, 0, 255);
        }

        if (tagID==0 || tagID==9 || tagID==19) {
          fill(230, 0, 255, 255);
        }

        if (tagID==43 || tagID==63 || tagID==126) {
          fill(0, 230, 230, 255);
        }


        rect(x, y, tagWidth, tagHeight);
        break;
      default:
        // println("Nothing");   // Does not execute
        break;
      }
    }//end if tagID
    else {
      fill(80, 80, 80, 80);
      rect(x, y, tagWidth, tagHeight);
    }
    //always reset update flags
    updateWeights=false;
  }

  float waveCount = 0;
  float waveStart = 0;
  float waveDistantRatio = 0;

  float dwellRandom = 0;
  float dwellStart = 0;


  void animateWave(float distanceRatio) {
    waveDistantRatio = distanceRatio;
    waveCount = 20*distanceRatio; //Reset wave animation count
    waveStart = -65+(65*distanceRatio);

    //Random selection of tags to dwell after wave
    float toDwellOrNotToDwell = random(0, 10);
    if (toDwellOrNotToDwell<(8*distanceRatio) &&  distanceRatio>0.7f || distanceRatio>0.9) {
      dwellRandom = distanceRatio * 50;
      dwellStart = dwellRandom; //remember where we started dwelling
    }
  }
}



class LLLTagVoxel {

  color voxColor;
  float voxSize;
  //The inner voxel array of this piece.
  ArrayList<LLLTagVoxel> tagVoxels = new ArrayList<LLLTagVoxel>();

  PVector point;

  // Contructor
  LLLTagVoxel(color tempColor, float tempSize, PVector tempPoint) {

    voxColor   = tempColor;
    voxSize    = tempSize;
    point      = tempPoint;
  }


  //Randomize Voxel Color for testing
  void heatColorG(color c1, color c2, color c3, float tempWeight) {

    color c = color(255, 255, 255);

    if (tempWeight<0.5) {
      c = lerpColor(c1, c2, tempWeight*2);
    } else {
      c = lerpColor(c2, c3, (tempWeight-0.5)*2);
    }

    voxColor = c;
  }

  //Return Randomize Voxel Color for testing
  color returnHeatColorG(color c1, color c2, color c3, float tempWeight) {

    color c = color(255, 255, 255);

    if (tempWeight<0.5) {
      c = lerpColor(c1, c2, tempWeight*2);
    } else {
      c = lerpColor(c2, c3, (tempWeight-0.5)*2);
    }

    return c;
  }
}
