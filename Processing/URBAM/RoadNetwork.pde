  import ai.pathfinder.*;

public class RoadNetwork {
  private PVector size;
  private float scale;
  private PVector[] bounds;  // [0] Left-Top  [1] Right-Bottom
  private Pathfinder graph;
  /* <--- CONSTRUCTOR ---> */
  RoadNetwork(String GeoJSONfile) {

    ArrayList<Node> nodes = new ArrayList<Node>();
    
    // Load file -->
    JSONObject JSON = loadJSONObject(GeoJSONfile);
    JSONArray JSONlines = JSON.getJSONArray("features");
    JSONArray JSONBoundslines = JSONBounds.getJSONArray("features");
    setBoundingBox(JSONBoundslines);
    
    // Import all nodes -->
    Node prevNode = null;
    for(int i=0; i<JSONlines.size(); i++) {
      
      JSONObject props = JSONlines.getJSONObject(i).getJSONObject("properties");
      String type = props.isNull("type") ? "null" : props.getString("type");
      String name = props.isNull("name") ? "null" : props.getString("name");
      boolean oneWay = props.isNull("oneway") ? false : props.getBoolean("oneway");
      
      JSONArray points = JSONlines.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
      for(int j=0; j<points.size(); j++) {
           // Point coordinates to XY screen position -->
        PVector pos = toXY(points.getJSONArray(j).getFloat(1), points.getJSONArray(j).getFloat(0));
        
        // Node already exists (same X and Y pos). Connect  -->
        Node existingNode = nodeExists(pos.x, pos.y, nodes);
        if(existingNode != null) {
          if(j>0) {
            prevNode.connect( existingNode);
            existingNode.connect(prevNode);
            //prevNode.connectBoth( existingNode, type, name, allowedAccess );
            //if(oneWay) existingNode.forbid(prevNode, RoadAgent.CAR);
          }
          prevNode = existingNode;
          
        // Node doesn't exist yet. Create it and connect -->
        } else {
          Node newNode = new Node(pos.x, pos.y);
          if(j>0) {
            prevNode.connect( newNode);
            newNode.connect( prevNode);
          }
          nodes.add(newNode);
          prevNode = newNode;
          
        }
      }
      }
      graph = new Pathfinder(nodes); 
    }

  private Node nodeExists(float x, float y, ArrayList<Node> nodes) {
    for(Node node : nodes) {
      if(node.x == x && node.y == y) {
        return node;
      }
    }
    return null;
  }
  
  // FIND NODES BOUNDS -->
  public void setBoundingBox(JSONArray JSONlines) {
    float minLat = Float.MAX_VALUE,
          minLng = Float.MAX_VALUE,
          maxLat = -Float.MAX_VALUE,
          maxLng = -Float.MAX_VALUE;
    for(int i=0; i<JSONlines.size(); i++) {
      JSONArray points = JSONlines.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
      for(int j=0; j<points.size(); j++) {
        float Lat = points.getJSONArray(j).getFloat(1);
        float Lng = points.getJSONArray(j).getFloat(0);
        if( Lat < minLat ) minLat = Lat;
        if( Lat > maxLat ) maxLat = Lat;
        if( Lng < minLng ) minLng = Lng;
        if( Lng > maxLng ) maxLng = Lng;
      }
    }
    
    // Conversion to Mercator projection -->
    PVector coordsTL = toWebMercator(minLat, minLng);
    PVector coordsBR = toWebMercator(maxLat, maxLng);
    this.bounds = new PVector[] { coordsTL, coordsBR };
    println("coordsTL" + coordsTL + "coordsBR" + coordsBR);
    // Resize map keeping ratio -->
    float mapRatio = (coordsBR.x - coordsTL.x) / (coordsBR.y - coordsTL.y);
    this.size = mapRatio < 1 ? new PVector( height * mapRatio, height ) : new PVector( width , width / mapRatio ) ;
    this.scale = (coordsBR.x - coordsTL.x) / size.x;     
  }
 
  
    // CONVERT TO WEBMERCATOR PROJECTION
  private PVector toWebMercator( float lat, float lng ) {
    float RADIUS = 6378137f; // Earth Radius
    float sin = sin( radians(lat) );
    return new PVector(lng * radians(RADIUS), ( RADIUS / 2 ) * log( ( 1.0 + sin ) / ( 1.0 - sin ) ));
  }
  
    // LAT, LNG COORDINATES TO XY SCREEN POINTS -->
  private PVector toXY(float lat, float lng) {
    PVector projectedPoint = toWebMercator(lat, lng);
    return new PVector(
      map(projectedPoint.x, bounds[0].x, bounds[1].x, 0, size.x),
      map(projectedPoint.y, bounds[0].y, bounds[1].y, size.y, 0)
    );
  }
  
  public ArrayList<Node> getNodeInsideROI(PVector pos, int size){
    ArrayList<Node> tmp = new ArrayList<Node>();
    for (int i=0;i<graph.nodes.size();i++){
        Node tempN = (Node)graph.nodes.get(i);
        if(((tempN.x>pos.x-size/2) && (tempN.x)<pos.x+size/2) &&
        ((tempN.y>pos.y-size/2) && (tempN.y)<pos.y+size/2))
        {
          tmp.add(tempN);
        }       
      }
    return tmp;
  }
  
  public void draw(PGraphics p){ 
    if(drawer.showRoad){
      for(int i = 0; i < graph.nodes.size(); i++){
      Node tempN = (Node)graph.nodes.get(i);
      for(int j = 0; j < tempN.links.size(); j++){
        color c= #FFFFFF;
        if(drawer.showCongestedRoad){
          float weight = model.getAgentInsideROI(new PVector(tempN.x,tempN.y),int(legoGrid.cellsize)).size()/5.0;
          //float dist = dist(tempN.x, tempN.y, ((Connector)tempN.links.get(j)).n.x, ((Connector)tempN.links.get(j)).n.y);
          //weight = dist/50.0;
          //println(weight);
          if (weight<0.5) {
            c = lerpColor(legoGrid.c1, legoGrid.c2, weight*2);
          } 
          else {
            c = lerpColor(legoGrid.c2, legoGrid.c3, (weight-0.5)*2);
          }
        }
        p.stroke(c); p.strokeWeight(2);
        p.line(tempN.x, tempN.y, ((Connector)tempN.links.get(j)).n.x, ((Connector)tempN.links.get(j)).n.y);
        p.noStroke();
      }
    }
    }
      
  }
}  
