import processing.sound.*;
import oscP5.*;
OscP5 oscP5;

PVector posePosition;
float mouthHeight;
float mouthWidth;
boolean found;

ArrayList<PImage> catcherImgs = new ArrayList<PImage>();
ArrayList<PImage> treasureImgs = new ArrayList<PImage>();
SoundFile boom;
SoundFile cash;

boolean active = false;
int startingPoint;
int counter = 0;
int score = 0;
Catcher catcher;
ArrayList<Treasure> treasures = new ArrayList<Treasure>();

void setup() {
  size(1600, 900);
  imageMode(CENTER);
  
  catcherImgs.add(loadImage("close.png"));
  catcherImgs.add(loadImage("open.png"));
  treasureImgs.add(loadImage("coin.png"));
  treasureImgs.add(loadImage("sack.png"));
  treasureImgs.add(loadImage("box.png"));
  treasureImgs.add(loadImage("bomb.png"));
  boom = new SoundFile(this, "boom.wav");
  cash = new SoundFile(this, "cash.wav");
  
  posePosition = new PVector();
  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "posePosition", "/pose/position");
  oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
  oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
  oscP5.plug(this, "found", "/found");
  
  catcher = new Catcher(800, 180, 420, 100, 1500);
}


void draw() {
  background(255);
  if (!active){
    fill(0);
    textSize(36);
    text("Move your HEAD to move the bag, open your MOUTH before catch", 200, 400);
    text("***Open your mouth to start***", 480, 500);
    if (mouthHeight > 3) {
      active = true;
      startingPoint = millis();
    }
    return;
  }
  board(timeCompute(millis() - startingPoint), scoreCompute(score));
  
  if (millis() - counter > 1000) {
    float decision = random(0, 100);
    if      (decision > 85) treasures.add(new Treasure(random(200, 1400), -100, random(6, 8), 2));
    else if (decision > 55) treasures.add(new Treasure(random(200, 1400), -100, random(4, 6), 1));
    else                    treasures.add(new Treasure(random(200, 1400), -100, random(3, 4), 0));
    treasures.add(new Treasure(random(200, 1400), -100, random(4, 8), 3));
    
    counter = millis();
  }
  
  if (found) catcher.update(posePosition, mouthHeight);
  catcher.display(catcherImgs);
  
  for (int i = treasures.size() - 1; i >= 0; i--) {
    Treasure curr = treasures.get(i);
    if (catcher.collide(curr, cash, boom)) {
      if      (curr.type == 0) score += 10;
      else if (curr.type == 1) score += 20;
      else if (curr.type == 2) score += 50;
      else                     score -= 100;
      treasures.remove(i);
    }
    else if (curr.pos.y > 1000) {
      treasures.remove(i);
    }
    else {
      curr.move();
      curr.display(treasureImgs);
    }
  }
}


public void mouthWidthReceived(float w) {
  //println("mouth Width: " + w);
  mouthWidth = w;
}

public void mouthHeightReceived(float h) {
  //println("mouth height: " + h);
  mouthHeight = h;
}

public void posePosition(float x, float y) {
  //println("pose position\tX: " + x + " Y: " + y );
  posePosition.x = x;
  posePosition.y = y;
}

public void found(int i) {
  //println("found: " + i); // 1 == found, 0 == not found
  found = i == 1;
}

String timeCompute(int ms) {
  int second = ms / 1000;
  int minute = second / 60;
  second = second % 60;
  return "TIME:" + 
         (minute > 9 ? str(minute) : "0" + str(minute)) + 
         ":" + 
         (second > 9 ? str(second) : "0" + str(second));
}

String scoreCompute(int score) {
  return "SCORE:" + score;
}

void board(String timeStr, String scoreStr) {
  textSize(18);
  fill(0);
  text(timeStr, 20, 50);
  text(scoreStr, 20, 100);
}