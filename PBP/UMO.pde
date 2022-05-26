abstract class UMO implements Processable {
  PShape umo;
  private float radius;
  PVector position = new PVector(0,0);
  PVector velocity = new PVector(0,0);
  PVector acceleration = new PVector(0,0);
  private color Color;
  private final float friction = .98; // for smoother stoping

  void update() {
    position.add(velocity);
    velocity.mult(getFriction());
  }

  void display() {
    shape(umo, getX(), getY());
  }

  void collisionWithBorder() {
    if (getX() - getRadius() < 0 ) {
      setX(getRadius());
    }
    if (getX() + getRadius() > width) {
      setX(width - getRadius());
    }
    if (getY() - getRadius() < 0 ) {
      setY(getRadius());
    }
    if (getY() + getRadius() > height ) {
      setY(height - getRadius());
    }
  }

  float getRadius() {
    return radius;
  }
  void setRadius(float radius) {
    this.radius = radius;
  }

  float getX() {
    return position.x;
  }
  void setX(float x) {
    this.position.x = x;
  }

  float getY() {
    return position.y;
  }
  void setY(float y) {
    this.position.y = y;
  }

  float getDX() {
    return velocity.x;
  }
  void setDX(float dx) {
    this.velocity.x = dx;
  }

  float getDY() {
    return velocity.y;
  }
  void setDY(float dy) {
    this.velocity.y = dy;
  }

  float getDDX() {
    return acceleration.x;
  }
  void setDDX(float ddx) {
    this.acceleration.x = ddx;
  }

  float getDDY() {
    return acceleration.y;
  }
  void setDDY(float ddy) {
    this.acceleration.x = ddy;
  }

  float getFriction() {
    return friction;
  }

  color getColor() {
    return Color;
  }
  void setColor(color Color) {
    this.Color = Color;
  }
}
