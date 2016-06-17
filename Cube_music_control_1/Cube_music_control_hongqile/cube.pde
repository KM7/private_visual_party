class Cube {
  float _strokeCol = 200;
  float xpos;
  float ypos;
  float zpos;
  float theta;

  Cube(color c_, float xpos_, float ypos_, float zpos_, float theta_) {
    //c = c_;
    xpos = xpos_;
    ypos = ypos_;
    zpos = zpos_;
    theta = theta_;
  }

  void display() {
    //stroke(12,12);

    //translate(width/2,height/2);
    //translate(width/2,height/2);
    rotateZ(theta);
    //line(-100,0,100,0);
    //line(0,-100,0,100);
    noFill();
    if (_strokeCol > 100) { 
      _strokeCol -=2;
    } else {
      _strokeCol +=2;
    }// fade in
    stroke(_strokeCol, 10);
    strokeWeight(random(4));
    //ellipse(x1, y1, wid, hei);
    //rotate((float)mouseX/width*2*PI);
    theta +=0.01;
    //translate(width/2,height/2);
    rotateY(theta+90);
    box(3000, 95, 90);
    for ( int i = 0; i < song.bufferSize() - 1; i++ )
    {
      float x1  =  map( i, 0, song.bufferSize(), 0, width );
      float x2  =  map( i+1, 0, song.bufferSize(), 0, width );
      stroke(#05F0DE*i);
      //line( x1, 50 + song.left.get(i)*350, x2, 50 + song.left.get(i+1)*350);
      //line( x1, 100 + song.right.get(i)*350, x2, 150 + song.right.get(i+1)*350);
      
      //point(x1*20,100 + song.right.get(i)*50*20*m_faudioX*5);
      //point(x1*20,100 + song.right.get(i)*150*-30*m_faudioX*5);
    }

    //translate(width/2,height/2);
    rotateZ(theta+50*vizAudio.getLevel(0.5));
   
    box(40, 95, 90);
    bezier(85, 20, 10, 10, 90, 90, 15, 80);
    //translate(width/2,height/2);
    rotateX(theta-30);
    box(50, 50, 50);
    bezier(85, 20, 10, 10, 90, 90, 15, 80);
  }
}