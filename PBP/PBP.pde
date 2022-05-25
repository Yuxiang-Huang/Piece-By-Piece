Gunship player;
boolean[] keysPressed; 
ArrayList<Polygon> polygons;
boolean DEBUG = true;

void setup() {
  size(displayWidth, displayHeight);
  player = new Gunship(width/2, height/2);
  // for multi-key presses
  keysPressed = new boolean[4];
  // creating polygons
  polygons = new ArrayList<Polygon>();
  for (int x = 0; x < 9; x++) {
    int rand = (int) random(3);
    if (rand == 0) {
      Polygon now = new Polygon("square");
    }
    if (rand == 1) {
      Polygon now = new Polygon("triangle");
    }
    if (rand == 2) {
      Polygon now = new Polygon("pentagon");
    }
  }
}

void keyPressed() {
  if (key == 'a' || keyCode == LEFT) {
    keysPressed[0] = true;
  }
  if (key == 'w' || keyCode == UP) {
    keysPressed[1] = true;
  } 
  if (key == 'd' || keyCode == RIGHT) {
    keysPressed[2] = true;
  }
  if (key == 's' || keyCode == DOWN) {
    keysPressed[3] = true;
  }
}

void keyReleased() {
  if (key == 'a' || keyCode == LEFT) {
    keysPressed[0] = false;
  }
  if (key == 'w' || keyCode == UP) {
    keysPressed[1] = false;
  }   
  if (key == 'd' || keyCode == RIGHT) {
    keysPressed[2] = false;
  }
  if (key == 's' || keyCode == DOWN) {
    keysPressed[3] = false;
  }
}

void draw() {
  background(255);

  for (Polygon polygon : polygons) {
    if (DEBUG) {
      fill(0);
      text("x: "+polygon.getX() + "; y: "+polygon.getY(), polygon.getX()+10, polygon.getY()-10);
    }
    polygon.display();
  }
  // display & update player last so that it always appears on top 
  // all colisions processed through player
  player.update();
  player.display();
  if (DEBUG) {
    fill(0);
    text("x: "+player.getX() + "; y: "+player.getY(), player.getX()+10, player.getY()-10);
    float mag = 0;
    if (player.velocity.mag() > 0.01) {
      mag = player.velocity.mag();
    }
    text(""+mag, player.getX()+40, player.getY()-40);
  }
}
