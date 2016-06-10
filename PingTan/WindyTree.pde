/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/139564*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

class WindyTree {
  float MAX_ANGLE = 32*PI/180;
  float MIN_ANGLE = -MAX_ANGLE;
  float SMALL_BRANCH_LENGTH_MIN = 1;        //a branch can be small between SMALL_BRANCH_LENGTH_MIN
  float SMALL_BRANCH_LENGTH_MAX = 100;      //and SMALL_BRANCH_LENGTH_MAX
  float TALL_BRANCH_LENGTH_MIN = 50;//a branch can be tall between TALL_BRANCH_LENGTH_MIN
  float TALL_BRANCH_LENGTH_MAX = 200;//and TALL_BRANCH_LENGTH_MAX
  float ROTATION_ADJUSTMENT = PI/2.;
  float MAX_BRANCH_WIDTH = 5.5;
  int   NB_TREES = 5;
  int   NB_BRANCHES = 5;

  float angle = MAX_ANGLE;
  float[] minBranchLength;
  float[] maxBranchLength;

  PVector[] origines;
  Node originalNodes[];
  int[] nbNodes;

  float m_mouseX;
  float m_mouseY;
  float m_speed;
  int   m_blossom;
  int   m_depth;

  Wind wind;
  
  WindyTree() {
    m_speed = 1;
    m_blossom = 0;
    m_depth = MAX_DEPTH-2;
    wind = new Wind();
    setTree(NB_TREES);
    onMouseMove();
  }

  void draw() {
    rectMode(CENTER);
    onMouseMove();
    wind.update(); 
  }
  
  void increaseDepth() {
    if(m_depth<MAX_DEPTH) m_depth++;
     windyTree.resetTree();
  }

  void decreaseDepth() {
    if(m_depth>0) m_depth--;
     windyTree.resetTree();
  }

  void increaseDelta() {
    m_delta*=1.05;
  }
  
  void decreaseDelta() {
    m_delta/=1.05;
  }

  void increaseSpeed() {
    m_speed*=1.05;
  }
  
  void decreaseSpeed() {
    m_speed/=1.05;
  }
    
  void changeBlossom(int flag) {
    if(flag==-1) m_blossom++;
    else m_blossom=flag;
    if(m_blossom<0 || m_blossom>6) m_blossom=0;
  }
  
  void printParameter() {
    text("WindyTree : blossom(b) "+m_blossom+" speed(nm) "+m_speed+" delta(<>) "+m_delta+" depth "+m_depth, 15, 70);
  }
  
  void setTree(int num) {
    NB_TREES=num;
    originalNodes = new Node[NB_TREES];
    origines = new PVector[NB_TREES];
    nbNodes = new int[NB_TREES];
    minBranchLength = new float[NB_TREES];
    maxBranchLength = new float[NB_TREES];
    for(int i = 0; i < NB_TREES; i++)
      makeNewTree(i);
  }    
  
  void resetTree() {
    for(int i = 0; i < NB_TREES; i++)
      startTree(i);
  }    

  void makeNewTree(int i) {
    angle = random(MIN_ANGLE, MAX_ANGLE);
    origines[i] = new PVector(random(width/(NB_TREES+1), NB_TREES*width/(NB_TREES+1)), height);//(i+1)*width/(NB_TREES+1), height);
    minBranchLength[i] = random(SMALL_BRANCH_LENGTH_MIN, SMALL_BRANCH_LENGTH_MAX);
    maxBranchLength[i] = TALL_BRANCH_LENGTH_MIN + (TALL_BRANCH_LENGTH_MAX - SMALL_BRANCH_LENGTH_MIN) * random(1);
    if (maxBranchLength[i] < TALL_BRANCH_LENGTH_MIN) maxBranchLength[i] = TALL_BRANCH_LENGTH_MIN;
    if (maxBranchLength[i] > TALL_BRANCH_LENGTH_MAX) maxBranchLength[i] = TALL_BRANCH_LENGTH_MAX;
    startTree(i);
  }

  void startTree(int j) {
    nbNodes[j] = 0;
    //PVector originalPosition = new PVector(width/2, height);
    originalNodes[j] = new Node(0, NB_BRANCHES, origines[j], 0, maxBranchLength[j], 0, color(0));
    addNodes(originalNodes[j], j);
  }
  
