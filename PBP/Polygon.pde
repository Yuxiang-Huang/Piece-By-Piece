class Polygon extends UMO {
  private int heldExp;
  private String shape;
  private int radius;

  Polygon(String name) {
    setX(random(width));
    setY(random(height));
    //Not to collide with player ship
    while (Math.abs(getX() - player.getX()) < player.getRadius()) {
      setX(random(width));
    }
    while (Math.abs(getY() - player.getY()) < player.getRadius()) {
      setY(random(height));
    }
    polygons.add(this);
    if (name.equals("square")) {
      setHeldExp(10);
      setShape("square");
      setRadius(10);
      //setMaxHealth(10);
      //setCurrentHealth(10);
      //setCollisionDamage(8);
    }
    if (name.equals("triangle")) {
      setHeldExp(25);
      setShape("triangle");
      setRadius(10);
      //setMaxHealth(25);
      //setCurrentHealth(25);
      //setCollisionDamage(8);
    }
    if (name.equals("pentagon")) {
      setHeldExp(130);
      setShape("pentagon");
      setRadius(10);
      //setMaxHealth(130);
      //setCurrentHealth(130);
      //setCollisionDamage(12);
    }
  }

  void die() {
    polygons.remove(this);
    //player.setExp(player.getExp() + getHeldExp());
  }

  void display() {
    if (shape.equals("square")) {
      square(getX(), getY(), getRadius());
    } else if (shape.equals("triangle")) {
      triangle(getX(), getY() - getRadius(), 
        getX() - radius * sqrt(3) / 2, getY() + getRadius() / 2, 
        getX() + radius * sqrt(3) / 2, getY() + getRadius() / 2);
    } else if (shape.equals("pentagon")) {
      pentagon();
    }
  }

  void pentagon() {
    //From Processsing
    float angle = TWO_PI / 5;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = getX() + cos(a) * getRadius();
      float sy = getY() + sin(a) * getRadius();
      vertex(sx, sy);
    }
    endShape(CLOSE);
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
