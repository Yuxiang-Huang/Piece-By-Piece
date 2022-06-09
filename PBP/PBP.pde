Gunship player;
Gunship boss;
Controller input;
ArrayList<Polygon> polygons;
ArrayList<Gunship> enemies;
boolean DEBUG = false;
float unit;

private float MouseX;
private float MouseY;

final int INTRO = -2;
final int INFO = -1;
final int PLAYING = 0;
final int PAUSED = 1;
final int LOST = 2;
final int WON = 3;

private int gameState;
GameScreen GameScreen = new GameScreen();

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

  GameScreen.resetText();

  // creating polygons and enemies
  polygons = new ArrayList<Polygon>();
  enemies = new ArrayList<Gunship>(); // has to be initlized before polygons are made becuase of check in isCollidingWithAnyUMO() in UMO

  for (int i = 0; i < (((width/unit)*(height/unit)*.2)/(unit*1.77)); i++) { // ~20% of screen should be polygons
    Polygon polygon = new Polygon();
    polygons.add(polygon);
  }

  //please don't delete just comment
  //for (int i = 0; i < 10; i++) {
  //  Gunship enemy = new Gunship();
  //  enemies.add(enemy);
  //}

  setGameState(INTRO);
  setTimeSinceEnemySpawn(600);
  //cheat
  //setTimeSinceEnemySpawn(60000);
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
  // fix mouse coordinates to be absolute rather than relative //<>//
  setMouseX((player.getX() - displayWidth/2) + mouseX); //<>//
  setMouseY((player.getY() - displayHeight/2) + mouseY);

  if (getGameState() == INTRO) {
    GameScreen.displayIntro();
  } else if (getGameState() == INFO) {
    GameScreen.displayInfo();
  } else {
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
      if (getTimeSinceEnemySpawn() <= 0 && boss == null) {
        spawnAnEnemy();
        setTimeSinceEnemySpawn(enemies.size() * 600);
      } else if (boss == null) {
        setTimeSinceEnemySpawn(getTimeSinceEnemySpawn() - 1);
      }

      updateAllPolygons();
      displayAllPolygons();
      updateAllEnemies();
      displayAllEnemies();

      GameScreen.mediumText(CENTER);
      if (boss == null) {
        text("Enemy spawning in " + timeSinceEnemySpawn / 60, player.getX(), player.getY() - displayHeight/2 + 2*unit);
      }
      GameScreen.resetText();   


      // display time till next enemy spawn
      textSize(unit*2);
      textAlign(CENTER);
      text("Enemy spawning in " + timeSinceEnemySpawn / 60, player.getX(), player.getY() - displayHeight/2 + 2*unit);
      GameScreen.resetText();  

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
      displayAllPolygons();
      displayAllEnemies();
      player.getMinimap().display();
      player.playerDisplay();

      textSize(unit*2);
      textAlign(CENTER);
      text("Enemy spawning in " + timeSinceEnemySpawn / 60, player.getX(), player.getY() - displayHeight/2 + 2*unit);
      GameScreen.resetText(); 

      // PAUSED/LOST/WON GAME SCREENS
      if (getGameState() == PAUSED) {
        GameScreen.displayPaused();
      } else if (getGameState() == LOST) {
        GameScreen.displayLost();
      } else if (getGameState() == WON) {
        GameScreen.displayWon();
      }
    }
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


void updateAllPolygons() {
  for (int p = 0; p < polygons.size(); p++) {
    Polygon polygon = polygons.get(p);
    if (isWithinUpdateDistance(polygon)) { 
      polygon.update();
    }
  }
}
void displayAllPolygons() {
  for (int p = 0; p < polygons.size(); p++) {
    Polygon polygon = polygons.get(p);
    if (isWithinDisplayDistance(polygon)) {
      polygon.display();
    }
  }
}

void updateAllEnemies() {
  for (int e = 0; e < enemies.size(); e++) {
    Gunship enemy = enemies.get(e);
    if (isWithinUpdateDistance(enemy)) { 
      enemy.enemyUpdate();
    }
  }
}
void displayAllEnemies() {
  for (int e = 0; e < enemies.size(); e++) {
    Gunship enemy = enemies.get(e);
    if (isWithinDisplayDistance(enemy)) {
      enemy.enemyDisplay();
    }
  }
}

void spawnAnEnemy() {
  int levelHolder = player.getLevel() + (int) random(7) - 3;
  if (levelHolder < 15) {
    if (levelHolder < 1) {
      levelHolder = 1;
    }
    Gunship enemy = new Gunship(levelHolder);
    enemies.add(enemy);
  }
  if (levelHolder > 15 ) {//& levelHolder < 30) {
    int rand = (int) random(4);
    Gunship enemy;
    switch (rand) {
    case 0: 
      enemy = new Twin(levelHolder);
      enemies.add(enemy); 
      break;
    case 1: 
      enemy = new Sniper(levelHolder);
      enemies.add(enemy);
      break;
    case 2: 
      enemy = new MachineGun(levelHolder);
      enemies.add(enemy);
      break;
    case 3: 
      enemy = new FlankGuard(levelHolder);
      enemies.add(enemy);
      break;
    }
  }
  //if (levelHolder > 30) {

  //}
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
