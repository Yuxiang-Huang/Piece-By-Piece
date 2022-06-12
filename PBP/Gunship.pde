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

  private int timeSinceLastHit;
  private float healthRegen;
  private float heal10percent;
  private int collisionDamageWithShip;

  private boolean autoFire;
  private boolean autoRotate;
  private boolean suicidal;
  private String type;
  private String recoilMode = "";
  private int invincible;

  Gunship(int level){
    //set stats base on level
    setLevel(level);
    setRadius(unit * pow(1.01, getLevel()-1));
    setSkillPoints(getLevel() - 1);
    
    //!!!!!
    setAngle(0);
    acceleration.set(unit*.025, unit*.025);
    acceleration.mult(pow(0.985, (getLevel() - 1))); //confirmed from website
    
    setShop(new Shop(this));
    getShop().maxHealth.base = 50 + 2*(getLevel() - 1);
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
  
  void display() {
  }

  void update() {
  }

  void die() {
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
          //0.5 sec?
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
      if (float(getExp())/getExpRequiredForNextLevel() <= 1) {
        rect(getX() - 7*unit, getY() + displayHeight/2 - 2*unit, 15*unit*(float(getExp())/getExpRequiredForNextLevel()), unit);
      } else { 
        rect(getX() - 7*unit, getY() + displayHeight/2 - 2*unit, 15*unit, unit);
      }

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

  void heal() {
    if (getTimeSinceLastHit() != 0) {
      //healing within 30 seconds
      if (getHealth() < getMaxHealth()) {
        setHealth(getHealth() + getHealthRegen() / 7 * getMaxHealth() / 1800);
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
    return 10*int(pow(getLevel(), 1.5));
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

  float getHealthRegen() {
    return healthRegen;
  }
  void setHealthRegen(float healthRegen) {
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
