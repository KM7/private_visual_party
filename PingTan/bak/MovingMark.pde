class MovingMark {
  int      i, t, displayType=1;
  float    x, y, hue, theta, radius;
  float    p=0, dp=0.0075;

  MovingMark(float x, float y, float theta, float radius, float hue) {
    this.x=x;
    this.y=y;
    this.theta=theta;
    this.radius=radius;
    this.hue=hue;
  }

  void update(float dx, float dy, float dtheta) {
    addForce(x*invWidth, y*invHeight, dx*invWidth, dy*invHeight);
    x+=dx;
    y+=dy;
    theta+=dtheta;
  }

  void draw(int type) {
    if (type==0) drawMark0();
    else if (type==1) drawMark1();
    else if (type==2) drawMark2();
    else if (type==3) drawMark3();
    else if (type==4) drawMark4();
    else if (type==5) drawMark5();
    else if (type==6) drawMark6();
  }

  void drawMark0() {
    pushMatrix();
    translate(x, y);
    rotate(-theta);

    stroke((180+hue)%360, 100, 100);
    for (t=0; t<360; t+=10) {
      float c = cos(t/360.*TWO_PI);
      float s = sin(t/360.*TWO_PI);
      float r = 0; //noise(t/360.);
      line(radius*c, radius*s, (3+r)*radius*c, (3+r)*radius*s);
    }  

    noStroke();
    fill(hue, 99, 99);
    ellipse(0, 0, radius*2, radius*2);

    stroke(hue, 100, 100);
    line(0, 0, radius, 0);

    popMatrix();
  }

  void drawMark1() {
    pushMatrix();
    translate(x, y);
    rotate(-theta);
    noStroke();
    fill(hue, 100, 100);
    ellipse(0, 0, radius*2, radius*2);
    stroke((180+hue)%360, 100, 100);
    strokeWeight(3);
    line(0, 0, 2*radius, 0);
    noFill();
    strokeWeight(1);
    stroke((180+hue)%360, 30, 100);
    ellipse(0, 0, radius*5, radius*5);
    strokeWeight(2);
    popMatrix();
  }

  void drawMark2() {
    int m=6;
    pushMatrix();
    translate(x, y);
    rotate(-theta);
    noFill();
    for (i=0; i<m; i++) {
      strokeWeight((m-i));
      stroke(hue, 100-10*i, 100);
      ellipse(0, 0, radius*(i+1), radius*(i+1));
    }
    strokeWeight(m/2);
    stroke((180+hue)%360, 100, 100);
    line(0, 0, m/2*radius, 0);
    strokeWeight(2);
    popMatrix();
  }

  void drawMark3() {
    float  t;
    int    m=8;
    pushMatrix();
    translate(x, y);
    rotate(-theta);
    noFill();
    for (i=0; i<m; i++) {
      strokeWeight((m-i));
      stroke(hue, 100-10*i, 100);
      t = noise(p+i)*2;      
      pushMatrix();
        rotate(t*TWO_PI);
        arc(0, 0, radius*(i+1), radius*(i+1), t, TWO_PI-t);
      popMatrix();
    }
    strokeWeight(m/2);
    stroke((180+hue)%360, 100, 100);
    line(0, 0, m/2*radius, 0);
    strokeWeight(2);
    popMatrix();
    p+=dp;
  }

  void drawMark4() {
    int m=6;
    pushMatrix();
    translate(x, y);
    rotate(-theta);
    noFill();
    for (i=0; i<m; i++) {
      strokeWeight((m-i));
      stroke(hue, 100-10*i, 100);
      rect(0, 0, radius*(i+1), radius*(i+1));
    }
    strokeWeight(m/2);
    stroke((180+hue)%360, 100, 100);
    line(0, 0, m/2*radius, 0);
    strokeWeight(2);
    popMatrix();
  }

  void drawMark5() {
    float  t;
    int    m=5;
    pushMatrix();
    translate(x, y);
    rotate(-theta);
    noFill();
    for (i=0; i<m; i++) {
      strokeWeight((m-i));
      stroke(hue, 100-10*i, 100);
      t = noise(p+i/100.);      
      pushMatrix();
        rotate(t*TWO_PI);
        rect(0, 0, radius*(i+1), radius*(i+1));
      popMatrix();
    }
    strokeWeight(m/2);
    stroke((180+hue)%360, 100, 100);
    line(0, 0, m/2*radius, 0);
    strokeWeight(2);
    popMatrix();
    p+=dp/10.;
  }

  void drawMark6() {
    pushMatrix();
    translate(x, y);
    rotate(-theta);

    strokeWeight(3);
    fill(hue, 100, 100);
    stroke((180+hue)%360, 100, 100);
    ellipse(0, 0, radius*2, radius*2);
    line(0, 0, radius, 0);

    popMatrix();
  }

  String info() {
    String tmp="position:=("+x+","+y+") theta:="+theta+" radius:="+radius;  
    return tmp;
  }
}

