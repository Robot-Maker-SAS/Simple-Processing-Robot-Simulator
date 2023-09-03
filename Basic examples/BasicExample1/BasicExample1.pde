// Code made by Mike118 from www.robot-maker.com.
// This Sketch can be used as a basis for a wheeled robot simulator for the French robotics cup
// the table is oriented so that the x axis is the length of the table (3000mm)
// the y-axis is the width of the table (2000mm) and the origin at the bottom middle.
// x € [ -1500, 1500] and y € [0, 2000]
// Allows to display the position of the robot as well as 200 lidar points
// Send serial frames of the form P:x,y,z to move the robot with a line break at the end
// Send serial frames of the form L:x0,y0,x1,y1,...x199,y199 with a line break at the end
// Plug in an arduino with the provided arduino example code for testing
// Note: you must only have one com port connected to the computer with this code...

class Point {
  public short x;
  public short y;
  public Point(int x, int y) {
    this.x = (short)x;
    this.y = (short)y;
  }
}

Point [] lidar = new Point[200];

// Dimensions of the table in mm
int tablex = 3000;
int tabley = 2000;

PImage table;
int framerate = 25;

// Robot coordinates in mm and angle in radians
int x=-1400; // mm
int y=1200; // mm
float z=0; // rad

import processing.serial.*;
String[] serialports;
Serial rx;

void setup() {
  noStroke(); // remove shape stroke
  size(1200, 700);
  frameRate(framerate);
  table = loadImage("tablegrille.png"); // 750 * 500 pixel  1 pixel = 4mm
  serialports = Serial.list();
  println(serialports.length);
  println(serialports);

  for (int i=0; i < 200; i++) {
    lidar[i] = new Point(0, 0);
  }

  if ( serialports.length == 1) {
    rx = new Serial(this, Serial.list()[0], 115200);
    rx.bufferUntil('\n');
  } else
    println("error");
}

void draw() {
  background(0);
  println(frameCount + ": " +  key);
  imageMode(CENTER);
  image(table, width/2, height/2);
  drawData() ;
  drawRobot(x, y, z, 180, 180, color(255,255,0)); 
  for (int i = 0; i < 200; i++) {
    drawRect(lidar[i].x, lidar[i].y, 0, 16, 16, color(255,0,0));
  }
}

// Functions to convert position in mm to position in pixels
int xToPixel(int x) {
  return x/4 + width/2 ;  //  1 pixel = 4mm
}

int yToPixel(int y) {
  return -y/4 + height -100; //  1 pixel = 4mm and -100 because 700pixel window height size and 500pixels image heigt size and image in center
}

// drawRobot(int x, int y, float z, int w, int l, color c)
// x y position (mm)
// z angle (rad)
// w and l (mm) robot width and length
// c (color) color(r,g,b) to define the robot color.
 
void drawRobot(int x, int y, float z, int w, int l, color c) {
    int prettyMarge = 5;
    drawRect(x, y, z, w, l, c);
    // wheels
    drawRect(int(x - (l/3*sin(z)) + ( 2*w/5*cos(z))), int(y + ( l/3*cos(z)) + (2*w/5*sin(z))), z, w/5 + prettyMarge, l/3 + prettyMarge, color(50, 50, 50));
    drawRect(int(x - (-l/3*sin(z)) + ( 2*w/5*cos(z))), int(y + ( -l/3*cos(z)) + (2*w/5*sin(z))), z, w/5 + prettyMarge, l/3 + prettyMarge, color(50, 50, 50));
    drawRect(int(x - (l/3*sin(z)) + ( -2*w/5*cos(z))), int(y + ( l/3*cos(z)) + (-2*w/5*sin(z))), z, w/5 + prettyMarge, l/3 + prettyMarge, color(50, 50, 50));
    drawRect(int(x - (-l/3*sin(z)) + ( -2*w/5*cos(z))), int(y + ( -l/3*cos(z)) + (-2*w/5*sin(z))), z, w/5 + prettyMarge, l/3 + prettyMarge, color(50, 50, 50));
    // red dot
    drawRect(int(x - (l/3*sin(z))), int(y + (l/3*cos(z))), z, w/5, l/5, color(255, 0, 0));
}

// drawRect(int x, int y, float z, int r, int g, color c)
// x y position (mm)
// z angle (rad)
// w and l (mm) rectangle width and length
// c color  color(r,g,b) to define the rectangle color.

void drawRect(int x, int y, float z, int w, int l, color c) {
  pushMatrix();
  rectMode(CENTER);
  int robotPixelWidth = w / 4;
  int robotPixelLength = l/ 4;
  fill(c);
  translate(xToPixel(x), yToPixel(y));
  rotate(-z);
  rect(0, 0, robotPixelWidth, robotPixelLength); 
  popMatrix();
}

void drawData() {
  textSize(18);
  fill(0, 0, 255);
  text("x = " + x, 30, 20);
  text("y = " + y, 30, 40);
  text("z = " + z, 30, 60);
}

void serialEvent(Serial thisPort) {
  String message = thisPort.readString();
  message = trim(message);
  println(message);
  String[] dataMessage = split(message, ":");

  if (dataMessage.length == 2) {
    String[] valuesMessage = split(dataMessage[1], ",");
    if (dataMessage[0].charAt(0) == 'L') {
      if (valuesMessage.length >= 400) {
        for (int i=0; i<200; i++) {
          lidar[i].x=(short)(int(valuesMessage[2*i]));
          lidar[i].y=(short)(int(valuesMessage[2*i + 1]));
        }
      }
    } else if (dataMessage[0].charAt(0) == 'P') {
      x = (short)int(valuesMessage[0]);
      y = (short)int(valuesMessage[1]);
      z = float(valuesMessage[2]);
    }
  }
}
