class Treasure {
  PVector pos;
  float speed;
  int type;
  float G;
  
  Treasure (float _posx, float _posy, float _speed, int _type) {
    this.pos = new PVector(_posx, _posy);
    this.speed = _speed;
    this.type = _type;
    this.G = 0.1;
  }
  
  void move() {
    this.speed += this.G;
    this.pos.y += this.speed;
  }
  
  void display(ArrayList<PImage> treasures) {
    image(treasures.get(this.type), this.pos.x, this.pos.y); 
  }
}