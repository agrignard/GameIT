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
  ArrayList<Block> blocks;
  //float unit = 11.95f;
  float unit = 14.175f*sizeScale;
  int wideCount=32;
  int highCount=26;
  PVector startPoint = new PVector(630*sizeScale, 35*sizeScale, 0);
  int scaleWorld = 1;
  
  public void setupInteractiveTagTable(){
    blocks = new ArrayList<Block>();
    unit = unit * scaleWorld;
    for (int y = 0; y < highCount; y++) {
    for (int x = 0; x < wideCount; x++) {     
      int type = parseInt(abs(random(0, 3))); //assign random type , either 0,1,2
      //Create new tag and account for street gaps and start location//
      float tagWeight = random(0, 800)/1000.0f;
      float highwaySpacer = 0;
      if (x>18) {
        highwaySpacer= unit*.2;
      }
      LLLTag tempTag = new LLLTag(x*unit+startPoint.x*scaleWorld +highwaySpacer, y*unit+startPoint.y*scaleWorld, type, unit*.8, unit*.8, tagWeight, 5);
      tagList.add(tempTag);
      tempTag.refreshAllWeights();
    }
  }
  }
  
  public void instantiateAgentFromGrid(){
    Agent ag = null;
    int nbWorkingBuilding= buildings.getWorkingBuilding().size();
    int nbLivingBuilding= buildings.getLivingBuilding().size();
    for (LLLTag t : tagList) {
      //OFFICE
      if (t.tagID==43 || t.tagID==63 || t.tagID==126){
        for ( int i=0;i<=t.density;i++){
          Node srcNode =  (Node) model.map.graph.nodes.get(int(random(model.map.graph.nodes.size())));
          //Node srcNode;
          if(t.tagID==43){
            srcNode =  model.getNodeInsideROI(getRandomTagPerID(0).point,100).get(0);
          }
          if(t.tagID==63){
            srcNode =  model.getNodeInsideROI(getRandomTagPerID(9).point,100).get(0);
          }
          if(t.tagID==126){
            srcNode =  model.getNodeInsideROI(getRandomTagPerID(19).point,100).get(0);
          }
          //Node srcNode =  model.getNodeInsideROI(buildings.getLivingBuilding().get(int(random(nbLivingBuilding-1))).shape.getVertex(0),500).get(0); 
          Node destNode = model.getNodeInsideROI(t.point,100).get(0);
          ag = new Agent(model.map, model.profiles.get(5+int(random(4))), "people_from_grid", "working", srcNode, destNode);
          model.agents.add(ag);
        }
        
      }
      //RESIDENTIAL
      if (t.tagID==0 || t.tagID==9 || t.tagID==19){
        for ( int i=0;i<=t.density;i++){
          Node srcNode = model.getNodeInsideROI(t.point,100).get(0);
          Node destNode =  (Node) model.map.graph.nodes.get(int(random(model.map.graph.nodes.size())));
          if(t.tagID==0){
            destNode =  model.getNodeInsideROI(getRandomTagPerID(43).point,100).get(0);
          }
          if(t.tagID==9){
            destNode =  model.getNodeInsideROI(getRandomTagPerID(63).point,100).get(0);
          }
          if(t.tagID==19){
            destNode =  model.getNodeInsideROI(getRandomTagPerID(126).point,100).get(0);
          }
          //Node destNode =  model.getNodeInsideROI(buildings.getWorkingBuilding().get(int(random(nbWorkingBuilding))).shape.getVertex(0),500).get(0);
          ag= new Agent(model.map, model.profiles.get(int(random(4))), "people_from_grid", "living",srcNode, destNode);
          model.agents.add(ag);
        }
      } 
    }
    for (LLLTag t : tagList) {
      if(t.tagID==0 || t.tagID==9 || t.tagID==19 || t.tagID==43 || t.tagID==63 || t.tagID==126){
        blocks.add(new Block(t.point, int(t.tagWidth), legoGrid.colorMap.get(t.tagID),t.tagID,int(t.density)*50));
      }
    }
  }
  
  public void UpdateAndDraw(PGraphics p){
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
        switch(tagViz) {
        case 'E':
        break;
        case 'P': 
          if (mod2.tagID == 138) {
            if (dist<130) { //distance threshold for parks
              float tempCal =  ( dist/130.0f) ;
              //Easing 
              float sqt = sqrt(tempCal);
              tempCal= (sqt / (2.0f * (sqt - tempCal) + 0.5f)) ;
              if (tempCal<calcWeights) {
                calcWeights = tempCal;
              };
            }
          }

          if (mod.delta) {
            float proximityThreshold = 180 * scaleWorld; //This is the proximity threshold of the neighbouring tags that will be impacted by this change in animation/
            if ( dist<proximityThreshold) {
              mod2.animateWave((1.0f- dist/proximityThreshold ));//feed distance ratio to animation wave
            };
          }
          break;
        case 'O': 
          if (mod2.tagID==43 || mod2.tagID==63 || mod2.tagID==126) {
            if (dist<130) { //distance threshold for parks
              float tempCal =  ( dist/130.0f) ;
              //Easing 
              float sqt = sqrt(tempCal);
              tempCal= (sqt / (2.0f * (sqt - tempCal) + 0.3f)) ;
              if (tempCal<calcWeights) {
                calcWeights = tempCal;
              };
            }
          }

          if (mod.delta) {
            float proximityThreshold = 180 * scaleWorld; //This is the proximity threshold of the neighbouring tags that will be impacted by this change in animation/
            if ( dist<proximityThreshold) {
              mod2.animateWave((1.0f- dist/proximityThreshold ));//feed distance ratio to animation wave
            };
          }
          break;
        case 'R': 
          if (mod2.tagID==0 || mod2.tagID==9 || mod2.tagID==19) {
            if (dist<130) { //distance threshold for parks
              float tempCal =  ( dist/130.0f) ;
              //Easing 
              float sqt = sqrt(tempCal);
              tempCal= (sqt / (2.0f * (sqt - tempCal) + 0.3f)) ;
              if (tempCal<calcWeights) {
                calcWeights = tempCal;
              };
            }
          }

          if (mod.delta) {
            float proximityThreshold = 180 * scaleWorld; //This is the proximity threshold of the neighbouring tags that will be impacted by this change in animation/
            if ( dist<proximityThreshold) {
              mod2.animateWave((1.0f- dist/proximityThreshold ));//feed distance ratio to animation wave
            };
          }
          break;
        case 'T': 
          break;
        default:
          break;
        }
      }
      //reconcile calcWeights with the number of values found
      switch(tagViz) {
      case 'P': 
        mod.delta = false;
        mod.updateWeight(calcWeights);
        mod.refreshAllWeights();
        break;
      case 'O': 
        mod.delta = false;
        mod.refreshAllWeights();
        mod.updateWeight(calcWeights);
        break;
      case 'R': 
        mod.delta = false;
        mod.refreshAllWeights();
        mod.updateWeight(calcWeights);
        break;
      default:
        break;
      }
    }
    if(mod.visible){
      mod.display(p,tagViz);
    }
    
  }
  }
  
 void displayMicroPop(PGraphics p){
    int spread=2;
    for (LLLTag t : tags.tagList) {
      if(t.visible){
        for (int i=0;i<=t.density-1;i++){
          if(t.tagID==0||t.tagID==9||t.tagID==19||t.tagID==43||t.tagID==63||t.tagID==126){
            p.fill(legoGrid.colorMap.get(t.tagID));
            if(i%2==0){
              p.ellipse(t.x + t.tagWidth/2 + noise(t.x+i)*t.tagWidth*spread,t.y+t.tagHeight/2+ noise(t.y+i)*t.tagHeight*spread,4,4);
            } else{
            p.ellipse(t.x + t.tagWidth/2 - noise(t.x+i)*t.tagWidth*spread,t.y+t.tagHeight/2 - noise(t.y+i)*t.tagHeight*spread,4,4);
          }
        }
      }
      }
    }
    if(drawer.showParticleSystem){
      for(Block b: tags.blocks){
        if(b.visible){
          b.run(p);
        }
      }
    }

  }
  
  LLLTag getRandomTagPerID(int id){
    ArrayList<LLLTag> tmpList = new ArrayList<LLLTag>();
    for (LLLTag t : tags.tagList) {
      if(t.tagID==id){
        tmpList.add(t);
      }
    }
    int size = tmpList.size();
    return tmpList.get(int(random(size)));
  }
   
  void updateTagDensity(int id, int value){
    for (LLLTag t : tags.tagList) {
      if(id == t.tagID){
        t.density=value/10;
      }
    }
    for (Block b : tags.blocks) {
      if(id == b.id){
        b.intensity=value*5;
      }
    }
    
  }  
  void updateTagVisibilityPerId(int id, int visible){
    if(visible == 1){
      drawer.showAgent=false;
      for (LLLTag t : tags.tagList) {
        t.visible=false;
      } 
      for (LLLTag t : tags.tagList) {
        if(id == t.tagID){
          t.visible= (visible == 0) ? false : true;
        }
      }
      for (Block b : tags.blocks) {
        b.visible=false;
      } 
      for (Block b : tags.blocks) {
        if(id == b.id){
          b.visible= (visible == 0) ? false : true;
        }
      }
    }
    if(visible==0){
      for (LLLTag t : tags.tagList) {
        t.visible=true;
      }
      for (Block b : tags.blocks) {
        b.visible=true;
      } 
    }
  }
}

