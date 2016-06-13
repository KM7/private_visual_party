/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/139564*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

import msafluid.*;
import ddf.minim.*;
import processing.serial.*;
import ddf.minim.analysis.*;
import javax.media.opengl.GL2;
import codeanticode.gsvideo.*;

//part of the flower drop initialization
ArrayList<flower> pts;
//initial wind status
float windspeed=0;
float windAcc=0;
float trigger_threashold=0.5;
float appear_threashold=0.01;
float wind_power=0.5;
boolean auto_pilot;
boolean onPressed, showInstruction;

//end of the configures


final int White = 0;
final int Silver = 1;
final int Gray = 2;
final int Black = 3;
final int Maroon = 4;
final int Yellow = 5;
final int Olive = 6;
final int Lime = 7;
final int Green = 8;
final int Aqua = 9;
final int Teal = 10;
final int Blue = 11;
final int Navy = 12;
final int Fuchsia = 13;
final int Purple = 14;
final int colorCount = 15;
final float eps = 0.00001; 

int     fps = 30;
int     MAX_DEPTH = 6;
int     backgroundType = colorCount+2; //120
int     startFrame;
int     slidingStep = 3;

float   FLUID_WIDTH = 140;
float   m_offset = 0;
float   m_delta = 0.03;
float   m_alpha = 128;

float   m_faudioX = 0.;
float   m_faudioY = 0.;
float   m_aspectRatio2;
float   m_colorMult = 5;        
float   m_velocityMult = 30.0f;

PImage  imgFluid;
boolean drawParticle = false;
boolean addForceFlag = false;
boolean drawFluidFlag = false;
boolean drawParameter = true;
boolean drawAudioFlag = true;
boolean drawSlidingFlag = false;
boolean recordingFlag = true;
boolean colorParticle = false;
boolean fullScreenFlag = true;

Minim minim;
GSMovieMaker mm;
VizAudio vizAudio;
WindyTree windyTree;
BackGround backGround;
MSAFluidSolver2D fluidSolver;
ParticleSystem particleSystem;

void setup() {
  frameRate(fps);  
  if(!fullScreenFlag) size(1400, 1000, P3D);   
  else size(displayWidth, displayHeight, P3D);
  
  mm = new GSMovieMaker(this, width, height, "pingtan.ogg", GSMovieMaker.THEORA, GSMovieMaker.MEDIUM, fps);
  mm.setQueueSize(50, 10);


  ellipseMode(CENTER);
  colorMode(RGB, 255);  
  minim = new Minim(this);
  windyTree = new WindyTree();
  backGround = new BackGround();
  vizAudio = new VizAudio(minim);
  particleSystem = new ParticleSystem();
  fluidSolver = new MSAFluidSolver2D((int)(FLUID_WIDTH), (int)(FLUID_WIDTH * height/width));
  fluidSolver.enableRGB(true).setFadeSpeed(0.003).setDeltaT(0.5).setVisc(0.0001);
  imgFluid = createImage(fluidSolver.getWidth(), fluidSolver.getHeight(), RGB);
  m_aspectRatio2 = (float)width*width/height/height;  
  textFont(createFont("Arial", 18));
  
//start off the initialization of the flower   
    pts = new ArrayList<flower>();

}

void draw() {
  backGround.draw(backgroundType);
  if(addForceFlag && mouseX==pmouseX && mouseY==mouseY) 
      addForce((float)mouseX/width, (float)mouseY/height, (float)(noise(m_offset)-.5)/256., (float)(noise(m_offset+1)-.5)/256.);
  if(drawFluidFlag) {
    fluidSolver.update();
    for(int i=0; i<fluidSolver.getNumCells(); i++) 
      imgFluid.pixels[i] = color(fluidSolver.r[i]*255, fluidSolver.g[i]*255, fluidSolver.b[i]*255);
    imgFluid.updatePixels();//  fastblur(imgFluid, 2);
    image(imgFluid, 0, 0, width, height);
  } 
  if(drawParticle) particleSystem.updateAndDraw();  
  windyTree.draw();
  vizAudio.draw(drawAudioFlag);  
  printParameter();  
  m_offset+=m_delta;
  loadPixels();
  mm.addFrame(pixels);
  //draw part for the flower
  handle_flower_drop();
  //wind handling
  update_wind();
}

boolean sketchFullScreen() {
  return fullScreenFlag;
}

void mousePressed() {
  if(mouseButton == LEFT) 
    windyTree.decreaseDepth();
  else if(mouseButton == RIGHT) 
    windyTree.increaseDepth();
}

