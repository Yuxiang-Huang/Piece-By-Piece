class Bullet extends UMO {   //<>//
  private Gunship gunship;
  private Gun gun;
  private int timeTillDeath;
  private final float frictionForBullet = .99;

  Bullet(Gunship gunship, Gun gun) {
    this.gunship = gunship;
    this.gun = gun;
    setRadius(unit/2 * pow (1.01, getGunship().getLevel() - 1)); // base confirmed from playing, modifier confirmed from wiki
    float angle = gunship.getAngle() + gun.getAngle() + (random(gunship.getSpread()*2)-gunship.getSpread());

    //for spawning the bullet on the gun rather then the middle of the gunship, could probably be written better.
    position.set(gunship.getX()+(gunship.getRadius()*cos(angle)), gunship.getY()+(gunship.getRadius()*sin(angle)));
    velocity = PVector.fromAngle(angle);
    velocity.setMag(gunship.shop.bulletSpeed.getBase() + (gunship.shop.bulletSpeed.getModifier()*gunship.shop.bulletSpeed.getLevel()));

    //for flankguard
    if (! gunship.getRecoilMode().equals("none")) {
      //threshold m1 for correct direction
      float m1 = pow(getRadius(), 3.5);
      float m2 = pow(gunship.getRadius(), 3);
      float dxHolder = -1 * (2*m1*getDX() + (m2-m1) * gunship.getDX()) / (float)(m1 + m2);
      float dyHolder = -1 * (2*m1*getDY() + (m2-m1) * gunship.getDY()) / (float)(m1 + m2);
      if (gunship.getRecoilMode().equals("lower")) {
        dxHolder *= 0.25;
        dyHolder *= 0.25;
      }
      gunship.velocity.add(new PVector(dxHolder/2, dyHolder/2));
    }
    setTimeTillDeath(180); //confirmed from wiki
    setMaxHealth(int((gunship.shop.bulletPenetration.getBase() + (gunship.shop.bulletPenetration.getModifier()*gunship.shop.bulletPenetration.getLevel()))));
    setHealth(getMaxHealth()); //bullet penetration
    setCollisionDamage(int((gunship.shop.bulletDamage.getBase() + (gunship.shop.bulletDamage.getModifier()*gunship.shop.bulletDamage.getLevel()))));
  }

  void display() {
    ellipseMode(RADIUS);
    //color the bullets
    if (getGunship() != player) {
      fill(255, 0, 0);
    }
    circle(getX(), getY(), getRadius());
    fill(0);
    if (DEBUG && getX() - player.getX() < displayWidth / 2 && getY() - player.getY() < displayHeight / 2 ) {
      fill(0);
      text(""+ int(getHealth()), getX(), getY() + unit);
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
    getGun().getBullets().remove(this);
  }

  /**
   Loops over all Polygons and if currently colliding with one, applies its damage and force to it
   */
  void collisionWithUMO() {
    for (int p = 0; p < polygons.size(); p++) {
      Polygon polygon = polygons.get(p);
      if (isCollidingWithPolygon(polygon)) {
        //trust physics
        float m1 = pow(getRadius(), 3);
        float m2 = pow(polygon.getRadius(), 3);

        float dxHolder = (2*m1*getDX() + (m2-m1) * polygon.getDX() ) / (float)(m1 + m2);
        float dyHolder = (2*m1*getDY() + (m2-m1) * polygon.getDY() ) / (float)(m1 + m2);
        polygon.velocity.set(dxHolder, dyHolder);

        if (polygon.getHealth() >  polygon.getCollisionDamage()) {
          setHealth(getHealth() - polygon.getCollisionDamage());
        } else {
          setHealth(getHealth() - polygon.getHealth());
        }
        polygon.setHealth(polygon.getHealth() - getCollisionDamage());
        if (polygon.isDead()) {
          gunship.setExp(gunship.getExp() + polygon.getExp()); // Fixed: shouldn't always give it to the player
        }
        return;
      }
    }

    //ship bullet collision
    if (getGunship() != player) {
      if (dist(getX(), getY(), player.getX(), player.getY()) < getRadius() + player.getRadius()) {
        //only do damage part if not invincible
        if (player.getInvincible() == 0) {
          setHealth(getHealth() - player.getCollisionDamage());
          player.setHealth(player.getHealth() - getCollisionDamage());
          player.setTimeSinceLastHit(1800);
        }
      }
    } else {
      for (EnemyGunship enemy : enemies) {
        if (dist(getX(), getY(), enemy.getX(), enemy.getY()) < getRadius() + enemy.getRadius()) {
          if (enemy.getHealth() >  enemy.getCollisionDamage()) {
            setHealth(getHealth() - enemy.getCollisionDamage());
          } else {
            setHealth(getHealth() - enemy.getHealth());
          }
          //only do damage part if not invincible
          if (enemy.getInvincible() == 0) {
            enemy.setHealth(enemy.getHealth() - getCollisionDamage());
            enemy.setTimeSinceLastHit(1800);
          }

          if (enemy.isDead()) {
            player.setExp(player.getExp() + enemy.getLevel() * (enemy.getLevel() - 1) * 10 / 2) ; 
            //half of total enemy exp, trust math
          }
          return;
        }
      }
    }

    //bullet bullet collision
    if (getGunship() != player) {
      for (Gun gun : player.getGuns()) {
        for (int b = 0; b < gun.getBullets().size(); b++) {
          Bullet bullet = gun.getBullets().get(b);
          if (sqrt(pow((getX() - bullet.getX()), 2) + pow((getY() - bullet.getY()), 2))
            < getRadius() + bullet.getRadius()) {
            //take collision damage or remaining health
            float healthBefore = getHealth();
            if (bullet.getHealth() >  bullet.getCollisionDamage()) {
              setHealth(getHealth() - bullet.getCollisionDamage());
            } else {
              setHealth(getHealth() - bullet.getHealth());
            }
            if (healthBefore >  getCollisionDamage()) {
              bullet.setHealth(bullet.getHealth() - getCollisionDamage());
            } else {
              bullet.setHealth(bullet.getHealth() - healthBefore);
            }
          }
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
  
  Gunship getGunship() {
    return gunship;
  }
  void setGunship(Gunship gunship) {
    this.gunship = gunship;
  } 
  
  Gun getGun() {
    return gun;
  }
  void setGun(Gun gun) {
    this.gun = gun;
  } 
}
