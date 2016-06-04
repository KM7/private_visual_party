var num=100;
var onPressed=false;
var pts=Array(0);
var start=false;
var img;




function setup(){
createCanvas(windowWidth, windowHeight);
//background(255);
frameRate(30);
imageMode(CENTER);

}


function draw(){
//background(255);
//println(pts.length);
if (!start){
background(255,375,32);
textAlign(CENTER,CENTER);
//image(img,width/2,height/2-120,200,200);
text("This is a pubes generator 在线梦想Sperm生成器.",width/2,height/2);
text("Touch the screen 触摸屏幕 to start generating.",width/2,height/2+20);
text("V0.1 by KM7",width/2,height/2+40);



} else{
  if (onPressed) {
     var newP = new Particle(mouseX, mouseY, 0,pts.length, pts.length);
      pts.push(newP);
  }
 
  for (var i=0; i<pts.length; i++) {
    var p = pts[i];
    p.update();
    p.display();
  }
 
  for (var i=pts.length-1; i>-1; i--) {
    var p = pts[i];
    if (p.dead) {
      pts.splice(i,1);
    }
  }
  
}
}



function mousePressed() {
  onPressed = true;
}
 
function mouseReleased() {
  if (start==false){
  //background(255,178,233);
  background(255);
  start=true;
  }
  onPressed = false;
}
function preload() {
  img = loadImage("img/pube.png");
}


function Particle(x,y,xOffset,yOffset){
  this.loc=createVector(x, y)
   this.randDegrees = random(360);
   this.vel = createVector(cos(radians(this.randDegrees)), sin(radians(this.randDegrees)));
   this.vel.mult(random(5));
   this.acc = createVector(0,0);
   this.lifeSpan=int(random(8, 14));
   this.passedLife=0;
   this.dead=false;
   this.weight=0;
   this.weightRange=random(1,8);
   this.decay= random(0.75, 0.9);
   this.xOffset, yOffset;
   this.c=color(random(255),random(255),random(255));
   this.xOffset = xOffset;
   this.yOffset = yOffset;
   this.past_trail=Array();

   this.update= function(){
    //if the position is out of bound, sabotage it put it into death
    if(this.loc.x<0||this.loc.x>width||this.loc.y<0||this.loc.y>height){
            this.dead = true;
    }
    
    //update the path it has visited before
    this.past_trail.push(this.loc.copy());
    if (this.past_trail.length>this.lifeSpan){
        this.past_trail.shift();
    }else{
      
    }
    
    if(this.passedLife>=this.lifeSpan){
      
    }else{
      this.passedLife++;
    }
     
    this.alpha2 = float(this.lifeSpan+this.passedLife)/this.lifeSpan * 70+50;
    this.weight = float(this.lifeSpan+this.passedLife)/this.lifeSpan * this.weightRange;
     
    this.acc.set(0,0);
     
    var rn = (noise((this.loc.x+frameCount+this.xOffset)*0.01, (this.loc.y+frameCount+this.yOffset)*0.01)-0.5)*4*PI;
    var maga = noise((this.loc.y+frameCount)*0.01, (this.loc.x+frameCount)*0.01);
    var dir = createVector(cos(rn),sin(rn));
    this.acc.add(dir);
    this.acc.mult(maga);
     
    var randDegrees = random(360);
    var randV = createVector(cos(radians(this.randDegrees)), sin(radians(this.randDegrees)));
    randV.mult(0.5);
    this.acc.add(randV);
     
    this.vel.add(this.acc);
    this.vel.mult(this.decay);
    this.vel.limit(1.3);
    this.loc.add(this.vel);
  }
  
  this.display_single=function(input_vector,life_span){
    //print(life_span);
    var temp_weight = float(life_span) * this.weightRange*0.2;
    push();
    //strokeWeight(temp_weight*0.02);
    translate(input_vector.x,input_vector.y);
    noStroke();
    fill(this.c);
    ellipse(0,0,temp_weight,temp_weight);
    //point(0,0);
    //stroke(0,this.alpha2);
    //sphere(weight);
    pop();
  }
   
  this.display = function(){
    //stroke(0, alpha);
    //point(loc.x, loc.y);
   // this.display_single(this.loc);
    
    for(var i=0;i<this.past_trail.length;i++){
      this.display_single(this.past_trail[i],i);
    }

     
    /**
    strokeWeight(weight);
    stroke(c);
    point(loc.x, loc.y);
    **/
     
    //strokeWeight(weight);
    //stroke(c);
   // point(loc.x, loc.y,loc.y);
  }
}
