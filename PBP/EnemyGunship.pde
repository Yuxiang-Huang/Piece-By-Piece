class EnemyGunship extends Gunship { 
  private boolean suicidal;
  private String type;
  
  // enemy constructor
  EnemyGunship(int level) {
    super(level);
    position.set(random(width), random(height));
    while (isCollidingWithAnyUMOSpawning()) { // cant spawn ship on top of UMO or too close to player
      setX(random(width));
      setY(random(height));
    }
    getShop().randomUpgrade();
    //compare gun stats to gunship stats to determine if suicidal
    if (getShop().getHealthRegen().getLevel() + getShop().getMaxHealth().getLevel() + getShop().getBodyDamage().getLevel() + getShop().getMovementSpeed().getLevel() > 
      (getShop().getBulletPenetration().getLevel() + getShop().getBulletDamage().getLevel()) * 2) {
      setSuicidal(true);
    }
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
  }
  
  void display() {
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
      } else if (getType().equals("escape")) {
        text("E", getX(), getY());
      } else {
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
  
  void update() {
    if (getInvincible() > 0) {
      setInvincible(getInvincible() - 1);
    }

    //in shooting distance, 90 is just a random number I chose for now after few testing
    if (isSuicidal() || dist(getX(), getY(), player.getX(), player.getY()) < 
      (getShop().getBulletSpeed().getBase() + (getShop().getBulletSpeed().getModifier()*getShop().getBulletSpeed().getLevel())) * 90) {
      autoFire();
    }
    // update and display all guns
    for (Gun gun : getGuns()) {
      gun.update();
    }

    // decrement shoot cooldown by 1
    if (getShootCooldown() > 0) {
      setShootCooldown(getShootCooldown()-1);
    }

    // check if enemy has enough exp for level up
    if (getExp() >= getExpRequiredForNextLevel() && getLevel() < 57) {
      setExp(getExp()-getExpRequiredForNextLevel());
      setLevel(getLevel()+1);
      setSkillPoints(getSkillPoints()+1);
      //increase stats upon level up
      getShop().maxHealth.base += 2;
      setRadius(unit * pow(1.01, getLevel()-1)); //confirmed from wiki
      acceleration.mult(0.985); //confirmed from website
      getShop().update(); // to update maxHealth;
      getShop().randomUpgrade();
      //update suicidal
      if (getShop().getHealthRegen().getLevel() + getShop().getMaxHealth().getLevel() + getShop().getBodyDamage().getLevel() + getShop().getMovementSpeed().getLevel() > 
        (getShop().getBulletPenetration().getLevel() + getShop().getBulletDamage().getLevel()) * 2) {
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
      die();
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
        //float speedNow = velocity.mag();
        velocity.add((random(15) - random(15)) * velocity.x/15, (random(15) - random(15)) * velocity.y/15);
        //velocity.setMag(speedNow);
        velocity.setMag(acceleration.x * 9);
      } else if (getType().equals("ghost")) {
        velocity.add((random(30) - random(30)) * velocity.x/15, (random(30) - random(30)) * velocity.y/15);
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
    enemies.remove(this);
    setTimeUntilEnemySpawn(getTimeUntilEnemySpawn() - 600);
    if (getTimeUntilEnemySpawn() < 0) {
      setTimeUntilEnemySpawn(0);
    }
  }
  
  //get and set methods------------------------------------------------------------------
  
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
}
