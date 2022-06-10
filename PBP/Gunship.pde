class Gunship extends UMO {
  private Shop shop;
  private Minimap minimap; 
  private int level;
  private int skillPoints;
  private int numberOfEvolutions;

  private int reloadSpeed;
  private float shootCooldown;

  private float angle;
  private ArrayList<Gun> guns;
  private float spread;

  private int healthRegen;
  private int timeSinceLastHit;
  private float heal10percent;
  private int collisionDamageWithShip;

  private boolean autoFire;
  private boolean autoRotate;
  private boolean suicidal;
  private int invincible;
  private String type;

  private String recoilMode = "";
  
  //error?
  Gunship(){
  }
  
  // player constructor
  Gunship(float x, float y, int level) {
    setRadius(unit);
    position.set(x, y);
    setAngle(0);
    acceleration.set(unit*.025, unit*.025);

    setNumberOfEvolutions(4);
    setShop(new Shop(this));
    setMinimap(new Minimap(this));

    // set stats base on level
    setLevel(level);
    shop.maxHealth.base = 50 + 2*(getLevel() - 1);
    setRadius(unit * pow(1.01, getLevel()-1));

    acceleration.mult(pow(0.985, (getLevel() - 1))); //confirmed from website
    setSkillPoints(getLevel() - 1);

    getShop().update();
    setHealth(getMaxHealth());

    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    setShootCooldown(0);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    body.setFill(color(1, 178, 225));
    rectMode(CORNER);
    PShape gun = createShape(RECT, -unit/3, 0, 2*unit/3, 1.5*unit);
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);

    setSpread(.03*getShop().getReload().getLevel()); // bullet spread scales with reload speed 
    setTimeSinceLastHit(0);
  }


  // enemy constructor
  Gunship(int levelHolder) {
    setRadius(unit * pow(1.01, getLevel()-1)); //confirmed from wiki
    position.set(random(width), random(height));
    while (isCollidingWithAnyUMOSpawning()) { // cant spawn ship on top of UMO or too close to player
      setX(random(width));
      setY(random(height));
    }
    setAngle(0);
    acceleration.set(unit*.01, unit*.01);
    setInvincible(60);

    setLevel(levelHolder);

    setShop(new Shop(this));

    // set stats base on level
    getShop().maxHealth.base = 50 + 2*(getLevel() - 1);
    setRadius(unit * pow(1.01, getLevel() - 1)); //confirmed from wiki  
    acceleration.mult(pow(0.985, (getLevel() - 1))); //confirmed from website
    setSkillPoints(getLevel() - 1);

    shop.randomUpgrade();
    //compare gun stats to gunship stats to determine if suicidal
    if (getShop().getHealthRegen().getLevel() + getShop().getMaxHealth().getLevel() + 
      getShop().getBodyDamage().getLevel() + getShop().getMovementSpeed().getLevel() > 
      getShop().getBulletSpeed().getLevel() + getShop().getBulletPenetration().getLevel() +
      getShop().getBulletDamage().getLevel() + getShop().getReload().getLevel()) {
      setSuicidal(true);
    }

    getShop().update();
    setHealth(getMaxHealth());

    guns = new ArrayList<Gun>();
    guns.add(new Gun(this, 0));
    setShootCooldown(0);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    int rand = (int) (random(3));
    if (rand == 0) {
      setType("straight");
      body.setFill(color(0, 255, 0));
    } else if (rand == 1) {
      setType("random");
      //cyan
      body.setFill(color(0, 255, 255));
    } else {
      setType("predict");
      //magenta
      body.setFill(color(255, 0, 255));
    }
    rectMode(CORNER);
    PShape gun = createShape(RECT, -unit/3, 0, 2*unit/3, 1.5*unit);
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);

    setTimeSinceLastHit(0);
  }

  void playerDisplay() {
    //rotate
    pushMatrix();
    translate(getX(), getY());
    rotate(getAngle()-HALF_PI); // dont know why HALF_PI is necesassary. But if not present, rotation is of by 90 degrees.
    scale(getRadius()/unit);
    if (getInvincible() > 1) {
      if (getInvincible() % 2 == 0) {
        shape(umo, 0, 0);
      } else {
        //umo.setFill(color(255));
        //shape(umo, 0, 0);
        //umo.setFill(color(165, 42, 42));
      }
    } else {
      shape(umo, 0, 0);
    }
    popMatrix();

    if (getHealth() != getMaxHealth()) {
      displayHealthBar();
    }

    displayExpBar();
    if (canEvolve()) {
      displayEvolutions();
    }

    if (DEBUG) {
      text(""+getHealth(), getX() - unit, getY());
      text("x: "+round(getX()) + "; y: "+round(getY()), getX()+unit*2, getY()-unit*2);
      text("dx: "+round(getDX()) + "; dy: "+round(getDY()), getX()+unit*2, getY()-unit);
      text("mag: "+round(velocity.mag()), getX()+unit*2, getY());
      text("shootCooldown: "+getShootCooldown(), getX()+unit*2, getY()+unit);
      text("Level: "+getLevel() + "; Exp: "+getExp() + "; SP: "+getSkillPoints(), getX()+unit*2, getY()+unit*2);
      text("timeSinceLastHit: "+getTimeSinceLastHit(), getX()+unit*2, getY()+unit*3);
      text("maxHealth: "+getMaxHealth(), getX()+unit*2, getY()+unit*4);
      text("collisionDamage: "+getCollisionDamage(), getX()+unit*2, getY()+unit*5);
      text("AutoFire: "+getAutoFire() + "; AutoRotate: "+getAutoRotate(), getX()+unit*2, getY()+unit*6);
      text("Invincible: "+getInvincible(), getX()+unit*2, getY()+unit*7);
      text("radius: "+getRadius(), getX()+unit*2, getY()+unit*8);
    }
  }

  void enemyDisplay() {
    pushMatrix();
    translate(getX(), getY());
    rotate(getAngle()-HALF_PI); // dont know why HALF_PI is necesassary. But if not present, rotation is of by 90 degrees.
    scale(getRadius()/unit);
    if (getInvincible() > 1) {
      if (getInvincible() % 2 == 0) {
        shape(umo, 0, 0);
      } else {
        //umo.setFill(color(255));
        //shape(umo, 0, 0);
        //umo.setFill(color(165, 42, 42));
      }
    } else {
      shape(umo, 0, 0);
    }
    popMatrix();
    if (!DEBUG) {
      if (getType().equals("straight")) {
        text("S", getX(), getY());
      } else if (getType().equals("random")) {
        text("R", getX(), getY());
      } else if (getType().equals("predict")) {
        text("P", getX(), getY());
      } else if (getType().equals("escape")){
        text("E", getX(), getY());
      } else{
        text("G", getX(), getY());
      }
    }

    if (getHealth() != getMaxHealth()) {
      displayHealthBar();
    }

    if (DEBUG && getX() - player.getX() < displayWidth / 2 && getY() - player.getY() < displayHeight / 2 ) {
      text(""+getHealth(), getX() - unit, getY());
      text("x: "+round(getX()) + "; y: "+round(getY()), getX()+unit*2, getY()-unit*2);
      text("dx: "+round(getDX()) + "; dy: "+round(getDY()), getX()+unit*2, getY()-unit);
      text("mag: "+round(velocity.mag()), getX()+unit*2, getY());
      text("shootCooldown: "+getShootCooldown(), getX()+unit*2, getY()+unit);
      text("Level: "+getLevel() + "; Exp: "+getExp(), getX()+unit*2, getY()+unit*2);
      text("timeSinceLastHit: "+getTimeSinceLastHit(), getX()+unit*2, getY()+unit*3);
      text("maxHealth: "+getMaxHealth(), getX()+unit*2, getY()+unit*4);
      text("collisionDamage: "+getCollisionDamage(), getX()+unit*2, getY()+unit*5);
      text("Invincible: "+getInvincible(), getX()+unit*2, getY()+unit*6);
      text("radius: "+getRadius(), getX()+unit*2, getY()+unit*7);
      text("regen points: "+getShop().getHealthRegen().getLevel(), getX()+unit*2, getY()+unit*8);
    }
  }


  /**
   Loops over all bullets, updates and displays them,
   Decrements shoot cooldown by 1,
   Levels up if it has enough exp,
   Regens health,
   Decrments hit cooldown by 1,
   Dies if health is at 0,
   Applies acceleration from Controller, velocity, and friction
   checks for collisions with Polygons and Borders
   */
  void playerUpdate() {
    if (getInvincible() > 0) {
      setInvincible(getInvincible() - 1);
    }

    // check for what directions are being pressed
    float xdir = 0;
    float ydir = 0;
    if (input.inputs[0]) { // LEFT
      xdir = -1;
    }
    if (input.inputs[1]) { // UP
      ydir = -1;
    }
    if (input.inputs[2]) { // RIGHT
      xdir = 1;
    }
    if (input.inputs[3]) { // DOWN
      ydir = 1;
    }

    PVector accelerationNow = new PVector(acceleration.x*xdir, acceleration.y*ydir);
    //apply acceleration
    if (xdir != 0 && ydir != 0) {
      accelerationNow.mult(1.0/sqrt(2));
    }
    velocity.add(accelerationNow);

    //don't fly
    if (velocity.mag() > unit/2) {
      velocity.setMag(unit/2);
    }

    // apply velocity
    position.add(velocity);

    // apply friction
    velocity.mult(getFriction());

    if (getAutoRotate()) {
      autoRotate();
    } else {
      setAngle(getAngleToMouse());
    } 

    if (getAutoFire()) {
      autoFire();
    }
    // update all guns
    for (Gun gun : guns) {
      gun.update();
    }

    // decrement shoot cooldown by 1
    if (getShootCooldown() > 0) {
      setShootCooldown(getShootCooldown()-1);
    }

    // check if player has enough exp for level up
    if (getExp() >= getExpRequiredForNextLevel() && player.getLevel() < 30) {
      setExp(getExp()-getExpRequiredForNextLevel());
      setLevel(getLevel()+1);
      setSkillPoints(getSkillPoints()+1);
      //increase stats upon level up
      getShop().maxHealth.base += 2;
      setRadius(unit * pow(1.01, getLevel()-1)); //confirmed from wiki
      acceleration.mult(0.985); //confirmed from website
      getShop().update(); // to update maxHealth;
    }   

    heal();

    // check for collisions
    collisionWithBorder();
    collisionWithUMO();

    if (getTimeSinceLastHit() > 0) {
      setTimeSinceLastHit(getTimeSinceLastHit() - 1);
    }

    if (int(getHealth()) == 0) {
      playerDie();
    }

    if (player.getHealth() == 0) {
      setGameState(LOST);
    }
  }

  void enemyUpdate() {
    if (getInvincible() > 0) {
      setInvincible(getInvincible() - 1);
    }

    //in shooting distance, 90 is just a random number I chose for now after few testing
    if (isSuicidal() || dist(getX(), getY(), player.getX(), player.getY()) < 
      (getShop().getBulletSpeed().getBase() + (getShop().getBulletSpeed().getModifier()*getShop().getBulletSpeed().getLevel())) * 90) {
      autoFire();
    }
    // update and display all guns
    for (Gun gun : guns) {
      gun.update();
    }

    // decrement shoot cooldown by 1
    if (getShootCooldown() > 0) {
      setShootCooldown(getShootCooldown()-1);
    }

    // check if enemy has enough exp for level up
    if (getExp() >= getExpRequiredForNextLevel()) {
      setExp(getExp()-getExpRequiredForNextLevel());
      setLevel(getLevel()+1);
      setSkillPoints(getSkillPoints()+1);
      //increase stats upon level up
      getShop().maxHealth.base += 2;
      setRadius(unit * pow(1.01, getLevel()-1)); //confirmed from wiki
      acceleration.mult(0.985); //confirmed from website
      getShop().update(); // to update maxHealth;
      shop.randomUpgrade();
      //update suicidal
      if (getShop().getHealthRegen().getLevel() + getShop().getMaxHealth().getLevel() + 
        getShop().getBodyDamage().getLevel() + getShop().getMovementSpeed().getLevel() > 
        getShop().getBulletSpeed().getLevel() + getShop().getBulletPenetration().getLevel() +
        getShop().getBulletDamage().getLevel() + getShop().getReload().getLevel()) {
        setSuicidal(true);
      } else {
        setSuicidal(false);
      }
    }   

    heal();

    if (getTimeSinceLastHit() > 0) {
      setTimeSinceLastHit(getTimeSinceLastHit() - 1);
    }

    //should be in UMO.update
    if (int(getHealth()) == 0) {
      enemyDie();
    }

    //botMove
    if (!getType().equals("predict") && !getType().equals("escape")) {
      //stratight at the player
      PVector accelerationNow = new PVector(acceleration.x*(player.getX() - getX()), acceleration.y*(player.getY() - getY()));
      accelerationNow.setMag(mag(acceleration.x, acceleration.y));
      if (accelerationNow.x != 0 && accelerationNow.y != 0) {
        accelerationNow.mult(1.0/sqrt(2));
      }
      velocity.add(accelerationNow);

      if (getType().equals("random")) {
        //randomness
        float speedNow = velocity.mag();
        velocity.add((random(15) - random(15)) * velocity.x/15, (random(15) - random(15)) * velocity.y/15);
        velocity.setMag(speedNow);
      } else if (getType().equals("ghost")){
        velocity.add((random(30) - random(30)) * velocity.x/30, (random(30) - random(30)) * velocity.y/30);
        velocity.setMag(acceleration.x * 9);
      }
    } else if (getType().equals("predict")) {
      //move toward the player's position after 1 sec
      PVector accelerationNow = new PVector(acceleration.x*(player.getX() + player.getDX() * 60 - getX()), acceleration.y*(player.getY() + player.getDY() * 60 - getY()));
      accelerationNow.setMag(mag(acceleration.x, acceleration.y));
      if (accelerationNow.x != 0 && accelerationNow.y != 0) {
        accelerationNow.mult(1.0/sqrt(2));
      }
      velocity.add(accelerationNow);
    } else {
      //move in reciprocal to escape
      PVector accelerationNow = new PVector(max(1, abs(acceleration.x*player.getDY())), max(1, abs(acceleration.y* player.getDX())));
      if (player.getX() > getX()) {
        accelerationNow.x *= -1;
      } 
      if (player.getY() > getY()) {
        accelerationNow.y *= -1;
      }
      accelerationNow.setMag(mag(acceleration.x, acceleration.y));
      if (accelerationNow.x != 0 && accelerationNow.y != 0) {
        accelerationNow.mult(1.0/sqrt(2));
      }
      velocity.add(accelerationNow);
    }

    //don't fly
    if (velocity.mag() > unit/2) {
      velocity.setMag(unit/2);
    }

    // apply velocity
    position.add(velocity);

    // apply friction
    velocity.mult(getFriction());

    float angle = 0;
    if (this != boss) {
      if (getType().equals("predict")) {
        //shoot at the direction player is moving in
        angle = atan2((player.getY() + player.getDY() * 60 - getY()), (player.getX() + player.getDX() * 60 - getX()));
      } else {
        //straight at player  
        angle = atan2((player.getY() - getY()), (player.getX() - getX()));
        if (angle < 0) {
          angle = TWO_PI + angle;
        }

        //randomize facing angle
        if (getType().equals("random") || getType().equals("ghost")) {
          angle += (random(1) - random(1)) * PI/16;
        }
      }
    } else {
      autoRotate();
    }

    //rotate toward gunship if more stats on bullet, else use bullet to accelerate
    if (this != boss) {
      if (isSuicidal()) {
        setAngle(angle + PI);
      } else {
        setAngle(angle);
      }
    }

    // check for collisions
    collisionWithBorder();
    collisionWithUMO();
  }

  void die() {
  } // need to have becuase Gunship extends UMO

  void playerDie() {
    setGameState(LOST);
  }  

  void enemyDie() {
    enemies.remove(this);
    setTimeSinceEnemySpawn(getTimeSinceEnemySpawn() - 600);
    if (getTimeSinceEnemySpawn() < 0) {
      setTimeSinceEnemySpawn(0);
    }
  }

  /**
   Loops over all Polygons and if currently colliding with one, applies its damage and force to it
   */
  void collisionWithUMO() {
    for (int p = 0; p < polygons.size(); p++) {
      Polygon polygon = polygons.get(p);
      if (isCollidingWithPolygon(polygon)) {
        //trust physics
        float m1 = pow(getRadius(), 3);
        float m2 = pow(polygon.getRadius(), 3);

        float dxHolder = (2*m1*getDX() + (m2-m1) * polygon.getDX()) / (float)(m1 + m2);
        float dyHolder = (2*m1*getDY() + (m2-m1) * polygon.getDY()) / (float)(m1 + m2);
        //only defy physics for pentagon
        if (polygon.getShape().equals("pentagon")) {
          setDX(3*(2*m2*polygon.getDX() + (m1-m2) * getDX()) / (m1 + m2));
          setDY(3*(2*m2*polygon.getDY() + (m1-m2) * getDY()) / (float)(m1 + m2));
        } else {
          setDX((2*m2*polygon.getDX() + (m1-m2) * getDX()) / (m1 + m2));
          setDY((2*m2*polygon.getDY() + (m1-m2) * getDY()) / (float)(m1 + m2));
        }
        polygon.velocity.set(dxHolder, dyHolder);

        //only do damage part if not invincible
        if (getInvincible() == 0) {
          if (polygon.getHealth() >  polygon.getCollisionDamage()) {
            setHealth(getHealth() - polygon.getCollisionDamage());
          } else {
            setHealth(getHealth() - polygon.getHealth());
          }
          polygon.setHealth(polygon.getHealth() - getCollisionDamage());
        }

        if (polygon.isDead()) {
          setExp(getExp() + polygon.getExp()); // Fixed: shouldn't always give it to the player
        }
        //for health regen after 30 sec
        setTimeSinceLastHit(1800);
        return;
      }
    }

    if (this != player) {
      //check for collision with player
      if (dist(getX(), getY(), player.getX(), player.getY()) < getRadius() + player.getRadius()) {
        float m1 = unit;
        float m2 = unit;
        float dxHolder = (2*m1*getDX() + (m2-m1) * player.getDX()) / (float)(m1 + m2);
        float dyHolder = (2*m1*getDY() + (m2-m1) * player.getDY()) / (float)(m1 + m2);
        velocity.add(-1*(2*m2*player.getDX() + (m1-m2) * getDX()) / (m1 + m2), -1*(2*m2*player.getDY() + (m1-m2) * getDY()) / (float)(m1 + m2));
        player.velocity.add(dxHolder, dyHolder);

        //only do damage part if not invincible
        if (getInvincible() == 0 && player.getInvincible() == 0) {
          if (getHealth() >  getCollisionDamage()) {
            player.setHealth(player.getHealth() - getCollisionDamageWithShip());
          } else {
            player.setHealth(player.getHealth() - getHealth());
          }
          setHealth(getHealth() - player.getCollisionDamageWithShip());
          if (isDead()) {
            player.setExp(player.getExp() + getLevel() * (getLevel() - 1) * 10 / 2) ; 
            //half of total enemy exp, trust math
          }
          //1 sec?
          setInvincible(30);
          player.setInvincible(30);
        }
      }
      //check for collision with enemies
      for (Gunship enemy : enemies) {
        if (enemy != this) {
          if (dist(getX(), getY(), enemy.getX(), enemy.getY()) < getRadius() + enemy.getRadius()) {
            float m1 = unit;
            float m2 = unit;
            float dxHolder = (2*m1*getDX() + (m2-m1) * enemy.getDX()) / (float)(m1 + m2);
            float dyHolder = (2*m1*getDY() + (m2-m1) * enemy.getDY()) / (float)(m1 + m2);
            velocity.add(-1*(2*m2*enemy.getDX() + (m1-m2) * getDX()) / (m1 + m2), -1*(2*m2*enemy.getDY() + (m1-m2) * getDY()) / (float)(m1 + m2));
            enemy.velocity.add(dxHolder, dyHolder);
          }
        }
      }
    }
  }

  float getAngleToMouse() {
    float angle = atan2(getMouseY()-getY(), getMouseX()-getX());
    if (angle < 0) {
      angle = TWO_PI + angle;
    }
    return angle;
  }

  boolean canShoot() {
    return (getShootCooldown() == 0);
  }

  void shoot() {
    setShootCooldown(getReloadSpeed());
    for (Gun gun : guns) {
      gun.shoot();
    }
  }

  void displayExpBar() {
    rectMode(CORNER);
    if (player.getLevel() < 30) {
      fill(200, 230); // Translucent Dark Grey for needed Exp
      rect(getX() - 7*unit, getY() + displayHeight/2 - 2*unit, 15*unit, unit); //confirmed from playing
      fill(255, 255, 0); // yellow for gained Exp
      rect(getX() - 7*unit, getY() + displayHeight/2 - 2*unit, 15*unit*((float)(getExp())/getExpRequiredForNextLevel()), unit);
      fill(0);
    } else {
      //max level
      fill(255, 255, 0); // yellow for gained Exp
      rect(getX() - 7*unit, getY() + displayHeight/2 - 2*unit, 15*unit, unit);
      fill(0);
    }
    GameScreen.smallText(CENTER);
    text("Lvl " + getLevel(), getX(), getY() + displayHeight/2 - 1.1*unit);
    GameScreen.resetText();
  }

  void displayEvolutions() {
    GameScreen.smallText(CENTER);

    text("EVOLVE", getX()-(displayWidth/2)+(unit*5.5), getY()-(displayHeight/2)+(unit*2));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*5), unit*2, unit*2);
    shape(new Twin(0, 0, getLevel()).umo, getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*4.5));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*5), unit*2, unit*2);
    shape(new Sniper(0, 0, getLevel()).umo, getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*4.5));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*10), unit*2, unit*2);
    shape(new MachineGun(0, 0, getLevel()).umo, getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*10));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*10), unit*2, unit*2);
    shape(new FlankGuard(0, 0, getLevel()).umo, getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*10));

    GameScreen.resetText();
  }

  void evolve(char evolution) {
    Gunship newPlayer = player;
    switch(key) {
    case '1': 
      newPlayer = new Twin(player.getX(), player.getY(), getLevel()); 
      break;
    case '2': 
      unit*=.8; // increase fov
      newPlayer = new Sniper(player.getX(), player.getY(), getLevel()); 
      break;
    case '3': 
      newPlayer = new MachineGun(player.getX(), player.getY(), getLevel()); 
      break;
    case '4': 
      newPlayer = new FlankGuard(player.getX(), player.getY(), getLevel()); 
      break;
    }
    newPlayer.velocity = player.velocity;
    newPlayer.setShop(player.getShop());
    newPlayer.getShop().gunship = newPlayer;
    newPlayer.setSkillPoints(player.getSkillPoints());
    newPlayer.setRadius(player.getRadius());
    player = newPlayer;
    player.updateStats();
    shop.update();
  }

  void heal() {
    if (getTimeSinceLastHit() != 0) {
      //healing within 30 seconds
      if (getHealth() < getMaxHealth()) {
        setHealth(getHealth() + (float) getHealthRegen() / 7 * getMaxHealth() / 1800);
      }
      if (getTimeSinceLastHit() == 1) {
        setHeal10percent((getMaxHealth() - getHealth())/10/60);
      }
    } else {
      //healing after 30 seconds
      if (getHealth() < getMaxHealth()) {
        setHealth(getHealth() + getHeal10percent());
      }
    }
    if (getHealth() > getMaxHealth()) {
      setHealth(getMaxHealth());
    }
  }

  void autoFire() {
    if (canShoot()) {
      shoot();
    }
  }

  void autoRotate() {
    setAngle(getAngle()+radians(2));
  }

  /**
   * updates stat base and modifier 
  */
  void updateStats() {
  }

  //get and set methods------------------------------------------------------------------

  Shop getShop() {
    return shop;
  }
  void setShop(Shop shop) {
    this.shop = shop;
  }

  Minimap getMinimap() {
    return minimap;
  }
  void setMinimap(Minimap minimap) {
    this.minimap = minimap;
  }

  ArrayList<Gun> getGuns() {
    return guns;
  }
  void setGuns(ArrayList<Gun> guns) {
    this.guns = guns;
  }

  int getExpRequiredForNextLevel() {
    return 10*getLevel();
  }

  int getReloadSpeed() {
    return reloadSpeed;
  }
  void setReloadSpeed(int reloadSpeed) {
    this.reloadSpeed = reloadSpeed;
  }

  float getShootCooldown() {
    return shootCooldown;
  }
  void setShootCooldown(float shootCooldown) {
    this.shootCooldown = shootCooldown;
  }

  int getLevel() {
    return level;
  }
  void setLevel(int level) {
    this.level = level;
  }

  boolean canEvolve() {
    return getLevel() >= 15;
  }

  int getNumberOfEvolutions() {
    return numberOfEvolutions;
  }
  void setNumberOfEvolutions(int numberOfEvolutions) {
    this.numberOfEvolutions = numberOfEvolutions;
  }

  int getSkillPoints() {
    return skillPoints;
  }
  void setSkillPoints(int skillPoints) {
    this.skillPoints = skillPoints;
  }

  float getAngle() {
    return angle;
  }
  void setAngle(float angle) {
    this.angle = angle;
  }

  int getHealthRegen() {
    return healthRegen;
  }
  void setHealthRegen(int healthRegen) {
    this.healthRegen = healthRegen;
  }

  int getTimeSinceLastHit() {
    return timeSinceLastHit;
  }
  void setTimeSinceLastHit(int timeSinceLastHit) {
    this.timeSinceLastHit = timeSinceLastHit;
  }

  float getHeal10percent() {
    return heal10percent;
  }
  void setHeal10percent(float heal10percent) {
    this.heal10percent = heal10percent;
  }

  boolean getAutoFire() {
    return autoFire;
  }
  void setAutoFire(boolean autoFire) {
    this.autoFire = autoFire;
  }

  boolean getAutoRotate() {
    return autoRotate;
  }
  void setAutoRotate(boolean autoRotate) {
    this.autoRotate = autoRotate;
  }

  int getCollisionDamageWithShip() {
    return collisionDamageWithShip;
  }
  void setCollisionDamageWithShip(int collisionDamageWithShip) {
    this.collisionDamageWithShip = collisionDamageWithShip;
  }

  boolean isSuicidal() {
    return suicidal;
  }
  void setSuicidal(boolean suicidal) {
    this.suicidal = suicidal;
  }

  String getType() {
    return type;
  }
  void setType(String type) {
    this.type = type;
  }

  int getInvincible() {
    return invincible;
  }
  void setInvincible(int invincible) {
    this.invincible = invincible;
  }

  String getRecoilMode() {
    return recoilMode;
  }

  void setRecoilMode (String recoilMode) {
    this.recoilMode = recoilMode;
  }

  float getSpread() {
    return spread;
  }
  void setSpread(float spread) {
    this.spread = spread;
  }
}
