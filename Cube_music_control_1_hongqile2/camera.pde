void cam(){
  
  float cameraY = height/2.0;
  float fov = mouseX/float(width) * PI/2;
  float cameraZ = cameraY / tan(fov / 2.0);
  float aspect = float(width)/float(height);
  if (mousePressed) {
    aspect = aspect / 2.0;
   
  }
  perspective(fov, aspect, cameraZ/10.0, cameraZ*10.0);
  translate(width/2+30, height/2, -3000);
  rotateZ(-PI/6);
  rotateZ(PI/3 + mouseY/float(height) * PI);
  rotateY(PI/3 + mouseY/float(height) * PI);
  
}