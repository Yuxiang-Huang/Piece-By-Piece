abstract class UMO implements Processable {
  PShape umo;
  PVector position = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);
  PVector acceleration = new PVector(0, 0);
  private final float friction = .9; // confirmed from website
  private float radius;
  private int exp;

  private int maxHealth;
  private float health; 
  private int collisionDamage;

  /**
   If dead, dies
   Apply acceleration, velocity, and friction
   */
  void update() {
    if (isDead()) {
      die();
    }
    velocity.add(acceleration);
    position.add(velocity);
    velocity.mult(getFriction());
  }

  void display() {
    shape(umo, getX(), getY());
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
    rect(getX()-getRadius(), getY()+(d*(getRadius()+unit*3.0/4)), getRadius()*2, unit/2);
    fill(color(0, 255, 0)); // green for current health
    rect(getX()-getRadius(), getY()+(d*(getRadius()+unit*3.0/4)), getRadius()*2*((getHealth())/getMaxHealth()), unit/2);
    fill(0);
  }

  boolean isDead() {
    return int(getHealth()) == 0;
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
    if (getX() - getRadius() < 0) {
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
    float Radius = 0;
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

  boolean isCollidingWithPolygonSpawning(Polygon polygon) {
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
    return dist(getX(), getY(), polygon.getX(), polygon.getY()) < (getRadius() + Radius) * 3;
  }

  boolean isCollidingWithAnyUMO() {
    if (sqrt(pow((getX() - player.getX()), 2) + pow((getY() - player.getY()), 2)) 
      < getRadius() + player.getRadius()) {
      return true;
    }

    for (EnemyGunship enemy : enemies) {
      if (sqrt(pow((getX() - enemy.getX()), 2) + pow((getY() - enemy.getY()), 2)) 
        < getRadius() + enemy.getRadius()) {
        return true;
      }
    }

    for (Polygon polygon : polygons) {
      if (isCollidingWithPolygon(polygon)) {
        return true;
      }
    }
    return false;
  }

  boolean isCollidingWithAnyUMOSpawning() {
    //k to leave some breathing space
    int k = 3;
    if (sqrt(pow((getX() - player.getX()), 2) + pow((getY() - player.getY()), 2)) 
      < (getRadius() + player.getRadius()) * k) {
      return true;
    }

    for (EnemyGunship enemy : enemies) {
      if (sqrt(pow((getX() - enemy.getX()), 2) + pow((getY() - enemy.getY()), 2)) 
        < (getRadius() + enemy.getRadius()) * k) {
        return true;
      }
    }

    for (Polygon polygon : polygons) {
      if (isCollidingWithPolygonSpawning(polygon)) {
        return true;
      }
    }
    return false;
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

  float getHealth() {
    return health;
  }
  void setHealth(float health) {
    if (health < 0) {
      health = 0;
    } else if (health > getMaxHealth()) {
      health = getMaxHealth();
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
