import java.util.Map;
import java.util.Iterator;
/* ABM CLASS ------------------------------------------------------------*/
public class ABM {
  private int id;
  private RoadNetwork map;
  private String type;
  private ArrayList<Agent> agents;
  private ArrayList<String> profiles;
  private ArrayList<Integer> colors;
  HashMap<String, Integer> colorProfiles; 
  int nbPeoplePerProfile;
  ABM(int _id, RoadNetwork _map, String _type, int _nbPeoplePerProfile) {
    id=_id;
    map=_map;
    type=_type;
    nbPeoplePerProfile= _nbPeoplePerProfile;
    agents = new ArrayList<Agent>();
    profiles = new ArrayList<String>();
    colors = new ArrayList<Integer>();
   /* colors.add(#FFFFB2);
    colors.add(#FFFFB2);
    colors.add(#0B5038);
    colors.add(#8CAB13);
    colors.add(#FFFFFF);
    colors.add(#FECC5C);
    colors.add(#FD8D3C);
    colors.add(#F03B20);
    colors.add(#BD0026);
    colors.add(#FF0000);*/
    
    
    colors.add(color(167,177,60));
    colors.add(color(148,177,60));
    colors.add(color(90,177,60));
    colors.add(color(60,177,132));
    colors.add(color(3,201,68));
    colors.add(color(115,177,60));
    colors.add(color(42,139,190));
    colors.add(color(51,91,193));
    colors.add(color(83,70,212));
    colors.add(color(196,60,177));
    
    
    
    profiles.add("Young Children");
    profiles.add("High School");
    profiles.add("Home maker");
    profiles.add("Retirees");
    profiles.add("Artist");
    profiles.add("College"); 
    profiles.add("Young professional");
    profiles.add("Mid-career workers");
    profiles.add("Executives"); 
    profiles.add("Workforce");
    colorProfiles = new HashMap<String, Integer>();
    colorProfiles.put(profiles.get(0), colors.get(0));
    colorProfiles.put(profiles.get(1), colors.get(1));
    colorProfiles.put(profiles.get(2), colors.get(2));
    colorProfiles.put(profiles.get(3), colors.get(3));
    colorProfiles.put(profiles.get(4), colors.get(4));
    colorProfiles.put(profiles.get(5), colors.get(5));
    colorProfiles.put(profiles.get(6), colors.get(6));
    colorProfiles.put(profiles.get(7), colors.get(7));
    colorProfiles.put(profiles.get(8), colors.get(8));
    colorProfiles.put(profiles.get(9), colors.get(9));
  }

  public void initModel() {
    agents.clear();
    createAgents(id,nbPeoplePerProfile, type);
    createStaticAgents(id,nbPeoplePerProfile, "static");
  }

  public void updateGlobalPop(int modelId) {
    if (frameCount % 30 == 0) {
      if (sliderHandler.globalSliders.get(0)>sliderHandler.tmpGlobalSliders.get(0)) {
        addNAgentsPerUsage(modelId, (int)((sliderHandler.globalSliders.get(0) - sliderHandler.tmpGlobalSliders.get(0)))*1000/100, "working");
        sliderHandler.tmpGlobalSliders.set(0, sliderHandler.globalSliders.get(0));
      }
      if (sliderHandler.globalSliders.get(0)<sliderHandler.tmpGlobalSliders.get(0)) {
        removeNAgentsPerUsage(modelId, int((sliderHandler.tmpGlobalSliders.get(0) - sliderHandler.globalSliders.get(0)))*1000/100, "working");
        sliderHandler.tmpGlobalSliders.set(0, sliderHandler.globalSliders.get(0));
      }
      if (sliderHandler.globalSliders.get(1)>sliderHandler.tmpGlobalSliders.get(1)) {
        addNAgentsPerUsage(modelId, int((sliderHandler.globalSliders.get(1) - sliderHandler.tmpGlobalSliders.get(1)))*1000/100, "living");
        sliderHandler.tmpGlobalSliders.set(1, sliderHandler.globalSliders.get(1));
      }
      if (sliderHandler.globalSliders.get(1)<sliderHandler.tmpGlobalSliders.get(1)) {
        removeNAgentsPerUsage(modelId, int((sliderHandler.tmpGlobalSliders.get(1) - sliderHandler.globalSliders.get(1)))*1000/100, "living");
        sliderHandler.tmpGlobalSliders.set(1, sliderHandler.globalSliders.get(1));
      }
    }
  }

