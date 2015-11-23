// Appropriated from The Nature of Code by Daniel Shiffman

class Box {
  
  Body body;
  float w, h;
  
  Box(float x, float y) {

    w = 16;
    h = 16;
    
    // define the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    
    // create the body in world
    body = box2d.createBody(bd);
    
    PolygonShape ps = new PolygonShape();
    
    float box2dW = box2d.scalarPixelsToWorld(w/2); // Box2D considers w/h of a rect to be the dist from the center to the edge.
    float box2dH = box2d.scalarPixelsToWorld(h/2);

    ps.setAsBox(box2dW, box2dH);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    
    // attach fixture to body
    body.createFixture(fd);
  }
  
  void draw() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a); // have to use minus angle because of counterclockwise rotation in Box2D
    fill(175);
    stroke(0);
    rectMode(CENTER);
    rect(0,0,w,h);
    popMatrix();
  }
  
  void destroy() {
    box2d.destroyBody(body);
  }
  
}