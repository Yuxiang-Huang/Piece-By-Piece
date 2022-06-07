class TripleShot extends Gunship {
  // player constructor 
  TripleShot(float x, float y) {
    super(x, y);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, -15));
    getGuns().add(new Gun(this, 0));
    getGuns().add(new Gun(this, 15));
    setShootCooldown(0);

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
    //PShape gun1 = createShape(QUAD, (-getRadius()/3*cos(radians(-15)))-())
    rectMode(CORNER);
    PShape gun2 = createShape(RECT, -getRadius()/3, getRadius()/3, 2*getRadius()/3, 1.3*getRadius());
    gun2.setFill(color(0));


    //umo.addChild(gun1);
    umo.addChild(gun2);
    //umo.addChild(gun3);
    umo.addChild(body);
  }

  // enemy constructor
  TripleShot() {
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
    return false;
  }
}
