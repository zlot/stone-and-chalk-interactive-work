import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import blobDetection.*; // blobs

import controlP5.*;

ControlP5 cp5;

// A reference to our box2d world
Box2DProcessing box2d;


Boundary floor;
SnowflakeCtrl snowflakeCtrl;
VisionCtrl visionCtrl;

void setup() {
  size(1000, 700, P2D);
  smooth();

  cp5 = new ControlP5(this);

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // Add a listener to listen for collisions
  box2d.world.setContactListener(new CustomListener());
  box2d.setGravity(0, -10);

  snowflakeCtrl = new SnowflakeCtrl();
  

  floor = new Boundary(width/2, height-5, width, 10);

  visionCtrl = new VisionCtrl(this);
  setupControls();
}

void draw() {
  background(9, 21, 45);

  snowflakeCtrl.updateAndDraw();
  
  if (random(1) < 0.2) {
    snowflakeCtrl.addSnowflake();
  }

  box2d.step();

  floor.display();
  
  visionCtrl.update();
  visionCtrl.drawBlobsAndEdges(false, true);
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
  visionCtrl.blobThreshold = theValue;
}

public void kinectMinThreshold(float theValue) {
  visionCtrl.minDepth = (int)theValue;
}
public void kinectMaxThreshold(float theValue) {
  visionCtrl.maxDepth = (int)theValue;
}