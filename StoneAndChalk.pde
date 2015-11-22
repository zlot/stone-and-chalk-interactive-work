// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// Basic example of controlling an object with our own motion (by attaching a MouseJoint)
// Also demonstrates how to know which object was hit

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// A reference to our box2d world
Box2DProcessing box2d;

// Just a single box this time
Box box;

// An ArrayList of particles that will fall on the surface
ArrayList<Particle> particles;

// The Spring that will attach to the box from the mouse


// Perlin noise values
float xoff = 0;
float yoff = 1000;

Boundary floor;

PGraphics snowflakePg;

void setup() {
  size(1000,700,P2D);
  smooth();

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  // Add a listener to listen for collisions!
  box2d.world.setContactListener(new CustomListener());

  // Make the box
  box = new Box(width/2,height/2);
  // Create the empty list
  particles = new ArrayList<Particle>();

  // add one particle
  float sz = random(4,8);
  particles.add(new Particle(width/2,-20,sz));
  
  floor = new Boundary(width/2, height-5, width, 10);

  PImage img = loadImage("SnowflakeTestSmall.png");
  snowflakePg = createGraphics(64,64);
  snowflakePg.beginDraw();
  snowflakePg.clear();
  snowflakePg.image(loadImage("SnowflakeTestSmall.png"),0,0);
  snowflakePg.endDraw();
}

void draw() {
  background(0);

  if (random(1) < 0.2) {
   float sz = random(4,8);
   particles.add(new Particle(width/2,-20,sz));
  }


  // We must always step through time!
  box2d.step();

  // Make an x,y coordinate out of perlin noise  
  float x = noise(xoff)*width;
  float y = noise(yoff)*height;
  xoff += 0.01;
  yoff += 0.01;

  // This is tempting but will not work!
  // box.body.setXForm(box2d.screenToWorld(x,y),0);

  //box.body.setAngularVelocity(0);

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

  box.display();
  floor.display();
  
  
  // Just drawing the framerate to see how many particles it can handle
  fill(255);
  text("framerate: " + (int)frameRate,12,16);
  
}