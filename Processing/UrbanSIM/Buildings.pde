public class Buildings{
  
  ArrayList<Building> buildings;
  HashMap<String,Integer> hm = new HashMap<String,Integer>();
  private String usage;
  
  Buildings (String GeoJSONfile){
    buildings = new ArrayList<Building>();
    hm = new HashMap<String,Integer>();
    hm.put("Restaurant",#2B6A89);hm.put("Night",#1B2D36);hm.put("Restaurant",#2B6A89);hm.put("GP",#244251);hm.put( "Cultural",#2A7EA6);
    hm.put("Shopping",#1D223A);hm.put("HS",#111111);hm.put("Uni",#807F30);hm.put(  "O",#545425);
    hm.put("R",#222222);hm.put("Park",#24461F);
    JSONObject JSON = loadJSONObject(GeoJSONfile);
    JSONArray JSONpolygons = JSON.getJSONArray("features");
    
    for(int i=0; i<JSONpolygons.size(); i++) {
      JSONObject props = JSONpolygons.getJSONObject(i).getJSONObject("properties");
      String type = props.isNull("type") ? "null" : props.getString("type");
      usage = props.isNull("Usage") ? "null" : props.getString("Usage");
      String scale = props.isNull("Scale") ? "null" : props.getString("Scale");
      String category = props.isNull("Category") ? "null" : props.getString("Category");
            
      JSONArray polygons = JSONpolygons.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
      for(int j=0; j<polygons.size(); j++) {
        JSONArray points= polygons.getJSONArray(j);
        PShape s = createShape();
        s.beginShape();
        s.fill(hm.get(usage));
        s.noStroke();       
        for(int k=0; k<points.size(); k++) {
          PVector pos = roads.toXY(points.getJSONArray(k).getFloat(1),points.getJSONArray(k).getFloat(0));
          s.vertex(pos.x,pos.y);
        }
        s.endShape(CLOSE);
        Building b= new Building(s,usage);
        buildings.add(b);
      }
    }
  }
  
  public void draw(PGraphics p){
    if (drawer.showBuilding){ 
      for (int i=0;i<buildings.size();i++){
        p.shape(buildings.get(i).shape, 0, 0);
      }
    }
  }
  
  public ArrayList<Building> getWorkingBuilding(){
    ArrayList<Building> tmp = new ArrayList<Building>();
    for (int i=0;i<buildings.size();i++){
        if(buildings.get(i).usage.equals("O"))
        {
          tmp.add(buildings.get(i));
        }       
      }
    return tmp;
  }
  
  public ArrayList<Building> getLivingBuilding(){
    ArrayList<Building> tmp = new ArrayList<Building>();
    for (int i=0;i<buildings.size();i++){
        if(buildings.get(i).usage.equals("R"))
        {
          tmp.add(buildings.get(i));
        }       
      }
    return tmp;
  }
  
}

public class Building{
  PShape shape;
  String usage;
  Building(PShape _shape, String _usage){
    shape=_shape;
    usage= _usage;
  }
}