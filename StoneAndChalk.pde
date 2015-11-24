import blobDetection.*;
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import controlP5.*;


ControlP5 cp5;

Box2DProcessing box2d;

Boundary floor;

BlobCtrl blobCtrl;
SnowflakeCtrl snowflakeCtrl;
VisionCtrl visionCtrl;

ArrayList<BlobChainShape> blobChainShapes;

void setup() {
  size(1024, 768, P2D);
  smooth();

  cp5 = new ControlP5(this);

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);
  // Add a listener to listen for collisions
  box2d.world.setContactListener(new CustomListener());
  
  floor = new Boundary(width/2, height-5, width, 10);

  visionCtrl = new VisionCtrl(this);
  blobCtrl = new BlobCtrl(visionCtrl.srcImg.width, visionCtrl.srcImg.height);
  snowflakeCtrl = new SnowflakeCtrl();

  blobChainShapes = new ArrayList<BlobChainShape>();

  setupControls();
}

void draw() {
  background(9, 21, 45);
  
  floor.display();
  

  snowflakeCtrl.updateAndDraw();
  
  if(random(1) < 0.2) {
    snowflakeCtrl.addSnowflake();
  }

  blobCtrl.detectBlobs(visionCtrl.srcImg);

  for(Blob blob : blobCtrl.blobs) {
    blobChainShapes.add(new BlobChainShape(blob));
  }
  
  for(BlobChainShape blobChainShape : blobChainShapes) {
    blobChainShape.draw();  
  }
  
  box2d.step();

  for(BlobChainShape blobChainShape : blobChainShapes) {
   blobChainShape.destroy();
  }
  blobChainShapes.clear();

  // DEBUGs
  //blobCtrl.drawSrcImg();
  visionCtrl.drawDebug();
  
  // Draw framerate
  fill(255);
  text("framerate: " + (int)frameRate, 12, 16);
}


void setupControls() {
  cp5.addSlider("blobThreshold")
    .setPosition(100, 50)
    .setRange(0, 0.3)
    .setValue(0.1f);
    
  cp5.addSlider("kinectMinThreshold")
    .setPosition(100, 150)
    .setRange(30, 100)
    .setValue(visionCtrl.minDepth);
  cp5.addSlider("kinectMaxThreshold")
    .setPosition(100, 250)
    .setRange(850, 1100)
    .setValue(visionCtrl.maxDepth);
}

// an event from slider blobThreshold
public void blobThreshold(float theValue) {
  blobCtrl.blobThreshold = theValue;
}

public void kinectMinThreshold(float theValue) {
  visionCtrl.minDepth = (int)theValue;
}
public void kinectMaxThreshold(float theValue) {
  visionCtrl.maxDepth = (int)theValue;
}