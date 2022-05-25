public class Gunship extends UMO {
  private float maxSpeed;
  private float angle;

  public Gunship(float x, float y) {
    setRadius(30);
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(.2, .2);
    setMaxSpeed(5);
    setAngle(0);

    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
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

    // check for what directions are being pressed
    float xdir = 0; 
    float ydir = 0;
    if (keysPressed[0]) { // LEFT
      xdir = -1;
    } 
    if (keysPressed[1]) { // UP
      ydir = -1;
    } 
    if (keysPressed[2]) { // RIGHT
      xdir = 1;
    } 
    if (keysPressed[3]) { // DOWN
      ydir = 1;
    } 

    //apply acceleration
    velocity.add(new PVector(acceleration.x*xdir, acceleration.y*ydir));
    if (velocity.mag() > getMaxSpeed()) {
      velocity.setMag(getMaxSpeed());
    }
    // apply velocity
    position.add(velocity);
    //apply friction
    if (!keysPressed[0] && !keysPressed[1] && !keysPressed[2] && !keysPressed[3]) {
      velocity.mult(getFriction());
    }
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
