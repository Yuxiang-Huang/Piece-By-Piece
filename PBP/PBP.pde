Gunship player;
Controller input;
ArrayList<Polygon> polygons;
boolean DEBUG = true;
float unit;

void setup() {
  size(displayWidth, displayHeight);
  frameRate(60);
  unit = min(displayWidth/70, displayHeight/35);
  player = new Gunship(width/2, height/2);
  input = new Controller();

  // creating polygons
  polygons = new ArrayList<Polygon>();
  for (int i = 0; i < 10; i++) {
    float rand = random(1);
    if (rand < .5) { // 50%
      Polygon now = new Polygon("square");
    } else if (rand < .83) { // 33%
      Polygon now = new Polygon("triangle");
    } else { // 17%
      Polygon now = new Polygon("pentagon");
    }
  }
}

void keyPressed() {
  input.press(keyCode);
}

void keyReleased() {
  input.release(keyCode);
}

void mouseClicked() {
  if (player.canShoot()) {
    player.shoot();
  }
}

void draw() {
  background(255);

  //draw lines
  for (int row = 0; row < height; row+=unit) {
    stroke(100);
    line(0, row, width, row);
  }
  for (int col = 0; col < width; col+=unit) {
    stroke(200);
    line(col, 0, col, height);
  }

  for (Polygon polygon : polygons) {
    polygon.display();
    polygon.update();

    if (DEBUG) {
      fill(0);
      text("x: "+round(polygon.getX()) + "; y: "+round(polygon.getY()), polygon.getX()+40, polygon.getY()-40);
      text("dx: "+polygon.getDX() + "; dy: "+polygon.getDY(), polygon.getX()+40, polygon.getY()-20);
    }
  }

  // display & update player last so that it always appears on top 
  // all colisions processed through player
  player.update();
  player.display();

  if (DEBUG) {
    fill(0);
    text("x: "+round(player.getX()) + "; y: "+round(player.getY()), player.getX()+40, player.getY()-40);
    text("dx: "+player.getDX() + "; dy: "+player.getDY(), player.getX()+40, player.getY()-20);
    float mag = 0;
    if (player.velocity.mag() > 0.01) {
      mag = player.velocity.mag();
    }
    text("mag: "+mag, player.getX()+40, player.getY());
    text("countdown: "+player.getCountdown(), player.getX()+40, player.getY()+20);

    text(frameRate, 20, 20);
  }
}