void mouseMoved() {
  if(addForceFlag) 
    addForce((float)mouseX/width, (float)mouseY/height, (float)(mouseX-pmouseX)/width, (float)(mouseY-pmouseY)/height);
  if(drawParticle) 
    particleSystem.addParticles(mouseX, mouseY, 10);    
}

void keyPressed() {
  if (key == ' ') 
    windyTree.setTree((int)random(5,10));
  else if (key == ',') 
    windyTree.decreaseDelta();
  else if (key == '.') 
    windyTree.increaseDelta();
  else if (key == 'n') 
    windyTree.decreaseSpeed();
  else if (key == 'm') 
    windyTree.increaseSpeed();
  else if (key == 'b') 
    windyTree.changeBlossom(-1);
  else if (key == 'a') 
    addForceFlag=!addForceFlag;
  else if (key == 'z') {
    backgroundType--;
    if(backgroundType<0)     
      backgroundType=255;
  }    
  else if (key == 'x') {
    backgroundType++;
    if(backgroundType==256)     
      backgroundType=0;
  }    
  else if (key == 'h') 
    m_alpha--;
  else if (key == 'j') 
    m_alpha++;
  else if (key == 'q') {
    drawSlidingFlag=!drawSlidingFlag;
    if(drawSlidingFlag) {
      startFrame = frameCount;
    }  
  }  
  else if (key == 'w') {
    recordingFlag=!recordingFlag;
    if(recordingFlag) mm.start();
    else mm.finish();
  }
  else if (key == 's') 
    drawParticle=!drawParticle;
  else if (key == 'd') 
    drawFluidFlag=!drawFluidFlag;
  else if (key == 'f') 
    drawParameter=!drawParameter;
  else if (key == 'g') 
    drawAudioFlag=!drawAudioFlag;
  else if (key == 'e') 
    colorParticle=!colorParticle;
  else if (key >= '1' && key <= '8' ) 
    windyTree.changeBlossom(key-'1');
}

void printParameter() {
  fill(0);
  text("PingTan 2015.10.31 lbg@dongseo.ac.kr info(f) audio(g) frameCount "+frameCount, 15, 30);
  if(drawParameter) {
    text("background(zx) "+backgroundType+" fluid(d) "+drawFluidFlag+" particle(s) "+drawParticle+" colorParticle(e) "+
      colorParticle+" force(a) "+addForceFlag+" sliding(q) "+drawSlidingFlag+" recording(w) "+recordingFlag, 15, 50);
    windyTree.printParameter();  
  }
}

void addForce(float x, float y, float dx, float dy) {
  color drawColor;
  float speed = dx * dx  + dy * dy * m_aspectRatio2;    
  if(speed > 0) {
    x=constrain(x, 0, 1);
    y=constrain(y, 0, 1);
    float hue = ((x + y) * 180 + frameCount) % 360;
    if(colorParticle) {
      colorMode(HSB, 360, 100, 100);
      drawColor = color(hue, 100, 100);
      colorMode(RGB, 255);      
    }
    else drawColor = color(hue, noise(m_offset)*255);
    int index = fluidSolver.getIndexForNormalizedPosition(x, y);        
    fluidSolver.rOld[index] += red(drawColor) * m_colorMult;
    fluidSolver.gOld[index] += green(drawColor) * m_colorMult;
    fluidSolver.bOld[index] += blue(drawColor) * m_colorMult;    
    fluidSolver.uOld[index] += dx * m_velocityMult;
    fluidSolver.vOld[index] += dy * m_velocityMult;
  }
}

