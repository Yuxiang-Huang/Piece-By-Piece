class Polygon extends UMO {
  private int heldExp;
  private String shape;

  Polygon(String name) {
    // So that all polygons are not concentrated on (0,0)
    setShape(name);
    position.set(random(width), random(height));

    // Not to collide with player ship
    while (Math.abs(getX() - player.getX()) < player.getRadius() && 
      Math.abs(getY() - player.getY()) < player.getRadius()) 
    {
      setX(random(width));
      setY(random(height));
    }

    polygons.add(this);

    umo = createShape();
    if (name.equals("square")) {
      setHeldExp(10);
      setRadius(unit);
      rectMode(RADIUS);
      umo = createShape(RECT, 0, 0, getRadius(), getRadius());
      umo.setFill(color(255, 255, 0));

      //setMaxHealth(10);
      //setCurrentHealth(10);
      //setCollisionDamage(8);
    } else if (name.equals("triangle")) {
      setHeldExp(25);
      setRadius(unit * 1.5);
      umo = createShape(TRIANGLE, 0, -getRadius(), 
        getRadius() * sqrt(3) / 2, getRadius() / 2, 
        -getRadius() * sqrt(3) / 2, getRadius() / 2);
      umo.setFill(color(255, 0, 0));

      //setMaxHealth(25);
      //setCurrentHealth(25);
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
      umo.setFill(color(0, 0, 255));

      //setMaxHealth(130);
      //setCurrentHealth(130);
      //setCollisionDamage(12);
    }
  }

  void update() {
    position.add(velocity);
    velocity.mult(getFriction());
    // check for collisions
    collisionWithBorder();
    collisionWithUMO();
  }

  void collisionWithUMO() {
    for (Polygon polygon : polygons) {
      //distance formula
      if (sqrt(pow((getX() - polygon.getX()), 2) + pow((getY() - polygon.getY()), 2)) 
        < getRadius() + polygon.getRadius() ) {
        //trust physics
        float m1 = getRadius()*getRadius();
        float m2 = polygon.getRadius()*polygon.getRadius();

        float dxHolder = (2*m1*getDX() + (m2-m1) * polygon.getDX() ) / (m1 + m2);
        float dyHolder = (2*m1*getDY() + (m2-m1) * polygon.getDY() ) / (m1 + m2);
        setDX( (2*m2*polygon.getDX() + (m1-m2) * getDX() ) / (m1 + m2));
        setDY( (2*m2*polygon.getDY() + (m1-m2) * getDY() ) / (m1 + m2));
        polygon.velocity.set(dxHolder, dyHolder);
        
      }
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
}
