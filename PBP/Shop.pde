class Shop {
  Gunship gunship;

  //      Stat statName          = new Stat(level, base, modifier)
  private Stat healthRegen       = new Stat(0, 5, 5);
  private Stat maxHealth         = new Stat(0, 50, 25);
  private Stat bodyDamage        = new Stat(0, 20, 5);
  private Stat bulletSpeed       = new Stat(0, 10, 2);
  private Stat bulletPenetration = new Stat(0, 7, 3);
  private Stat bulletDamage      = new Stat(0, 7, 3);
  private Stat reload            = new Stat(0, 60, -5);
  private Stat movementSpeed     = new Stat(0, 10, 2);


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
    void setModifier() {
      this.modifer = modifier;
    }
  }
}
