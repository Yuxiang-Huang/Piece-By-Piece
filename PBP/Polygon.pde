class Polygon extends UMO {
  private String shape;

  final color YELLOW = color(255, 255, 0);
  final color RED = color(255, 0, 0);
  final color BLUE = color(0, 0, 255);

  float radian;
  float angularChange;
  boolean rotationCW;

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

    // Not to collide with player ship and leave some area in between
    while (isCollidingWithAnyUMOSpawning()){
      setX(random(width));
      setY(random(height));
    }

    //random Circular movement
    if (random(2) > 1) {
      setRotationCW(true);
    }
    setRadian(2*PI*random(1));
    setAngularChange(radians(random(1)/10.0)); //not done
  }

  void display() {
    pushMatrix();
    translate(getX(), getY());
    rotate(getRadian()-HALF_PI); 
    shape(umo, 0, 0);
    popMatrix();
    if (getHealth() != getMaxHealth()) {
      displayHealthBar();
    }

    if (DEBUG && getX() - player.getX() < displayWidth / 2 && getY() - player.getY() < displayHeight / 2 ) {
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
    moveInCircle();
    super.update();
  }

  void die() {
    polygons.remove(this);
    Polygon polygon = new Polygon();
    polygons.add(polygon);
  }

  /**
   Loops over all Polygons and if currently colliding with one, applies force to it
   */
  void collisionWithUMO() {
    for (int p = 0; p < polygons.size(); p++) {
      Polygon polygon = polygons.get(p);
      if (polygon != this) {
        if (isCollidingWithPolygon(polygon)) {
          //trust physics
          float m1 = pow(getRadius(), 2);
          float m2 = pow(polygon.getRadius(), 2);
          float dxHolder = 3 * (2*m1*getDX() + (m2-m1) * polygon.getDX()) / (float)(m1 + m2);
          float dyHolder = 3 * (2*m1*getDY() + (m2-m1) * polygon.getDY()) / (float)(m1 + m2);
          setDX(3 * (2*m2*polygon.getDX() + (m1-m2) * getDX()) / (float)(m1 + m2));
          setDY(3 * (2*m2*polygon.getDY() + (m1-m2) * getDY()) / (float)(m1 + m2));
          polygon.velocity.set(new PVector(dxHolder, dyHolder));

          setRotationCW(! getRotationCW());
          polygon.setRotationCW(! polygon.getRotationCW());
        }
      }
    }
  }

  void moveInCircle() {
    //one full circle in 60 seconds
    radian += getAngularChange();
    if (getRotationCW()) {
      acceleration.set((unit/500)*cos(radian), (unit/500)*sin(radian));
    } else {
      acceleration.set((unit/500)*cos(radian)*-1, (unit/500)*sin(radian)*-1);
    }
  }

  //get and set methods------------------------------------------------------------------

  String getShape() {
    return shape;
  }

  void setShape(String shape) {
    this.shape = shape;
  }

  float getRadian() {
    return radian;
  }
  void setRadian(float radian) {
    this.radian = radian;
  }

  float getAngularChange() {
    return angularChange;
  }
  void setAngularChange(float angularChange) {
    this.angularChange = angularChange;
  }

  boolean getRotationCW() {
    return rotationCW;
  }
  void setRotationCW(boolean rotationCW) {
    this.rotationCW = rotationCW;
  }
}
