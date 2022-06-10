class Twin extends Gunship {
  // player constructor 
  Twin(float x, float y, int level) {
    super(x, y, level);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 3));
    getGuns().add(new Gun(this, -3));

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    body.setFill(color(1, 178, 225));
    rectMode(CORNERS);
    PShape gun1 = createShape(RECT, -1, 0, -unit*2/3, unit*2);
    gun1.setFill(color(0));
    rectMode(CORNERS);
    PShape gun2 = createShape(RECT, 1, 0, unit*2/3, unit*2);
    gun2.setFill(color(0));

    umo.addChild(gun1);
    umo.addChild(gun2);
    umo.addChild(body);
  }

  // enemy constructor
  Twin(int levelHolder) {
    super(levelHolder);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 3));
    getGuns().add(new Gun(this, -3));

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    int rand = (int) (random(3));
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
  }

  boolean canEvolve() {
    return false;
  }
}

class Sniper extends Gunship {
  // player constructor 
  Sniper(float x, float y, int level) {
    super(x, y, level);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    body.setFill(color(1, 178, 225));
    rectMode(CORNERS);
    PShape gun = createShape(RECT, -unit/3, 0, unit/3, unit*2);
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);
  }
  // enemy constructor
  Sniper(int levelHolder) {
    super(levelHolder);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    int rand = (int) (random(3));
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
    PShape gun = createShape(RECT, -unit/3, 0, unit/3, unit*2);
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);
  }

  boolean canEvolve() {
    return false;
  }
}

class MachineGun extends Gunship {
  // player constructor
  MachineGun(float x, float y, int level) {
    super(x, y, level);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));


    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    body.setFill(color(1, 178, 225));
    rectMode(CORNER);
    PShape gun = createShape(TRIANGLE, 0, 0, -unit, 1.5*unit, unit, 1.5*unit);
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);
  }


  // enemy constructor
  MachineGun(int levelHolder) {
    super(levelHolder);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));

    // make shape of gunship
    umo = createShape(GROUP);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    int rand = (int) (random(3));
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
  }

  boolean canEvolve() {
    return false;
  }
}

class FlankGuard extends Gunship {
  // player constructor
  FlankGuard(float x, float y, int level) {
    super(x, y, level);
    setNoBulletPush(true);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    getGuns().add(new Gun(this, 180));

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    body.setFill(color(1, 178, 225));
    rectMode(CORNER);
    PShape gun1 = createShape(RECT, -unit/3, unit/3, 2*unit/3, 1.3*unit);
    gun1.setFill(color(0));
    rectMode(CORNER);
    PShape gun2 = createShape(RECT, unit/3, -unit/3, -2*unit/3, -1*unit);
    gun2.setFill(color(0));

    umo.addChild(gun1);
    umo.addChild(gun2);
    umo.addChild(body);
  }


  // enemy constructor
  FlankGuard(int levelHolder) {
    super(levelHolder);
    setNoBulletPush(true);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    getGuns().add(new Gun(this, 180));

    // make shape of gunship
    umo = createShape(GROUP);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, unit, unit);
    int rand = (int) (random(3));
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
  }

  boolean canEvolve() {
    return false;
  }
}
