class Polygon extends UMO {
  private String shape;

  final color YELLOW = color(255, 255, 0);
  final color RED = color(255, 0, 0);
  final color BLUE = color(0, 0, 255);

  Polygon() {
    // So that all polygons are not concentrated on (0,0)
    umo = createShape();
    float rand = random(1);
    if (rand < .5) { // 50%
      setShape("square"); 
      setHeldExp(10);
      setRadius(unit);
     
      rectMode(RADIUS);
      umo = createShape(RECT, 0, 0, getRadius(), getRadius());
      umo.setFill(YELLOW); 
      
      setHealth(10);
      setCollisionDamage(10);
      
    } else if (rand < .83) { // 33%
      setShape("triangle");
      setHeldExp(25);
      setRadius(unit * 1.5);
      
      umo = createShape(TRIANGLE, 0, -getRadius(), 
        getRadius() * sqrt(3) / 2, getRadius() / 2, 
        -getRadius() * sqrt(3) / 2, getRadius() / 2);
      umo.setFill(RED);
      setHealth(30);
      setCollisionDamage(20);
    } else { // 17%
      setShape("pentagon");
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

      setHealth(100); 
      setCollisionDamage(12);
      setExp(130);
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
    Polygon polygon = new Polygon();
    player.setExp(player.getExp() + getExp());
  }

  void display() {
    shape(umo, getX(), getY());
  }

  String getShape() {
    return shape;
  }

  void setShape(String shapeNow) {
    shape = shapeNow;
  }

  void collisionWithUMO() {
    for (int p = 0; p < polygons.size(); p++) {
      Polygon polygon = polygons.get(p);
      if (isCollidingWithPolygon(polygon)) {
        //trust physics
        float m1 = getRadius()*getRadius()*getRadius();
        float m2 = polygon.getRadius()*polygon.getRadius()*polygon.getRadius();

        float dxHolder = (2*m1*getDX() + (m2-m1) * polygon.getDX() ) / (float)(m1 + m2);
        float dyHolder = (2*m1*getDY() + (m2-m1) * polygon.getDY() ) / (float)(m1 + m2);
        setDX( (2*m2*polygon.getDX() + (m1-m2) * getDX() ) / (float)(m1 + m2));
        setDY( (2*m2*polygon.getDY() + (m1-m2) * getDY() ) / (float)(m1 + m2));
        polygon.velocity.set(dxHolder, dyHolder);
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
