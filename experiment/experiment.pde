ArrayList<flower> pts;
boolean onPressed, showInstruction;
float windspeed=-10;
float windAcc;

void setup() {
  size(720, 720, P2D);
  smooth();
  frameRate(30);
  colorMode(HSB);
  rectMode(CENTER);
  pts = new ArrayList<flower>();
 
  background(255);
}
 
void draw() {
 background(255);
  if (onPressed) {
     flower newP = new flower(mouseX, mouseY, pts.size(), pts.size());
      pts.add(newP);
  }
 
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
  
      if (keyPressed&&key == 'a') {
  windspeed=windspeed-1;
  }
  
    
      if (keyPressed&&key == 'd') {
  windspeed=windspeed+1;
  }
  stroke(0);
  fill(0);
  text("Wind situation " + windspeed,50,50);

}
 
void mousePressed() {
  onPressed = true;
}
 
void mouseReleased() {
  onPressed = false;
}
 
void keyPressed() {
  if (key == 'c') {
    for (int i=pts.size()-1; i>-1; i--) {
      flower p = pts.get(i);
      pts.remove(i);
    }
    background(255);
  }
  

}
