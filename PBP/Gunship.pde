class Gunship extends UMO {
  private Shop shop;
  private int level;
  private int skillPoints;

  private float maxSpeed;
  private float speed;

  private int reloadSpeed; 
  private int shootCooldown;

  private float angle;
  private ArrayList<Bullet> bullets;

  private int healthRegen;
  private int timeSinceLastHit;
  private float heal10percent;

  Gunship(float x, float y) {
    setRadius(unit);
    position.set(x, y);
    acceleration.set(.2, .2);
    setAngle(0);

    setLevel(1);
    shop = new Shop(this, 20, height-250);

    //setHealthRegen(shop.healthRegen.getBase() + (shop.healthRegen.getModifier()*shop.healthRegen.getLevel()));
    setMaxHealth(shop.maxHealth.getBase()); 
    setHealth(getMaxHealth());
    setCollisionDamage(shop.bodyDamage.getBase());
    setReloadSpeed(shop.reload.getBase());
    setMaxSpeed(shop.movementSpeed.getBase());

    bullets = new ArrayList<Bullet>();
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

  void display() {
    //rotate
    setAngle(getAngleToMouse());
    pushMatrix();
    translate(getX(), getY());
    rotate(getAngle()-HALF_PI); // dont know why HALF_PI is necesassary. But if not present, rotation is of by 90 degrees. 
    scale(getRadius()/unit);
    shape(umo, 0, 0);
    popMatrix();

    if (getHealth() != getMaxHealth()) {
      displayHealthBar();
    }

    if (DEBUG) {
      text(""+getHealth(), getX() - 15, getY());
      text("x: "+round(getX()) + "; y: "+round(getY()), getX()+40, getY()-40);
      text("dx: "+round(getDX()) + "; dy: "+round(getDY()), getX()+40, getY()-20);
      text("mag: "+round(velocity.mag()), getX()+40, getY());
      text("shootCooldown: "+getShootCooldown(), getX()+40, player.getY()+20);
      text("Level: "+getLevel() + "; Exp: "+getExp(), getX()+40, getY()+40);
      text("timeSinceLastHit: "+getTimeSinceLastHit(), getX()+40, getY()+60);
      text("maxHealth: "+getMaxHealth(), getX()+40, getY()+80);
    }
  }

  void update() {

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
    if (getSpeed() > getMaxSpeed()) {
      setSpeed(getMaxSpeed());
    }
    // apply velocity
    position.add(velocity);

    // apply friction
    if (!input.inputs[0] && !input.inputs[1] && !input.inputs[2] && !input.inputs[3]) {
      velocity.mult(getFriction());
    }

    // check for collisions
    collisionWithBorder();
    collisionWithUMO();

    // update and display all bullets
    for (int b = 0; b < bullets.size(); b++) {
      Bullet bullet = bullets.get(b);
      bullet.update();
      bullet.display();
    }

    // decrement shoot cooldown by 1
    if (shootCooldown > 0) {
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

      setRadius(getRadius() * 1.1); //not confirmed
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
    setGameState(LOST);
  }

  void collisionWithUMO() {
    for (int p = 0; p < polygons.size(); p++) {
      Polygon polygon = polygons.get(p);
      if (isCollidingWithPolygon(polygon)) {
        //trust physics
        float m1 = getRadius()*getRadius()*getRadius();
        float m2 = polygon.getRadius()*polygon.getRadius()*polygon.getRadius();

        float dxHolder = (2*m1*getDX() + (m2-m1) * polygon.getDX()) / (float)(m1 + m2);
        float dyHolder = (2*m1*getDY() + (m2-m1) * polygon.getDY()) / (float)(m1 + m2);
        setDX((2*m2*polygon.getDX() + (m1-m2) * getDX()) / (m1 + m2));
        setDY((2*m2*polygon.getDY() + (m1-m2) * getDY()) / (float)(m1 + m2));
        polygon.velocity.set(dxHolder, dyHolder);

        if (polygon.getHealth() >  getCollisionDamage()) {
          setHealth(getHealth() - getCollisionDamage());
        } else {
          setHealth(getHealth() - polygon.getHealth());
        }
        polygon.setHealth(polygon.getHealth() - getCollisionDamage());

        //for health regen after 30 sec
        setTimeSinceLastHit(1800);
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

  int getExpRequiredForNextLevel() {
    return 10*getLevel();
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

  //get and set methods------------------------------------------------------------------

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

  float getMaxSpeed() {
    return maxSpeed;
  }
  void setMaxSpeed(float maxSpeed) {
    this.maxSpeed = maxSpeed;
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
}
