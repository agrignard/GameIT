class Block {
  PVector location;
  int size;
  color c;
  ParticleSystem ps;

  Block(PVector l, int _size, color _c) {
    location = l.get();
    size = _size;
    c = _c;
    ps = new ParticleSystem(l,c);
    systems.add(ps);
  }
  
  void run(){
    ps.addParticle();
    ps.run();
  }

  void display(PGraphics p) {  
      //p.fill(255);  
      //p.rect(location.x, location.y, size, size);  
  }
}

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color c;

  Particle(PVector l, color _c) {
    acceleration = new PVector(random(-0.01, 0.01),random(-0.01,0.01));
    velocity = new PVector(random(-1,1),random(-1,1));
    location = l.get();
    lifespan = 255.0;
    c= _c;
  }

  void run() {
    update();
    display(offscreen);
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
    p.stroke(c,lifespan);
    p.fill(c,lifespan);
    p.ellipse(location.x,location.y,8,8);  
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

// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  color c;

  ParticleSystem(PVector _location, color _c) {
    origin = _location;
    particles = new ArrayList<Particle>();
    c = _c;
  }

  void addParticle() {
      particles.add(new Particle(origin,c));
  }
  
  void applyForce(PVector force){
    for(Particle p : particles){
      p.applyForce(force);
    }
  } 

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
