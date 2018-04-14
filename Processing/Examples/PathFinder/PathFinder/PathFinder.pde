import ai.pathfinder.*;

// Demo of Dijkstra algorithm

Pathfinder dijk;
int w = 10;
int h = 10;
int spacing;
PFont font;

void setup(){
  size(400, 400);
  spacing = width / w;
  smooth();
  dijk = new Pathfinder(w, h, 1.0);
  //font = loadFont("ArialMT-10.vlw");
  //textFont(font, 10);
}

void draw(){
  background(230);
  fill(255);
  int m = (mouseX/spacing) + (mouseY/spacing) * w;
  rect((m % w) * spacing, (m / w) * spacing, spacing, spacing);
  drawConnectors();
  drawNodes();
}

void mousePressed(){
  int m = (mouseX/spacing) + (mouseY/spacing) * w;
  Node n = (Node)dijk.nodes.get(m);
  dijk.dijkstra(n);
}

void drawNodes(){
  stroke(10);
  for(int i = 0; i < dijk.nodes.size(); i++){
    Node n = (Node)dijk.nodes.get(i);
    Node p = null;
    int pnum = -1;
    if(n.parent != null){
      p = n.parent;
      pnum = dijk.indexOf(p);
    }
    int x = i % w;
    int y = i / w;
    int s = spacing / 2;
    fill(255);
    ellipse(s + x * spacing, s + y * spacing, 10, 10);
    fill(0);
    text(nf(n.g, 2, 1), 10 + x * spacing, 10 + y * spacing);
    if(p != null){
      int px = pnum % w;
      int py = pnum / w;
      line(s + x * spacing, s + y * spacing, s + lerp(x, px, .75) * spacing, s + lerp(y, py, .75) * spacing);
    }
  }
}
void drawConnectors(){
  stroke(200, 200, 250);
  for(int i = 0; i < dijk.nodes.size(); i++){
    Node n = (Node)dijk.nodes.get(i);
    int cnum = -1;
    for(int j = 0; j < n.links.size(); j++){
      Connector c = (Connector)n.links.get(j);
      cnum = dijk.indexOf(c.n);
      int x = i % w;
      int y = i / w;
      int cx = cnum % w;
      int cy = cnum / w;
      int s = spacing / 2;
      line(s + x * spacing, s + y * spacing, s + cx * spacing, s + cy * spacing);
    }
  }
}  