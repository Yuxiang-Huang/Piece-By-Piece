abstract class UMO implements Processable {
  PShape umo;
  private float radius;
  private float x, y;
  private float dx, dy;
  private float ddx, ddy;
  private color Color;
  private final float friction = .95;

  void update() {
  }
  void display() {
    shape(umo, getX(), getY());
  }

  void collisionWithBorder(){
    println(radius);
    if (getX() < 0 + getRadius()) {
      setX(getRadius());
    }
    if (getX() > width- getRadius()) {
      setX(width - getRadius());
    }
    if (getY() < 0 + getRadius()) {
      setY(getRadius());
    }
    if (getY() > height - getRadius()) {
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
  return x;
}
void setX(float x) {
  this.x = x;
}

float getY() {
  return y;
}
void setY(float y) {
  this.y = y;
}

float getDX() {
  return dx;
}
void setDX(float dx) {
  this.dx = dx;
}

float getDY() {
  return dy;
}
void setDY(float dy) {
  this.dy = dy;
}

float getDDX() {
  return ddx;
}
void setDDX(float ddx) {
  this.ddx = ddx;
}

float getDDY() {
  return ddy;
}
void setDDY(float ddy) {
  this.ddy = ddy;
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
