abstract class UMO implements Processable {
  private float x, y;
  private float dx, dy;
  private float ddx, ddy;
  private float friction;

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
  void setFriction(float friction) {
    this.friction = friction;
  }
}
