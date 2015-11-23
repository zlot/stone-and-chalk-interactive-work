class BlobChainShape {
  
  final static int STEP = 10;
  
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
    
    // Was getting assertion errors here with createLoop
    // TODO: Test to make sure all assertion errors are gone
    try {
      chain.createLoop(vertices, vertices.length);  
      // define body
      BodyDef bd = new BodyDef();
      // create body in box2d world
      body = box2d.world.createBody(bd);
      // attach fixture to body
      body.createFixture(chain, 1);
    } catch(AssertionError ex) {
      println("Received an assertion error when trying to createChain. Just going to continue ...");
    }
    
    

  }
  
  
  void draw() {
    pushStyle();
    strokeWeight(4);
    stroke(0,255,0);
    noFill();
    int childCount = chain.getChildCount();
    for(int i=0; i<childCount; i++) {
      EdgeShape edgeShape = new EdgeShape();
      chain.getChildEdge(edgeShape, i); // note the C side-effect way of assigning edgeShape
      Vec2 v = box2d.coordWorldToPixels(edgeShape.m_vertex0);
      ellipse(v.x, v.y, 30, 30);  
    }
   
  }
  
  void destroy() {
    if(body != null) {
      box2d.destroyBody(body);
    }
  }
  
}