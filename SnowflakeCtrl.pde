class SnowflakeCtrl {

  final int NUM_OF_SNOWFLAKE_IMGS = 5;
  PGraphics[] snowflakeImgs;

  // An ArrayList of particles that will fall on the surface
  ArrayList<Particle> particles;


  SnowflakeCtrl() {

    //Load in snowflake images into array
    snowflakeImgs = new PGraphics[NUM_OF_SNOWFLAKE_IMGS];

    for(int i = 0; i<NUM_OF_SNOWFLAKE_IMGS; i++) {
      int size = int(random(60, 100));
      snowflakeImgs[i] = createGraphics(size, size);
      snowflakeImgs[i].beginDraw();
      snowflakeImgs[i].clear();
      snowflakeImgs[i].image(loadImage("snowflake"+i+".png"), 0, 0, size, size);
      snowflakeImgs[i].endDraw();
    }
    
    particles = new ArrayList<Particle>();

  }
  
  void updateAndDraw() {
    for(int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.display();
      // Particles that leave the screen, we delete them
      // (note they have to be deleted from both the box2d world and our list)
      if(p.done()) {
        particles.remove(i);
      }
    }
  }
  
  void addSnowflake() {
    float randomX = random(0, width);
    particles.add(new Particle(randomX, -70, 8, chooseSnowflake()));
  }

  PGraphics chooseSnowflake() {
    int r = int(random(0, snowflakeImgs.length));
    return(snowflakeImgs[r]);
  }
}