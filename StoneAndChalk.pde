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
ArrayList<Controller> controls;
boolean isControlsShowing = false;

Box2DProcessing box2d;

Boundary floor;

BlobCtrl blobCtrl;
SnowflakeCtrl snowflakeCtrl;
VisionCtrl visionCtrl;

ArrayList<BlobChainShape> blobChainShapes;

boolean drawDebug = false;
boolean drawFramerate = false;
boolean drawBlobChainShapes = false;
boolean drawBlobSrcImg = true;

void setup() {
  size(1024, 768, P2D);
  noSmooth();
  noStroke();
  cp5 = new ControlP5(this);
  controls = new ArrayList<Controller>();

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

int snowflakesPerDrawLoop;

void draw() {
  background(9, 21, 45);
  
  floor.display();
  
  blendMode(ADD);
  snowflakeCtrl.updateAndDraw();
  blendMode(NORMAL);
  
  if(random(1) < 0.2) {
    for(int i=0; i<snowflakesPerDrawLoop; i++) {
      snowflakeCtrl.addSnowflake();  
    }
  }

  blobCtrl.detectBlobs(visionCtrl.getImage());

  for(Blob blob : blobCtrl.blobs) {
    blobChainShapes.add(new BlobChainShape(blob));
  }  
  
  if(drawBlobChainShapes) {
    for(BlobChainShape blobChainShape : blobChainShapes) {
      blobChainShape.draw();  
    }    
  }
  
  box2d.step();

  for(BlobChainShape blobChainShape : blobChainShapes) {
   blobChainShape.destroy();
  }
  blobChainShapes.clear();

  if(drawBlobSrcImg) {
    blobCtrl.drawSrcImg();
  }
  if(drawDebug) {
    blobCtrl.drawBlobsAndEdges(false, true);
    visionCtrl.drawDebug();   
  }
  if(drawFramerate) {
    // Draw framerate
    fill(255);
    text("framerate: " + (int)frameRate, 12, 16);
    if (frameCount % 60==0) println(frameRate);
  }
    
}


void setupControls() {
  controls.add(
    cp5.addSlider("blobThreshold")
    .setPosition(100, 50)
    .setRange(0, 0.3)
    .setValue(0.1f)
    .hide()
  );
  controls.add(
    cp5.addSlider("kinectMinThreshold")
    .setPosition(100, 80)
    .setRange(30, 100)
    .setValue(30)
    .hide()
  );
  controls.add(
    cp5.addSlider("kinectMaxThreshold")
    .setPosition(100, 110)
    .setRange(850, 1100)
    .setValue(943)
    .hide()
  );
  controls.add(
    cp5.addSlider("snowflakesPerDrawLoop")
    .setPosition(100, 140)
    .setRange(0, 20)
    .setValue(1)
    .hide()
  );
  controls.add(
    cp5.addSlider("blurStrength")
    .setPosition(100, 170)
    .setRange(1, 8)
    .setNumberOfTickMarks(8)
    .setValue(3)
    .hide()
  );
  controls.add( 
    cp5.addToggle("drawDebug")
    .setPosition(100, 200).hide()
  );
  controls.add(
    cp5.addToggle("drawBlobChainShapes")
    .setPosition(180, 200).hide()
  );
  controls.add(
    cp5.addToggle("drawBlobSrcImg")
    .setPosition(100, 230).hide()
  );
  controls.add(
    cp5.addToggle("drawFramerate")
    .setPosition(180, 230).hide()
  );
}

// an event from slider blobThreshold
public void blobThreshold(float val) {
  blobCtrl.blobThreshold = val;
}
public void kinectMinThreshold(float val) {
  visionCtrl.minDepth = (int)val;
}
public void kinectMaxThreshold(float val) {
  visionCtrl.maxDepth = (int)val;
}
public void blurStrength(float val) {
  blobCtrl.blurStrength = (int)val;
}

void keyPressed() {
  if(key == ' ') {
    if(isControlsShowing) {
      for(Controller c : controls) {
        c.hide();
        isControlsShowing =!isControlsShowing;
      }
    } else {
      for(Controller c : controls) {
        c.show();
        isControlsShowing =!isControlsShowing;
      }
    }
  }
}