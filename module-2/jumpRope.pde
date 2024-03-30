import processing.sound.*;
import processing.serial.*;

Serial myPort; // create object from Serial class
String val; // data receieved from the serial port

int points = 0;

float height = 250;
float x = 0.75;
float speed_up_x = 0;

float playerHeight = 50;
float groundX = 0;
float groundY = 350;
float playerX = (500/2) - (playerHeight/2);
float playerY = groundY - playerHeight;
float vy = 0;
float ay = 0.5;

int color1 = 235;
int color2 = 164;
int color3 = 218;
int lastResetTime;

SoundFile points_sound;
SoundFile background_sound;

boolean ropeTouched = false;
boolean up = false;

void setup() {
  size(500, 500);
  
  String portName = Serial.list()[1]; // TODO: is this fine? first port in the serial list
  System.out.println(portName);
  myPort = new Serial(this, portName, 9600);
  
  
  // intialize background sound
  background_sound = new SoundFile(this, "background.mp3");
  background_sound.amp(.25);
  background_sound.play();
  lastResetTime = millis();
  
  // initalize points sound
  points_sound = new SoundFile(this, "points.wav");
  points_sound.amp(.7);
}

void draw() {
   if (myPort.available() > 0) {
     val = myPort.readStringUntil('\n'); 
   }
   val = trim(val);
  
  
  // Reset background sound every 16 seconds
  if (millis() - lastResetTime > 16000) {
    background_sound.stop();
    background_sound.play();
    lastResetTime = millis();
  }
  
  // Draw Background (sky, ground)
  background(166, 202, 247); // background color
  fill(182, 227, 185);
  rect(0, 350, 500, 150); // ground
  
  // Game Instructions
  fill(191, 90, 168);
  textSize(20);
  text("Jump Rope", 200, 45);
  fill(217, 150, 201);
  //fill(255);
  textSize(17);
  text("Hit the Button to Jump!", 175, 65);
  text("Points: " + points, 215, 85);
  
  // Pink square
  fill(color1, color2, color3);
  rect(playerX, playerY, playerHeight, playerHeight);
  
  // Change music depending on voltage
  if (val != null && val.indexOf("Voltage: 0.00") >= 0) {
    color1 = 235;
    color2 = 164;
    color3 = 218;
  }
  if (val != null && val.indexOf("Voltage: 3.30") >= 0) {
    color1 = 171;
    color2 = 151;
    color3 = 204;
  }
  
  // Simulates jumping and gravity
  if (val != null && val.indexOf("Button: 0") >= 0) {
    vy = -10;
    ay = 0.5;
  }
  
  playerY += vy;
  vy += ay;
  if (playerY > groundY - playerHeight) { //turns off gravity so box doesn't fly off screen
    playerY = groundY - playerHeight;
    vy = 0;
    ay = 0;
  }
  
  line(50, height, 450, height);
  height = height + x;
  
  // Rope reached ground (height 350)
  if (height >= 350) {
  // If player not on ground at this time, get 1 point
    if (playerY != 300) {
      points = points + 1;
      points_sound.play(); // play points sound
    }
    x = -0.75 - speed_up_x; // make rope move up
    speed_up_x = speed_up_x + 0.1; // make speed of rope increase
  }
  
  // Rope reaches max point in air
  if (height <= 250) {
    x = 0.75 + speed_up_x; // make rope move down
    speed_up_x = speed_up_x + 0.1; // make speed of rope increase
  }
  
  // Restart: Player touched rope
  if (height >= 348 && playerY == 300 && ropeTouched == false) {
    ropeTouched = true;
    //fail_sound.play(); // play point sound
    speed_up_x = 0; 
    delay(125);
  }
  
  // Game over text
  if (height >= 348 && playerY == 300) {
    textSize(20);
    fill(235, 87, 109);
    text("Game Over!", 200, 115);
    up = true;
    points = 0;
  }
  
  // Game over text
  if (height >= 335 && playerY == 300 && up == true) {
    textSize(20);
    fill(235, 87, 109);
    text("Game Over!", 200, 115);
  }
  
  if (height <= 335) {
    ropeTouched = false;
    up = false;
  }
}