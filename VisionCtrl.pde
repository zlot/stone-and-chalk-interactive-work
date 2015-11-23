class VisionCtrl {

  Kinect kinect;

  // the kinect's dimensions to be used later on for calculations
  final int kinectWidth = 640;
  final int kinectHeight = 480;
  // to center and rescale from 640x480 to higher custom resolutions
  float reScale;
  
  // min/max thresholding for kinect
  int minDepth = 60;
  int maxDepth = 986;
  PImage depthImg;

  BlobDetection blobDetection;
  PImage blobs;
  float blobThreshold = 0.2;


  VisionCtrl(StoneAndChalk main) {
    kinect = new Kinect(main);
    kinect.initDepth();
    depthImg = new PImage(kinect.width, kinect.height);
    // create a smaller blob image for speed and efficiency
    blobs = createImage(kinectWidth/3, kinectHeight/3, RGB);

    // initialize blob detection object to the blob image dimensions
    blobDetection = new BlobDetection(blobs.width, blobs.height);
    //  theBlobDetection.setPosDiscrimination(false);
  }

  void update() {

    blobDetection.setThreshold(blobThreshold);

    int[] rawDepth = kinect.getRawDepth();
    for (int i=0; i<rawDepth.length; i++) {
      if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
        depthImg.pixels[i] = color(255);
      } else {
        depthImg.pixels[i] = color(0);
      }
    }
    depthImg.updatePixels();

    blobs.copy(depthImg, 0, 0, depthImg.width, depthImg.height, 0, 0, blobs.width, blobs.height);

    // filter
    blobs.filter(BLUR, 3);

    blobDetection.computeBlobs(blobs.pixels);
  }

  void drawDebug() {
    image(depthImg, 0, 0, depthImg.width/3, depthImg.height/3);
    image(blobs, 300, 0, blobs.width, blobs.height);
  }

  void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges) {
    noFill();
    Blob b;
    EdgeVertex eA, eB;
    for (int n=0; n<blobDetection.getBlobNb(); n++) {
      b=blobDetection.getBlob(n);
      if (b!=null) {
        // Edges
        if (drawEdges) {
          strokeWeight(2);
          stroke(0, 255, 0);
          for (int m=0; m<b.getEdgeNb(); m++) {
            eA = b.getEdgeVertexA(m);
            eB = b.getEdgeVertexB(m);
            if (eA !=null && eB !=null)
              line(eA.x*width, eA.y*height, eB.x*width, eB.y*height);
          }
        }

        // Blobs
        if (drawBlobs) {
          strokeWeight(1);
          stroke(255, 0, 0);
          rect(b.xMin*width, b.yMin*height, b.w*width, b.h*height);
        }
      }
    }
  }
}