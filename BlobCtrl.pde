class BlobCtrl {
  
  BlobDetection theBlobDetection;
  
  float blobThreshold = 0.10f;

  int blurStrength = 3;
  
  ArrayList<Blob> blobs;
  PImage srcImg;
  
  BlobCtrl(int w, int h) {
    theBlobDetection = new BlobDetection(w, h);
    theBlobDetection.setPosDiscrimination(false);
    blobs = new ArrayList<Blob>();
  }
    
  void detectBlobs(PImage srcImg) {
    theBlobDetection.setThreshold(blobThreshold);
    
    this.srcImg = srcImg;
    // TODO:: could be faster way. see maybe https://forum.processing.org/two/discussion/3294/doing-blob-detection-on-half-an-image
    if(visionCtrl.isKinect()) {
      srcImg.filter(BLUR, blurStrength);
    }

    theBlobDetection.computeBlobs(srcImg.pixels);
    
    fillBlobsList();
  }
  
  void fillBlobsList() {
    blobs.clear();
    for (int i=0; i<theBlobDetection.getBlobNb(); i++) {
      blobs.add(theBlobDetection.getBlob(i));
    }
  }
  
  /** Debug method **/
  void drawSrcImg() {
    image(srcImg, 0, 0, width, height);
  }
  
  void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges) {
    noFill();
    Blob b;
    EdgeVertex eA, eB;
    for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++) {
      b=theBlobDetection.getBlob(n);
      if (b!=null) {
        // Edges
        if (drawEdges) {
          strokeWeight(2);
          stroke(0, 255, 0);
          for(int m=0;m<b.getEdgeNb();m+=BlobChainShape.STEP) {
            eA = b.getEdgeVertexA(m);
            eB = b.getEdgeVertexB(m);
            ellipse(eA.x*width, eA.y*height, 30, 30);
            if(eA !=null && eB !=null)
              line(
                eA.x*width, eA.y*height, 
                eB.x*width, eB.y*height
              );
          }
        }
  
        // Blobs
        if(drawBlobs) {
          strokeWeight(1);
          stroke(255, 0, 0);
          rect(
            b.xMin*width, b.yMin*height, 
            b.w*width, b.h*height
          );
        }
      }
    }
  }

}