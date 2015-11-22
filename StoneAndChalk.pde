
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

// An ArrayList of particles that will fall on the surface
ArrayList<Particle> particles;

// Perlin noise values
float xoff = 0;
float yoff = 1000;

Boundary floor;

PGraphics snowflakePg;

VisionCtrl visionCtrl;

void setup() {
  size(1000, 700, P2D);
  smooth();

  cp5 = new ControlP5(this);

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  // Add a listener to listen for collisions!
  box2d.world.setContactListener(new CustomListener());

  // Create the empty list
  particles = new ArrayList<Particle>();

  floor = new Boundary(width/2, height-5, width, 10);


  visionCtrl = new VisionCtrl(this);
  setupControls();

  snowflakePg = createGraphics(64, 64);
  snowflakePg.beginDraw();
  snowflakePg.clear();
  snowflakePg.image(loadImage("SnowflakeTestSmall.png"),0,0);
  snowflakePg.endDraw();
}

void draw() {
  background(0);

  if (random(1) < 0.2) {
    float sz = random(4, 8);
    particles.add(new Particle(width/2, -20, sz));
  }


  // We must always step through time!
  box2d.step();

  // Look at all particles
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.display();
    // Particles that leave the screen, we delete them
    // (note they have to be deleted from both the box2d world and our list
    if (p.done()) {
      particles.remove(i);
    }
  }

  floor.display();

  visionCtrl.update();
  visionCtrl.drawBlobsAndEdges(true, true);
  visionCtrl.drawDebug();

  // Just drawing the framerate to see how many particles it can handle
  fill(255);
  text("framerate: " + (int)frameRate, 12, 16);
}

void setupControls() {
  cp5.addSlider("blobThreshold")
    .setPosition(100, 50)
    .setRange(0, 0.3)
    .setValue(0.1);
}

// an event from slider blobThreshold
public void blobThreshold(float theValue) {
  visionCtrl.blobThreshold = theValue;
}