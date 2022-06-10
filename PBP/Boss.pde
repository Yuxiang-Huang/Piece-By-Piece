class QuadTank extends Gunship {  
  private int display1;
  private int display2;

  // boss constructor
  QuadTank(float x, float y) {
    super(x, y, 30);
    setRecoilMode("none");
    setRadius(unit);
    position.set(x, y);
    setAngle(0);
    acceleration.set(unit*.01, unit*.01);
    setInvincible(60);

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

    setType("random");
    createGunship(color(0, 255, 255));
  }

  void enemyUpdate() {
    super.enemyUpdate();
    //second phase
    if (getType() == "random" && getHealth() < getMaxHealth() / 3 * 2) {
      setDisplay1(600); 
      setType("straight");
      //spawn four gunships around you
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
          Enemy.setX(player.getX());
          Enemy.setY(player.getY() - getRadius() * 30);
          break;
        }
        enemies.add(Enemy);
      }

      createGunship(color(0, 255, 0));
    } 
    if (getDisplay1() > 0 ) {
      setDisplay1(getDisplay1() - 1);
      GameScreen.mediumText(CENTER);
      text("Boss is ANGRY!", player.getX(), player.getY() - displayHeight/2 + 2*unit);
      GameScreen.resetText();
    }

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

      Gunship enemy2 = new Sniper(29);
      enemy2.setX(player.getX() + getRadius() * 30);
      enemy2.setY(player.getY() - getRadius() * 30);
      enemies.add(enemy2);

      Gunship enemy3 = new MachineGun(29);
      enemy3.setX(player.getX() - getRadius() * 30);
      enemy3.setY(player.getY() + getRadius() * 30);
      enemies.add(enemy3);

      Gunship enemy4 = new FlankGuard(29);
      enemy4.setX(player.getX() - getRadius() * 30);
      enemy4.setY(player.getY() - getRadius() * 30);
      enemies.add(enemy4);

      createGunship(color(255, 0, 255));
    }

    if (getDisplay2() > 0 ) {
      setDisplay2(getDisplay2() - 1);
      GameScreen.mediumText(CENTER);
      text("Boss is ENRAGED!!!", player.getX(), player.getY() - displayHeight/2 + 2*unit);
      GameScreen.resetText();
    }

    //escape mode. Sike, this is the last stage
    if (getType().equals("predict") && getHealth() < getMaxHealth() / 6) {
      setDisplay2(0);
      GameScreen.mediumText(CENTER);
      text("Boss is Escaping...", player.getX(), player.getY() - displayHeight/2 + 2*unit);
      GameScreen.resetText();
      setType("escape");
      createGunship(color(255));
    }

    //do you really think there is a last stage?
    if (getType().equals("escape") && getHealth() > getMaxHealth() / 6) {
      setType("predict");
      createGunship(color(255, 0, 255));
    }
  }

  boolean canEvolve() {
    return false;
  }

  void enemyDie() {
    enemies.remove(this);
    boss = null;
    setTimeUntilBossSpawn(600);
    
    setBossMode(2);
    player.setLevel(45);
    shop.maxHealth.base = 50 + 2*(getLevel() - 1);
    setRadius(unit * pow(1.01, getLevel()-1));

    acceleration.mult(pow(0.985, (getLevel() - 1))); //confirmed from website
    setSkillPoints(getLevel() - 1);

    getShop().update();
    setHealth(getMaxHealth());
    PBP.setDisplayTime(600);
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

  void createGunship(color c) {
    umo = createShape(GROUP);
    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(c);
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

///////////////////////////////////////////////////////////////////////////////////////////////

class TwinFlank extends Gunship {  
  private int display1;

  // boss constructor
  TwinFlank(float x, float y) {
    super(x, y, 57);
    setRecoilMode("none");
    setRadius(unit);
    position.set(x, y);
    setAngle(0);
    acceleration.set(unit*.01, unit*.01);
    setInvincible(60);

    setShop(new Shop(this));

    // set stats base on level
    getShop().maxHealth.base = 900; //why not
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

    setType("ghost");
    createGunship(color(0));
  }

  void enemyUpdate() {
    super.enemyUpdate();
    //second phase
    if (getType() == "ghost" && getHealth() < getMaxHealth() / 2) {
      setDisplay1(600); 
      setType("predict");
      //spawn eight gunships around you
      for (int x = 0; x < 4; x++) {
        Gunship Enemy = new Gunship(45);
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
          Enemy.setX(player.getX());
          Enemy.setY(player.getY() - getRadius() * 30);
          break;
        }
        enemies.add(Enemy);
      }
      
      Gunship enemy1 = new Twin(45);
      enemy1.setX(player.getX() + getRadius() * 30);
      enemy1.setY(player.getY() + getRadius() * 30);
      enemies.add(enemy1);

      Gunship enemy2 = new Sniper(45);
      enemy2.setX(player.getX() + getRadius() * 30);
      enemy2.setY(player.getY() - getRadius() * 30);
      enemies.add(enemy2);

      Gunship enemy3 = new MachineGun(45);
      enemy3.setX(player.getX() - getRadius() * 30);
      enemy3.setY(player.getY() + getRadius() * 30);
      enemies.add(enemy3);

      Gunship enemy4 = new FlankGuard(45);
      enemy4.setX(player.getX() - getRadius() * 30);
      enemy4.setY(player.getY() - getRadius() * 30);
      enemies.add(enemy4);

      createGunship(color(255, 0, 255));
    } 
    if (getDisplay1() > 0 ) {
      setDisplay1(getDisplay1() - 1);
      GameScreen.mediumText(CENTER);
      text("Boss is FURIOUS!!!!!", player.getX(), player.getY() - displayHeight/2 + 2*unit);
      GameScreen.resetText();
    }

    //escape mode.
    if (getType().equals("predict") && getHealth() < getMaxHealth() / 6) {
      setDisplay1(0);
      GameScreen.mediumText(CENTER);
      text("Boss is Escaping...", player.getX(), player.getY() - displayHeight/2 + 2*unit);
      GameScreen.resetText();
      setType("escape");
      createGunship(color(255));
    }

    //do you really think there is a last stage?
    if (getType().equals("escape") && getHealth() > getMaxHealth() / 6) {
      setType("predict");
      createGunship(color(255, 0, 255));
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

  void createGunship(color c) {
    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
    rectMode(CORNERS);
    PShape gun1 = createShape(RECT, -1, 0, -getRadius()*2/3, getRadius()*2);
    gun1.setFill(color(0));
    rectMode(CORNERS);
    PShape gun2 = createShape(RECT, 1, 0, getRadius()*2/3, getRadius()*2);
    gun2.setFill(color(0));
    rectMode(CORNERS);
    PShape gun3 = createShape(RECT, -1, 0, -getRadius()*2/3, -getRadius()*2);
    gun1.setFill(color(0));
    rectMode(CORNERS);
    PShape gun4 = createShape(RECT, 1, 0, getRadius()*2/3, -getRadius()*2);
    gun2.setFill(color(0));

    umo.addChild(gun1);
    umo.addChild(gun2);
    umo.addChild(gun3);
    umo.addChild(gun4);
    umo.addChild(body);
  }
}
