class Gunship extends UMO {
  private Shop shop;
  private int level;
  private int skillPoints;

  private int reloadSpeed;
  private int shootCooldown;

  private float angle;
  private ArrayList<Bullet> bullets;

  private float maxSpeed;
  private int healthRegen;
  private int timeSinceLastHit;
  private float heal10percent;

  private boolean AutoFire;

  Gunship(float x, float y) {
    setRadius(unit);
    position.set(x, y);
    setAngle(0);
    acceleration.set(unit*.025, unit*.025);

    setLevel(1);
    setShop(new Shop(this, unit, height-unit * 12));

    getShop().update();
    setHealth(getMaxHealth());

    setBullets(new ArrayList<Bullet>());
    setShootCooldown(0);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
    rectMode(CORNER);
    PShape gun = createShape(RECT, -getRadius()/3, getRadius()/3, 2*getRadius()/3, 1.3*getRadius());
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);

    setTimeSinceLastHit(0);
  }

  //enemy constructor
  Gunship() {
    setRadius(unit);
    position.set(random(width), random(height));
    while (isCollidingWithAnyUMO()) {
      setX(random(width));
      setY(random(height));
    }
    setAngle(0);
    acceleration.set(unit*.01, unit*.01);

    setLevel((int) random(14) + 1);

    shop = new Shop(this, unit, height-unit * 12);

    //set stats base on level
    shop.maxHealth.base = 50 + 2 * (getLevel() - 1);
    setRadius(getRadius() * pow(1.01, getLevel() - 1)); //confirmed from wiki
    acceleration.mult(pow(0.985, (getLevel() - 1))); //confirmed from website
    setSkillPoints(getLevel() - 1);

    //randomly assign skill points here
    //randomly assign skill points here

    shop.update();
    setHealth(getMaxHealth());

    bullets = new ArrayList<Bullet>();
    setShootCooldown(0);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(0, 0, 255));
    rectMode(CORNER);
    PShape gun = createShape(RECT, -getRadius()/3, getRadius()/3, 2*getRadius()/3, 1.3*getRadius());
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);

    setTimeSinceLastHit(0);

    setAutoFire(true);

    enemies.add(this);
  }

  void display() {
    if (!enemies.contains(this)) {
      //rotate
      setAngle(getAngleToMouse());
      pushMatrix();
      translate(getX(), getY());
      rotate(getAngle()-HALF_PI); // dont know why HALF_PI is necesassary. But if not present, rotation is of by 90 degrees.
      scale(getRadius()/unit);
      shape(umo, 0, 0);
      popMatrix();
    } else {
      //rotate toward gunship
      float angle = atan2((player.getY() - getY()), (player.getX() - getX()));
      if (angle < 0) {
        angle = TWO_PI + angle;
      }
      setAngle(angle); //need help...
      pushMatrix();
      translate(getX(), getY());
      rotate(getAngle()-HALF_PI); // dont know why HALF_PI is necesassary. But if not present, rotation is of by 90 degrees.
      scale(getRadius()/unit);
      shape(umo, 0, 0);
      popMatrix();
    }
    if (getHealth() != getMaxHealth()) {
      displayHealthBar();
    }

    displayExpBar();

    if (DEBUG) {
      text(""+getHealth(), getX() - unit, getY());
      text("x: "+round(getX()) + "; y: "+round(getY()), getX()+unit*2, getY()-unit*2);
      text("dx: "+round(getDX()) + "; dy: "+round(getDY()), getX()+unit*2, getY()-unit);
      text("mag: "+round(velocity.mag()), getX()+unit*2, getY());
      text("shootCooldown: "+getShootCooldown(), getX()+unit*2, getY()+unit);
      text("Level: "+getLevel() + "; Exp: "+getExp(), getX()+unit*2, getY()+unit*2);
      text("timeSinceLastHit: "+getTimeSinceLastHit(), getX()+unit*2, getY()+unit*3);
      text("maxHealth: "+getMaxHealth(), getX()+unit*2, getY()+unit*4);
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
  void update() {
    if (getAutoFire()) {
      autoFire();
    }
    // update and display all bullets
    for (int b = 0; b < getBullets().size(); b++) {
      Bullet bullet = getBullets().get(b);
      bullet.update();
      bullet.display();
    }

    // decrement shoot cooldown by 1
    if (getShootCooldown() > 0) {
      setShootCooldown(getShootCooldown()-1);
    }

    // check if gunship has enough exp for level up
    if (getExp() >= getExpRequiredForNextLevel()) {
      setExp(getExp()-getExpRequiredForNextLevel());
      setLevel(getLevel()+1);
      setSkillPoints(getSkillPoints()+1);
      //increase stats upon level up
      getShop().maxHealth.base += 2;
      setRadius(getRadius() * 1.01); //confirmed from wiki
      acceleration.mult(0.985); //confirmed from website
      getShop().update(); // to update maxHealth;
    }   

    heal();

    if (getTimeSinceLastHit() > 0) {
      setTimeSinceLastHit(getTimeSinceLastHit() - 1);
    }

    //should be in UMO.update
    if (int(getHealth()) == 0) {
      die();
    }

    if (enemies.contains(this)) {
      botMove();
    } else {
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

      //apply acceleration
      velocity.add(new PVector(acceleration.x*xdir, acceleration.y*ydir));
      if (velocity.mag() > getMaxSpeed()) {
        velocity.setMag(getMaxSpeed());
      }

      // apply velocity
      position.add(velocity);
      //pos.add(new PVector(-velocity.x, -velocity.y));

      // apply friction
      if (!input.inputs[0] && !input.inputs[1] && !input.inputs[2] && !input.inputs[3]) {
        velocity.mult(getFriction());
      }
    }

    // check for collisions
    collisionWithBorder();
    collisionWithUMO();

    // update and display all bullets
    for (int b = 0; b < bullets.size(); b++) {
      Bullet bullet = getBullets().get(b);
      bullet.update();
      bullet.display();
    }

    // decrement shoot cooldown by 1
    if (getShootCooldown() > 0) {
      setShootCooldown(getShootCooldown()-1);
    }

    // check if gunship has enough exp for level up
    if (getExp() >= getExpRequiredForNextLevel()) {
      setExp(getExp()-getExpRequiredForNextLevel());
      setLevel(getLevel()+1);
      setSkillPoints(getSkillPoints()+1);
      //increase stats upon level up
      setMaxHealth((int)getMaxHealth() + 2);
      setHealth(getHealth() + 2);
      setRadius(getRadius() * 1.07); //not confirmed
    }  

    if (int(getHealth()) == 0) {
      die();
    }

    heal();
    if (getTimeSinceLastHit() > 0) {
      setTimeSinceLastHit(getTimeSinceLastHit() - 1);
    }
  }

  void die() {
    if (enemies.contains(this)) {
      Gunship enemy = new Gunship();
    } else {
      setGameState(LOST);
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
        setDX((2*m2*polygon.getDX() + (m1-m2) * getDX()) / (m1 + m2));
        setDY((2*m2*polygon.getDY() + (m1-m2) * getDY()) / (float)(m1 + m2));
        polygon.velocity.set(dxHolder, dyHolder);

        if (polygon.getHealth() >  polygon.getCollisionDamage()) {
          setHealth(getHealth() - polygon.getCollisionDamage());
        } else {
          setHealth(getHealth() - polygon.getHealth());
        }
        polygon.setHealth(polygon.getHealth() - getCollisionDamage());

        //for health regen after 30 sec
        setTimeSinceLastHit(1800);
        return;
      }
    }
  }

  float getAngleToMouse() {
    float angle = atan2(mouseY-getY(), mouseX-getX());
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
    bullets.add(new Bullet(this));
  }

  void displayExpBar() {
    rectMode(CORNER);
    fill(200, 200, 200, 230); // black for needed Exp
    rect(width / 2 - 7 * unit, height - 2*unit, 15*unit, unit); //confirmed from playing
    fill(color(255, 255, 0)); // yellow for gained Exp
    rect(width / 2 - 7 * unit, height - 2*unit, 15*unit*((float)(getExp())/getExpRequiredForNextLevel()), unit);
    fill(255);
    textAlign(CENTER);
    textSize(unit);
    fill(0);
    text("Lvl " + getLevel(), width / 2, height - unit*1.1);
    textAlign(LEFT);
    textSize(unit*3.0/4);
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

  void botMove() {
    int xdir;
    int ydir;
    if (getX() > player.getX()) {
      xdir = -1;
    } else {
      xdir = 1;
    }
    if (getY() > player.getY()) {
      ydir = -1;
    } else {
      ydir = 1;
    }
    velocity.add(new PVector(acceleration.x*xdir, acceleration.y*ydir));
    if (velocity.mag() > getMaxSpeed()) {
      velocity.setMag(getMaxSpeed());
    }
    // apply velocity
    position.add(velocity);

    // apply friction
    velocity.mult(getFriction());
  }

  void autoFire() {
    if (canShoot()) {
      shoot();
    }
  }

  //get and set methods------------------------------------------------------------------

  Shop getShop() {
    return shop;
  }
  void setShop(Shop shop) {
    this.shop = shop;
  }

  ArrayList<Bullet> getBullets() {
    return bullets;
  }
  void setBullets(ArrayList<Bullet> bullets) {
    this.bullets = bullets;
  }

  float getMaxSpeed() {
    return maxSpeed;
  }
  void setMaxSpeed(float maxSpeed) {
    this.maxSpeed = maxSpeed;
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

  int getShootCooldown() {
    return shootCooldown;
  }
  void setShootCooldown(int shootCooldown) {
    this.shootCooldown = shootCooldown;
  }

  int getLevel() {
    return level;
  }
  void setLevel(int level) {
    this.level = level;
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
    return AutoFire;
  }
  void setAutoFire(boolean AutoFire) {
    this.AutoFire = AutoFire;
  }
}
