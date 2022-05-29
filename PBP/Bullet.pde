class Bullet extends UMO {
  Gunship gunship;
  private int timeTillDeath;

  Bullet(Gunship gunship) {
    this.gunship = gunship;
    setRadius(unit/2); //confirmed from playing

    //for spawning the bullet on the gun rather then the middle of the gunship, could probably be written better.
    position.set(gunship.getX()+(gunship.getRadius()*cos(gunship.getAngle())), gunship.getY()+(gunship.getRadius()*sin(gunship.getAngle())));
    velocity = PVector.fromAngle(gunship.getAngle());

    setSpeed(gunship.shop.bulletSpeed.getBase() + (gunship.shop.bulletSpeed.getModifier()*gunship.shop.bulletSpeed.getLevel()));
    setTimeTillDeath(180); //confirmed from wiki
    setHealth(gunship.shop.bulletPenetration.getBase() + (gunship.shop.bulletPenetration.getModifier()*gunship.shop.bulletPenetration.getLevel())); //bullet penetration
    setCollisionDamage(gunship.shop.bulletDamage.getBase() + (gunship.shop.bulletDamage.getModifier()*gunship.shop.bulletDamage.getLevel()));
  }

  void display() {
    ellipseMode(RADIUS);
    circle(getX(), getY(), getRadius());
    if (DEBUG) {
      fill(0);
      text(""+ (int) getHealth(), getX(), getY() + unit);
      text("x: "+round(getX()) + "; y: "+round(getY()), getX()+unit, getY()-unit);
      text("dx: "+round(getDX()) + "; dy: "+round(getDY()), getX()+unit, getY());
    }
  }

  void update() {
    // kill bullet after certain amount of time
    setTimeTillDeath(getTimeTillDeath()-1);
    collisionWithUMO();
    if (getTimeTillDeath() == 0 || isCollidingWithBorder()) {
      die();
    }
    super.update();
  }

  void die() {
    gunship.bullets.remove(this);
  }

  void collisionWithUMO() {
    for (int p = 0; p < polygons.size(); p++) {
      Polygon polygon = polygons.get(p);
      if (isCollidingWithPolygon(polygon)) {

        //trust physics
        float m1 = getRadius()*getRadius()*getRadius();
        float m2 = polygon.getRadius()*polygon.getRadius()*polygon.getRadius();

        float dxHolder = (2*m1*getDX() + (m2-m1) * polygon.getDX() ) / (float)(m1 + m2);
        float dyHolder = (2*m1*getDY() + (m2-m1) * polygon.getDY() ) / (float)(m1 + m2);
        polygon.velocity.set(dxHolder, dyHolder);

        if (polygon.getHealth() >  getCollisionDamage()) {
          setHealth(getHealth() - getCollisionDamage());
        } else {
          setHealth(getHealth() - polygon.getHealth());
        }
        polygon.setHealth(polygon.getHealth() - getCollisionDamage());
      }
    }
  }

  int getTimeTillDeath() {
    return timeTillDeath;
  }
  void setTimeTillDeath(int timeTillDeath) {
    this.timeTillDeath = timeTillDeath;
  }
}