  public void updateLocapPop(int modelId) {
    if (frameCount % 30 == 0) {
      for (int i=0; i<sliderHandler.tmpLocalSliders.size(); i++) {
        if (sliderHandler.localSliders.get(i)>sliderHandler.tmpLocalSliders.get(i)) {
          if (i<5) {
            addNAgentPerProfiles(modelId, (int)((sliderHandler.localSliders.get(i) - sliderHandler.tmpLocalSliders.get(i)))*2, profiles.get(i), "living") ;
          } else {
            addNAgentPerProfiles(modelId, (int)((sliderHandler.localSliders.get(i) - sliderHandler.tmpLocalSliders.get(i)))*2, profiles.get(i), "working") ;
          }
          sliderHandler.tmpLocalSliders.set(i, sliderHandler.localSliders.get(i));
        }
        if (sliderHandler.localSliders.get(i)<sliderHandler.tmpLocalSliders.get(i)) {
          removeNAgentsPerProfiles(modelId, int((sliderHandler.tmpLocalSliders.get(i) - sliderHandler.localSliders.get(i)))*2, profiles.get(i));
          sliderHandler.tmpLocalSliders.set(i, sliderHandler.localSliders.get(i));
        }
      }
    }
  }

  public void run(PGraphics p) {
    for (int i=0; i<agents.size(); i++) {
      if(!agents.get(i).type.equals("static")){
         agents.get(i).move();
      } 
      agents.get(i).draw(p);
    }
  }

  public void addNAgentsPerUsage(int modelId, int num, String usage) {
    for (int i = 0; i < num; i++) {
      if (usage.equals("living")) {
        models.get(modelId).agents.add( new Agent(modelId,map, profiles.get(int(random(4))), "people", "living"));
      } else {
        models.get(modelId).agents.add( new Agent(modelId,map, profiles.get(5+int(random(4))), "people", "working"));
      }
    }
  }

  public void removeNAgentsPerUsage(int modelId, int num, String usage) {
    Iterator<Agent> ag = models.get(modelId).agents.iterator();
    int i=0;
    while (ag.hasNext()) { 
      Agent tmpAg = ag.next();

      if (usage.equals(tmpAg.usage)) { 
        if (i<num) { 
          ag.remove();
          i++;
        }
      }
    }
  }  


  public void addNAgentPerProfiles(int modelId, int num, String profile, String usage) {
    for (int i = 0; i < num; i++) {
      models.get(modelId).agents.add( new Agent(modelId,map, profile, "people", usage));
    }
  }

  public void removeNAgentsPerProfiles(int modelId, int n, String profile) {
    Iterator<Agent> ag = models.get(modelId).agents.iterator();
    int i=0;
    while (ag.hasNext()) { 
      Agent tmpAg = ag.next();

      if (profile.equals(tmpAg.profile)) { 
        if (i<n) { 
          ag.remove();
          i++;
        }
      }
    }
  }

  public void createAgents(int id, int num, String type) {
    for (int i = 0; i < num; i++) {
      for (int j=0; j<profiles.size()/2; j++) {
        agents.add( new Agent(id, map, profiles.get(j), type, "living"));
      }
      for (int j=5; j<profiles.size(); j++) {
        agents.add( new Agent(id, map, profiles.get(j), type, "working"));
      }
    }
  }
  
  public void createStaticAgents(int id, int num, String type) {
    for (int i = 0; i < num; i++) {
      for (int j=0; j<profiles.size()/2; j++) {
        agents.add( new Agent(id, map, profiles.get(j), type, "living"));
      }
      for (int j=5; j<profiles.size(); j++) {
        agents.add( new Agent(id, map, profiles.get(j), type, "working"));
      }
    }
  }
  
