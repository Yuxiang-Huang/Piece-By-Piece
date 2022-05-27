class Polygon extends UMO {
  private int heldExp;
  private String shape;

  final color YELLOW = color(255, 255, 0);
  final color RED = color(255, 0, 0);
  final color BLUE = color(0, 0, 255);

  Polygon(String name) {
    // So that all polygons are not concentrated on (0,0)
    setShape(name);

    umo = createShape();
    if (name.equals("square")) {
      setHeldExp(10);
      setRadius(unit);
      rectMode(RADIUS);
      umo = createShape(RECT, 0, 0, getRadius(), getRadius());
      umo.setFill(YELLOW); 
      setHealth(10);
      //setCollisionDamage(8);
    } else if (name.equals("triangle")) {
      setHeldExp(25);
      setRadius(unit * 1.5);
      umo = createShape(TRIANGLE, 0, -getRadius(), 
        getRadius() * sqrt(3) / 2, getRadius() / 2, 
        -getRadius() * sqrt(3) / 2, getRadius() / 2);
      umo.setFill(RED);
      setHealth(25);

      //setCollisionDamage(8);
    } else if (name.equals("pentagon")) {
      setHeldExp(130);
      setRadius(unit * 1.75);
      float angle = TWO_PI/5;
      umo = createShape();
      umo.beginShape();
      for (float a = 0; a < TWO_PI; a += angle) {
        float sx = cos(a) * getRadius();
        float sy = sin(a) * getRadius();
        umo.vertex(sx, sy);
      }
      umo.endShape(CLOSE);
      umo.setFill(BLUE);

      setHealth(130);
      //setCollisionDamage(12);
    }

    position.set(random(width), random(height));

    // Not to collide with player ship
    while (sqrt(pow((getX() - player.getX()), 2) + pow((getY() - player.getY()), 2)) 
      < getRadius() + player.getRadius() || isCollidingWithAnyPolygon()) {
      setX(random(width));
      setY(random(height));
    }

    polygons.add(this);
  }

  void update() {
    position.add(velocity);
    velocity.mult(getFriction());
    // check for collisions
    collisionWithBorder();
    collisionWithUMO();
    if (getHealth() == 0) {
      die();
    }
  }

  void die() {
    polygons.remove(this);
    //player.setExp(player.getExp() + getHeldExp());
  }

  void display() {
    shape(umo, getX(), getY());
  }

  int getHeldExp() {
    return heldExp;
  }

  void setHeldExp(int heldExpNow) {
    heldExp = heldExpNow;
  }

  String getShape() {
    return shape;
  }

  void setShape(String shapeNow) {
    shape = shapeNow;
  }

  void collisionWithUMO() {
    for (Polygon polygon : polygons) {
      if (isCollidingWithPolygon(polygon)) {
        //trust physics
        float m1 = getRadius()*getRadius();
        float m2 = polygon.getRadius()*polygon.getRadius();

        float dxHolder = (2*m1*getDX() + (m2-m1) * polygon.getDX() ) / (m1 + m2);
        float dyHolder = (2*m1*getDY() + (m2-m1) * polygon.getDY() ) / (m1 + m2);
        setDX( (2*m2*polygon.getDX() + (m1-m2) * getDX() ) / (m1 + m2));
        setDY( (2*m2*polygon.getDY() + (m1-m2) * getDY() ) / (m1 + m2));
        polygon.velocity.set(dxHolder, dyHolder);
        //polygon.update();
      }
    }
  }

  boolean isCollidingWithAnyPolygon() {
    for (Polygon polygon : polygons) {
      if (isCollidingWithPolygon(polygon)) {
        return true;
      }
    }
    return false;
  }
}
