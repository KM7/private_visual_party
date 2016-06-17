import processing.opengl.*;
import glitchP5.*; // import GlitchP5

import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.analysis.*;

Glitch glitch;
GlitchP5 glitchP5;
VizAudio vizAudio;
Minim minim;


Branch _trunk;
//BackGround backGround;

AudioPlayer song;
BeatDetect beat;
BeatListener bl;


Cube[] cubes = new Cube[12];

final int colorCount = 15;

float   m_faudioX = 0.;
float   m_faudioY = 0.;
float sb = 0.1;
float moveZ ;

float theta;
float kickSize, snareSize, hatSize;

int     backgroundType = colorCount+2; //120
int     startFrame;
int     slidingStep = 3;
int _numChildren = 3;
int _maxLevels =6;

//boolean drawSlidingFlag = false;
//boolean drawFluidFlag = false;


void setup() {
  frameRate(30);
  size(1024, 769, P3D);
  noCursor();
  newTree();
  minim = new Minim(this);
  vizAudio = new VizAudio(minim);
  //backGround = new BackGround();
  

  song = minim.loadFile("Pixel³ - 4.mp3");
  song.play();
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(300);  
  kickSize = snareSize = hatSize = 16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);  

  translate(width/2, height/2);
  //camera(70.0, 35.0, 120.0, 50.0, 50.0, 0.0, 0.0, 1.0, 0.0);
  //for (int i =0; i<cubes.length; i++) {
  //  //Cube(color c_, float xpos_,float ypos_,float zpos_,float theta_)
  //  cubes[i] = new Cube(color(255, 0, 100, random(0)), 0, 0, 0, 0.01);
  //}
  smooth();
  //rectMode(CENTER);
  glitch = new Glitch();
  glitchP5 = new GlitchP5(this);
}

void draw() {
  theta = 0;
  
  
  
  
  
  // backGround.draw(backgroundType);

  //if (frameCount %1 ==0) {
  //  backgroundType++;
  //  if (backgroundType==256)     
  //    backgroundType=0;
  //} else if ( frameCount %3 == 0 ) {
  //  backgroundType--;
  //  if (backgroundType<0)     
  //    backgroundType=255;
  //}
  loadPixels();
  background((m_faudioX*100)*255);
  
  cam();
  pushMatrix();
  vizAudio.draw();




  //zbackground(255);
  //_trunk.rectMove();
  translate(width/2, height/2);
  //for (int i = 0; i<cubes.length; i++) {
  //  cubes[i].display();
  //  //cubes[i].move();
  //}

  popMatrix();
  pushMatrix();
  translate(width/2, height/2);
  _trunk.updateMe(0, 0, 0);
  _trunk.drawMe();
  _trunk. maudioMove();
  popMatrix();
  camera_glitch(vizAudio.getLevel(0.5*m_faudioX), vizAudio.getLevel(0.8), 0.5);


  float x=0;
  float y = 0;
  if (x < 1024) {
    x=random(1024);
  } else if (x>1024) {
    x-=random(1024);
  }
  if (y < 768) {
    y+=random(768);
  }




  if ( beat.isHat() ) hatSize = 32;
  float fucker = map(hatSize, 0, 32, 0.1, 0.475);

  glitch.display(x, y, fucker);
  updatePixels();
  glitchP5.run(); // this needs to be at the end of draw(). anything after it will not be drawn to the screen
  glitchFucker((int)x, (int)y);
}



void newTree() {
  _trunk = new Branch(1, 0, width/2, 50, 1000);
  //_trunk.drawMe();
}
void keyPressed() {
  if (key == 'z') {
    backgroundType--;
    if (backgroundType<0)     
      backgroundType=255;
  } else if (key == 'x') {
    backgroundType++;
    if (backgroundType==256)     
      backgroundType=0;
  }
}

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;

  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }

  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}