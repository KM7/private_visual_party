class Glitch {
  float d;
  float red;
  float green;
  float blue;
  
  int rad =3;
  
  Glitch() {
  }
  void display(float x,float y,float wantofuck) {
    for (int i=0; i<height; i++) {
      for (int j=0; j<width; j++) {
        color c = pixels[i*width+j];
        red = c <<4 & 0xff;
        green = c << 3 & 0xaa;
        blue = c  & 0xff;
        d =dist(x, y, j, i)*wantofuck;
        red += 50/d-rad;
        green += 50/d-rad;
        blue += 155/d-rad+(int)m_faudioX*10;
        
        //changes the pixel to the glitched pixel
        pixels[i*width+j]=color(red, green, blue);
      }
    }
  }
}
void glitchFucker(int x,int y)
{
  // trigger a glitch: glitchP5.glitch(  posX,       // 
  //                               posY,       // position on screen(int)
  //          posJitterX,     // 
  //          posJitterY,     // max. position offset(int)
  //          sizeX,       // 
  //          sizeY,       // size (int)
  //          numberOfGlitches,   // number of individual glitches (int)
  //          randomness,     // this is a jitter for size (float)
  //          attack,     // max time (in frames) until indiv. glitch appears (int)
  //          sustain      // max time until it dies off after appearing (int)
  //              );

}