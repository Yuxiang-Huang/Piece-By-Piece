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
  // player constructor
  QuadTank(float x, float y) {
    super(x, y);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    getGuns().add(new Gun(this, 90));
    getGuns().add(new Gun(this, 180));
    getGuns().add(new Gun(this, 270));

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
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


  // enemy constructor
  QuadTank(int levelHolder) {
    super(levelHolder);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    getGuns().add(new Gun(this, 90));
    getGuns().add(new Gun(this, 180));
    getGuns().add(new Gun(this, 270));

    // make shape of gunship
    umo = createShape(GROUP);

    ellipseMode(RADIUS);
    PShape body = createShape(ELLIPSE, 0, 0, getRadius(), getRadius());
    body.setFill(color(165, 42, 42));
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

  boolean canEvolve() {
    return false;
  }
}

class TwinFlank extends Gunship {
  // player constructor 
  TwinFlank(float x, float y) {
    super(x, y);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 3));
    getGuns().add(new Gun(this, -3));
    getGuns().add(new Gun(this, 177));
    getGuns().add(new Gun(this, -177));

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

  // enemy constructor
  TwinFlank(int levelHolder) {
    super(levelHolder);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 3));
    getGuns().add(new Gun(this, -3));
    getGuns().add(new Gun(this, 177));
    getGuns().add(new Gun(this, -177));


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

  boolean canEvolve() {
    return false;
  }
}
