class Bullet extends UMO { //<>// //<>//
  Gunship gunship;
  private int timeTillDeath;
  private final float frictionForBullet = .98;

  Bullet(Gunship gunship) {
    this.gunship = gunship;
    setRadius(unit/2 * pow (1.01, gunship.getLevel() - 1)); //base confirmed from playing, modifier confirmed from wiki

    //for spawning the bullet on the gun rather then the middle of the gunship, could probably be written better.
    position.set(gunship.getX()+(gunship.getRadius()*cos(gunship.getAngle())), gunship.getY()+(gunship.getRadius()*sin(gunship.getAngle())));
    velocity = PVector.fromAngle(gunship.getAngle());

    setSpeed(gunship.shop.bulletSpeed.getBase() + (gunship.shop.bulletSpeed.getModifier()*gunship.shop.bulletSpeed.getLevel()));
    //apply opposite force to gunship
    float m1 = getRadius()*getRadius()*getRadius();
    float m2 = gunship.getRadius()*gunship.getRadius()*gunship.getRadius();
    float dxHolder = -1 * (2*m1*getDX() + (m2-m1) * gunship.getDX()) / (float)(m1 + m2);
    float dyHolder = -1 * (2*m1*getDY() + (m2-m1) * gunship.getDY()) / (float)(m1 + m2);
    gunship.velocity.add(new PVector(dxHolder, dyHolder));
    setTimeTillDeath(120); //confirmed from wiki
    setMaxHealth((int)(gunship.shop.bulletPenetration.getBase() + (gunship.shop.bulletPenetration.getModifier()*gunship.shop.bulletPenetration.getLevel())));
    setHealth(getMaxHealth()); //bullet penetration
    setCollisionDamage((int)(gunship.shop.bulletDamage.getBase() + (gunship.shop.bulletDamage.getModifier()*gunship.shop.bulletDamage.getLevel())));
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

  /**
   Updates the timeTillDeath timer.
   If timer is at 0 or currently colliding with the border, then die.
   Checks for collisions with UMOs.
   Calls super.update.
   */
  void update() {
    // kill bullet after certain amount of time
    setTimeTillDeath(getTimeTillDeath()-1);
    if (getTimeTillDeath() == 0 || isCollidingWithBorder()) {
      die();
    }
    collisionWithUMO();
    super.update();
  }

  /**
   Removes the bullet from its gunship's list of bullets
   */
  void die() {
    gunship.bullets.remove(this);
  }


  /**
   Loops over all Polygons and if currently colliding with one, applies its damage and force to it
   */
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

        if (polygon.getHealth() >  polygon.getCollisionDamage()) {
          setHealth(getHealth() - polygon.getCollisionDamage());
        } else {
          setHealth(getHealth() - polygon.getHealth());
        }
        polygon.setHealth(polygon.getHealth() - getCollisionDamage());
        return;
      }
    }

    //ship bullet collision
    if (enemies.contains(gunship)) {
      if (sqrt(pow((getX() - player.getX()), 2) + pow((getY() - player.getY()), 2))
        < getRadius() + player.getRadius()) {
        setHealth(getHealth() - player.getCollisionDamage());
        player.setHealth(player.getHealth() - getCollisionDamage());
      }
    } else {
      for (Gunship enemy : enemies) {
        if (sqrt(pow((getX() - enemy.getX()), 2) + pow((getY() - enemy.getY()), 2))
          < getRadius() + enemy.getRadius()) {
          if (enemy.getHealth() >  enemy.getCollisionDamage()) {
            setHealth(getHealth() - enemy.getCollisionDamage());
          } else {
            setHealth(getHealth() - enemy.getHealth());
          }
          enemy.setHealth(enemy.getHealth() - getCollisionDamage());
          return;
        }
      }
    }
  }
  //get and set methods------------------------------------------------------------------

  int getTimeTillDeath() {
    return timeTillDeath;
  }
  void setTimeTillDeath(int timeTillDeath) {
    this.timeTillDeath = timeTillDeath;
  }

  float getFriction() {
    return frictionForBullet;
  }
}
