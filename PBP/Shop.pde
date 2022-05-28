class Shop {
  Gunship gunship;

  //Stat statName          = new Stat(level, base, modifier)
  Stat healthRegen = new Stat(0, 5, 5);
  Stat maxHealth = new Stat(0, 50, 25);
  Stat bodyDamage = new Stat(0, 20, 5);
  Stat bulletSpeed = new Stat(0, 10, 2);
  Stat bulletPenetration = new Stat(0, 7, 3);
  Stat bulletDamage = new Stat(0, 7, 3);
  Stat reload = new Stat(0, 60, -5);
  Stat movementSpeed = new Stat(0, 10, 2);


  class Stat {
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
