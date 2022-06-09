class QuadTank extends Gunship {  
  private int display1;
  private int display2;

  // boss constructor
  QuadTank(float x, float y) {
    super(x,y);
    setRadius(unit);
    position.set(x, y);
    setAngle(0);
    acceleration.set(unit*.01, unit*.01);
    setInvincible(60);

    setLevel(30);

    setShop(new Shop(this));

    // set stats base on level
    getShop().maxHealth.base = 600; //why not
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
      setType("straight");
      //spawn four gunships around you
<<<<<<< HEAD
      for (int x = 0; x < 4; x++) {
        Gunship Enemy = new Gunship(14);
        switch(x) {
        case 0:
          Enemy.setX(player.getX() + getRadius() * 30);
          Enemy.setY(player.getY());
          break;
        case 1:
          Enemy.setX(player.getX() - getRadius() * 30);
          Enemy.setY(player.getY());
          break;
        case 2:
          Enemy.setX(player.getX());
          Enemy.setY(player.getY() + getRadius() * 30);
          break;
        case 3:
=======
      for (int x = 0 ; x < 4; x++){
        Gunship Enemy = new Gunship(14);
        switch(x){
          case 0:
          Enemy.setX(player.getX() + getRadius() * 30);
          Enemy.setY(player.getY());
          break;
          case 1:
          Enemy.setX(player.getX() - getRadius() * 30);
          Enemy.setY(player.getY());
          break;
          case 2:
          Enemy.setX(player.getX());
          Enemy.setY(player.getY() + getRadius() * 30);
          break;
          case 3:
>>>>>>> main
          Enemy.setX(player.getX());
          Enemy.setY(player.getY() - getRadius() * 30);
          break;
        }
        enemies.add(Enemy);
      }
<<<<<<< HEAD

      //there must be a more efficient way...
      //Daniel, I just want to change the color of the body...
      umo = createShape(GROUP);
      ellipseMode(RADIUS);
      PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
      body.setFill(color(0, 255, 0));
=======
      
      //there must be a more efficient way...
//Daniel, I just want to change the color of the body...
      umo = createShape(GROUP);
      ellipseMode(RADIUS);
      PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
body.setFill(color(0, 255, 0));
>>>>>>> main
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
      textSize(unit*2);
      textAlign(CENTER);
      text("Boss is ANGRY!", player.getX(), player.getY() - displayHeight/2 + 2*unit);
      textAlign(LEFT);
      textSize(unit*3.0/4);
    }
<<<<<<< HEAD

=======
    
>>>>>>> main
    //last phase
    if (getType() == "straight" && getHealth() < getMaxHealth() / 3) {
      setDisplay1(0); 
      setDisplay2(600); 
      setType("predict");
      //spawn four types of ships around you
      Gunship enemy1 = new Twin(29);
      enemy1.setX(player.getX() + getRadius() * 30);
      enemy1.setY(player.getY() + getRadius() * 30);
      enemies.add(enemy1);
<<<<<<< HEAD

=======
      
>>>>>>> main
      Gunship enemy2 = new Sniper(29);
      enemy2.setX(player.getX() + getRadius() * 30);
      enemy2.setY(player.getY() - getRadius() * 30);
      enemies.add(enemy2);
<<<<<<< HEAD

=======
      
>>>>>>> main
      Gunship enemy3 = new MachineGun(29);
      enemy3.setX(player.getX() - getRadius() * 30);
      enemy3.setY(player.getY() + getRadius() * 30);
      enemies.add(enemy3);
<<<<<<< HEAD

=======
      
>>>>>>> main
      Gunship enemy4 = new FlankGuard(29);
      enemy4.setX(player.getX() - getRadius() * 30);
      enemy4.setY(player.getY() - getRadius() * 30);
      enemies.add(enemy4);
<<<<<<< HEAD

=======
      
>>>>>>> main
      // there must be a more efficient way...
      umo = createShape(GROUP);
      ellipseMode(RADIUS);
      PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
<<<<<<< HEAD
      body.setFill(color(255, 0, 255));
=======
body.setFill(color(255, 0, 255));
>>>>>>> main
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
<<<<<<< HEAD

=======
    
>>>>>>> main
    if (getDisplay2() > 0 ) {
      setDisplay2(getDisplay2() - 1);
      textSize(unit*2);
      textAlign(CENTER);
      text("Boss is ENRAGED!!!", player.getX(), player.getY() - displayHeight/2 + 2*unit);
      textAlign(LEFT);
      textSize(unit*3.0/4);
    }
<<<<<<< HEAD

    //escape mode. Sike, this is the last stage
    if (getHealth() < getMaxHealth() / 6) {
=======
    
    //escape mode. Sike, this is the last stage
    if (getHealth() < getMaxHealth() / 6){
>>>>>>> main
      setDisplay2(0);
      textSize(unit*2);
      textAlign(CENTER);
      text("Boss is Escaping...", player.getX(), player.getY() - displayHeight/2 + 2*unit);
      textAlign(LEFT);
      textSize(unit*3.0/4);
<<<<<<< HEAD

=======
      
>>>>>>> main
      setType("escape");
      umo = createShape(GROUP);
      ellipseMode(RADIUS);
      PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
<<<<<<< HEAD
      body.setFill(color(255));
=======
body.setFill(color(255));
>>>>>>> main
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
  }

  boolean canEvolve() {
    return false;
  }

  void enemyDie() {
    enemies.remove(this);
    setGameState(WON);
  }

  int getDisplay1() {
    return display1;
  }
  void setDisplay1(int display1) {
    this.display1 = display1;
  }

  int getDisplay2() {
    return display2;
  }
  void setDisplay2(int display2) {
    this.display2 = display2;
  }
}
