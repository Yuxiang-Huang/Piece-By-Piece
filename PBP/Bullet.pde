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
    setRadius(10);
    setCountdown(60);
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
    if (getCountdown() == 0) {
      gunship.bullets.remove(this);
    }
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
