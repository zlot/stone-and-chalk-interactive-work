class BlobChainShape {
  
  final int STEP = 40;
  
  ArrayList<Vec2> pixelCoords;
  Body body;
  ChainShape chain;
  
  /* Create blobchainshape from blob */
  BlobChainShape(Blob blob) {
    
    pixelCoords = new ArrayList<Vec2>();
    
    final int NUM_OF_EDGES = blob.getEdgeNb();
    EdgeVertex edgeA;
    
    for(int i=0; i<NUM_OF_EDGES; i+= STEP) {
      edgeA = blob.getEdgeVertexA(i);
      pixelCoords.add(new Vec2(edgeA.x*width, edgeA.y*height));
    }
    
    chain = new ChainShape();
    
    Vec2[] vertices = new Vec2[pixelCoords.size()];
    
    for(int i=0; i<vertices.length; i++) {
      vertices[i] = box2d.coordPixelsToWorld(pixelCoords.get(i)); //Convert each vertex to Box2d world coords
    }
    
    chain.createLoop(vertices, vertices.length);
    
    // define body
    BodyDef bd = new BodyDef();
    //bd.type = BodyType.DYNAMIC;

    // create body in box2d world
    body = box2d.world.createBody(bd);
    
    // attach fixture to body
    body.createFixture(chain, 1);
  }
  
  
  void draw() {
    pushStyle();
    strokeWeight(1);
    stroke(0);
    noFill();

    pushMatrix();
    beginShape();
    
    for(int i=0; i<chain.getChildCount(); i++) {
      EdgeShape edgeShape = new EdgeShape();
      chain.getChildEdge(edgeShape, i); // note the C side-effect way of assigning edgeShape
      Vec2 edge = box2d.coordWorldToPixels(edgeShape.m_vertex0);
      vertex(edge.x, edge.y);
      ellipse(edge.x, edge.y, 30, 30);  
    }
   
    endShape();
    popMatrix();

  }
  
  void destroy() {
    if(body != null) {
      box2d.destroyBody(body);
    }
  }
  
}