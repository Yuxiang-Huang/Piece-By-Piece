class EnemyTwin extends EnemyGunship {
  // enemy constructor
  EnemyTwin(int level) {
    super(level);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 3));
    getGuns().add(new Gun(this, -3));

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    int rand = int(random(3));
    if (rand == 0) {
      setType("straight");
      body.setFill(color(0, 255, 0));
    } else if (rand == 1) {
      setType("random");
      //cyan
      body.setFill(color(0, 255, 255));
    } else {
      setType("predict");
      //magenta
      body.setFill(color(255, 0, 255));
    }
    rectMode(CORNER);
    PShape gun1 = createShape(RECT, -1, 0, -unit*2/3, unit*2);
    gun1.setFill(color(0));
    PShape gun2 = createShape(RECT, 1, 0, unit*2/3, unit*2);
    gun2.setFill(color(0));

    umo.addChild(gun1);
    umo.addChild(gun2);
    umo.addChild(body);

    updateStats();
    getShop().update();
  }

  boolean canEvolve() {
    return false;
  }

  void updateStats() {
    getShop().getBulletPenetration().setBase(getShop().getBulletPenetration().getBase()*0.9);
    getShop().getBulletPenetration().setModifier(getShop().getBulletPenetration().getModifier()*0.9);

    getShop().getBulletDamage().setBase(getShop().getBulletDamage().getBase()*0.65);
    getShop().getBulletDamage().setModifier(getShop().getBulletDamage().getModifier()*0.65);
  }
}

class EnemySniper extends EnemyGunship {
  // enemy constructor
  EnemySniper(int levelHolder) {
    super(levelHolder);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    int rand = int(random(3));
    if (rand == 0) {
      setType("straight");
      body.setFill(color(0, 255, 0));
    } else if (rand == 1) {
      setType("random");
      //cyan
      body.setFill(color(0, 255, 255));
    } else {
      setType("predict");
      //magenta
      body.setFill(color(255, 0, 255));
    }
    rectMode(CORNERS);
    PShape gun = createShape(RECT, -unit/3, 0, unit/3, unit*2);
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);
    updateStats();
    getShop().update();
  }

  boolean canEvolve() {
    return false;
  }

  void updateStats() {
    getShop().getBulletSpeed().setBase(getShop().getBulletSpeed().getBase()*1.5);
    getShop().getBulletSpeed().setModifier(getShop().getBulletSpeed().getModifier()*1.5);

    getShop().getBulletDamage().setBase(getShop().getBulletDamage().getBase()*1.5);
    getShop().getBulletDamage().setModifier(getShop().getBulletDamage().getModifier()*1.5);

    getShop().getReload().setBase(getShop().getReload().getBase()*2.0);
    getShop().getReload().setModifier(getShop().getReload().getModifier()*2.0);
  }
}

class EnemyMachineGun extends EnemyGunship{
  // enemy constructor
  EnemyMachineGun(int levelHolder) {
    super(levelHolder);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));

    // make shape of gunship
    umo = createShape(GROUP);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    int rand = int(random(3));
    if (rand == 0) {
      setType("straight");
      body.setFill(color(0, 255, 0));
    } else if (rand == 1) {
      setType("random");
      //cyan
      body.setFill(color(0, 255, 255));
    } else {
      setType("predict");
      //magenta
      body.setFill(color(255, 0, 255));
    }
    rectMode(CORNER);
    PShape gun = createShape(TRIANGLE, 0, 0, -unit, 1.5*unit, unit, 1.5*unit);
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);
    updateStats();
    getShop().update();
    setSpread(0.3);
  }

  boolean canEvolve() {
    return false;
  }

  void updateStats() {
    getShop().getReload().setBase(getShop().getReload().getBase()/2.0);
    getShop().getReload().setModifier(getShop().getReload().getModifier()/2.0);

    getShop().getBulletDamage().setBase(getShop().getBulletDamage().getBase()*.7);
    getShop().getBulletDamage().setModifier(getShop().getBulletDamage().getModifier()*.7);

    setSpread(.5);
  }
}

class EnemyFlankGuard extends EnemyGunship {
  // enemy constructor
  EnemyFlankGuard(int levelHolder) {
    super(levelHolder);
    setRecoilMode("none");
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    getGuns().add(new Gun(this, 180));

    // make shape of gunship
    umo = createShape(GROUP);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    int rand = int(random(3));
    if (rand == 0) {
      setType("straight");
      body.setFill(color(0, 255, 0));
    } else if (rand == 1) {
      setType("random");
      //cyan
      body.setFill(color(0, 255, 255));
    } else {
      setType("predict");
      //magenta
      body.setFill(color(255, 0, 255));
    }
    rectMode(CORNER);
    PShape gun1 = createShape(RECT, -unit/3, 0, 2*unit/3, 1.5*unit);
    gun1.setFill(color(0));
    rectMode(CORNER);
    PShape gun2 = createShape(RECT, unit/3, 0, -2*unit/3, -1.3*unit);
    gun2.setFill(color(0));

    umo.addChild(gun1);
    umo.addChild(gun2);
    umo.addChild(body);
    updateStats();
    getShop().update();
  }

  boolean canEvolve() {
    return false;
  }
}
