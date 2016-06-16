/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

import controlP5.*;
ControlP5 cp5;

int myColorBackground = color(0,0,0);
int knobValue = 100;
Knob myKnobA;
Knob myKnobB;
Knob myKnobC;

void setup() {
  size(400,400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12016);
  
    cp5 = new ControlP5(this);
    
  // start the control panel 
  myKnobA = cp5.addKnob("triggerTH")
               .setRange(0,255)
               .setValue(50)
               .setPosition(100,70)
               .setRadius(50)
               .setDragDirection(Knob.VERTICAL)
               ;
               
  myKnobB = cp5.addKnob("apTH")
               .setRange(0,255)
               .setValue(50)
               .setPosition(200,70)
               .setRadius(50)
               .setDragDirection(Knob.VERTICAL)
               ;
               
  myKnobC = cp5.addKnob("windPower")
               .setRange(0,255)
               .setValue(50)
               .setPosition(100,200)
               .setRadius(50)
               .setDragDirection(Knob.VERTICAL)
               ;
   /**            
  myKnobD = cp5.addKnob("windPower")
               .setRange(0,255)
               .setValue(50)
               .setPosition(100,200)
               .setRadius(50)
               .setDragDirection(Knob.VERTICAL)
               ;
   **/
   
      cp5.addSlider("tilt")
     .setPosition(50,70)
     .setSize(20,230)
     .setRange(0,255)
     ;
                     
       cp5.addSlider("growth")
     .setPosition(100,40)
     .setSize(200,20)
     .setRange(0,200)
     ;
}


void draw() {
  background(0);  
    text("Server",width,height);
}

void get_ready_for_message(int topic,int input){
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/test"+topic);
  
  myMessage.add(input); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}

void triggerTH(int theValue) {
  get_ready_for_message(0,theValue);
  //println("a knob event. setting background to "+theValue);
}

void apTH(int theValue) {
  get_ready_for_message(1,theValue);
  //println("a knob event. setting background to "+theValue);
}

void windPower(int theValue) {
  get_ready_for_message(2,theValue);
  //println("a knob event. setting background to "+theValue);
}

void growth(int theValue){
  get_ready_for_message(5,theValue);
  //println("a knob event. setting background to "+theValue);
}

void tilt(int theValue){
  get_ready_for_message(6,theValue);
  //println("a knob event. setting background to "+theValue);
}
