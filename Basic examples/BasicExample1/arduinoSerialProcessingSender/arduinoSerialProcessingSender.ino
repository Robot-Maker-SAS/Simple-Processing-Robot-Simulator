// Code made by Mike118 from www.robot-maker.com.
// Simple test code to validate the operation of the simulator
// Allows to send a robot position frame as well as 200 lidar pts
// Serial frames of the form P:x,y,z with a line break at the end for the position of the robot
// Serial frames of the form L:x0,y0,x1,y1,...x199,y199 with a line break at the end for the 200 lidar pts.

#define DELAY 100  // ms
#define SPEED 16   // mm / DELAY
int x = -1400;     // Position (mm)
int y = 1200;      // Position (mm)
float z = PI / 4;  // Angle (Radian)
int deltax = SPEED;
int deltay = SPEED;

typedef struct {
  union {
    struct {
      int16_t x;
      int16_t y;
    };
    int16_t coordonnees[2];
    uint8_t bytes[4];
  };
} Point;


Point lidar[200] = { { 0, 0 } };

void setup() {
  Serial.begin(115200);
  for (uint8_t i = 0; i < 60; i++) {
    lidar[i].x = i * 50 - 1500;
    lidar[i].y = 0;
  }
  for (uint8_t i = 60; i < 100; i++) {
    lidar[i].x = 1500;
    lidar[i].y = (i - 60) * 50;
  }
  for (uint8_t i = 100; i < 160; i++) {
    lidar[i].x = 1500 - (i - 100) * 50;
    lidar[i].y = 2000;
  }
  for (uint8_t i = 160; i < 200; i++) {
    lidar[i].x = -1500;
    lidar[i].y = 2000 - (i - 160) * 50;
  }
}

void loop() {
  static uint32_t ref = millis();
  if (millis() - ref > DELAY) {
    ref = millis();

    if (x > 1250) {
      deltax = -SPEED;
    } else if (x < -1250) {
      deltax = SPEED;
    }

    if (y > 1750) {
      deltay = -SPEED;
    } else if (y < 250) {
      deltay = SPEED;
    }
    x += deltax;
    y += deltay;

    if (deltax > 0 && deltay > 0)
      z = -PI / 4;
    else if (deltax < 0 && deltay > 0)
      z = PI / 4;
    else if (deltax < 0 && deltay < 0)
      z = 3 * PI / 4;
    else if (deltax > 0 && deltay < 0)
      z = -3 * PI / 4;
    else
      z = 0;


    Serial.println((String) "P:" + x + "," + y + "," + z);

    Serial.print("L:");
    for (uint8_t i = 0; i < 200; i++) {
      Serial.print(lidar[i].x);
      Serial.print(',');
      Serial.print(lidar[i].y);
      Serial.print(',');
    }
    Serial.println();
  }
}
