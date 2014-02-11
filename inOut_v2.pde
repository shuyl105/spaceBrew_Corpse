import spacebrew.*;

int ySpeed=1;
int HeadY, BodyY, TailY;
PImage Head, Body, Tail;

// Spacebrew stuff
String server = "sandbox.spacebrew.cc";
String name   = "EC1";
String desc   = "Some stuff";
Spacebrew sb;

// App Size: you should decide on a width and height
// for your group
int appWidth  = 900;
int appHeight = 720;

// EC stuff
int corpseStarted   = 0;
boolean bDrawing    = false;
boolean bLocalKeyInput    = false;
boolean bRemoteKeyInput    = false;

void setup() {
  background(0);
  size( appWidth, appHeight );
  Head=loadImage("FishHead.png");
  Body=loadImage("fishBody.png");
  Tail=loadImage("FishTail.png");

  sb = new Spacebrew(this);
  sb.addPublish("out", "boolean", false);  //Start & Finish the app
  sb.addSubscribe("in", "boolean");  

  sb.addPublish("send", "boolean", false); //Keyoutput & Keyinput
  sb.addSubscribe("receive", "boolean");

  sb.connect( server, name, desc );
}

void draw() {
  // this will make it only render to screen when in EC draw mode
  if (!bDrawing) return;

  // ---- start person 1 ---- //
  if ( millis() - corpseStarted < 10000 ) {
    frameRate(20);
    for (int i = 0; i <height*10 ; i = i+900) { 
      if (bRemoteKeyInput) {
        image(Head, 0, HeadY +i);
      }
      else {        
        image(Head, 0, HeadY +i);
        HeadY-=ySpeed;
      }
    }

    // ---- start person 2 ---- //
  } 
  else if ( millis() - corpseStarted < 20000 ) { 
    frameRate(20);
    for (int i = -900; i <height*10 ; i = i+900) { 
      if (bRemoteKeyInput) {
        image(Body, width / 3, BodyY -i);
        BodyY+=ySpeed;
      }
      else {        
        image(Body, width / 3, BodyY -i);
      }
    }

    // ---- start person 3 ---- //
  } 
  else if ( millis() - corpseStarted < 30000 ) {

    frameRate(20);
    for (int i = 0; i <height*10 ; i = i+900) { 
      if (bRemoteKeyInput) {
        image(Tail, width/3*2, TailY+i);
        TailY-=ySpeed;
      }
      else {        
        image(Tail, width/3*2, TailY+i);
      }
    }
    // ---- we're done! ---- //
  } 
  else {
    sb.send( "out", false );
    bDrawing = false;
  }

  noStroke();
  fill(0, 0, 0, 60);
  rect(0, 0, width, 210);
  rect(0, 510, width, 210);

  stroke(255, 230, 0);
  strokeWeight(6); 
  noFill();
  rect(0-50, 210, 1000, 300 );
}

void keyPressed() {
  if (key==' ') {
    bLocalKeyInput = !bLocalKeyInput;  //switch true/false
    sb.send( "send", bLocalKeyInput);
  }
}

void mousePressed() {
  sb.send( "out", true );  //start the app
}


void onBooleanMessage( String name, boolean value ) {
  if ( name.equals("in") ) {
    if (value) {    // or if (value==true)
      bDrawing = true;
      corpseStarted = millis();
    }
    else {
      bDrawing = false;
    }
  }
  else if ( name.equals("receive") ) { 
    bRemoteKeyInput = value;
  }
}

