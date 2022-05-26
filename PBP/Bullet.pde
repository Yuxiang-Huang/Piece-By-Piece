class Bullet extends UMO {
  final float baseSpeed = 4.5;
  
  Bullet(Gunship gunship) {
    position.set(gunship.getX(), gunship.getY());
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
}
