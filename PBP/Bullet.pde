class Bullet extends UMO {
  Gunship gunship;
  float baseSpeed = 10;
  int timeTillDeath;
  ArrayList<UMO> collided = new ArrayList<UMO> ();

  Bullet(Gunship gunship) {
    this.gunship = gunship;
    //for spawning the bullet on the gun rather then the middle of the gunship, could probably be written better.
    position.set(gunship.getX()+(gunship.getRadius()*cos(gunship.getAngle())), gunship.getY()+(gunship.getRadius()*sin(gunship.getAngle())));
    velocity = PVector.fromAngle(gunship.getAngle());
    velocity.setMag(getBaseSpeed());
    setRadius(unit/2);
    setTimeTillDeath(60);
    setHealth(7); //bullet penetration
    setCollisionDamage(7); // confirmed value from wiki
  }

  void display() {
    fill(0);
    ellipseMode(RADIUS);
    circle(getX(), getY(), getRadius());
  }

  void update() {
    // kill bullet after certain amount of time
    setTimeTillDeath(getTimeTillDeath()-1);
    for (int p = 0; p < polygons.size(); p++) {
      Polygon polygon = polygons.get(p);
      if (isCollidingWithPolygon(polygon)) {
        if (! collided.contains(polygon)) {
          //trust physics
          float m1 = getRadius()*getRadius()*getRadius();
          float m2 = polygon.getRadius()*polygon.getRadius()*polygon.getRadius();

          float dxHolder = (2*m1*getDX() + (m2-m1) * polygon.getDX() ) / (float)(m1 + m2);
          float dyHolder = (2*m1*getDY() + (m2-m1) * polygon.getDY() ) / (float)(m1 + m2);
          polygon.velocity.set(dxHolder, dyHolder);

          if (polygon.getHealth() >  getCollisionDamage()) {
            setHealth(getHealth() - getCollisionDamage());
          } else {
            setHealth(getHealth() - polygon.getHealth());
          }
          polygon.setHealth(polygon.getHealth() - getCollisionDamage());

          collided.add(polygon);
        }
      }
    }
    if (getTimeTillDeath() == 0 || isCollidingWithBorder()) {
      die();
    }
    if (DEBUG) {
      fill(0);
      text(""+ getHealth(), getX(), getY() + 20);
      text("x: "+round(getX()) + "; y: "+round(getY()), getX()+20, getY()-20);
      text("dx: "+round(getDX()) + "; dy: "+round(getDY()), getX()+20, getY()-5);      
    }
    super.update();
  }

  void die() {
    gunship.bullets.remove(this);
  }
  
  void collisionWithUMO(){
  }

  float getBaseSpeed() {
    return baseSpeed;
  }

  void setBaseSpeed(float baseSpeed) {
    this.baseSpeed = baseSpeed;
  }

  int getTimeTillDeath() {
    return timeTillDeath;
  }
  void setTimeTillDeath(int timeTillDeath) {
    this.timeTillDeath = timeTillDeath;
  }
}
