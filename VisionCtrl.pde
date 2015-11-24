class VisionCtrl {

  Kinect kinect;

  // the kinect's dimensions to be used later on for calculations
  final int kinectWidth = 640;
  final int kinectHeight = 480;
  final int SMALLER_SRC_WIDTH = kinectWidth/3;
  final int SMALLER_SRC_HEIGHT = kinectHeight/3;
    
  // min/max thresholding for kinect
  int minDepth = 60;
  int maxDepth = 986;
  PImage depthImg;
  PImage srcImg;

  VisionCtrl(StoneAndChalk main) {
    kinect = new Kinect(main); 
    
    if(isKinect()) {
      kinect.initDepth();
      depthImg = new PImage(kinect.width, kinect.height);  
      // create a smaller blob image for speed and efficiency
      // TODO:: should be greyscale?
      srcImg = createImage(SMALLER_SRC_WIDTH, SMALLER_SRC_HEIGHT, ALPHA);
    } else {
      println("Creating test src img");
      createTestSrcImg();
    }
  }
  
  boolean isKinect() {
    return kinect.numDevices() > 0;
  }

  void createTestSrcImg() {
    final int NUM_OF_SRC_BLOBS = 12;
    PGraphics pg = createGraphics(SMALLER_SRC_WIDTH, SMALLER_SRC_HEIGHT, P2D);
    pg.beginDraw();
    pg.noStroke();
    pg.fill(0);
    for(int i=0; i<NUM_OF_SRC_BLOBS; i++) {
      pg.ellipse(random(SMALLER_SRC_WIDTH), random(SMALLER_SRC_HEIGHT), 20, 20);
    }
    pg.endDraw();
    pg.loadPixels();
    pg.updatePixels();
    srcImg = pg.get();
  }


  PImage getImage() {
    
    if(isKinect()) {
      int[] rawDepth = kinect.getRawDepth();
      
      depthImg.loadPixels();
      for (int i=0; i<rawDepth.length; i++) {
        if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
          depthImg.pixels[i] = color(255);
        } else {
          depthImg.pixels[i] = color(0);
        }
      }
      depthImg.updatePixels();
  
      srcImg.copy(depthImg, 0, 0, depthImg.width, depthImg.height, 0, 0, srcImg.width, srcImg.height);
    } else {
      // will just return created test src img
    }

    return srcImg.get();
  }
  
  
  void drawDebug() {
    if(isKinect()) {
      image(depthImg, 30, 30, depthImg.width/3, depthImg.height/3);  
    }
    image(srcImg, 0, 0, width, height);
  }
  

}