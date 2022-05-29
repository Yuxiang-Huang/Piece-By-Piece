class Shop implements Processable {
  Gunship gunship;
  PVector position;
 
  //Stat statName = new Stat(level, base, modifier)
  Stat healthRegen = new Stat(0, 5, 5);
  Stat maxHealth = new Stat(0, 50, 25);
  Stat bodyDamage = new Stat(0, 20, 5);
  Stat bulletSpeed = new Stat(0, 10, 1);
  Stat bulletPenetration = new Stat(0, 7, 3);
  Stat bulletDamage = new Stat(0, 7, 3);
  Stat reload = new Stat(0, 60, -5);
  Stat movementSpeed = new Stat(0, 5, 1);

  Shop(Gunship gunship, float x, float y) {
    this.gunship = gunship;
    position = new PVector(x, y);
  }

  void display() {
      //healthRegen.display(0);
      maxHealth.display(1);
      bodyDamage.display(2);
      bulletSpeed.display(3);
      bulletPenetration.display(4);
      bulletDamage.display(5);
      reload.display(6);
      movementSpeed.display(7);
  }
  
  void update() {
      //gunship.setHealthRegen(healthRegen.getBase() + (healthRegen.getModifier()*healthRegen.getLevel()));
      gunship.setMaxHealth(maxHealth.getBase() + (maxHealth.getModifier()*maxHealth.getLevel())); 
      gunship.setCollisionDamage(bodyDamage.getBase() + (bodyDamage.getModifier()*bodyDamage.getLevel()));
      gunship.setReloadSpeed(reload.getBase() + (reload.getModifier()*reload.getLevel()));
      gunship.setMaxSpeed(movementSpeed.getBase() + (movementSpeed.getModifier()*movementSpeed.getLevel()));
      gunship.acceleration.add(new PVector(.1, .1));
  }

  class Stat {
    
    final int maxLevel = 10;
    private int level;
    private int base;
    private int modifier;

    Stat(int level, int base, int modifier) {
      setLevel(level);
      setBase(base);
      setModifier(modifier);
    }
    
    void display(int i) {
      rectMode(CORNER);
      fill(200,200,200,200);
      rect(position.x, position.y+30*i, 200, 20, 5);
      fill(color(0,255,0));
      rect(position.x, position.y+30*i, 200*(float(getLevel())/maxLevel), 20, 5);
      for (i = 0; i < maxLevel; i++) {
          line(positions.x*)
      }
      
    }

    void upgrade() {
      setLevel(getLevel()+1);
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

    int getBase() {
      return base;
    }
    void setBase(int base) {
      this.base = base;
    }    

    int getModifier() {
      return modifier;
    }
    void setModifier(int modifier) {
      this.modifier = modifier;
    }
  }
}
