class Bullet extends UMO {
  final float baseSpeed = 3;
  Bullet(Gunship gunship) {
    position.set(gunship.getX(), gunship.getY());
    velocity.fromAngle(gunship.getAngle());
    velocity.setMag(getBaseSpeed());
    setRadius(10);
  }

  void display() {
    ellipseMode(RADIUS);
    circle(getX(), getY(), getRadius());
  }

  void update() {
  }

  float getBaseSpeed() {
    return baseSpeed;
  }
}
