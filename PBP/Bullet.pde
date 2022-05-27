class Bullet extends UMO {
  Gunship gunship;
  float baseSpeed = 10;
  int countdown;

  Bullet(Gunship gunship) {
    this.gunship = gunship;
    //for spawning the bullet on the gun rather then the middle of the gunship, could probably be written better.
    position.set(gunship.getX()+(gunship.getRadius()*cos(gunship.getAngle())), gunship.getY()+(gunship.getRadius()*sin(gunship.getAngle())));
    velocity = PVector.fromAngle(gunship.getAngle());
    velocity.setMag(getBaseSpeed());
    setRadius(gunship.getDamage());
    setCountdown(60);
    setHealth(1); //bullet penetration
    setCollisionDamage(gunship.getDamage()); // confirmed value from wiki
  }

  void display() {
    fill(0);
    ellipseMode(RADIUS);
    circle(getX(), getY(), getRadius());
  }

  void update() {
    position.add(velocity);
    velocity.mult(getFriction());
    // kill bullet after certain amount of time
    setCountdown(getCountdown()-1);
    for (int p = 0; p < polygons.size(); p++) {
      Polygon polygon = polygons.get(p);
      if (isCollidingWithPolygon(polygon)){
        die(); //bullet penetration
        polygon.setHealth(polygon.getHealth() - getCollisionDamage());
      }
    }
    if (getCountdown() == 0 || isCollidingWithBorder() || getHealth() == 0) {
      die();
    }
    
  }

  void die() {
    gunship.bullets.remove(this);
  }

  float getBaseSpeed() {
    return baseSpeed;
  }

  void setBaseSpeed(float baseSpeed) {
    this.baseSpeed = baseSpeed;
  }

  int getCountdown() {
    return countdown;
  }
  void setCountdown(int countdown) {
    this.countdown = countdown;
  }
}
