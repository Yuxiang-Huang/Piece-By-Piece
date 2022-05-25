public class Gunship extends UMO {
  private float maxSpeed;
  private float angle;

  public Gunship(float x, float y) {
    position = new PVector(x,y);
    velocity = new PVector(0,0);
    acceleration = new PVector(.2,.2);
    setMaxSpeed(10);
    setAngle(0);

    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, 30, 30);
    body.setFill(color(165, 42, 42));
    PShape gun = createShape(RECT, -10, 20/2, 20, 40);
    gun.setFill(color(0));

    umo.addChild(body);
    umo.addChild(gun);
  }

  void display() {
    //rotate
    setAngle(getAngleToMouse());
    pushMatrix();
    translate(getX(), getY());
    rotate(getAngle());
    shape(umo, 0, 0);
    popMatrix();
  }

  void update() {
    // check for what directions are being pressed and apply acceleration if max speed has not been reached yet

    // LEFT
    if (keysPressed[0]) {
      if (player.getDX() > -maxSpeed) {
        player.setDX(player.getDX()-getDDX());
      }
    } 
    // UP
    if (keysPressed[1]) {
      if (player.getDY() > -maxSpeed) {
        player.setDY(player.getDY()-getDDY());
      }
    }
    // RIGHT
    if (keysPressed[2]) {
      if (player.getDX() < maxSpeed) {
        player.setDX(player.getDX()+getDDX());
      }
    }
    // DOWN
    if (keysPressed[3]) {
      if (player.getDY() < maxSpeed) {
        player.setDY(player.getDY()+getDDY());
      }
    }

    velocity.normalize();
    velocity.mult(maxSpeed);

    // apply velocity
    setX(getX() + getDX());
    setY(getY() + getDY());
    //apply friction
    setDX(getDX()*getFriction());
    setDY(getDY()*getFriction());
  }

  float getMaxSpeed() {
    return maxSpeed;
  }
  void setMaxSpeed(float maxSpeed) {
    this.maxSpeed = maxSpeed;
  }

  float getAngle() {
    return angle;
  }
  void setAngle(float angle) {
    this.angle = angle;
  }

  float getAngleToMouse() {
    float angle = atan2(mouseY-getY(), mouseX-getX());
    if (angle < 0) {
      angle = TWO_PI + angle;
    }
    return angle-HALF_PI;
  }
}
