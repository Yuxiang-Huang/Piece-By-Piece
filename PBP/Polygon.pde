class Polygon extends UMO {
  private int heldExp;
  private String shape;

  Polygon(String name) {
    position = new PVector(random(width), random(height));
    
    velocity = new PVector(0, 0);
    
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
      setRadius(40);
      setColor(color(255, 255, 0));
      //setMaxHealth(10);
      //setCurrentHealth(10);
      //setCollisionDamage(8);
    }
    if (name.equals("triangle")) {
      setHeldExp(25);
      setShape("triangle");
      setRadius(30);
      setColor(color(255, 0, 0));
      //setMaxHealth(25);
      //setCurrentHealth(25);
      //setCollisionDamage(8);
    }
    if (name.equals("pentagon")) {
      setHeldExp(130);
      setShape("pentagon");
      setRadius(40);
      setColor(color(0, 0, 255));
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
      fill(getColor());
      square(getX(), getY(), getRadius());
    } else if (shape.equals("triangle")) {
      fill(getColor());
      triangle(getX(), getY() - getRadius(), 
        getX() - getRadius() * sqrt(3) / 2, getY() + getRadius() / 2, 
        getX() + getRadius() * sqrt(3) / 2, getY() + getRadius() / 2);
    } else if (shape.equals("pentagon")) {
      fill(getColor());
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
