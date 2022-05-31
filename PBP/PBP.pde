Player player;
Controller input;
ArrayList<Polygon> polygons;
boolean DEBUG = false;
float unit;
PVector pos = new PVector(0, 0);

final int PLAYING = 0;
final int LOST = 1;
final int WON = 2;

private int gameState;

void setup() {
  fullScreen(1);
  frameRate(60);

  fill(0);
  textSize(15);
  textAlign(LEFT);

  unit = min(displayWidth/70, displayHeight/35);
  player = new Player(width/2, height/2);
  input = new Controller();

  fill(0);
  textSize(unit*3.0/4);
  textAlign(LEFT);

  // creating polygons
  polygons = new ArrayList<Polygon>();
  for (int i = 0; i < 10; i++) {
    Polygon polygon = new Polygon();
  }

  // creating enemies


  setGameState(PLAYING);
}

void keyPressed() {
  if (getGameState() == PLAYING) {
    input.press(keyCode);
  }
}

void keyReleased() {
  if (getGameState() == PLAYING) {
    input.release(keyCode);
  }
}

void mouseClicked() {
  if (getGameState() == PLAYING) {
    if (player.canShoot()) {
      player.shoot();
    }
  }
}

void mousePressed() {}

void draw() {
  background(255);

  if (DEBUG) {
    text(frameRate, unit, unit);
  }

  //draw lines
  for (int row = 0; row < height; row+=unit) {
    stroke(100);
    line(0, row, width, row);
  }
  for (int col = 0; col < width; col+=unit) {
    stroke(100);
    line(col, 0, col, height);
  }

  if (getGameState() == PLAYING) {
    //pushMatrix();
    //translate(pos.x, pos.y);
    for (int p = 0; p < polygons.size(); p++) {
      Polygon polygon = polygons.get(p);
      polygon.display();
      polygon.update();
    }

    // display & update player last so that it always appears on top 
    // all colisions processed through player
    player.update();
    if (player.getHealth() == 0) {
      setGameState(LOST);
    } else if (player.getLevel() == 15) {
      setGameState(WON);
    }
    //popMatrix();
    player.display();
    if (player.getSkillPoints() > 0) {
      player.getShop().display();
    }
  } else {
    for (Polygon polygon : polygons) {
      polygon.display();
    }
    player.display();

    // LOST/WON GAME SCREENS

    fill(128, 128, 128, 200);
    rect(0, 0, width, height); 
    fill(0);
    textSize(unit * 10);
    textAlign(CENTER);
    if (getGameState() == LOST) {
      text("YOU LOST :(", width/2, height/2);
    } else if (getGameState() == WON) {
      text("YOU WON :)", width/2, height/2);
    }
    fill(0);
    textSize(unit*3.0/4);
    textAlign(LEFT);
  }
}

int getGameState() {
  return gameState;
}
void setGameState(int gameState) {
  this.gameState = gameState;
}
