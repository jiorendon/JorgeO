 import gab.opencv.*;
import java.awt.Rectangle;
import codeanticode.gsvideo.*;
import processing.serial.*;
import cc.arduino.*;

int j;
int k = 200;
int m = 0;
int time;
int wait = 5000;
int[] hist = new int[256];
int rM = 0;

PImage dst;
PImage foto;
PImage pal;
PImage indi;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

GSCapture cam;
OpenCV opencv;
OpenCV saved_file;
Rectangle[] faces;
Arduino arduino;
Histogram grayHist;

void setup() {
  size(800, 600);
  
  String[] cameras = GSCapture.list();
  
  if (cameras.length == 0)
  {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new GSCapture(this, 640, 480, cameras[0]);
    cam.start();
  }
  
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  for (int i = 0; i <= 13; i++){
    arduino.pinMode(i, Arduino.OUTPUT);
  }
 // for (int i = 22; i <= 53; i++){
 //   arduino.pinMode(i, Arduino.INPUT);
 // }
background(0,0,0);
}
 
void draw() {
  if (cam.available() == true) {
      cam.read();
   }
  saved_file = new OpenCV(this, "AA.jpg");
  foto = saved_file.getOutput();
  opencv = new OpenCV(this, cam);
  size(800, 600);

  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  
  faces = opencv.detect();
  opencv.gray();
  opencv.adaptiveThreshold(99,0);
  dst = opencv.getOutput();
  for (int i = 0; i < faces.length; i++) {
  k=faces[i].width;
  }
  contours = opencv.findContours();

  //image(opencv.getInput(), 0, 0);
  
  
  //image(dst,0,0);  
  
  tint(255,126);
  image(foto, 100, 0);
  
  if (k > 100 && k < 300 &&  int(random(0,5)) == 2){ 
  
   for (int i = 0; i < faces.length; i++) {
      indi = dst.get(faces[i].x-50, faces[i].y-50, faces[i].width+100, faces[i].height+100);
      indi.resize(600,600);
      image(indi, 100, 0);
      pal = get(100,0,600,600);
      pal.save("data/AA.jpg");  
 }
   
  
  }
 if (k > 100 && k < 300 &&  int(random(0,2)) == 2 ){
  time = millis();
  rM = 1;
  arduino.pinMode(50, Arduino.INPUT);
  arduino.pinMode(52, Arduino.INPUT);
  while (rM == 1){
   if(wait >= millis() - time){
   if (m == 0){
   arduino.digitalWrite(4, Arduino.HIGH); 
   }
   if (m == 1){
   arduino.digitalWrite(3, Arduino.HIGH); 
   }
   if (arduino.digitalRead(50) == Arduino.HIGH){
       arduino.digitalWrite(3, Arduino.LOW);
       arduino.digitalWrite(4, Arduino.HIGH);
       m=0;
       delay(3000);
       arduino.digitalWrite(4, Arduino.LOW);
       rM = 0;
       
   }
   if (arduino.digitalRead(52) == Arduino.HIGH){
      arduino.digitalWrite(4, Arduino.LOW);
      arduino.digitalWrite(3, Arduino.HIGH);
      m=1;
      delay(3000);
      arduino.digitalWrite(3, Arduino.LOW);
      rM = 0;
      
   }
   }
   if(wait <= millis() - time && m == 0){
   arduino.digitalWrite(4, Arduino.LOW);
   rM = 0;
  }
  if(wait <= millis() - time && m == 1){
   arduino.digitalWrite(3, Arduino.LOW);
   rM = 0;
  }
 }
}
  // tint(255,126);
  // image(foto, 0, 0);
 
  noFill();
  stroke(255, 255, 255);
  strokeWeight(1);
 
    
   for (Contour contour : contours) {
    stroke(0, 255, 0);
   // contour.draw();
    
    stroke(255, 0, 0);
    beginShape();
    for (PVector point : contour.getPolygonApproximation().getPoints()) {
    //  vertex(point.x, point.y);
    }
    endShape();
  }
}

