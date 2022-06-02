class Minimap implements Processable {
  Gunship gunship;
  PVector position;
  float l, h;

  Minimap(Gunship gunship) {
    this.gunship = gunship;
    this.position = new PVector(gunship.getX()+(displayWidth/2)-unit, gunship.getY()+(displayHeight/2)-unit);
    this.l = unit*15;
    this.h = unit*15*((float)displayHeight/displayWidth);
  }

  void update() {
    position.set(gunship.getX()+(displayWidth/2)-unit, gunship.getY()+(displayHeight/2)-unit);
  }

  void display() {
    float x, y;
    fill(255, 200);
    rectMode(CORNERS);
    rect(position.x, position.y, position.x - l, position.y - h);
    fill(0, 255, 0);
    x = (position.x - l) + l*((float)gunship.getX()/width);
    y = (position.y - h) + h*((float)gunship.getY()/height);
    circle(x, y, 5);
    for (Gunship enemy : enemies) {
      x = (position.x - l) + l*((float)enemy.getX()/width);
      y = (position.y - h) + h*((float)enemy.getY()/height);
      fill(255, 0, 0);
      circle(x, y, 5);
    }
  }
} 
