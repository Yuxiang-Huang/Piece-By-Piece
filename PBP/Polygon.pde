class Polygon extends UMO {
  private int heldExp;
  private String shape;
  private int radius;

  Polygon(String name) {
    setX((float)Math.random() * width);
    setY((float)Math.random() * height);
    while (Math.abs(getX() - player.getX()) < player.getRadius()) {
      setX((float)Math.random() * width);
    }
    while (Math.abs(getY() - player.getY()) < player.getRadius()) {
      setY((float)Math.random() * height);
    }
    //polygons.add(this);
    if (name.equals("square")) {
      setHeldExp(10);
      setShape("square");
      //setMaxHealth(10);
      //setCurrentHealth(10);
      //setCollisionDamage(8);
    }
    if (name.equals("triangle")) {
      setHeldExp(25);
      setShape("triangle");
      //setMaxHealth(25);
      //setCurrentHealth(25);
      //setCollisionDamage(8);
    }
  }

  void die() {
    //polygons.remove(this);
    //player.setExp(player.getExp() + getHeldExp());
  }

  void display() {
    if (shape.equals("square")) {
      square(getX(), getY(), 10);
    } else if (shape.equals("triangle")) {
      triangle(getX(), getY() - radius, 
        getX() - radius * sqrt(3) / 2, getY() + radius / 2, 
        getX() + radius * sqrt(3) / 2, getY() + radius / 2);
    }
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
