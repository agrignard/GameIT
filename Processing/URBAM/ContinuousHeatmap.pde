public enum Visibility { HIDE, SHOW, TOGGLE; }

public class ContinousHeatmap{
  private String title = "TITLE";
  private int width, height;
  private PImage heatmap, gradientMap, heatmapBrush;
  private HashMap<String, PImage> gradients = new HashMap<String, PImage>();
  private float maxValue = 0;
  private boolean visible = false;
  
  ContinousHeatmap(int x, int y, int width, int height) {
        this.width = width;
        this.height = height;
        
        // Default B/W gradient
        PImage defaultGrad = createImage(255, 1, RGB);
        defaultGrad.loadPixels();
        for(int i = 0; i < defaultGrad.pixels.length; i++) defaultGrad.pixels[i] = color(i, i, i); 
        defaultGrad.updatePixels();
        gradients.put("default", defaultGrad);
        clear();
    }
    
    public void setBrush(String brush, int brushSize) {
        heatmapBrush = loadImage(brush);
        heatmapBrush.resize(brushSize, brushSize);
    }
    
    
    public void addGradient(String name, String path) {
        File file = new File(dataPath(path));
        if( file.exists() ) {
          gradients.put(name, loadImage(path));
        }
    }
    
    public void visible(Visibility v) {
        switch(v) {
            case HIDE:
                visible = false;
                break;
            case SHOW:
                visible = true;
                break;
            case TOGGLE:
                visible = !visible;
                break;
        }
    }

    
    public boolean isVisible() {
        return visible;
    }

  
    public void clear() {
        heatmap = createImage(width, height, ARGB);
        gradientMap = createImage(width, height, ARGB);
        maxValue = 0;
        
    }
    
    
    public void update(String title, ArrayList objects) {
        update(title, objects, "default", false);
    }
    
    public void update(String title, ArrayList<Agent> agents, String gradient, boolean persistance) {
        this.title = title;
        if(drawer.showContinousHeatMap) {
            gradientMap.loadPixels();
            for(int i = 0; i < agents.size(); i++) {
                PVector position = agents.get(i).pos;
                gradientMap = addGradientPoint(gradientMap, position.x, position.y);
            }
            gradientMap.updatePixels();
            PImage gradientColors = gradients.containsKey(gradient) ? gradients.get(gradient) : gradients.get("default");
            if(persistance) heatmap.blend(colorize(gradientMap, gradientColors), 0, 0, width, height, 0, 0, width, height, MULTIPLY);
            else heatmap = colorize(gradientMap, gradientColors);
        }
    }
    public PImage addGradientPoint(PImage img, float x, float y) {
        int startX = int(x - heatmapBrush.width / 2);
        int startY = int(y - heatmapBrush.height / 2);
        for(int pY = 0; pY < heatmapBrush.height; pY++) {
            for(int pX = 0; pX < heatmapBrush.width; pX++) {
                int hmX = startX + pX;
                int hmY = startY + pY;
                if( hmX < 0 || hmY < 0 || hmX >= img.width || hmY >= img.height ) continue;
                int c = heatmapBrush.pixels[pY * heatmapBrush.width + pX] & 0xff;
                int i = hmY * img.width + hmX;
                if(img.pixels[i] < 0xffffff - c) {
                    img.pixels[i] += c;
                    if(img.pixels[i] > maxValue) maxValue = img.pixels[i];
                }
            }
        }
        return img;
    }
    
    
    public PImage colorize(PImage gradientMap, PImage heatmapColors) {
        PImage heatmap = createImage(width, height, ARGB);
        heatmap.loadPixels();
        for(int i=0; i< gradientMap.pixels.length; i++) {  
            int c = heatmapColors.pixels[ (int) map(gradientMap.pixels[i], 0, maxValue, 0, heatmapColors.pixels.length-1) ];
            heatmap.pixels[i] = c;
        }    
        heatmap.updatePixels();
        return heatmap;
    }

    public void draw(PGraphics p) {
       if (frameCount % 10 == 0) {
        aggregatedHeatmap.clear();
        aggregatedHeatmap.update("Aggregated", model.agents, "hot", false);
       }
        if (drawer.showContinousHeatMap) {
          p.beginShape();
          p.texture(heatmap);
          p.vertex(0,0,0,0);
          p.vertex(playGroundWidth, 0, playGroundWidth, 0);
          p.vertex(playGroundWidth, playGroundHeight, playGroundWidth, playGroundHeight);
          p.vertex(0, playGroundHeight, 0, playGroundHeight);
          p.endShape();
        }
    }
}
