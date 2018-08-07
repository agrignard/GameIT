class Block {
  PVector location;
  int size;
  color c;
  int id;
  ParticleSystem ps;
  int intensity;
  boolean visible;

  Block(PVector l, int _size, color _c, int _id, int _intensity) {
    location = l.get();
    size = _size;
    c = _c;
    id=_id;
    intensity = _intensity;
    visible = true;
    ps = new ParticleSystem(l,c);
    systems.add(ps);
  }
  
  void run(PGraphics p){
    ps.addParticle(intensity);
    ps.run(p);
  }

  void display(PGraphics p) {  
      p.rectMode(CENTER);  
      p.fill(c);  
      p.rect(location.x, location.y, size, size);  
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  color c;

  ParticleSystem(PVector _location, color _c) {
    origin = _location;
    particles = new ArrayList<Particle>();
    c = _c;
  }

  void addParticle(int intensity) {
      particles.add(new Particle(origin,c,intensity));
  }
  
  void applyForce(PVector force){
    for(Particle p : particles){
      p.applyForce(force);
    }
  } 

  void run(PGraphics _p) {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run(_p);
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color c;
  int decreasingSpan;

  Particle(PVector l, color _c, int _lifespan) {
    acceleration = new PVector(random(-0.01, 0.01),random(-0.01,0.01));
    velocity = new PVector(random(-1,1),random(-1,1));
    location = l.get();
    lifespan = _lifespan;
    c= _c;
  }

  void run(PGraphics p) {
    update();
    display(p);
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    lifespan -= 5.0;
  }

  // Method to display
  void display(PGraphics p) {
     //p.stroke(c,lifespan);
     p.fill(c,lifespan);
     p.ellipse(location.x,location.y,4,4); 
  }
  
  void applyForce(PVector force){
    acceleration.add(force);
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
