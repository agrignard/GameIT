public class Buildings{
  
  ArrayList<PShape> buildings;
  HashMap<String,Integer> hm = new HashMap<String,Integer>();
  
  Buildings (String GeoJSONfile){
    buildings = new ArrayList<PShape>();
    hm = new HashMap<String,Integer>();
    hm.put("Restaurant",#2B6A89);hm.put("Night",#1B2D36);hm.put("Restaurant",#2B6A89);hm.put("GP",#244251);hm.put( "Cultural",#2A7EA6);
    hm.put("Shopping",#1D223A);hm.put("HS",#FFFC2F);hm.put("Uni",#807F30);hm.put(  "O",#545425);
    hm.put("R",#222222);hm.put("Park",#24461F);
    JSONObject JSON = loadJSONObject(GeoJSONfile);
    JSONArray JSONpolygons = JSON.getJSONArray("features");
    
    for(int i=0; i<JSONpolygons.size(); i++) {
      JSONObject props = JSONpolygons.getJSONObject(i).getJSONObject("properties");
      String type = props.isNull("type") ? "null" : props.getString("type");
      String usage = props.isNull("Usage") ? "null" : props.getString("Usage");
      String scale = props.isNull("Scale") ? "null" : props.getString("Scale");
      String category = props.isNull("Category") ? "null" : props.getString("Category");
            
      JSONArray polygons = JSONpolygons.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
      for(int j=0; j<polygons.size(); j++) {
        JSONArray points= polygons.getJSONArray(j);
        PShape s = createShape();
        s.beginShape();
        s.fill(hm.get(category));
        s.noStroke();       
        for(int k=0; k<points.size(); k++) {
          PVector pos = roads.toXY(points.getJSONArray(k).getFloat(1),points.getJSONArray(k).getFloat(0));
          s.vertex(pos.x,pos.y);
        }
        s.endShape(CLOSE);
        buildings.add(s);
      }
    }
  }
  
  public void draw(PGraphics p){
    for (int i=0;i<buildings.size();i++){
      p.shape(buildings.get(i), 0, 0);
    }
  }
  
  
}