class Minimap implements Processable {
  PVector position;
  float l, h;

  Minimap() {
    this.position = new PVector(player.getX()+(displayWidth/2)-unit, player.getY()+(displayHeight/2)-unit);
    this.l = unit*15;
    this.h = unit*15*((float)displayHeight/displayWidth);
  }

  void update() {
    position.set(player.getX()+(displayWidth/2)-unit, player.getY()+(displayHeight/2)-unit);
  }

  void display() {
    float x, y;
    fill(255, 200);
    rectMode(CORNERS);
    rect(position.x, position.y, position.x - l, position.y - h);
    fill(0, 255, 0);
    x = (position.x - l) + l*(player.getX()/width);
    y = (position.y - h) + h*(player.getY()/height);
    circle(x, y, 5);
    for (EnemyGunship enemy : enemies) {
      x = (position.x - l) + l*(enemy.getX()/width);
      y = (position.y - h) + h*(enemy.getY()/height);
      fill(255, 0, 0);
      circle(x, y, 5);
    }
    if (boss != null) {
      x = (position.x - l) + l*(boss.getX()/width);
      y = (position.y - h) + h*(boss.getY()/height);
      fill(255,192,203);
      circle(x, y, 5);
    }
  }
} 