class LLLTag {
  color c1 = color(0, 255, 0);
  color c2 = color(255, 255, 0);
  color c3 = color(255, 0, 0);


  float x, y, rot, tagType, tagWidth, tagHeight, size, density;
  
  boolean visible = true;

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
  LLLTag(float xTemp, float yTemp, int typeTemp, float sizeX, float sizeY, float weightTemp, float densityTemp) {

    x = xTemp;
    y = yTemp;

    tagType = typeTemp;

    tagWidth = sizeX;
    tagHeight = sizeY;

    point = new PVector(x, y, 0);

    tagWeight = weightTemp;
    density = densityTemp;
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
  void display(PGraphics p,char tagVizIn) {
    p.noStroke();
    p.fill(255);
    p.ellipse(x, y, size, size);
    color cWalkCyan = color(0, 200, 200, 255);
    color cW1 = color(0, 255, 0);
    color cW2 = color(255, 255, 0);
    color cW3 = color(255, 0, 0);
    if (tagID>-2) {
      switch(tagVizIn) {
      case 'P': 
        updateWaveedGrid(p);
        break;
      case 'R': 
        updateWaveedGrid(p);
        if (tagID==43 || tagID==63 || tagID==126) {
          p.fill(0, 230, 230, 255);
          p.rect(x+tagWidth/3, y+tagWidth/3, tagWidth/3, tagHeight/3);
        }

        if (tagID==0 || tagID==9 || tagID==19) {
          p.fill(230, 0, 255, 255);
          p.rect(x+tagWidth/3, y+tagWidth/3, tagWidth/3, tagHeight/3);
        }
        break;
      case 'O':
      updateWaveedGrid(p);
        //Override Offices
        if (tagID==43 || tagID==63 || tagID==126) {
          p.fill(0, 230, 230, 255);
          p.rect(x+tagWidth/3, y+tagWidth/3, tagWidth/3, tagHeight/3);
        }

        if (tagID==0 || tagID==9 || tagID==19) {
          p.fill(230, 0, 255, 255);
          p.rect(x+tagWidth/3, y+tagWidth/3, tagWidth/3, tagHeight/3);
        }
        break;
      case 'T': 
        p.fill(0, 80, 80, 200);
        if(tagID==0||tagID==9||tagID==19||tagID==43||tagID==63||tagID==126){
          p.fill(legoGrid.colorMap.get(tagID),150);
        }
        if (tagID==138) {
          p.fill(0, 230, 0, 255);
        }
        p.rect(x, y, tagWidth, tagHeight);
        break;
       case 'E': 
        p.fill(#FFFFFF);
        p.rect(x, y, tagWidth, tagHeight);
        break;
      default:
        break;
      }
    }//end if tagID
    else {
      p.fill(80, 80, 80, 80);
      p.rect(x, y, tagWidth, tagHeight);
    }
    //always reset update flags
    updateWeights=false;
  }
    
  void updateWaveedGrid(PGraphics p){
        //Draw interior grid of 4x4
        for (int i=0; i<tagVoxels.size(); i++) {
          //Calc block size and position
          float tempSize = tagWidth/4;
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
          } else if ( waveCount>=0  ) {
            tagVoxels.get(i).heatColorG(c1, c2, c3, tagWeight);
            waveCount = waveCount - 0.08f;
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
          p.fill(tagVoxels.get(i).voxColor);
          p.rect(x+tagVoxels.get(i).point.x, y+tagVoxels.get(i).point.y, tempSize-0.0f, tempSize-0.0f);
        }//end Voxel Loop
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
