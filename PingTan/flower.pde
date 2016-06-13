class flower{
  PVector loc, vel, acc;
  int lifeSpan, passedLife;
  boolean dead;
  float alpha, weight, weightRange, decay, xOffset, yOffset;
  color c;
  int index;
   
  flower(float x, float y, float xOffset, float yOffset,float size,float a){
    loc = new PVector(x,y);
     
    float randDegrees = random(360);
    vel = new PVector(cos(radians(randDegrees)), 5);
    vel.mult(random(5));
     
    acc = new PVector(0,0);
    lifeSpan = 200;
    decay = random(0.75, 1);
    c = color(random(255),random(255),255);
    weightRange =size;
    alpha=a;
     
    this.xOffset = xOffset;
    this.yOffset = yOffset;
  }
   
  void update(){
    if(passedLife>=lifeSpan){
      dead = true;
    }else{
      passedLife++;
    }
     
    //alpha = float(lifeSpan-passedLife)/lifeSpan * 70+50;
    weight = float(lifeSpan-passedLife)/lifeSpan * weightRange;
     
    acc.set(0,0);
     
    float rn = (noise((loc.x+frameCount+xOffset)*0.01, (loc.y+frameCount+yOffset)*0.01)-0.5)*4*PI;
    float mag = noise((loc.y+frameCount)*0.01, (loc.x+frameCount)*0.1);
    PVector dir = new PVector(cos(rn),1);
    acc.add(dir);
    acc.mult(mag);
     
    float randDegrees = random(360);
    PVector randV = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
    randV.mult(0.5);
    acc.add(randV);
     
    vel.add(acc);
    vel.mult(decay);
    vel.limit(5);
    loc.add(vel);
    loc.add(new PVector(windspeed,0));
  }
   
  void display(){
    /**
    strokeWeight(weight+1.5);
    stroke(0, alpha);
    point(loc.x, loc.y);
    strokeWeight(weight);
    stroke(#F2AFC1,alpha);
    point(loc.x, loc.y);
    **/
    noStroke();
    fill(#F2AFC1, alpha);
    ellipse(loc.x, loc.y, weight,weight); //random(2, 10)
  }
  
}