/***
 * GSVideo drawing movie example.
 *
 * Adapted from Daniel Shiffman's original Drawing Movie 
 * example by Andres Colubri 
 * Makes a movie of a line drawn by the mouse. Press
 * the spacebar to finish and save the movie. 

void setup() {
  size(320, 240);
  frameRate(fps);
  
  PFont font = createFont("Courier", 24);
  textFont(font, 24);

  // Save as THEORA in a OGG file as MEDIUM quality (all quality settings are WORST, LOW,
  // MEDIUM, HIGH and BEST):
  mm = new GSMovieMaker(this, width, height, "drawing.ogg", GSMovieMaker.THEORA, GSMovieMaker.MEDIUM, fps);
  
  // Available codecs are: 
  // THEORA
  // XVID
  // X264
  // DIRAC
  // MJPEG
  // MJPEG2K
  // As for the file formats, the following are autodetected from the filename extension:
  // .ogg: OGG
  // .avi: Microsoft's AVI
  // .mov: Quicktime's MOV
  // .flv: Flash Video
  // .mkv: Matroska container
  // .mp4: MPEG-4
  // .3gp: 3GGP video
  // .mpg: MPEG-1
  // .mj2: Motion JPEG 2000
  // Please note that some of the codecs/containers might not work as expected, depending
  // on which gstreamer plugins are installed. Also, some codec/container combinations 
  // don't seem to be compatible, for example THEORA+AVI or X264+OGG.
  
  // Encoding with DIRAC codec into an avi file:
  //mm = new GSMovieMaker(this, width, height, "drawing.avi", GSMovieMaker.DIRAC, GSMovieMaker.BEST, fps);  
  
  // Important: Be sure of using the same framerate as the one set with frameRate().
  // If the sketch's framerate is higher than the speed with which GSMovieMaker 
  // can compress frames and save them to file, then the computer's RAM will start to become 
  // clogged with unprocessed frames waiting on the gstreamer's queue. If all the physical RAM 
  // is exhausted, then the whole system might become extremely slow and unresponsive.
  // Using the same framerate as in the frameRate() function seems to be a reasonable choice,
  // assuming that CPU can keep up with encoding at the same pace with which Processing sends
  // frames (which might not be the case is the CPU is slow). As the resolution increases, 
  // encoding becomes more costly and the risk of clogging the computer's RAM increases.
    
  // The movie maker can also be initialized by explicitly specifying the name of the desired gstreamer's
  // encoder and muxer elements. Also, arrays with property names and values for the encoder can be passed.
  // In the following code, the DIRAC encoder (schroenc) and the Matroska muxer (matroskamux) are selected,
  // with an encoding quality of 9.0 (schroenc accepts quality values between 0 and 10). The property arrays
  // can be set to null in order to use default property values.
  //String[] propName = { "quality" };
  //Float f = 9.0f;
  //Object[] propValue = { f };
  //mm = new GSMovieMaker(this, width, height, "drawing.ogg", "schroenc", "oggmux", propName, propValue, fps);
  
  // There are two queues in the movie recording process: a pre-encoding queue and an encoding 
  // queue. The former is stored in the Java side and the later inside gstreamer. When the 
  // encoding queue is full, frames start to accumulate in the pre-encoding queue until its
  // maximum size is reached. After that point, new frames are dropped. To have no limit in the
  // size of the pre-encoding queue, set it to zero.
  // The size of both is set with the following function (first argument is the size of pre-
  // encoding queue):
  mm.setQueueSize(50, 10);
  
  mm.start();
  
  background(160, 32, 32);
}

void draw() {
  stroke(7, 146, 168);
  strokeWeight(4);
  
  // Draw if mouse is pressed
  if (mousePressed && pmouseX != 0 && mouseY != 0) {
    line(pmouseX, pmouseY, mouseX, mouseY);
  }
  
  // Drawing framecount.
  String s = "Frame " + frameCount;
  fill(160, 32, 32);
  noStroke();
  rect(10, 6, textWidth(s), 24);
  fill(255);
  text(s, 10, 30);

  loadPixels();
  // Add window's pixels to movie
  mm.addFrame(pixels);
  
  println("Number of queued frames : " + mm.getQueuedFrames());
  println("Number of dropped frames: " + mm.getDroppedFrames());
}

void keyPressed() {
  if (key == ' ') {
    // Finish the movie if space bar is pressed
    mm.finish();
    // Quit running the sketch once the file is written
    exit();
  }
}



*/

void handle_flower_drop(){
  /**
    if (onPressed) {
     flower newP = new flower(mouseX, mouseY, pts.size(), pts.size());
      pts.add(newP);
  }
 **/
  for (int i=0; i<pts.size(); i++) {
    flower p = pts.get(i);
    p.update();
    p.display();
  }
 
  for (int i=pts.size()-1; i>-1; i--) {
    flower p = pts.get(i);
    if (p.dead) {
      pts.remove(i);
    }
  }
  
      if (keyPressed&&key == 'n') {
  windspeed=windspeed-1;
  }
  
    
      if (keyPressed&&key == 'm') {
  windspeed=windspeed+1;
  }
      if (keyPressed&&key == 'k') {
  onPressed=true;
  } else{
      onPressed=false;
  }
  
  if(m_faudioY>trigger_threashold){
onPressed=true;
  } else{
      onPressed=false;
  }
  
  stroke(0);
  fill(0);
  text("Wind situation " + windspeed,50,50);
}

void triger_the_flower(float x,float y,float size,float a){
      if (onPressed) {
      flower newP = new flower(int(x), int(y), pts.size(), pts.size(),size,a);
      pts.add(newP);
       }
}

void update_wind(){
  //update loop
  windspeed=windspeed+windAcc;
  //trigger loop
  if (frameCount%100==0){
    if (windspeed>0){
    windAcc=-random(wind_power);
    }else{
    windAcc=random(wind_power);
    }
  }
  
}
