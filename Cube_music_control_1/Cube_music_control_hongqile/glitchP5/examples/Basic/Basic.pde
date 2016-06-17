import processing.opengl.*;
import glitchP5.*; // import GlitchP5

GlitchP5 glitchP5; // declare an instance of GlitchP5. only one is needed

RotatingCubes rotatingCubes = new RotatingCubes();
PFont font = createFont("Sans Serif", 20);

void setup()
{
  size(600, 600, OPENGL);
  glitchP5 = new GlitchP5(this); // initiate the glitchP5 instance;
  textFont(font);
}


void draw()
{
  background(0);
  rotatingCubes.draw();
  fill(200,100);
  text("click to glitch", 10, 30);
  text("framerate: "+frameRate, 10, height-10);
  glitchP5.run(); // this needs to be at the end of draw(). anything after it will not be drawn to the screen
}


void mousePressed()
{
  // trigger a glitch: glitchP5.glitch(	posX, 			// 
  //                             	posY, 			// position on screen(int)
  //					posJitterX, 		// 
  //					posJitterY, 		// max. position offset(int)
  //					sizeX, 			// 
  //					sizeY, 			// size (int)
  //					numberOfGlitches, 	// number of individual glitches (int)
  //					randomness, 		// this is a jitter for size (float)
  //					attack, 		// max time (in frames) until indiv. glitch appears (int)
  //					sustain			// max time until it dies off after appearing (int)
  //				      );

  glitchP5.glitch(mouseX, mouseY, 200, 400, 200, 1200, 3, 1.0f, 10, 40);
}
