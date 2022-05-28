class Shop {
  Gunship gunship;

  private Stat healthRegen = new Stat();
  private Stat maxHealth = new Stat();
  private Stat bodyDamage = new Stat();
  private Stat bulletSpeed = new Stat();
  private Stat bulletPenetration = new Stat();
  private Stat bulletDamage = new Stat();
  private Stat reload = new Stat();
  private Stat movementSpeed = new Stat();


  class Stat {
    private int level;

    Stat() {
      setLevel(0);
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
  }
}
