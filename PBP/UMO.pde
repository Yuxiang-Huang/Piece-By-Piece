abstract class UMO implements Processable {
  PShape umo;
  PVector position = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);
  PVector acceleration = new PVector(0, 0);
  private final float friction = .98; // for smoother stoping
  private float radius;
  private int exp;
  
  private int maxHealth;
  private int health; 
  
  private int collisionDamage;
  
  void update() {
    if (isDead()){
      die();
    }
    velocity.add(acceleration);
    position.add(velocity);
    velocity.mult(getFriction());
  }

  void display() {
    shape(umo, getX(), getY());
  }
  
  boolean isDead(){
    return getHealth() == 0;
  }
  
  void displayHealthBar() {
    int d;
    if (getY() <= height/2) {
      d = 1;
    } else {
      d = -1;
    }
    rectMode(CORNER);
    fill(color(255, 0, 0)); // red for lost health
    rect(getX()-getRadius(), getY()+(d*(getRadius()+15)), getRadius()*2, 10);
    fill(color(0, 255, 0)); // green for current health
    rect(getX()-getRadius(), getY()+(d*(getRadius()+15)), getRadius()*2*(float(getHealth())/getMaxHealth()), 10);
  }

  boolean isCollidingWithBorder() {
    if (getX() - getRadius() < 0 || getX() + getRadius() > width || 
      getY() - getRadius() < 0 || getY() + getRadius() > height) 
    {
      return true;
    } 
    return false;
  }

  void collisionWithBorder() {
    if (getX() - getRadius() < 0 ) {
      setX(getRadius());
    }
    if (getX() + getRadius() > width) {
      setX(width - getRadius());
    }
    if (getY() - getRadius() < 0) {
      setY(getRadius());
    }
    if (getY() + getRadius() > height) {
      setY(height - getRadius());
    }
  }

  boolean isCollidingWithPolygon(Polygon polygon) {
    //distance formula
    float Radius = 0 ;
    //trust math to fix collision detection
    if (polygon.getShape().equals("square")) {
      Radius = polygon.getRadius() / sqrt(2);
    } else if (polygon.getShape().equals("triangle")) {
      Radius = polygon.getRadius() / 2;
    } else if (polygon.getShape().equals("pentagon")) {
      Radius = polygon.getRadius() * sin(54 / 180.0 * PI);
    }
    return dist(getX(), getY(), polygon.getX(), polygon.getY()) < getRadius() + Radius;
  }

  abstract void die();
  abstract void collisionWithUMO();

//get and set methods------------------------------------------------------------------

  float getRadius() {
    return radius;
  }
  void setRadius(float radius) {
    this.radius = radius;
  }

  float getX() {
    return position.x;
  }
  void setX(float x) {
    this.position.x = x;
  }

  float getY() {
    return position.y;
  }
  void setY(float y) {
    this.position.y = y;
  }

  float getDX() {
    return velocity.x;
  }
  void setDX(float dx) {
    this.velocity.x = dx;
  }

  float getDY() {
    return velocity.y;
  }
  void setDY(float dy) {
    this.velocity.y = dy;
  }

  float getDDX() {
    return acceleration.x;
  }
  void setDDX(float ddx) {
    this.acceleration.x = ddx;
  }

  float getDDY() {
    return acceleration.y;
  }
  void setDDY(float ddy) {
    this.acceleration.x = ddy;
  }

  float getFriction() {
    return friction;
  }

  int getMaxHealth() {
    return maxHealth;
  }

  void setMaxHealth(int maxHealth) {
    if (maxHealth < 0) {
      maxHealth = 0;
    }
    this.maxHealth = maxHealth;
  }

  int getHealth() {
    return health;
  }
  void setHealth(int health) {
    if (health < 0) {
      health = 0;
    }
    this.health = health;
  }

  int getCollisionDamage() {
    return collisionDamage;
  }
  void setCollisionDamage(int collisionDamage) {
    this.collisionDamage = collisionDamage;
  }

  int getExp() {
    return exp;
  }
  void setExp(int exp) {
    this.exp = exp;
  }
}
