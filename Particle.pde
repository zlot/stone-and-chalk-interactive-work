// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// A circular particle

class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  PGraphics snowflakeType;
  int startTime, startFadeAt, lifeSpan;
  int opacity;
  
  
  Particle(float x, float y, float r_, PGraphics s) {
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(x, y, r);
    snowflakeType = s;
    startTime = millis();
    startFadeAt = 5000;
    lifeSpan = 10000;
    opacity = 255;
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }else if(millis()-startTime>=lifeSpan){
      killBody();
      return true;
    }
    return false;
  }   
   
  void display() {
    //Decrease opacity of snowflake after set time
    if(millis()-startTime>=startFadeAt && opacity>0){
      opacity--;
    }
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body); 
   
    pushMatrix();
      translate(pos.x, pos.y);
      rotate(body.getAngle());
      pushStyle();
      tint(255, opacity);
      image(snowflakeType, -(snowflakeType.width/2), -(snowflakeType.height/2));
      popStyle();
    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);
    bd.linearDamping = 0.8;
    bd.angularDamping = 2;


    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 30;
    fd.friction = 0.01;
    fd.restitution = 0.3;

    // Attach fixture to body
    body.createFixture(fd);

    body.setAngularVelocity(random(-1, 1));
  }
}