void camera_glitch(float glitch_x, float glitch_y, float threashold) {

  beginCamera();
  camera();
  rotateX(PI*random(-glitch_x/2, glitch_x/2));
  rotateY(PI*random(-glitch_y/2, glitch_y/2));
  endCamera();
}