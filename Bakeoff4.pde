import java.util.ArrayList;
import java.util.Collections;
import ketai.sensors.*;

KetaiSensor sensor;
float rotationX, rotationY, rotationZ;
float light = 0;


  private class Target
  {
    int target = 0;
    int action = 0;
  }

  int trialCount = 5; //this will be set higher for the bakeoff
  int trialIndex = 0;
  ArrayList<Target> targets = new ArrayList<Target>();
     
  int startTime = 0; // time starts when the first click is captured
  int finishTime = 0; //records the time of the final click
  boolean userDone = false;
  int countDownTimerWait = 0;
  
  void setup() {
    size(450,700); //you can change this to be fullscreen
    frameRate(60);
    sensor = new KetaiSensor(this);
    sensor.start();
    orientation(PORTRAIT);
  
    rectMode(CENTER);
    textFont(createFont("Arial", 20)); //sets the font to Arial size 20
    textAlign(CENTER);
    
    for (int i=0;i<trialCount;i++)  //don't change this!
    {
      Target t = new Target();
      t.target = ((int)random(1000))%4;
      t.action = ((int)random(1000))%2;
      targets.add(t);
      println("created target with " + t.target + "," + t.action);
    }
    
    Collections.shuffle(targets); // randomize the order of the button;
  }

  void draw() {

    background(80); //background is light grey
    noStroke(); //no stroke
    
    countDownTimerWait--;
    
    if (startTime == 0)
      startTime = millis();
    
    
    if (userDone)
    {
      text("User completed " + trialCount + " trials", width/2, 50);
      text("User took " + nfc((finishTime-startTime)/1000f/trialCount,1) + " sec per target", width/2, 150);
      return;
    }
    
 
    fill(255);//white
    text("Trial " + (trialIndex+1) + " of " +trialCount, width/2, 50);
    text("Target #" + (targets.get(trialIndex).target)+1, width/2, 100);
    
    String cover = "";
    if(targets.get(trialIndex).action == 0){
      cover = "Cover";
    } else {
      cover = "Don't Cover";
    }
    
    text("Gyroscope: \n" + 
    "x: " + nfp(rotationX, 1, 3) + "\n" +
    "y: " + nfp(rotationY, 1, 3) + "\n" +
    "z: " + nfp(rotationZ, 1, 3) + "\n" +
    "proximity: " + cover, width/2, 180);
    
    fill(0, 255, 0);
    if(targets.get(trialIndex).target + 1 == 1){
      triangle(width/2 - 20, 50, width/2, 30, width/2 + 20, 50);
    }
    if(targets.get(trialIndex).target + 1 == 2){
      triangle(400, height/2 - 20, 420, height/2, 400, height/2 + 20);
    }
    if(targets.get(trialIndex).target + 1 == 3){
      triangle(width/2 - 20, 600, width/2, 620, width/2 + 20, 600);
    }
    if(targets.get(trialIndex).target + 1 == 4){
      triangle(50, height/2-20, 30, height/2, 50, height/2+20);
    }
  }
  
void onAccelerometerEvent(float x, float y, float z)
{
  
  rotationX = x;
  rotationY = y;
  rotationZ = z;
  
  if (trialIndex==targets.size() - 1 && !userDone)
    {
      userDone=true;
      finishTime = millis();
      return;
    }
  else{
    if(targets.get(trialIndex).target + 1 == 1 && y < -5){
      if(proximityCorrect()){
        trialIndex++;
      }
    }
    if(targets.get(trialIndex).target + 1 == 2 && x < -6){
      if(proximityCorrect()){
        trialIndex++;
      }
    }
    if(targets.get(trialIndex).target + 1 == 3 && y > 6) {
      if(proximityCorrect()){
        trialIndex++;
      }
    }
    if(targets.get(trialIndex).target + 1 == 4 && x > 6){
      if(proximityCorrect()){
        trialIndex++;
      }
    }
  }
}

boolean proximityCorrect(){
  if(targets.get(trialIndex).action == 0){
    return light == 0;
  } else{
    return light > 0;
  }
}

void onProximityEvent(float v)
{
  light = v;
}