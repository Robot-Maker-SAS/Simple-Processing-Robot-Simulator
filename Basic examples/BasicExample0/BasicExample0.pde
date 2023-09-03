// Code made by Mike118 from www.robot-maker.com.
// This Sketch can be used as a basis for a wheeled robot simulator for the French robotics cup
// the table is oriented so that the x axis is the length of the table (3000mm)
// the y-axis is the width of the table (2000mm) and the origin at the bottom middle.
// x € [ -1500, 1500] and y € [0, 2000]
// Made for azerty keyboard, use keyboard keys a z e q s d to move the robot.

// Dimensions of the table in mm
int tablex = 3000;
int tabley = 2000;

// Robot coordinates in mm
int x=-1400;
int y=1200;
float z=0;

// Robot speed modified by the keyboard
int vx=0;
int vy=0;
float vz = 0;

PImage table;

int framerate = 25;
int vmax = 500; // mm/s
float vzmax = PI/64;  // Rad/s

void setup() {
  noStroke(); // remove shape stroke
  size(1200, 700);
  frameRate(framerate);
  table = loadImage("tablegrille.png"); // 750 * 500 pixel  1 pixel = 4mm
}


void draw() {
  background(0);
  println(frameCount + ": " +  key);
  imageMode(CENTER);
  image(table, width/2, height/2);
  drawData() ;
  int w = 180;  // Robot width
  int l= 180;   // Robot length
  int margin = int(sqrt(w * w + l * l) / 2);

  x += vx * cos(z) - vy * sin(z);
  y += vy * cos(z) + vx * sin(z);

  int xmax = tablex/2 - margin;
  int ymax = tabley - margin;
  int xmin = -tablex/2 + margin;
  int ymin = 0 + margin;
  x = constrain(x, xmin, xmax);
  y = constrain(y, ymin, ymax);

  z += vz;
  if ( z > 2 * PI) {
    z-= 2*PI;
  } else if (z < 0) {
    z+= 2*PI;
  }
  drawRobot(x, y, z, w, l, color(255, 255, 0));
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


void keyPressed() {
  if (key == 'z')
    vy=vmax/framerate;
  else if (key == 's')
    vy=-vmax/framerate;
  else if (key == 'q')
    vx=-vmax/framerate;
  else if (key == 'd')
    vx=vmax/framerate;
  else if (key == 'a')
    vz=vzmax;
  else if (key == 'e')
    vz=-vzmax;
}

void keyReleased() {
  vx=0;
  vy=0;
  vz=0;
}

void drawData() {
  textSize(18);
  fill(0, 0, 255);
  text("x = " + x, 30, 20);
  text("y = " + y, 30, 40);
  text("z = " + z, 30, 60);
  text("vx = " + vx, 30, 80);
  text("vy = " + vy, 30, 100);
  text("vz = " + vz, 30, 120);
}
