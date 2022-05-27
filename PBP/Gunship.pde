class Gunship extends UMO {
  private float maxSpeed;
  private int reloadSpeed; 

  private float angle;
  private ArrayList<Bullet> bullets;
  private int countdown;

  Gunship(float x, float y) {
    setRadius(unit);
    position.set(x, y);
    acceleration.set(.2, .2);
    setAngle(0);

    setHealth(100);
    setCollisionDamage(10);
    setMaxSpeed(5);
    setReloadSpeed(60);


    bullets = new ArrayList<Bullet>();
    setCountdown(0);

    // make shape of gunship
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
    rotate(getAngle()-HALF_PI); // dont kpolygon why HALF_PI is necesassary. But if not present, rotation is of by 90 degrees. 
    shape(umo, 0, 0);
    popMatrix();
  }

  void update() {

    // check for what directions are being pressed
    float xdir = 0; 
    float ydir = 0;
    if (input.inputs[0]) { // LEFT
      xdir = -1;
    } 
    if (input.inputs[1]) { // UP
      ydir = -1;
    } 
    if (input.inputs[2]) { // RIGHT
      xdir = 1;
    } 
    if (input.inputs[3]) { // DOWN
      ydir = 1;
    } 

    //apply acceleration
    velocity.add(new PVector(acceleration.x*xdir, acceleration.y*ydir));
    if (velocity.mag() > getMaxSpeed()) {
      velocity.setMag(getMaxSpeed());
    }
    // apply velocity
    position.add(velocity);

    // apply friction
    if (!input.inputs[0] && !input.inputs[1] && !input.inputs[2] && !input.inputs[3]) {
      velocity.mult(getFriction());
    }

    // check for collisions
    collisionWithBorder();
    collisionWithUMO();

    // update and display all bullets
    for (int b = 0; b < bullets.size(); b++) {
      Bullet bullet = bullets.get(b);
      bullet.update();
      bullet.display();

      if (DEBUG) {
        text(""+bullet.getHealth(), bullet.getX(), bullet.getY());
        text("x: "+round(bullet.getX()) + "; y: "+round(bullet.getY()), bullet.getX()+40, bullet.getY()-40);
        text("dx: "+bullet.getDX() + "; dy: "+bullet.getDY(), bullet.getX()+40, bullet.getY()-20);
      }
    }

    if (countdown > 0) {
      setCountdown(getCountdown()-1);
    }
    
    if (getHealth() == 0) {
        die();
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
    return angle;
  }

  void collisionWithUMO() {
    for (int p = 0; p < polygons.size(); p++) {
      Polygon polygon = polygons.get(p);
      while (isCollidingWithPolygon(polygon)) {
        //trust physics
        float m1 = getRadius()*getRadius();
        float m2 = polygon.getRadius()*polygon.getRadius();

        float dxHolder = (2*m1*getDX() + (m2-m1) * polygon.getDX() ) / (m1 + m2);
        float dyHolder = (2*m1*getDY() + (m2-m1) * polygon.getDY() ) / (m1 + m2);
        setDX( (2*m2*polygon.getDX() + (m1-m2) * getDX() ) / (m1 + m2));
        setDY( (2*m2*polygon.getDY() + (m1-m2) * getDY() ) / (m1 + m2));
        polygon.velocity.set(dxHolder, dyHolder);
        
        setHealth(getHealth()-polygon.getCollisionDamage());
        polygon.setHealth(polygon.getHealth()-getCollisionDamage());
        
        polygon.update();
      }
    }
  }


  int getReloadSpeed() {
    return reloadSpeed;
  }
  void setReloadSpeed(int reloadSpeed) {
    this.reloadSpeed = reloadSpeed;
  }

  boolean canShoot() {
    return (getCountdown() == 0);
  }
  void shoot() {
    setCountdown(getReloadSpeed());
    bullets.add(new Bullet(this));
  }


  int getCountdown() {
    return countdown;
  }
  void setCountdown(int countdown) {
    this.countdown = countdown;
  }
}
