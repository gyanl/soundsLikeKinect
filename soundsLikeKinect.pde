import org.openkinect.processing.*; //<>// //<>//
  
import processing.sound.*;
Amplitude amp;
AudioIn in;


// Kinect Library object
Kinect kinect2;

// Angle for rotation
float a = 0;
float minThresh = 0;
float maxThresh = 1000;

float hue=0;

//PFont f;

float jitterx;
float jittery;
float jitterz;
float jitterMax = 100;
  
void setup() {
  //f = createFont("Helvetica", 200);
  size(1280, 720, P3D);
  kinect2 = new Kinect(this);
  kinect2.initDepth();
  kinect2.initVideo(); 
 // lines = loadStrings("text.txt");

  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);

}


void draw() {
  
  //whichword = (whichword++)%allWords.length;
  background(0);

  // Translate and rotate
  pushMatrix();
  translate(width/2, height/2, -2250);
  rotateY(a);

  // We're just going to calculate and draw every 2nd pixel
  int skip = 2;

  // Get the raw depth as array of integers
  int[] depth = kinect2.getRawDepth();



  stroke(255);
  strokeWeight(2);
  beginShape(POINTS);
  for (int x = 0; x < kinect2.width; x+=skip) {
    for (int y = 0; y < kinect2.height; y+=skip) {
      int offset = x + y * kinect2.width;
      int d = depth[offset];
      //calculte the x, y, z camera position based on the depth information
      if (d > minThresh && d < maxThresh && x > 100) {
      
        PVector point = depthToPointCloudPos(x, y, d);

        // Draw a point
      
        colorMode(HSB, 100);
        hue = map(d, 1350, 0, 0, 255);
        stroke(hue, 127, 127);
        fill(hue, 127, 127);

        jitterMax = 0-jitterMax;
        jitterx = amp.analyze()*jitterMax;
        jittery = amp.analyze()*jitterMax;
        jitterz = amp.analyze()*jitterMax;

        //text(" 0 ", 320-point.x, point.y, point.z+1300);
        vertex(320-point.x+jitterx, point.y+jittery, (point.z+1350)+jitterz);
      }
    }
  }
  endShape();
  scale(-1,1);
  popMatrix();

  fill(255);

  // Rotate
  a += 0;
}



//calculte the xyz camera position based on the depth data
PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue);// / (1.0f); // Convert from mm to meters
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}
