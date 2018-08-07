 public class Buildings{
  
  ArrayList<Building> buildings;
  HashMap<String,Integer> hm = new HashMap<String,Integer>();
  private String usage;
  private String scale;
  private String category;
  HashMap<String,Integer> colorMap = new HashMap<String,Integer>();
  
  Buildings (String GeoJSONfile){
    buildings = new ArrayList<Building>();
    /*hm = new HashMap<String,Integer>();
    hm.put("Restaurant",#2B6A89);hm.put("Night",#1B2D36);hm.put("Restaurant",#2B6A89);hm.put("GP",#244251);hm.put( "Cultural",#2A7EA6);
    hm.put("Shopping",#1D223A);hm.put("HS",#111111);hm.put("Uni",#807F30);hm.put("O",#00ffff);hm.put("P",#AAAAAA);
    hm.put("R",#ff00ff);hm.put("Park",#24461F);*/
    hm = new HashMap<String,Integer>();
    hm.put("Restaurant",#2B6A89);hm.put("Night",#1B2D36);hm.put("Restaurant",#2B6A89);hm.put("GP",#244251);hm.put( "Cultural",#2A7EA6);
    hm.put("Shopping",#1D223A);hm.put("HS",#111111);hm.put("Uni",#807F30);hm.put("O",#00ffff);hm.put("P",#AAAAAA);
    hm.put("R",#ff00ff);hm.put("Park",#24461F);
    colorMap = new HashMap<String,Integer>();
    colorMap.put("RS",#ff00ff);colorMap.put("RM",#b802ff);colorMap.put("RL",#a200ff);
    colorMap.put("OS",#00ffff);colorMap.put( "OM",#0099ff);colorMap.put("OL",#00ffd5);
    JSONObject JSON = loadJSONObject(GeoJSONfile);
    JSONArray JSONpolygons = JSON.getJSONArray("features");
    
    for(int i=0; i<JSONpolygons.size(); i++) {
      JSONObject props = JSONpolygons.getJSONObject(i).getJSONObject("properties");
      String type = props.isNull("type") ? "null" : props.getString("type");
      usage = props.isNull("Usage") ? "null" : props.getString("Usage");
      scale = props.isNull("Scale") ? "null" : props.getString("Scale");
      category = props.isNull("Category") ? "null" : props.getString("Category");
            
      JSONArray polygons = JSONpolygons.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
      for(int j=0; j<polygons.size(); j++) {
        JSONArray points= polygons.getJSONArray(j);
        PShape s = createShape();
        s.beginShape();
        //s.fill(colorMap.get(usage+scale));
        s.noStroke();       
        for(int k=0; k<points.size(); k++) {
          PVector pos = roads.toXY(points.getJSONArray(k).getFloat(1),points.getJSONArray(k).getFloat(0));
          s.vertex(pos.x,pos.y);
        }
        s.endShape(CLOSE);
        Building b= new Building(s,usage,category);
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
  
  
  public ArrayList<Building> getBuildingInsideROI(PVector pos, int size){
    ArrayList<Building> tmp = new ArrayList<Building>();
    for (int i=0;i<buildings.size();i++){
        if(((buildings.get(i).shape.getVertex(0).x>pos.x-size/2) && (buildings.get(i).shape.getVertex(0).x)<pos.x+size/2) &&
        ((buildings.get(i).shape.getVertex(0).y>pos.y-size/2) && (buildings.get(i).shape.getVertex(0).y)<pos.y+size/2))
        {
          tmp.add(buildings.get(i));
        }       
      }
    return tmp;
  }
  
  public ArrayList<Building> getBuildingInsideROIWithType(PVector pos, int size, String category){
    ArrayList<Building> tmp = new ArrayList<Building>();
    for (int i=0;i<buildings.size();i++){
        if(((buildings.get(i).shape.getVertex(0).x>pos.x-size/2) && (buildings.get(i).shape.getVertex(0).x)<pos.x+size/2) &&
        ((buildings.get(i).shape.getVertex(0).y>pos.y-size/2) && (buildings.get(i).shape.getVertex(0).y)<pos.y+size/2))
        { if(buildings.get(i).category.equals(category)){
          tmp.add(buildings.get(i));
        }  
        }       
      }
    return tmp;
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
  String category;
  Building(PShape _shape, String _usage, String _category){
    shape=_shape;
    usage= _usage;
    category=_category;
  }
}
