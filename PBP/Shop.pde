class Shop implements Processable {
  Gunship gunship;
  PVector position;

  //Stat statName = new Stat(level, base, modifier)
  private Stat healthRegen = new Stat("Health Regen", 0, 0, 1); //confirmed from website
  private Stat maxHealth = new Stat("Max Health", 0, 50, 20); //confirmed from wiki
  private Stat bodyDamage = new Stat("Body Damage", 0, 20, 4); //confirmed from wiki
  private Stat bodyDamageWithShip = new Stat("Body Damage", 0, 30, 6); //confirmed from wiki
  private Stat bulletSpeed = new Stat("Bullet Speed", 0, unit/3, unit/14); 
  private Stat bulletPenetration = new Stat("Bullet Penetration", 0, 7, 5); //I guess since level one would go through a square
  private Stat bulletDamage = new Stat("Bullet Damage", 0, 7, 3); //confirmed from wiki
  private Stat reload = new Stat("Reload", 0, 36, -2.4); //confirmed from wiki
  private Stat movementSpeed = new Stat("Movement Speed", 0, 0.05 * unit/2, 1.07); //confirmed from website

  Shop(Gunship gunship) {
    this.gunship = gunship;
    position = new PVector(0, 0);
  }

  void display() {
    position.set(player.getX()-(displayWidth/2)+unit, player.getY()+(displayHeight/2)-(unit*2));
    fill(0);
    text("skill Points: " + gunship.getSkillPoints(), position.x, position.y-(unit*(3.0/2))*7.5);
    healthRegen.display(0);
    maxHealth.display(1);
    bodyDamage.display(2);
    bulletSpeed.display(3);
    bulletPenetration.display(4);
    bulletDamage.display(5);
    reload.display(6);
    movementSpeed.display(7);
  }

  /**
   Updates all gunship related stats:
   Health Regen, Max Health, Body Damage, Reload Speed, and Movement Speed
   */
  void update() {
    gunship.setHealthRegen((int)(healthRegen.getBase() + (healthRegen.getModifier()*healthRegen.getLevel())));
    float percentHealth = gunship.getHealth() / gunship.getMaxHealth();
    gunship.setMaxHealth((int)(maxHealth.getBase() + (maxHealth.getModifier()*maxHealth.getLevel()))); 
    gunship.setHealth(percentHealth * gunship.getMaxHealth());
    gunship.setCollisionDamage((int)(bodyDamage.getBase() + (bodyDamage.getModifier()*bodyDamage.getLevel())));
    gunship.setCollisionDamageWithShip((int)(bodyDamageWithShip.getBase() + (bodyDamageWithShip.getModifier()*bodyDamage.getLevel())));
    gunship.setReloadSpeed((int)(reload.getBase() + (reload.getModifier()*reload.getLevel())));
    gunship.setSpread(.03*gunship.getShop().getReload().getLevel()); // bullet spread scales with reload speed 
    gunship.acceleration = new PVector(movementSpeed.getBase() * pow(movementSpeed.getModifier(), movementSpeed.getLevel()), movementSpeed.getBase() * pow(movementSpeed.getModifier(), movementSpeed.getLevel()));
  }

  void randomUpgrade() {
    while (gunship.getSkillPoints() > 0) {
      int rand = (int)(random(8) + 1);
      if (rand == 1 && ! healthRegen.isMaxLevel()) {
        healthRegen.upgrade();
        update();
        gunship.setSkillPoints(gunship.getSkillPoints()-1);
      }
      if (rand == 2 && ! maxHealth.isMaxLevel()) {
        maxHealth.upgrade();
        update();
        gunship.setSkillPoints(gunship.getSkillPoints()-1);
      }
      if (rand == 3 && ! bodyDamage.isMaxLevel()) {
        bodyDamage.upgrade();
        update();
        gunship.setSkillPoints(gunship.getSkillPoints()-1);
      }
      if (rand == 4 && ! bulletSpeed.isMaxLevel()) {
        bulletSpeed.upgrade();
        update();
        gunship.setSkillPoints(gunship.getSkillPoints()-1);
      }
      if (rand == 5 && ! bulletPenetration.isMaxLevel()) {
        bulletPenetration.upgrade();
        update();
        gunship.setSkillPoints(gunship.getSkillPoints()-1);
      }
      if (rand == 6 && ! bulletDamage.isMaxLevel()) {
        bulletDamage.upgrade();
        update();
        gunship.setSkillPoints(gunship.getSkillPoints()-1);
      }
      if (rand == 7 && ! reload.isMaxLevel()) {
        reload.upgrade();
        update();
        gunship.setSkillPoints(gunship.getSkillPoints()-1);
      }
      if (rand == 8 && ! movementSpeed.isMaxLevel()) {
        movementSpeed.upgrade();
        update();
        gunship.setSkillPoints(gunship.getSkillPoints()-1);
      }
    }
  }

  Stat getHealthRegen() {
    return healthRegen;
  }
  Stat getMaxHealth() {
    return maxHealth;
  }
  Stat getBodyDamage() {
    return bodyDamage;
  }
  Stat getBodyDamageWithShip() {
    return bodyDamageWithShip;
  }
  Stat getBulletSpeed() {
    return bulletSpeed;
  }
  Stat getBulletPenetration() {
    return bulletPenetration;
  }
  Stat getBulletDamage() {
    return bulletDamage;
  }
  Stat getReload() {
    return reload;
  }
  Stat getMovementSpeed() {
    return movementSpeed;
  }

  class Stat {
    private String statName;
    final int maxLevel = 7;
    private int level;
    private float base;
    private float modifier;

    Stat(String statName, int level, float base, float modifier) {
      setStatName(statName);
      setLevel(level);
      setBase(base);
      setModifier(modifier);
    }

    void display(int i) {
      i = 7 - i;
      rectMode(CORNER);
      fill(200, 200); // Translucent Light Grey
      rect(getX(), getY()-(unit*(3.0/2)*i), unit*10, unit, unit/4);
      fill(color(0, 255, 0)); // GREEN
      rect(getX(), getY()-(unit*(3.0/2)*i), unit*10*(float(getLevel())/maxLevel), unit, unit/4);
      stroke(color(100, 200));
      for (int j = 0; j < maxLevel; j++) {
        line(getX()+ ((unit*10)/7)*j, getY()-(unit*(3.0/2)*i), getX() + ((unit*10)/7)*j, getY()-(unit*(3.0/2)*i)+unit);
      }
      fill(0);
      text(getStatName(), getX()+(unit/10), getY()-((unit*(3.0/2))*i) + unit*3/4);
      text("["+(8-i)+"]", getX()+(unit*10)-unit, getY()-((unit*(3.0/2))*i) + (unit*.7));
    }

    /**
     Increments level of stat by 1.
     */
    void upgrade() {
      setLevel(getLevel()+1);
    }

    //get and set methods------------------------------------------------------------------

    float getX() {
      return position.x;
    }
    float getY() {
      return position.y;
    }

    int getLevel() {
      return level;
    }
    void setLevel(int level) {
      this.level = level;
    }

    boolean isMaxLevel() {
      return getLevel() == maxLevel;
    }

    float getBase() {
      return base;
    }
    void setBase(float base) {
      this.base = base;
    }    

    float getModifier() {
      return modifier;
    }
    void setModifier(float modifier) {
      this.modifier = modifier;
    }

    String getStatName() {
      return statName;
    }
    void setStatName(String statName) {
      this.statName = statName;
    }
  }
}
