class QuadTank extends Gunship { //<>//
  private int display1;
  private int display2;

  // boss constructor
  QuadTank(float x, float y) {
    super(x, y, 30);
    //!hard mode!
    //super(x, y, 45);
    setRecoilMode("none");
    setRadius(unit);
    position.set(x, y);
    setAngle(0);
    acceleration.set(unit*.01, unit*.01);
    setInvincible(60);

    setShop(new Shop(this));

    // set stats base on level
    getShop().maxHealth.base = 900; //why not
    getShop().getMaxHealth().setModifier(50);
    setRadius(unit * pow(1.01, getLevel() - 1)); //confirmed from wiki  
    acceleration.mult(pow(0.985, (getLevel() - 1))); //confirmed from website
    setSkillPoints(getLevel() - 1);

    getShop().getReload().setBase(getShop().getReload().getBase()/1.5);
    getShop().getReload().setModifier(getShop().getReload().getModifier()/1.5);

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

  void enemyUpdate() { //<>//
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
    //last phase
    else if (getType() == "straight" && getHealth() < getMaxHealth() / 3) {
      setDisplay1(0); 
      setDisplay2(600); 
      setType("predict");
      //spawn four types of ships around you
      Gunship enemy1 = new Twin(29);
      enemy1.setX(player.getX() + getRadius() * 30);
      enemy1.setY(player.getY() + getRadius() * 30);
      enemies.add(enemy1);

      Gunship enemy2 = new Sniper(29);
      enemy2.setX(player.getX() - getRadius() * 30);
      enemy2.setY(player.getY() + getRadius() * 30);
      enemies.add(enemy2);

      Gunship enemy3 = new MachineGun(29);
      enemy3.setX(player.getX() + getRadius() * 30);
      enemy3.setY(player.getY() - getRadius() * 30);
      enemies.add(enemy3);

      Gunship enemy4 = new FlankGuard(29);
      enemy4.setX(player.getX() - getRadius() * 30);
      enemy4.setY(player.getY() - getRadius() * 30);
      enemies.add(enemy4);

      if (! enemy1.getType().equals("predict") && ! enemy2.getType().equals("predict") && ! enemy4.getType().equals("predict")) {
        enemy3.setType("predict");
      }

      createGunship(color(255, 0, 255));
    }

    //escape mode. Sike, this is the last stage
    else if (getType().equals("predict") && getHealth() < getMaxHealth() / 6) {
      setDisplay2(0);
      setType("escape");
      createGunship(color(255));
    }

    //do you really think there is a last stage?
    if (getType().equals("escape") && getHealth() > getMaxHealth() / 3) {
      setType("predict");
      createGunship(color(255, 0, 255));
    }

    if (getType().equals("escape")) {
      if (abs(getX()-player.getX()) < (displayWidth/2)-getRadius() && abs(getY()-player.getY()) < (displayHeight/2)-getRadius()) {
        if (getX() - getRadius() < unit || getX() + getRadius() > width - unit || 
          getY() - getRadius() < unit || getY() + getRadius() > height - unit) {
          setType("ghost");
          getShop().getReload().setBase(getShop().getReload().getBase()*1.5/2);
          getShop().getReload().setModifier(getShop().getReload().getModifier()*1.5/2);
          createGunship(color(0));
          //no regen everything else full power
          getShop().getMaxHealth().setLevel(7);
          getShop().getBodyDamage().setLevel(7);
          getShop().getBulletSpeed().setLevel(7);
          getShop().getBulletPenetration().setLevel(7);
          getShop().getReload().setLevel(7);
          getShop().getMovementSpeed().setLevel(7);
          getShop().getHealthRegen().setModifier(0);
          getShop().getHealthRegen().setBase(0);
        }
      }
    }
  }

  boolean canEvolve() {
    return false;
  }

  void enemyDisplay() {
    super.enemyDisplay();
    if (getDisplay1() > 0 ) {
      setDisplay1(getDisplay1() - 1);
      GameScreen.mediumText(CENTER);
      text("Boss is ANGRY!", player.getX(), player.getY() - displayHeight/2 + 2*unit);
      GameScreen.resetText();
    } else if (getDisplay2() > 0 ) {
      setDisplay2(getDisplay2() - 1);
      GameScreen.mediumText(CENTER);
      text("Boss is ENRAGED!!!", player.getX(), player.getY() - displayHeight/2 + 2*unit);
      GameScreen.resetText();
    } else if (getType().equals("escape")) {
      GameScreen.mediumText(CENTER);
      text("Boss is Escaping...", player.getX(), player.getY() - displayHeight/2 + 2*unit);
      GameScreen.resetText();
    } else if (getType().equals("ghost")) {
      GameScreen.mediumText(CENTER);
      text("Last Fight!!!!!", player.getX(), player.getY() - displayHeight/2 + 2*unit);
      GameScreen.resetText();
    }
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
