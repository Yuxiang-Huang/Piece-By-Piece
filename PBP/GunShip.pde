public class Gunship extends UMO {
  public Gunship(float x, float y) {
    setX(x);
    setY(y);
    setDX(0);
    setDY(0);
    setDDX(.1);
    setDDY(.1);
  }

  void display() {
    ellipseMode(RADIUS);
    fill(128);
    circle(getX(), getY(), 20);
  }

  void update() {
    // check for what directions are being pressed and apply acceleration if max speed has not been reached yet

    // LEFT
    if (keysPressed[0]) {
      if (player.getDX() > -5) {
        player.setDX(player.getDX()-getDDX());
      }
    } 
    // UP
    if (keysPressed[1]) {
      if (player.getDY() > -5) {
        player.setDY(player.getDY()-getDDY());
      }
    }
    // RIGHT
    if (keysPressed[2]) {
      if (player.getDX() < 5) {
        player.setDX(player.getDX()+getDDX());
      }
    }
    // DOWN
    if (keysPressed[3]) {
      if (player.getDY() < 5) {
        player.setDY(player.getDY()+getDDY());
      }
    }

    //if (exactly two trues in keysPressed) {multiply dx and dy by sqrt(2)/2}

    // apply velocity
    setX(getX() + getDX());
    setY(getY() + getDY());
    //apply friction
    setDX(getDX()*getFriction());
    setDY(getDY()*getFriction());
  }
}
