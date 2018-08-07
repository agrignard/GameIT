import java.util.Map;
import java.util.Iterator;
import java.util.Collections;
import java.util.Arrays;
/* ABM CLASS ------------------------------------------------------------*/
public class ABM {
  private RoadNetwork map;
  private String type;
  private ArrayList<Agent> agents;
  private ArrayList<String> profiles;
  private ArrayList<Integer> colors;
  HashMap<String, Integer> colorProfiles; 
  int nbPeoplePerProfile;
  int workingColor= #00ffff;//#000095;//#283c86;//#165E93;//
  int livingColor= #ff00ff;//#FD710A;//#45a247;//#F4A528;//
  ABM(RoadNetwork _map) {
    map=_map;
    nbPeoplePerProfile= 100;
    agents = new ArrayList<Agent>();
    //PASTELLE ORANGE AND BLUE
    //colors = new ArrayList<Integer>(Arrays.asList(#AA6839,#FFCDAA,#D4966A,#804115,#552300,#2F4172,#7986AC,#4F608F,#162756,#061439));
    //Orange and Blue saturated
    //colors = new ArrayList<Integer>(Arrays.asList(#FD710A,#FD710A,#AB4E05,#6F3603,#E96809,#1400F1,#0000D4,#00006E,#000049,#000095)); 
    // Purple and blue
    colors = new ArrayList<Integer>(Arrays.asList(#ff00ff,#b802ff,#a200ff,#b802ff,#ff00ff,#00ffff,#0099ff,#00ffd5,#0099ff,#00ffff));   
    profiles = new ArrayList<String>(Arrays.asList("Young Children","High School","Home maker","Retirees","Artist","College","Young professional","Mid-career workers","Executives","Workforce"));
    colorProfiles = new HashMap<String, Integer>();
    for (int i=0;i<profiles.size();i++){
      colorProfiles.put(profiles.get(i), colors.get(i));
    }
  }

  public void initModel() {
    agents.clear();
    createAgents(nbPeoplePerProfile, "people");
    //createAgents(nbPeoplePerProfile, "static_people");
    createAgents(nbPeoplePerProfile/10, "bike");
    createAgents(nbPeoplePerProfile/20, "static_bike");
    createAgents(nbPeoplePerProfile/10, "car");
    createAgents(nbPeoplePerProfile/20, "static_car");
    createAgents(nbPeoplePerProfile, "mobike");
    //createAgents(nbPeoplePerProfile, "static_mobike");
  }

  public void updateGlobalPop() {
    if (frameCount % 30 == 0) {
      if (sliderHandler.globalSliders.get(0)>sliderHandler.tmpGlobalSliders.get(0)) {
        addNAgentsPerUsage((int)((sliderHandler.globalSliders.get(0) - sliderHandler.tmpGlobalSliders.get(0)))*10, "people","working");
        addNAgentsPerUsage((int)((sliderHandler.globalSliders.get(0) - sliderHandler.tmpGlobalSliders.get(0)))*10, "static_people","working");
        sliderHandler.tmpGlobalSliders.set(0, sliderHandler.globalSliders.get(0));
      }
      if (sliderHandler.globalSliders.get(0)<sliderHandler.tmpGlobalSliders.get(0)) {
        removeNAgentsPerUsage(int((sliderHandler.tmpGlobalSliders.get(0) - sliderHandler.globalSliders.get(0)))*10, "people", "working");
        removeNAgentsPerUsage(int((sliderHandler.tmpGlobalSliders.get(0) - sliderHandler.globalSliders.get(0)))*10, "static_people", "working");
        sliderHandler.tmpGlobalSliders.set(0, sliderHandler.globalSliders.get(0));
      }
      if (sliderHandler.globalSliders.get(1)>sliderHandler.tmpGlobalSliders.get(1)) {
        addNAgentsPerUsage(int((sliderHandler.globalSliders.get(1) - sliderHandler.tmpGlobalSliders.get(1)))*10, "people", "living");
        addNAgentsPerUsage(int((sliderHandler.globalSliders.get(1) - sliderHandler.tmpGlobalSliders.get(1)))*10, "static_people", "living");
        sliderHandler.tmpGlobalSliders.set(1, sliderHandler.globalSliders.get(1));
      }
      if (sliderHandler.globalSliders.get(1)<sliderHandler.tmpGlobalSliders.get(1)) {
        removeNAgentsPerUsage(int((sliderHandler.tmpGlobalSliders.get(1) - sliderHandler.globalSliders.get(1)))*10, "people", "living");
        removeNAgentsPerUsage(int((sliderHandler.tmpGlobalSliders.get(1) - sliderHandler.globalSliders.get(1)))*10, "static_people", "living");
        sliderHandler.tmpGlobalSliders.set(1, sliderHandler.globalSliders.get(1));
      }
    }
  }

  public void updateLocalPop() {
    if (frameCount % 30 == 0) {
      for (int i=0; i<sliderHandler.tmpLocalSliders.size(); i++) {
        if (sliderHandler.localSliders.get(i)>sliderHandler.tmpLocalSliders.get(i)) {
          if (i<5) {
            addNAgentPerProfiles((int)((sliderHandler.localSliders.get(i) - sliderHandler.tmpLocalSliders.get(i)))*2, profiles.get(i), "people","living") ;
            addNAgentPerProfiles((int)((sliderHandler.localSliders.get(i) - sliderHandler.tmpLocalSliders.get(i)))*2, profiles.get(i), "static_people","living") ;
          } else {
            addNAgentPerProfiles((int)((sliderHandler.localSliders.get(i) - sliderHandler.tmpLocalSliders.get(i)))*2, profiles.get(i), "people", "working") ;
            addNAgentPerProfiles((int)((sliderHandler.localSliders.get(i) - sliderHandler.tmpLocalSliders.get(i)))*2, profiles.get(i), "static_people", "working") ;
          }
          sliderHandler.tmpLocalSliders.set(i, sliderHandler.localSliders.get(i));
        }
        if (sliderHandler.localSliders.get(i)<sliderHandler.tmpLocalSliders.get(i)) {
          removeNAgentsPerProfiles(int((sliderHandler.tmpLocalSliders.get(i) - sliderHandler.localSliders.get(i)))*2, "people", profiles.get(i));
          removeNAgentsPerProfiles(int((sliderHandler.tmpLocalSliders.get(i) - sliderHandler.localSliders.get(i)))*2, "static_people", profiles.get(i));
          sliderHandler.tmpLocalSliders.set(i, sliderHandler.localSliders.get(i));
        }
      }
    }
  }

  public void run(PGraphics p) {
    for (int i=0; i<agents.size(); i++) {
      if (agents.get(i).type.equals("people") || agents.get(i).type.equals("people_from_grid") || agents.get(i).type.equals("bike") || agents.get(i).type.equals("car") || agents.get(i).type.equals("mobike")) {
        agents.get(i).move();
      } 
      agents.get(i).draw(p);
    }
  }
  
  public void relocateAgentInsideGrid(Agent a,PVector pos, int size){
       Building tmp = buildings.getBuildingInsideROI(pos,size).get(int (random(buildings.getBuildingInsideROI(pos,size).size())));
       a.pos = tmp.shape.getVertex(int(random(tmp.shape.getVertexCount())));
  }

  public void addNAgentsPerUsage(int num, String type, String usage) {
    Agent ag = null;
    for (int i = 0; i < num; i++) {
      if (usage.equals("living")) {
        ag= new Agent(map, profiles.get(int(random(4))), type, "living");
        model.agents.add(ag);
      } else {
        ag = new Agent(map, profiles.get(5+int(random(4))), type, "working");
        model.agents.add(ag);
      }
      if(ag.type.equals("static_people") && drawer.showViewCube){
          relocateAgentInsideGrid(ag,grid.curActiveGridPos,grid.cellSize);
      }
    }
  }

  public void removeNAgentsPerUsage(int n, String type, String usage) {
    Iterator<Agent> ag = model.agents.iterator();
    int i=0;
    while (ag.hasNext()) { 
      Agent tmpAg = ag.next();
      if(drawer.showViewCube){
        if(((tmpAg.pos.x>grid.curActiveGridPos.x-grid.cellSize/2) && (tmpAg.pos.x)<grid.curActiveGridPos.x+grid.cellSize/2) &&
        ((tmpAg.pos.y>grid.curActiveGridPos.y-grid.cellSize/2) && (tmpAg.pos.y)<grid.curActiveGridPos.y+grid.cellSize/2)){
          if (usage.equals(tmpAg.usage) && type.equals(tmpAg.type)) { 
            if (i<n) { 
              ag.remove();
              i++;
            }
          }
        }
      }else{     
      if (usage.equals(tmpAg.usage) && type.equals(tmpAg.type)) { 
        if (i<n) { 
        ag.remove();
        i++;
        }
      }
      }
    }
  }  


  public void addNAgentPerProfiles(int num, String profile, String type, String usage) {
    Agent ag = null;
    for (int i = 0; i < num; i++) {
      ag = new Agent(map, profile, type, usage);
      model.agents.add(ag);
      if(ag.type.equals("static_people") && drawer.showViewCube){
          relocateAgentInsideGrid(ag,grid.curActiveGridPos,grid.cellSize);
      }
    }
  }

  public void removeNAgentsPerProfiles(int n, String type, String profile) {
    
    Iterator<Agent> ag = model.agents.iterator();

    int i=0;
    while (ag.hasNext()) { 
      Agent tmpAg = ag.next();
      if(drawer.showViewCube){
        if(((tmpAg.pos.x>grid.curActiveGridPos.x-grid.cellSize/2) && (tmpAg.pos.x)<grid.curActiveGridPos.x+grid.cellSize/2) &&
        ((tmpAg.pos.y>grid.curActiveGridPos.y-grid.cellSize/2) && (tmpAg.pos.y)<grid.curActiveGridPos.y+grid.cellSize/2)){
          if (profile.equals(tmpAg.profile) && type.equals(tmpAg.type)) { 
            if (i<n) { 
              ag.remove();
              i++;
            }
          }
        }
        
      }else{      
        if (profile.equals(tmpAg.profile) && type.equals(tmpAg.type)) { 
          if (i<n) { 
            ag.remove();
            i++;
          }
        }
      }
    }
    
  }

  public void createAgents(int num, String type) {
    for (int i = 0; i < num; i++) {
      for (int j=0; j<profiles.size()/2; j++) {
        agents.add( new Agent( map, profiles.get(j), type, "living"));
      }
      for (int j=5; j<profiles.size(); j++) {
        agents.add( new Agent(map, profiles.get(j), type, "working"));
      }
    }
  }

  public int getNbMovingPeople() {
    int nbP=0;
    for (int i=0; i<agents.size(); i++) {
      if (agents.get(i).type.equals("people")) {
        nbP++;
      }
    }
    return nbP;
  }
    
  public Agent getRandomLivingPeople(){
    Agent ag = null;
    for (int i=0; i<agents.size(); i++) {
      if (agents.get(i).type.equals("people") && agents.get(i).usage.equals("living")) {
        ag=agents.get(i);
      }
    }
    return ag;
  }
  
  public Agent getRandomWorkingPeople(){
    Agent ag = null;
    for (int i=0; i<agents.size(); i++) {
      if (agents.get(i).type.equals("people") && agents.get(i).usage.equals("working")) {
        ag=agents.get(i);
      }
    }
    return ag;
  }
  
  public int getNbStaticPeople() {
    int nbP=0;
    for (int i=0; i<agents.size(); i++) {
      if (agents.get(i).type.equals("static_people")) {
        nbP++;
      }
    }
    return nbP;
  }
  
  public ArrayList<Agent> getAgentInsideROI(PVector pos, int size){
    ArrayList<Agent> tmp = new ArrayList<Agent>();
    for (int i=0;i<agents.size();i++){
        if(((agents.get(i).pos.x>pos.x-size/2) && (agents.get(i).pos.x)<pos.x+size/2) &&
        ((agents.get(i).pos.y>pos.y-size/2) && (agents.get(i).pos.y)<pos.y+size/2))
        {
          tmp.add(agents.get(i));
        }       
      }
    return tmp;
  }
  
  public ArrayList<Agent> getAgentInsideROI(PVector pos, int size, String type){
    ArrayList<Agent> tmp = new ArrayList<Agent>();
    for (int i=0;i<agents.size();i++){
        if(((agents.get(i).pos.x>pos.x-size/2) && (agents.get(i).pos.x)<pos.x+size/2) &&
        ((agents.get(i).pos.y>pos.y-size/2) && (agents.get(i).pos.y)<pos.y+size/2))
        { 
          if(agents.get(i).type.equals(type)){
            tmp.add(agents.get(i));
          }
          
        }       
      }
    return tmp;
  }
    
  public PVector getLinvingAndWorkingInsideROI(PVector pos, int size){
    PVector tmp = new PVector();
    for (int i=0;i<agents.size();i++){
        if(((agents.get(i).pos.x>pos.x-size/2) && (agents.get(i).pos.x)<pos.x+size/2) &&
        ((agents.get(i).pos.y>pos.y-size/2) && (agents.get(i).pos.y)<pos.y+size/2))
        {
          if(agents.get(i).usage.equals("living")){
            tmp.x++;
          }else{
            tmp.y++;
          }
        }       
      }
    return tmp;
  }
  
    public ArrayList<Node> getNodeInsideROI(PVector pos, int size){
    ArrayList<Node> tmp = new ArrayList<Node>();
    Node tmpNode; 
    for (int i=0;i<map.graph.nodes.size();i++){
      tmpNode = (Node) map.graph.nodes.get(i);
        if(((tmpNode.x>pos.x-size/2) && (tmpNode.x)<pos.x+size/2) &&
        ((tmpNode.y>pos.y-size/2) && (tmpNode.y)<pos.y+size/2))
        {
          tmp.add(tmpNode);
        }       
      }
    return tmp;
  }
  
  

}

public class Agent {
  private RoadNetwork map;
  private String profile;
  private String type;
  private String usage;
  private color myUsageColor;
  private color myProfileColor;
  private PVector pos;
  private float size;
  private float speed;
  private Node srcNode, destNode, toNode;
  private ArrayList<Node> path;
  private PVector dir;  

  Agent(RoadNetwork _map, String _profile, String _type, String _usage) {
    map=_map;
    type=_type;
    profile=_profile;
    usage=_usage;
    srcNode =  (Node) map.graph.nodes.get(int(random(map.graph.nodes.size())));
    destNode =  (Node) map.graph.nodes.get(int(random(map.graph.nodes.size())));
    pos= new PVector(srcNode.x, srcNode.y);
    path=null;
    dir = new PVector(0.0, 0.0);
    myProfileColor= (int)(model.colorProfiles.get(profile));
    myUsageColor = (usage.equals("working")) ? color(model.workingColor) : model.livingColor;

    if (type.equals("people") || type.equals("people_from_grid")) {
      speed= 0.25;
      speed = speed + random(-speed*0.2,speed*0.2);
      size= 4;
    }
    if (type.equals("bike") || type.equals("mobike")) {
      speed= 0.5;
      speed = speed + random(-speed*0.2,speed*0.2);
      size= 4;
    }
    if (type.equals("car")) {
      speed= 1.0;
      speed = speed + random(-speed*0.2,speed*0.2);
      size= 6;
    }
    if (type.equals("static_people") || type.equals("static_bike") || type.equals("static_mobike")) {
      speed= 0;
      size= 4 ;
      if (usage.equals("living")) {
        Building tmp= (buildings.getLivingBuilding().get(int(random(buildings.getLivingBuilding().size()))));
        pos.x = tmp.shape.getVertex(0).x;
        pos.y = tmp.shape.getVertex(0).y;
      } else {
        Building tmp= (buildings.getWorkingBuilding().get(int(random(buildings.getWorkingBuilding().size()))));
        pos.x = tmp.shape.getVertex(0).x;
        pos.y = tmp.shape.getVertex(0).y;
      }
    }    
  }
    ///FIXME: Need to factorize everything here.  
    Agent(RoadNetwork _map, String _profile, String _type, String _usage, Node _srcNode, Node _destNode) {
    map=_map;
    type=_type;
    profile=_profile;
    usage=_usage;
    srcNode =  _srcNode;
    destNode =  _destNode;
    pos= new PVector(srcNode.x, srcNode.y);
    path=null;
    dir = new PVector(0.0, 0.0);
    myProfileColor= (int)(model.colorProfiles.get(profile));
    myUsageColor = (usage.equals("working")) ? color(model.workingColor) : model.livingColor;

    if (type.equals("people") || type.equals("people_from_grid")) {
      speed= 0.25;
      speed = speed + random(-speed*0.2,speed*0.2);
      size= 4;
    }
    if (type.equals("bike") || type.equals("mobike")) {
      speed= 0.5;
      speed = speed + random(-speed*0.2,speed*0.2);
      size= 4;
    }
    if (type.equals("car")) {
      speed= 1.0;
      speed = speed + random(-speed*0.2,speed*0.2);
      size= 6;
    }
    if (type.equals("static_people") || type.equals("static_bike") || type.equals("static_mobike")) {
      speed= 0;
      size= 4 ;
      if (usage.equals("living")) {
        Building tmp= (buildings.getLivingBuilding().get(int(random(buildings.getLivingBuilding().size()))));
        pos.x = tmp.shape.getVertex(0).x;
        pos.y = tmp.shape.getVertex(0).y;
      } else {
        Building tmp= (buildings.getWorkingBuilding().get(int(random(buildings.getWorkingBuilding().size()))));
        pos.x = tmp.shape.getVertex(0).x;
        pos.y = tmp.shape.getVertex(0).y;
      }
    }    
  }


  public void draw(PGraphics p) {
    if (drawer.showAgent) {
      if (type.equals("people") || type.equals("static_people") || type.equals("people_from_grid")) {
        p.noStroke();
        p.fill(myProfileColor);
        p.ellipse(pos.x, pos.y, size, size);
      }
      
      if (type.equals("bike") || type.equals("static_bike")){
        p.stroke(myProfileColor);
        p.strokeWeight(2);
        p.noFill();
        p.ellipse(pos.x, pos.y, size, size);
        p.noStroke();
      }
      if (type.equals("car") || type.equals("static_car")){
        p.stroke(myProfileColor);
        p.strokeWeight(2);
        p.noFill();
        p.ellipse(pos.x, pos.y, size, size);
        p.noStroke();
      }
      if (type.equals("mobike") || type.equals("static_mobike")){
        if(drawer.showMoBike){
          p.fill(#FFFF00);
          p.ellipse(pos.x, pos.y, size, size);
          p.noStroke();
        }
      }
    }
    if( drawer.showCollisionPotential) {
      for (Agent a: model.agents){
        float dist = pos.dist(a.pos);
          if (dist<20) {
            p.stroke(lerpColor(myProfileColor, a.myProfileColor, 0.5));
            p.strokeWeight(1);
            p.line(pos.x, pos.y, a.pos.x, a.pos.y);
            p.noStroke();
          }
      }
    }
  }

  // CALCULATE ROUTE --->
  private boolean calcRoute(Node origin, Node dest) {
    // Agent already in destination --->
    if (origin == dest) {
      toNode=origin;
      return true;
      // Next node is available --->
    } else {
      ArrayList<Node> newPath = map.graph.aStar( origin, dest);
      if ( newPath != null ) {
        path = newPath;
        toNode = path.get( path.size()-2 );
        return true;
      }
    }
    return false;
  }

  public void move() {
    if (path == null) {
      calcRoute( srcNode, destNode );
    }
    PVector toNodePos = new PVector();
    toNodePos = new PVector(toNode.x, toNode.y);
    PVector destNodePos= new PVector(destNode.x, destNode.y);
    dir = PVector.sub(toNodePos, pos);  // Direction to go
    // Arrived to node -->
    if ( dir.mag() < dir.normalize().mult(speed).mag() ) {
      // Arrived to destination  --->
      if ( path.indexOf(toNode) == 0 ) {
        Node tmpNode;
        pos = destNodePos;
        //Re int src and dest
        if(type.equals("people_from_grid")){
          tmpNode= srcNode;
          srcNode=destNode;
          destNode=tmpNode;
        }
        else{
          srcNode =  (Node) map.graph.nodes.get(int(random(map.graph.nodes.size())));
          destNode =  (Node) map.graph.nodes.get(int(random(map.graph.nodes.size())));
        }
        
        pos= new PVector(srcNode.x, srcNode.y);
        path=null;
        dir = new PVector(0.0, 0.0);
        // Not destination. Look for next node --->
      } else {  
        srcNode = toNode;
        toNode = path.get( path.indexOf(toNode)-1 );
      }
      // Not arrived to node --->
    } else {
      //distTraveled += dir.mag();
      pos.add( dir );
      //posDraw = PVector.add(pos, dir.normalize().mult(type.getStreetOffset()).rotate(HALF_PI));
    }
  }
}
