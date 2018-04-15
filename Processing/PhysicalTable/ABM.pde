/* ABM CLASS ------------------------------------------------------------*/
public class ABM {
  private RoadNetwork map;
  private ArrayList<Agent> agents;
  public ArrayList<Integer> colorPalette;

  
  ABM(RoadNetwork _map){
    map=_map;
    agents = new ArrayList<Agent>();
    colorPalette = new ArrayList<Integer>();
    colorPalette.add(#FFFFB2);colorPalette.add(#FECC5C);colorPalette.add(#FD8D3C);colorPalette.add(#F03B20);
    colorPalette.add(#BD0026);colorPalette.add(#0B5038);colorPalette.add(#0B5038);  
  }
  
  public void initModel(){
    createAgents(2000);
  }
  
  public void run(PGraphics p){
    for (Agent agent : agents) {
      agent.move();
      agent.draw(p);
    }
  }
  
  public void createAgents(int num) {
    for (int i = 0; i < num; i++){
      agents.add( new Agent(map));
    }
  } 
}

public class Agent{
  private RoadNetwork map;
  private color myColor;
  private PVector pos;
  private float size;
  private float speed;
  private Node srcNode, destNode, toNode;
  private ArrayList<Node> path;
  private PVector dir;  
  //map<string,rgb> color_per_type <- [ "High School Student"::#FFFFB2, "College student"::#FECC5C,"Young professional"::#FD8D3C,  "Mid-career workers"::#F03B20, "Executives"::#BD0026, "Home maker"::#0B5038, "Retirees"::#8CAB13];
  
  
  Agent(RoadNetwork _map){
    map=_map;
    initAgent();
  }
  
  
  public void initAgent(){
    srcNode =  (Node) map.graph.nodes.get(int(random(map.graph.nodes.size())));
    destNode =  (Node) map.graph.nodes.get(int(random(map.graph.nodes.size())));
    pos= new PVector(srcNode.x,srcNode.y);
    path=null;
    dir = new PVector(0.0, 0.0);
    myColor= color(int(model.colorPalette.get(int(random(7)))));
    size= 3 + random(5);
    speed= 0.01 + random(0.2);
  }
    
  public void draw(PGraphics p){
    if(drawer.showAgent){
      p.noStroke();
      p.fill(myColor);
      p.ellipse(pos.x, pos.y, size, size);
    }
    
  }
    
  // CALCULATE ROUTE --->
  private boolean calcRoute(Node origin, Node dest) {
    // Agent already in destination --->
    if (origin == dest) {
      toNode=origin;
      return true;
      // Next node is available --->
    }  else {
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
        if (path == null){
          calcRoute( srcNode, destNode );
        }
        PVector toNodePos= new PVector(toNode.x,toNode.y);
        PVector destNodePos= new PVector(destNode.x,destNode.y);
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