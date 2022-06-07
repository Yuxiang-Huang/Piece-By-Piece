class Twin extends Gunship {
  // player constructor 
  Twin(float x, float y) {
    super(x, y);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 3));
    getGuns().add(new Gun(this, -3));
    setShootCooldown(0);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
    rectMode(CORNERS);
    PShape gun1 = createShape(RECT, -1, 0, -getRadius()*2/3, getRadius()*2);
    gun1.setFill(color(0));
    PShape gun2 = createShape(RECT, 1, 0, getRadius()*2/3, getRadius()*2);
    gun2.setFill(color(0));

    umo.addChild(gun1);
    umo.addChild(gun2);
    umo.addChild(body);
  }

  // enemy constructor
  Twin() {
    super();
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 3));
    getGuns().add(new Gun(this, -3));
    setShootCooldown(0);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
    rectMode(CORNERS);
    PShape gun1 = createShape(RECT, -1, 0, -getRadius()*2/3, getRadius()*2);
    gun1.setFill(color(0));
    PShape gun2 = createShape(RECT, 1, 0, getRadius()*2/3, getRadius()*2);
    gun2.setFill(color(0));

    umo.addChild(gun1);
    umo.addChild(gun2);
    umo.addChild(body);
  }

  void evolve() {
  }
  boolean canEvolve() {
    return getLevel() >= 30;
  }
}

class Sniper extends Gunship {
  // player constructor 
  Sniper(float x, float y) {
    super(x, y);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    setShootCooldown(0);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
    rectMode(CORNERS);
    PShape gun = createShape(RECT, -getRadius()/3, 0, getRadius()/3, getRadius()*2);
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);
  }
  // enemy constructor
  Sniper() {
    super();
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    setShootCooldown(0);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
    rectMode(CORNERS);
    PShape gun = createShape(RECT, -getRadius()/3, 0, getRadius()/3, getRadius()*2);
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);
  }

  void evolve() {
  }
  boolean canEvolve() {
    return getLevel() >= 30;
  }
}

class MachineGun extends Gunship {
  // player constructor
  MachineGun(float x, float y) {
    super(x, y);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    setShootCooldown(0);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
    rectMode(CORNER);
    PShape gun = createShape(TRIANGLE, 0, 0, -getRadius(), 1.5*getRadius(), getRadius(), 1.5*getRadius());
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);
  }


  // enemy constructor
  MachineGun() {
    super();
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    setShootCooldown(0);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
    PShape gun = createShape(TRIANGLE, 0, 0, -getRadius(), 1.5*getRadius(), getRadius(), 1.5*getRadius());
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);
  }

  void evolve() {
  }
  boolean canEvolve() {
    return getLevel() >= 30;
  }
}

class FlankGuard extends Gunship {
  // player constructor
  FlankGuard(float x, float y) {
    super(x, y);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    getGuns().add(new Gun(this, 180));
    setShootCooldown(0);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
    rectMode(CORNER);
    PShape gun1 = createShape(RECT, -getRadius()/3, getRadius()/3, 2*getRadius()/3, 1.3*getRadius());
    gun1.setFill(color(0));
    rectMode(CORNER);
    PShape gun2 = createShape(RECT, getRadius()/3, -getRadius()/3, -2*getRadius()/3, -1*getRadius());
    gun2.setFill(color(0));

    umo.addChild(gun1);
    umo.addChild(gun2);
    umo.addChild(body);
  }


  // enemy constructor
  FlankGuard() {
    super();
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    getGuns().add(new Gun(this, 180));
    setShootCooldown(0);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
    rectMode(CORNER);
    PShape gun1 = createShape(RECT, -getRadius()/3, getRadius()/3, 2*getRadius()/3, 1.3*getRadius());
    gun1.setFill(color(0));
    rectMode(CORNER);
    PShape gun2 = createShape(RECT, getRadius()/3, -getRadius()/3, -2*getRadius()/3, -1.3*getRadius());
    gun2.setFill(color(0));

    umo.addChild(gun1);
    umo.addChild(gun2);
    umo.addChild(body);
  }

  void evolve() {
  }
  boolean canEvolve() {
    return getLevel() >= 30;
  }
}
