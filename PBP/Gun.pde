class Gun {
  private Gunship gunship;
  private ArrayList<Bullet> bullets;
  private float angle;

  Gun(Gunship gunship, float angle) {
    this.gunship = gunship;
    setBullets(new ArrayList<Bullet>());
    setAngle(angle);
  }

  void update() {
    for (int b = 0; b < getBullets().size(); b++) {
      Bullet bullet = getBullets().get(b);
      bullet.update();
      bullet.display();
    }
  }
  
  void shoot() {
    getBullets().add(new Bullet(gunship, this));
  }


  //get and set methods------------------------------------------------------------------

  ArrayList<Bullet> getBullets() {
    return bullets;
  }
  void setBullets(ArrayList<Bullet> bullets) {
    this.bullets = bullets;
  }

  float getAngle() {
    return angle;
  }
  void setAngle(float angle) {
    this.angle = angle;
  }
}
