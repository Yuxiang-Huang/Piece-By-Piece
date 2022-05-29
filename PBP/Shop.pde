class Shop implements Processable {
  Gunship gunship;
  PVector position;
 
  //Stat statName = new Stat(level, base, modifier)
  Stat healthRegen = new Stat("Health Regen", 0, 5, 5);
  Stat maxHealth;
  Stat bodyDamage = new Stat("Body Damage", 0, 20, 6); //confirmed
  Stat bulletSpeed = new Stat("Bullet Speed", 0, 10, 1);
  Stat bulletPenetration = new Stat("Bullet Penetration", 0, 7, 3);
  Stat bulletDamage = new Stat("Bullet Damage", 0, 7, 3); //confirmed
  Stat reload = new Stat("Reload", 0, 36, -3); //-2.4 for wiki
  Stat movementSpeed = new Stat("Movement Speed", 0, 5, 1);

  Shop(Gunship gunship, float x, float y) {
    this.gunship = gunship;
    position = new PVector(x, y);
    maxHealth = new Stat("Max Health", 0, 50 + 2 * (gunship.getLevel() - 1), 20); //confirmed
  }

  void display() {
      healthRegen.display(0);
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
    
    String statName;
    final int maxLevel = 10;
    private int level;
    private int base;
    private int modifier;

    Stat(String statName, int level, int base, int modifier) {
      setStatName(statName);
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
      fill(0);
      text(getStatName(), position.x + 10, position.y+30*i + 15);
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
    
    String getStatName(){
      return statName;
    }
    void setStatName(String statName){
      this.statName = statName;
    }
  }
}
