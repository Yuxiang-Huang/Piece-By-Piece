class Polygon extends UMO {
  private String shape;

  final color YELLOW = color(255, 255, 0);
  final color RED = color(255, 0, 0);
  final color BLUE = color(0, 0, 255);

  Polygon() { //all stats confirmed from wiki except radius, which is confirmed from playing
    // So that all polygons are not concentrated on (0,0)
    stroke(0);
    umo = createShape();
    float rand = random(1);
    if (rand < .5) { // 50%
      setShape("square"); 
      setExp(10); 
      setRadius(unit); 

      rectMode(RADIUS);
      umo = createShape(RECT, 0, 0, getRadius(), getRadius());
      umo.setFill(YELLOW); 

      setMaxHealth(10);
      setHealth(getMaxHealth());
      setCollisionDamage(8);
    } else if (rand < .83) { // 33%
      setShape("triangle");
      setExp(25);
      setRadius(unit*1.5);

      umo = createShape(TRIANGLE, 0, -getRadius(), 
        getRadius() * sqrt(3) / 2, getRadius() / 2, 
        -getRadius() * sqrt(3) / 2, getRadius() / 2);
      umo.setFill(RED);

      setMaxHealth(30);
      setHealth(getMaxHealth());
      setCollisionDamage(8);
    } else { // 17%
      setShape("pentagon");
      setExp(130);      
      setRadius(unit*1.75);

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

      setMaxHealth(100); 
      setHealth(getMaxHealth());
      setCollisionDamage(12);
    }

    position.set(random(width), random(height));

    // Not to collide with player ship
    while (isCollidingWithAnyUMO()) {
      setX(random(width));
      setY(random(height));
    }

    polygons.add(this);
  }

  void display() {
    shape(umo, getX(), getY());
    if (getHealth() != getMaxHealth()) {
      displayHealthBar();
    }

    if (DEBUG) {
      text(""+ (int) getHealth(), getX(), getY());
      text("x: "+round(getX()) + "; y: "+round(getY()), getX()+unit*2, getY()-unit*2);
      text("dx: "+round(getDX()) + "; dy: "+round(getDY()), getX()+unit*2, getY()-unit);
      text("Exp: "+getExp(), getX()+unit*2, getY());
    }
  }

  void update() {
    // check for collisions
    collisionWithBorder();
    collisionWithUMO();
    randomMove();
    super.update();
  }

  void die() {
    polygons.remove(this);
    Polygon polygon = new Polygon();
    player.setExp(player.getExp() + getExp());
  }

  /**
   Loops over all Polygons and if currently colliding with one, applies force to it
   */
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
        return;
      }
    }
  }

  /**
   Applies a random increment to the acceleration to create a wiggily motion
   */
  void randomMove() {
    float rand = random(1);
    int xdir;
    int ydir;
    if (rand < 0.5) {
      xdir = 1;
    } else {
      xdir = -1;
    }
    rand = random(1);
    if (rand < 0.5) {
      ydir = 1;
    } else {
      ydir = -1;
    }
    acceleration.set(unit / 500 * xdir, unit / 500 * ydir);
  }

  //get and set methods------------------------------------------------------------------

  String getShape() {
    return shape;
  }

  void setShape(String shapeNow) {
    shape = shapeNow;
  }
}