  void addNodes(Node p_node, int j) {
    nbNodes[j]++;
    Node parentNode = p_node;
    int l_depth = parentNode.depth;
    float newX;
    float newY;
    float newBranchLength;
    float newAngle;
    color newColor;
    for(int i = 0; i < NB_BRANCHES; i++) {
      newBranchLength = random(minBranchLength[j], maxBranchLength[j]) * (m_depth - l_depth) / m_depth;
      newAngle = parentNode.myAngle - angle + (2 * angle * i / (NB_BRANCHES-1)) + random(1) * (l_depth+1) / m_depth * (random(1) > .5 ? 1 : -1);
      newX = parentNode.x + cos(newAngle - ROTATION_ADJUSTMENT) * newBranchLength;
      newY = parentNode.y + sin(newAngle - ROTATION_ADJUSTMENT) * newBranchLength;
      parentNode.tabNodes[i] = new Node(l_depth+1, NB_BRANCHES, new PVector(newX, newY), newAngle, newBranchLength, i, 0);
      if(l_depth+1 < m_depth) addNodes(parentNode.tabNodes[i], j);
    }
    parentNode.shuffle();//allows an organic order of the branches
  }
  
  void onMouseMove() {
    m_faudioX=map(m_faudioX, 0, 3, 0, 1); 
    m_faudioY=map(m_faudioY, 0, 10, 0, 1); 
    m_faudioX=constrain(m_faudioX, 0, 1);
    m_faudioY=constrain(m_faudioY, 0, 1)/3.;
    m_mouseX = mouseX*(1.-m_faudioX);
    m_mouseY = mouseY*(1.-m_faudioY);
    updateTrunk();
    for(int i = 0; i < NB_TREES; i++)
      updateNode(originalNodes[i]);
      
    stroke(0, 255, 0, m_alpha);  
    fill(#F2AFC1, m_alpha);
    ellipse(10, height-20, 12, 12); //random(2, 10)
    drawTree();
  }

  void drawTree() {
    int parentdepth = 0;
    for(int i = 0; i < NB_TREES; i++) {
      PVector toPoint = new PVector(originalNodes[i].x, originalNodes[i].y);
      strokeWeight(MAX_BRANCH_WIDTH);
      if(drawFluidFlag) stroke(20*(2+parentdepth));          
      else stroke(20*(1+parentdepth), 255/(2+(parentdepth)*4.5));  //.9
      line(origines[i].x, origines[i].y, toPoint.x, toPoint.y);
      drawNode(originalNodes[i]);
    }
  }
  
  //Call this method to get one available node
  void get_available_node(){
    //
  }
  
  Node call_next_node(Node p_originalNode){
    boolean flag=false;    
    Node myParentNode = p_originalNode;
    int parentdepth = myParentNode.depth;
    if (parentdepth < m_depth) {
      Node myChildNode;
      for (int i = 0; i < NB_BRANCHES; i++) {
        myChildNode = myParentNode.tabNodes[i];
        strokeWeight(MAX_BRANCH_WIDTH-parentdepth-1);                  //MAX_BRANCH_WIDTH/(1+parentm_depth*.17));
        if(drawFluidFlag) stroke(20*(2+parentdepth));          
        else stroke(20*(1+parentdepth), 255/(2+(parentdepth)*4.5));    //.9 
        line(myParentNode.x, myParentNode.y, myChildNode.x, myChildNode.y);
        strokeWeight((MAX_BRANCH_WIDTH-parentdepth)*.85);  
        if(m_blossom>0 && parentdepth==m_depth-1 && parentdepth<MAX_DEPTH-1) flag=true;
        if(parentdepth==MAX_DEPTH-1) flag=true;
        if(flag) {
          strokeWeight((MAX_BRANCH_WIDTH-parentdepth)*.85);  
          float w=noise(m_offset);
          float a=(255.-m_alpha)+m_alpha*noise(m_offset+1);
          a = constrain(a, 0, 255);
          //fly it off
        }
        call_next_node(myChildNode);
      }   
    }
    return p_originalNode;
  }
  
  void drawNode(Node p_originalNode) { 
    boolean flag=false;    
    Node myParentNode = p_originalNode;
    int parentdepth = myParentNode.depth;
    if (parentdepth < m_depth) {
      Node myChildNode;
      for (int i = 0; i < NB_BRANCHES; i++) {
        myChildNode = myParentNode.tabNodes[i];
        strokeWeight(MAX_BRANCH_WIDTH-parentdepth-1);                  //MAX_BRANCH_WIDTH/(1+parentm_depth*.17));
        if(drawFluidFlag) stroke(20*(2+parentdepth));          
        else stroke(20*(1+parentdepth), 255/(2+(parentdepth)*4.5));    //.9 
        line(myParentNode.x, myParentNode.y, myChildNode.x, myChildNode.y);
        strokeWeight((MAX_BRANCH_WIDTH-parentdepth)*.85);  
        if(m_blossom>0 && parentdepth==m_depth-1 && parentdepth<MAX_DEPTH-1) flag=true;
        if(parentdepth==MAX_DEPTH-1 && random(0,1)<0.45) flag=true;
        if(flag) {
          strokeWeight((MAX_BRANCH_WIDTH-parentdepth)*.85);  
          float w=noise(m_offset);
          float a=(255.-m_alpha)+m_alpha*noise(m_offset+1);
          a = constrain(a, 0, 255);
          int  m=(MAX_DEPTH-parentdepth);
          if(m_blossom==1) {
            fill(255, a);
            rect(myChildNode.x, myChildNode.y, 3+10*w, 3+10*w);
          }
          else if(m_blossom==2) {
            stroke(255, a);
            fill(255, a);
            rect(myChildNode.x, myChildNode.y, m+2+2*w, m+2+2*w);
          }
          else if(m_blossom==3) {
            stroke(255, 0, 0, a);
            fill(255, 0, 0, a);
            rect(myChildNode.x, myChildNode.y, m+2*w, m+2*w);
          }  
          else if(m_blossom==4) {
            stroke(0, 255, 0, a);
            fill(0, 255, 0, a);
            rect(myChildNode.x, myChildNode.y, m+2*w, m+2*w);
          }  
          else if(m_blossom==5) {
            stroke(0, 0, 255, a);
            fill(0, 0, 255, a);
            rect(myChildNode.x, myChildNode.y, m+2*w, m+2*w);
          }  
          else if(m_blossom==6) {
            blossom(myChildNode.x, myChildNode.y, a);
          }  
        }
        drawNode(myChildNode);
      }   
    }
  }

  void blossom(float x, float y, float a) {
    float f=noise(m_offset)*16+(MAX_DEPTH-m_depth+1)*2;
    fill(#F2AFC1, a);
    ellipse(x+1.5, y, f, f); //random(2, 10)
  /*
    fill(#ED7A9E);
    ellipse(x, y+1.5, f, f);
    fill(#E54C7C);
    ellipse(x-1.5, y, f, f);
  */
  /*  
    float rnd = random(10);
    if(rnd < 0.1) {
      fill(#E54C7C);
      ellipse(x+random(-100, 100), height-random(20), random(4, 10), random(4, 10));
    }
    else if(rnd > 9.9) {
      fill(#F2AFC1);
      ellipse(x+random(-100, 100), height-random(20), random(4, 10), random(4, 10));
    }
  */  
  }

  void updateTrunk() {
    for(int i = 0; i < NB_TREES; i++) {
      float newOriginalNodeY = origines[i].y - 2.5 * (maxBranchLength[i] - minBranchLength[i]) * (height - m_mouseY) / height - SMALL_BRANCH_LENGTH_MAX; // mouseY
      originalNodes[i].updateNodeInfos(originalNodes[i].x, newOriginalNodeY, originalNodes[i].myAngle, originalNodes[i].distance);
    }
  }
  
  void updateNode(Node p_node) {
    Node myParentNode = p_node;
    int l_depth = myParentNode.depth;      
    if(l_depth < m_depth) {
      Node myChildNode;
      float coeffDist = 0.26+(height-m_mouseY*(.5+noise(m_offset)))/height;                        //
      float coeffAngle = (noise(m_offset/100.+1.0)-0.5)*2.+m_mouseX/width*2.;                            // mouseX
//      float coeffAngle = 0.2+(noise(m_offset+1.0)+0.8)*m_mouseX/width;                            // mouseX
      for(int i = 0; i < NB_BRANCHES; i++) {
        myChildNode = myParentNode.tabNodes[i];
        float newBranchLength = myChildNode.distanceO * coeffDist;
        myChildNode.angleO += m_speed * wind.speed(myChildNode.x, myChildNode.y) * myChildNode.depth * myChildNode.depth;
        float newAngle = myChildNode.angleO * coeffAngle;
        float newX = myParentNode.x + cos(newAngle - ROTATION_ADJUSTMENT) * newBranchLength;
        float newY = myParentNode.y + sin(newAngle - ROTATION_ADJUSTMENT) * newBranchLength;
        myChildNode.updateNodeInfos(newX, newY, newAngle, newBranchLength);
        updateNode(myChildNode);
      }
    }
  }
}

