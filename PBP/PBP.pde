Gunship player;
Controller input;
ArrayList<Polygon> polygons;
boolean DEBUG = true;
float unit;

void setup() {
  fullScreen();
  //size(displayWidth, displayHeight);
  frameRate(60);
  unit = min(displayWidth/70, displayHeight/35);
  player = new Gunship(width/2, height/2);
  input = new Controller();

  // creating polygons
  polygons = new ArrayList<Polygon>();
  for (int i = 0; i < 10; i++) {
    Polygon polygon = new Polygon();
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

  if (DEBUG) {
    text(frameRate, 20, 20);
  }

  //draw lines
  for (int row = 0; row < height; row+=unit) {
    stroke(100);
    line(0, row, width, row);
  }
  for (int col = 0; col < width; col+=unit) {
    stroke(200);
    line(col, 0, col, height);
  }

  // display & update player last so that it always appears on top 
  // all colisions processed through player
  player.update();
  player.display();



  for (int p = 0; p < polygons.size(); p++) {
    Polygon polygon = polygons.get(p);
    polygon.display();
    polygon.update();
  }
}
