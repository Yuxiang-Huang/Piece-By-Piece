class Bullet extends UMO {
  float baseSpeed = 4.5;
  
  Bullet(Gunship gunship) {
    //for spawning the bullet on the gun rather then the middle of the gunship
    position.set(gunship.getX()+(gunship.getRadius()*cos(gunship.getAngle())), gunship.getY()+(gunship.getRadius()*sin(gunship.getAngle())));
    velocity = PVector.fromAngle(gunship.getAngle());
    velocity.setMag(getBaseSpeed());
    setRadius(10);
  }

  void display() {
    ellipseMode(RADIUS);
    circle(getX(), getY(), getRadius());
  }

  void update() {
    position.add(velocity);
  }

  float getBaseSpeed() {
    return baseSpeed;
  }
  
  void setBaseSpeed(float baseSpeed) {
    this.baseSpeed = baseSpeed;
  }
}
