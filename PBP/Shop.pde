class Shop {
  Gunship gunship;
 
  //Stat statName = new Stat(level, base, modifier)
  Stat healthRegen = new Stat(0, 5, 5);
  Stat maxHealth = new Stat(0, 50, 25);
  Stat bodyDamage = new Stat(0, 20, 5);
  Stat bulletSpeed = new Stat(0, 10, 1);
  Stat bulletPenetration = new Stat(0, 7, 3);
  Stat bulletDamage = new Stat(0, 7, 3);
  Stat reload = new Stat(0, 60, -5);
  Stat movementSpeed = new Stat(0, 5, 1);

  Shop(Gunship gunship) {
    this.gunship = gunship;
  }

  void display() {
  
  }
  
  void update() {
      //gunship.setHealthRegen(healthRegen.getBase() + (healthRegen.getModifier()*healthRegen.getLevel()));
      println(maxHealth.getBase());
      println(maxHealth.getModifier());
      println(maxHealth.getLevel());
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
