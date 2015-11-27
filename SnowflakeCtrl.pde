class SnowflakeCtrl {

  final int NUM_OF_SNOWFLAKE_IMGS = 6+2; // +2 for the 2 logos
  PGraphics[] snowflakeImgs;

  // An ArrayList of particles that will fall on the surface
  ArrayList<Particle> particles;

  PImage scLogo, westpacLogo;
  final int WESTPAC_LOGO_SIZE = 100;

  SnowflakeCtrl() {

    //Load in snowflake images into array
    snowflakeImgs = new PGraphics[NUM_OF_SNOWFLAKE_IMGS];

    scLogo = loadImage("S_C_Circle.png");
    westpacLogo = loadImage("WestpacLogo2.png");

    for(int i = 0; i<NUM_OF_SNOWFLAKE_IMGS-2; i++) {
      int size = int(random(40, 80));
      snowflakeImgs[i] = createGraphics(size, size, P2D);
      snowflakeImgs[i].noSmooth();
      snowflakeImgs[i].beginDraw();
      snowflakeImgs[i].clear();
      snowflakeImgs[i].image(loadImage("snowflake"+i+".png"), 0, 0, size, size);
      snowflakeImgs[i].endDraw();
    }
    int size = int(random(60, 100));
    snowflakeImgs[NUM_OF_SNOWFLAKE_IMGS-2] = createGraphics(size, size, P2D);
    snowflakeImgs[NUM_OF_SNOWFLAKE_IMGS-2].noSmooth();
    snowflakeImgs[NUM_OF_SNOWFLAKE_IMGS-2].beginDraw();
    snowflakeImgs[NUM_OF_SNOWFLAKE_IMGS-2].clear();
    snowflakeImgs[NUM_OF_SNOWFLAKE_IMGS-2].image(loadImage("S_C_Circle.png"), 0, 0, size, size);
    snowflakeImgs[NUM_OF_SNOWFLAKE_IMGS-2].endDraw();
    
    snowflakeImgs[NUM_OF_SNOWFLAKE_IMGS-1] = createGraphics(WESTPAC_LOGO_SIZE, WESTPAC_LOGO_SIZE, P2D);
    snowflakeImgs[NUM_OF_SNOWFLAKE_IMGS-1].noSmooth();
    snowflakeImgs[NUM_OF_SNOWFLAKE_IMGS-1].beginDraw();
    snowflakeImgs[NUM_OF_SNOWFLAKE_IMGS-1].clear();
    snowflakeImgs[NUM_OF_SNOWFLAKE_IMGS-1].image(loadImage("WestpacLogo2.png"), 0, 0, WESTPAC_LOGO_SIZE, WESTPAC_LOGO_SIZE);
    snowflakeImgs[NUM_OF_SNOWFLAKE_IMGS-1].endDraw();
  
    particles = new ArrayList<Particle>();

  }
  
  void updateAndDraw() {
    for(int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.display();
      // Particles that leave the screen, we delete them
      if(p.done()) {
        particles.remove(i);
      }
    }
  }
  
  void addSnowflake() {
    float randomX = random(0, width);
    particles.add(new Particle(randomX, -70, 8, chooseSnowflake()));
  }

  PImage chooseSnowflake() {
    int r = int(random(0, snowflakeImgs.length));
    return(snowflakeImgs[r].get());
  }
}