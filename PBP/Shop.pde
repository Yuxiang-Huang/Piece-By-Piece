class Shop implements Processable {
  Gunship gunship;
  PVector position;

  //Stat statName = new Stat(level, base, modifier)
  Stat healthRegen = new Stat("Health Regen", 0, 0, 1); //confirmed from website
  Stat maxHealth = new Stat("Max Health", 0, 50, 20); //confirmed from wiki
  Stat bodyDamage = new Stat("Body Damage", 0, 20, 6); //confirmed from wiki
  Stat bulletSpeed = new Stat("Bullet Speed", 0, (int)unit/3, (int) unit/14); 
  Stat bulletPenetration = new Stat("Bullet Penetration", 0, 7, 5); //I guess same as damage???
  Stat bulletDamage = new Stat("Bullet Damage", 0, 7, 3); //confirmed from wiki
  Stat reload = new Stat("Reload", 0, 60, -3); //-2.4 for wiki
  Stat movementSpeed = new Stat("Movement Speed", 0, unit/5.4, unit/(5.4*5)); //confirmed from website

  Shop(Gunship gunship) {
    this.gunship = gunship;
    position = new PVector(0,0);
  }

  void display() {
    position.set(player.getX()-(width/2)+unit, player.getY()+(height/2)-(unit*2));
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
    gunship.setReloadSpeed((int)(reload.getBase() + (reload.getModifier()*reload.getLevel())));
    gunship.setMaxSpeed(movementSpeed.getBase() + movementSpeed.getModifier()*movementSpeed.getLevel());
  }
  
  void updatePosition() {
    
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
      text("skill Points: " + gunship.getSkillPoints(), getX(), getY()-(unit*(3.0/2))*7.5);
      rectMode(CORNER);
      fill(200, 200, 200, 200); // Translucent Light Grey
      rect(getX(), getY()-(unit*(3.0/2)*i), unit*10, unit, unit/4);
      fill(color(0, 255, 0)); // GREEN
      rect(getX(), getY()-(unit*(3.0/2)*i), unit*10*(float(getLevel())/maxLevel), unit, unit/4);
      fill(0);
      text(getStatName(), getX()+(unit/10), getY()-((unit*(3.0/2))*i) + unit*3/4);
      text("["+(8-i)+"]",getX()+(unit*10)-unit, getY()-((unit*(3.0/2))*i) + (unit*.7));
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
