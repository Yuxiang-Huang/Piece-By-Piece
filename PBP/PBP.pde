Gunship player;
Controller input;
ArrayList<Polygon> polygons;
ArrayList<Gunship> enemies;
boolean DEBUG = false;
float unit;

private float MouseX;
private float MouseY;

final int PLAYING = 0;
final int LOST = 1;
final int WON = 2;

private int gameState;

int timeSinceEnemySpawn;

void setup() {
  fullScreen(1);
  frameRate(60);

  width = displayWidth*3;
  height = displayHeight*3;

  setMouseX(0);
  setMouseY(0);

  unit = min(displayWidth/70, displayHeight/35);
  player = new Gunship(width/2, height/2);
  input = new Controller();

  fill(0);
  textSize(unit*3.0/4);
  textAlign(LEFT);

  // creating polygons and enemies
  polygons = new ArrayList<Polygon>();
  enemies = new ArrayList<Gunship>(); // has to be initlized before polygons are made becuase of check in isCollidingWithAnyUMO() in UMO
  for (int i = 0; i < 100; i++) {
    Polygon polygon = new Polygon();
    polygons.add(polygon);
  }

  setGameState(PLAYING);
  setTimeSinceEnemySpawn(600);
}

void keyPressed() {
  input.press(keyCode);
}

void keyReleased() {
  input.release(keyCode);
}

void mouseClicked() {
  if (getGameState() == PLAYING && !player.getAutoFire()) {
    if (player.canShoot()) {
      player.shoot();
    }
  }
}

void mousePressed() {
  if (getGameState() == PLAYING) {
    player.setAutoFire(true);
  }
}

void mouseReleased() {
  if (getGameState() == PLAYING) {
    player.setAutoFire(false);
  }
}

void draw() {
  background(200, 200, 200, 200);

  // to center camera on player
  translate(displayWidth/2 - player.getX(), displayHeight/2 - player.getY());
  // fix mouse coordinates to be absolute rather than relative
  setMouseX((player.getX() - displayWidth/2) + mouseX);
  setMouseY((player.getY() - displayHeight/2) + mouseY);

  // draw border
  fill(255);
  rectMode(CORNERS);
  rect(0, 0, width, height);
  fill(0);

  // draw grid lines
  for (int row = 0; row < height; row+=unit) {
    stroke(100);
    line(0, row, width, row);
  }
  for (int col = 0; col < width; col+=unit) {
    stroke(100);
    line(col, 0, col, height);
  }

  if (DEBUG) {
    fill(0);
    text(frameRate, player.getX() - displayWidth/2 + unit, player.getY() - displayHeight/2 + unit);
  }

  if (getGameState() == PLAYING) {
    if (timeSinceEnemySpawn == 0) {
      Gunship enemy = new Gunship();
      enemies.add(enemy);
      setTimeSinceEnemySpawn(enemies.size() * 600);
    } else {
      setTimeSinceEnemySpawn(getTimeSinceEnemySpawn() - 1);
    }

    for (int p = 0; p < polygons.size(); p++) {
      Polygon polygon = polygons.get(p);
      if (isWithinUpdateDistance(polygon)) { 
        polygon.update();
        if (isWithinDisplayDistance(polygon)) {
          polygon.display();
        }
      }
    }

    for (int e = 0; e < enemies.size(); e++) {
      Gunship enemy = enemies.get(e);
      if (isWithinUpdateDistance(enemy)) { 
        enemy.enemyUpdate();
        if (isWithinDisplayDistance(enemy)) {
          enemy.enemyDisplay();
        }
      }
    }

    textSize(unit*2);
    textAlign(CENTER);
    text("Enemy spawning in " + timeSinceEnemySpawn / 60, player.getX(), player.getY() - displayHeight/2 + 2*unit);
    textAlign(LEFT);
    textSize(unit*3.0/4);    

    // display & update player last so that it always appears on top 
    // all colisions processed through player

    player.playerUpdate();
    player.playerDisplay();

    player.getMinimap().update();
    player.getMinimap().display();

    if (player.getSkillPoints() > 0) {
      player.getShop().display();
    }
  } else {
    for (Polygon polygon : polygons) {
      if (isWithinDisplayDistance(polygon)) {
        polygon.display();
      }
    }
    for (Gunship enemy : enemies) {
      if (isWithinDisplayDistance(enemy)) {
        enemy.enemyDisplay();
      }
    }
    player.getMinimap().display();
    player.playerDisplay();

    // LOST/WON GAME SCREENS

    fill(128, 128, 128, 200);
    rect(player.getX()-(displayWidth/2), player.getY()-(displayHeight/2), displayWidth, displayHeight); 
    fill(0);
    textSize(unit*10);
    textAlign(CENTER);
    String message = "";
    if (getGameState() == LOST) {
      message = "YOU LOST :(";
    } else if (getGameState() == WON) {
      message = "YOU WON :)";
    }
    text(message, player.getX(), player.getY());

    // reset text
    fill(0);
    textSize(unit*3.0/4);
    textAlign(LEFT);
  }
}

boolean isWithinDisplayDistance(UMO umo) {
  return abs(umo.getX()-player.getX()) < (displayWidth/2)+umo.getRadius() &&
    abs(umo.getY()-player.getY()) < (displayHeight/2)+umo.getRadius();
}

boolean isWithinUpdateDistance(UMO umo) {
  return abs(umo.getX()-player.getX()) < (displayWidth)+umo.getRadius() &&
    abs(umo.getY()-player.getY()) < (displayHeight)+umo.getRadius();
}

// get and set methods------------------------------------------------------------------

int getGameState() {
  return gameState;
}
void setGameState(int gameState) {
  this.gameState = gameState;
}

float getMouseX() {
  return this.MouseX;
}
void setMouseX(float MouseX) {
  this.MouseX = MouseX;
}

float getMouseY() {
  return MouseY;
}
void setMouseY(float MouseY) {
  this.MouseY = MouseY;
}

int getTimeSinceEnemySpawn() {
  return timeSinceEnemySpawn;
}
void setTimeSinceEnemySpawn(int timeSinceEnemySpawn) {
  this.timeSinceEnemySpawn = timeSinceEnemySpawn;
}
