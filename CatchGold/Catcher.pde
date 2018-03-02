class Catcher {
  PVector pos;
  int state;
  float inputMin, inputMax;
  float outputMin, outputMax;
  
  Catcher(float _posY, float _inputMin, float _inputMax, float _outputMin, float _outputMax) {
    this.pos = new PVector(0, _posY);
    this.inputMin = _inputMin;
    this.inputMax = _inputMax;
    this.outputMin = _outputMin;
    this.outputMax = _outputMax;
    this.state = 0;
  }
  
  boolean collide(Treasure that, SoundFile cash, SoundFile boom) {
    if (this.state == 0) return false;
    if (abs(this.pos.x - that.pos.x) < 100 && abs(this.pos.y - that.pos.y) < 175) {
      if (that.type == 3) boom.play();
      else                cash.play();
      return true;
    }      
    return false;
  }
  
  void update(PVector position, float trigger) {
     float x = constrain(position.x, this.inputMin, this.inputMax);
     x = map(x, this.inputMin, this.inputMax, this.outputMax, this.outputMin);
     this.pos.x = x;
     
     if (trigger > 3) this.state = 1;
     else             this.state = 0;
  }

  void display(ArrayList<PImage> images) {
    image(images.get(this.state), this.pos.x, this.pos.y);
  }
}