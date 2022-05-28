class Gunship extends UMO {
  int level;

  private float maxSpeed;
  private int reloadSpeed; 

  private float angle;
  private ArrayList<Bullet> bullets;
  private int countdown;

  private int damage;
  private int bulletPenetration;

  Gunship(float x, float y) {
    setRadius(unit);
    position.set(x, y);
    acceleration.set(.2, .2);
    setAngle(0);

    setLevel(1);
    setMaxHealth(50); // confirmed value from wiki
    setHealth(getMaxHealth());
    setCollisionDamage(20); // confirmed value from wiki
    setMaxSpeed(5);
    setReloadSpeed(60);


    bullets = new ArrayList<Bullet>();
    setCountdown(0);
    setDamage(7);
    setBulletPenetration(7);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
    rectMode(CORNER);
    PShape gun = createShape(RECT, -getRadius()/3, getRadius()/3, 2*getRadius()/3, 1.3*getRadius());
    gun.setFill(color(0));

    umo.addChild(body);
    umo.addChild(gun);
  }

  void display() {
    //rotate
    setAngle(getAngleToMouse());
    pushMatrix();
    translate(getX(), getY());
    rotate(getAngle()-HALF_PI); // dont know why HALF_PI is necesassary. But if not present, rotation is of by 90 degrees. 
    shape(umo, 0, 0);
    popMatrix();
    
    if (getHealth() != getMaxHealth()) {
      displayHealthBar();
    }

    if (DEBUG) {
      fill(0);
      text(""+getHealth(), getX(), getY());
      text("x: "+round(getX()) + "; y: "+round(getY()), getX()+40, getY()-40);
      text("dx: "+round(getDX()) + "; dy: "+round(getDY()), getX()+40, getY()-20);
      text("mag: "+round(velocity.mag()), getX()+40, getY());
      text("countdown: "+getCountdown(), getX()+40, player.getY()+20);
      text("Level: "+getLevel() + "; Exp: "+getExp(), getX()+40, getY()+40);
    }
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
        text("dx: "+round(bullet.getDX()) + "; dy: "+round(bullet.getDY()), bullet.getX()+40, bullet.getY()-20);
      }
    }

    // decrement shoot cooldown by 1
    if (countdown > 0) {
      setCountdown(getCountdown()-1);
    }

    // check if gunship has enough exp for level up
    if (getExp() >= getExpRequiredForNextLevel()) {
      setExp(getExp()-getExpRequiredForNextLevel());
      setLevel(getLevel()+1);
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
      if (isCollidingWithPolygon(polygon)) {
        //trust physics
        float m1 = getRadius()*getRadius()*getRadius();
        float m2 = polygon.getRadius()*polygon.getRadius()*polygon.getRadius();

        float dxHolder = (2*m1*getDX() + (m2-m1) * polygon.getDX() ) / (float)(m1 + m2);
        float dyHolder = (2*m1*getDY() + (m2-m1) * polygon.getDY() ) / (float)(m1 + m2);
        setDX( (2*m2*polygon.getDX() + (m1-m2) * getDX() ) / (m1 + m2));
        setDY( (2*m2*polygon.getDY() + (m1-m2) * getDY() ) / (float)(m1 + m2));
        polygon.velocity.set(dxHolder, dyHolder);

        if (isCollidingWithPolygon(polygon)) {
          if (polygon.getHealth() >  getCollisionDamage()) {
            setHealth(getHealth() - getCollisionDamage());
          } else {
            setHealth(getHealth() - polygon.getHealth());
          }
          polygon.setHealth(polygon.getHealth() - getCollisionDamage());
        }
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

  int getLevel() {
    return level;
  }
  void setLevel(int level) {
    this.level = level;
  }

  int getExpRequiredForNextLevel() {
    return int(10*pow(1.5, getLevel()+1));
  }

  int getDamage() {
    return damage;
  }
  void setDamage(int damage) {
    this.damage = damage;
  }
  int getBulletPenetration() {
    return bulletPenetration;
  }
  void setBulletPenetration(int bulletPenetration) {
    this.bulletPenetration = bulletPenetration;
  }
}
