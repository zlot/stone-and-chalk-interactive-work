// Appropriated from The Nature of Code by Daniel Shiffman

class CustomShape {

  Body body;

  CustomShape() {
    makeBody();
  }

  void makeBody() {

    PolygonShape shape = new PolygonShape();

    Vec2[] vertices = new Vec2[4];
    vertices[0] = box2d.vectorPixelsToWorld(new Vec2(-15, 25));
    vertices[1] = box2d.vectorPixelsToWorld(new Vec2(15, 0));
    vertices[2] = box2d.vectorPixelsToWorld(new Vec2(20, -15));
    vertices[3] = box2d.vectorPixelsToWorld(new Vec2(-10, -10));
    
    shape.set(vertices, vertices.length);
    
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(new PVector(displayWidth/4, displayHeight/4)));
    body = box2d.createBody(bd);
    
    body.createFixture(shape, 1.0);
    
  }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    
    Fixture f = body.getFixtureList();
    PolygonShape polygonShape = (PolygonShape) f.getShape();
    
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(175);
    stroke(0);
    beginShape();
    // For every vertex, convert to pixel vector
    for(int i=0; i<polygonShape.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(polygonShape.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
    
  }


  void destroy() {
    box2d.destroyBody(body);
  }
}