import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.analysis.*;

AudioPlayer song;
Minim minim;
VizAudio vizAudio;
AudioOutput out;
Delay myDelay;
Branch _trunk;
BackGround backGround;
Cube[] cubes = new Cube[12];
Glitch glitch;

final int colorCount = 15;

float grid_size=50;
float depth=-500;

float   m_faudioX = 0.;
float   m_faudioY = 0.;
float sb = 0.1;
float moveZ ;

int     backgroundType = colorCount+2; //120
int     startFrame;
int     slidingStep = 3;
int _numChildren = 3;
int _maxLevels =6;

boolean drawSlidingFlag = true;
boolean drawFluidFlag = true;
void setup() {
  frameRate(100);
  size(1024, 768, P3D);
  noCursor();
  newTree();
  minim = new Minim(this);
  backGround = new BackGround();
  out = minim.getLineOut();
  myDelay = new Delay( 0.15, 0.7, true, true );
  song = minim.loadFile("Pixel³ - 4.mp3");
  song.play();
  Waveform saw = Waves.sawh( 1); 
  Oscil myBlip = new Oscil(150.0, 0.5, saw );
  Waveform square = Waves.square( 0.7 );
  // create an LFO to be used for an amplitude envelope
  Oscil myLFO = new Oscil( 0.8, 0.3, square );
  // offset the center value of the LFO so that it outputs 0 
  // for the long portion of the duty cycle
  myLFO.offset.setLastValue( 0.6 );

  myLFO.patch( myBlip.amplitude );

  // and the Blip is patched through the delay into the output
  myBlip.patch( myDelay ).patch( out );
    vizAudio = new VizAudio(minim);

  translate(width/2, height/2);
  //camera(70.0, 35.0, 120.0, 50.0, 50.0, 0.0, 0.0, 1.0, 0.0);
  for (int i =0; i<cubes.length; i++) {
    //Cube(color c_, float xpos_,float ypos_,float zpos_,float theta_)
    cubes[i] = new Cube(color(255, 0, 100, random(0)), 0, 0, 0, 0.01);
  }
  smooth();
  //rectMode(CENTER);
}
float theta =0;
void draw() {

  //backGround.draw(backgroundType);
  //if(frameCount %1 ==0){
  //   backgroundType++;
  //  if (backgroundType==256)     
  //    backgroundType=0;

  //}else if( frameCount %3 == 0 ){
  //   backgroundType--;
  //  if (backgroundType<0)     
  //    backgroundType=255;
  //}



  cam();
  pushMatrix();
  vizAudio.draw();

  background(m_faudioX*100);

  //zbackground(255);
  rectMove();
  translate(width/2, height/2);
  for (int i = 0; i<cubes.length; i++) {
    cubes[i].display();
    //cubes[i].move();
  }
  popMatrix();
  pushMatrix();
  translate(width/2, height/2);
  _trunk.updateMe(0, 0, 0);
  _trunk.drawMe();
  _trunk. maudioMove();
  popMatrix();
  camera_glitch(vizAudio.getLevel(0.5), vizAudio.getLevel(0.8), 0.5);
  trigger_event();
  saveFrame("line-######.png");
}
void mouseMoved()
{
  // set the delay time by the horizontal location
  float delayTime = map( mouseX, 0, width, 0.0001, 0.5 );
  myDelay.setDelTime( delayTime );
  // set the feedback factor by the vertical location
  float feedbackFactor = map( mouseY, 0, height, 0.99, 0.0 );
  myDelay.setDelAmp( feedbackFactor );
}

void rectMove() {
  for (int i = -1000; i < 50000; i+=5) {
    pushMatrix();
    translate(0, 0, m_faudioX*500);
    pushMatrix();
    translate(width/2, height/2, -i);
    rotate(moveZ*m_faudioY/2);
    stroke(0);
    rectMode(CENTER);
    //stroke(255);
    strokeWeight(2*m_faudioY/2);
    noFill();
    //rect(1, -1*m_faudioX, 20000/(i+1), 20000/(i+1));
    line(1, -1*m_faudioX, 5000, 5000);

    moveZ+=0.05;
    if (moveZ >5500) {
      moveZ =0.00001;
    }
    popMatrix();
    popMatrix();
  }
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

void trigger_event(){
song.cue(frameCount*10);
}