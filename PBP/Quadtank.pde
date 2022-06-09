//class TripleShot extends Gunship {
//  // player constructor 
//  TripleShot(float x, float y) {
//    super(x, y);
//    setGuns(new ArrayList<Gun>());
//    getGuns().add(new Gun(this, -15));
//    getGuns().add(new Gun(this, 0));
//    getGuns().add(new Gun(this, 15));
//    setShootCooldown(0);

//    // make shape of gunship
//    umo = createShape(GROUP);

//    ellipseMode(RADIUS);
//    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
//    body.setFill(color(165, 42, 42));
//    //PShape gun1 = createShape(QUAD, (-getRadius()/3*cos(radians(-15)))-())
//    rectMode(CORNER);
//    PShape gun2 = createShape(RECT, -getRadius()/3, getRadius()/3, 2*getRadius()/3, 1.3*getRadius());
//    gun2.setFill(color(0));


//    //umo.addChild(gun1);
//    umo.addChild(gun2);
//    //umo.addChild(gun3);
//    umo.addChild(body);
//  }

//  // enemy constructor
//  TripleShot() {
//    super();
//    setGuns(new ArrayList<Gun>());
//    getGuns().add(new Gun(this, 3));
//    getGuns().add(new Gun(this, -3));
//    setShootCooldown(0);

//    // make shape of gunship
//    umo = createShape(GROUP);

//    ellipseMode(RADIUS);
//    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
//    body.setFill(color(165, 42, 42));
//    rectMode(CORNERS);
//    PShape gun1 = createShape(QUAD, 0, 0, -getRadius()*2/3, getRadius()*2);
//    gun1.setFill(color(0));
//    PShape gun2 = createShape(RECT, 0, 0, getRadius()*2/3, getRadius()*2);
//    gun2.setFill(color(0));

//    umo.addChild(gun1);
//    umo.addChild(gun2);
//    umo.addChild(body);
//  }

//  void evolve() {
//  }
//  boolean canEvolve() {
//    return false;
//  }
//}

class QuadTank extends Gunship {  
  private int display1;
  private int display2;

  // boss constructor
  QuadTank(float x, float y) {
    setRadius(unit);
    position.set(x, y);
    setAngle(0);
    acceleration.set(unit*.01, unit*.01);
    setInvincible(60);

    setLevel(30);

    setShop(new Shop(this));

    // set stats base on level
    getShop().maxHealth.base = 300; //why not
    setRadius(unit * pow(1.01, getLevel() - 1)); //confirmed from wiki  
    acceleration.mult(pow(0.985, (getLevel() - 1))); //confirmed from website
    setSkillPoints(getLevel() - 1);

    getShop().randomUpgrade();

    getShop().update();
    setHealth(getMaxHealth());

    setShootCooldown(0);

    setTimeSinceLastHit(0);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    getGuns().add(new Gun(this, 90));
    getGuns().add(new Gun(this, 180));
    getGuns().add(new Gun(this, 270));

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    setType("random");
    body.setFill(color(0, 255, 255));
    rectMode(CORNER);
    PShape gun1 = createShape(RECT, -getRadius()/3, 0, 2*getRadius()/3, 1.5*getRadius());
    gun1.setFill(color(0));
    rectMode(CORNER);
    PShape gun2 = createShape(RECT, 0, getRadius()/3, 1.5*getRadius(), -2*getRadius()/3);
    gun2.setFill(color(0));
    rectMode(CORNER);
    PShape gun3 = createShape(RECT, getRadius()/3, 0, -2*getRadius()/3, -1.5*getRadius());
    gun3.setFill(color(0));
    rectMode(CORNER);
    PShape gun4 = createShape(RECT, 0, getRadius()/3, -1.5*getRadius(), -2*getRadius()/3);
    gun4.setFill(color(0));

    umo.addChild(gun1);
    umo.addChild(gun2);
    umo.addChild(gun3);
    umo.addChild(gun4);
    umo.addChild(body);
  }

  void enemyUpdate() {
    super.enemyUpdate();
    //second phase
    if (getType() == "random" && getHealth() < getMaxHealth() / 3 * 2) {
      setDisplay1(600); 
// there must be a more efficient way...
      umo = createShape(GROUP);
      ellipseMode(RADIUS);
      PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
      setType("straight");
      body.setFill(color(0, 255, 0));
      rectMode(CORNER);
      PShape gun1 = createShape(RECT, -getRadius()/3, 0, 2*getRadius()/3, 1.5*getRadius());
      gun1.setFill(color(0));
      rectMode(CORNER);
      PShape gun2 = createShape(RECT, 0, getRadius()/3, 1.5*getRadius(), -2*getRadius()/3);
      gun2.setFill(color(0));
      rectMode(CORNER);
      PShape gun3 = createShape(RECT, getRadius()/3, 0, -2*getRadius()/3, -1.5*getRadius());
      gun3.setFill(color(0));
      rectMode(CORNER);
      PShape gun4 = createShape(RECT, 0, getRadius()/3, -1.5*getRadius(), -2*getRadius()/3);
      gun4.setFill(color(0));

      umo.addChild(gun1);
      umo.addChild(gun2);
      umo.addChild(gun3);
      umo.addChild(gun4);
      umo.addChild(body);
    } 
    if (getDisplay1() > 0 ) {
      setDisplay1(getDisplay1() - 1);
      text("Boss is ANGRY", player.getX(), player.getY() - displayHeight/2 + 2*unit);
    }

    if (getHealth() < getMaxHealth() / 3) {
    }
  }

  boolean canEvolve() {
    return false;
  }

  void enemyDie() {
    setGameState(WON);
  }

  int getDisplay1() {
    return display1;
  }
  void setDisplay1(int display1) {
    this.display1 = display1;
  }

  int getDisplay2() {
    return display1;
  }
  void setDisplay2(int display2) {
    this.display2 = display2;
  }
}