  public int getNbCars(){
    int nbCars=0;
    for (int i=0;i<agents.size();i++){
      if(agents.get(i).type.equals("car")){
        nbCars++;
      }
    }
    return nbCars;
  }
  public void updateCarPop(){
    if (frameCount % 300 == 0) {
      int living=0;
      int working=0;
      int nbCars=getNbCars();
      for (int i=0;i<agents.size();i++){
        if(agents.get(i).usage.equals("living")){
          living++;
        }else{
          working++;
        }
      }
      int nbNewCar = abs((sliderHandler.globalSliders.get(1)-sliderHandler.tmpLocalSliders.get(1))-(sliderHandler.globalSliders.get(0)-sliderHandler.tmpLocalSliders.get(0)));
      nbNewCar=nbNewCar*10;
      sliderHandler.tmpLocalSliders.set(0, sliderHandler.localSliders.get(0));
      sliderHandler.tmpLocalSliders.set(1, sliderHandler.localSliders.get(1));
      if(nbNewCar>0){
        if(getNbCars()<nbNewCar){
          for(int i=0;i<nbNewCar-nbCars;i++){
            if(living>working){
              agents.add( new Agent(id, map, profiles.get(4), "car", "living"));
            }else{
              agents.add( new Agent(id, map, profiles.get(int(5+random(4))), "car", "working"));
            }
          } 
        }else{
            Iterator<Agent> ag = models.get(0).agents.iterator();
            int i=0;
            while (ag.hasNext()) { 
            Agent tmpAg = ag.next();
              if (tmpAg.type.equals("car")) { 
                if (i<nbNewCar-nbCars) { 
                  ag.remove();
                  i++;
                }
              }
            }
        }
      }else{
        if(getNbCars()>0){
          int tmp = getNbCars(); 
          Iterator<Agent> ag = models.get(0).agents.iterator();
            int i=0;
            while (ag.hasNext()) { 
            Agent tmpAg = ag.next();
              if (tmpAg.type.equals("car")) { 
                if (i<tmp) { 
                  ag.remove();
                  i++;
                }
              }
            }
        }
      }
    }
  }
}

public class Agent {
  private int modelId;
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
  //map<string,rgb> color_per_type <- [ "High School Student"::#FFFFB2, "College student"::#FECC5C,"Young professional"::#FD8D3C,  "Mid-career workers"::#F03B20, "Executives"::#BD0026, "Home maker"::#0B5038, "Retirees"::#8CAB13];


  Agent(int _modelId, RoadNetwork _map, String _profile, String _type, String _usage) {
    modelId = _modelId;
    map=_map;
    type=_type;
    profile=_profile;
    usage=_usage;
    srcNode =  (Node) map.graph.nodes.get(int(random(map.graph.nodes.size())));
    destNode =  (Node) map.graph.nodes.get(int(random(map.graph.nodes.size())));
    pos= new PVector(srcNode.x, srcNode.y);
    path=null;
    dir = new PVector(0.0, 0.0);
    myProfileColor= (int)(models.get(0).colorProfiles.get(profile));
    myUsageColor = (usage.equals("working")) ? #165E93 : #F4A528;

    if (type.equals("car")) {
      speed= 0.3 + random(0.5);
      size= 5 + random(5);
    }
    if (type.equals("people")) {
      speed= 0.05 + random(0.1);
      size= 3 + random(8);
    }
    if(type.equals("static")){
      speed= 0.1 + random(0.5);
      size= 3 + random(8);
      if(usage.equals("living")){
        Building tmp= (buildings.getLivingBuilding().get(int(random(buildings.getLivingBuilding().size()))));
        pos.x = tmp.shape.getVertex(0).x;
        pos.y = tmp.shape.getVertex(0).y;
      }else{
        Building tmp= (buildings.getWorkingBuilding().get(int(random(buildings.getWorkingBuilding().size()))));
        pos.x = tmp.shape.getVertex(0).x;
        pos.y = tmp.shape.getVertex(0).y;
      }
    }
  }


  public void draw(PGraphics p) {
    if (drawer.showAgent) {
      if (type.equals("people") || type.equals("static")) {
        p.noStroke();
        if (drawer.showUsage) {
          p.fill(myUsageColor);
        } else {
          p.fill(myProfileColor);
        }
        p.ellipse(pos.x, pos.y, size, size);
      }
      if (type.equals("car")) { 
        p.stroke(myProfileColor);
        p.strokeWeight(2);
        p.noFill();
        p.ellipse(pos.x, pos.y, size, size);
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
    if(modelId==0){
      toNodePos = new PVector(toNode.x, toNode.y);
    }
    if(modelId==1){
      //toNodePos= new PVector(mouseX + random(-grid.cellSize,grid.cellSize), mouseY + random(-grid.cellSize,grid.cellSize));
      toNodePos = new PVector(toNode.x, toNode.y);
    }
    //PVector toNodePos= new PVector(mouseX, mouseY);
    PVector destNodePos= new PVector(destNode.x, destNode.y);
    dir = PVector.sub(toNodePos, pos);  // Direction to go
    // Arrived to node -->
    if ( dir.mag() < dir.normalize().mult(speed).mag() ) {
      // Arrived to destination  --->
      if ( path.indexOf(toNode) == 0 ) {  
        pos = destNodePos;
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