class Twin extends Gunship {
  // player constructor 
  Twin(float x, float y) {
    super(x, y);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 3));
    getGuns().add(new Gun(this, -3));

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
    PShape gun1 = createShape(RECT, -1, 0, -getRadius()*2/3, getRadius()*2);
    gun1.setFill(color(0));
    PShape gun2 = createShape(RECT, 1, 0, getRadius()*2/3, getRadius()*2);
    gun2.setFill(color(0));

    umo.addChild(gun1);
    umo.addChild(gun2);
    umo.addChild(body);
  }

  void displayEvolutions() {
    fill(0);
    textSize(unit);
    textAlign(CENTER);

    text("EVOLVE", getX()-(displayWidth/2)+(unit*5.5), getY()-(displayHeight/2)+(unit*2));


    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*5), unit*2, unit*2);
    //shape(new TripleShot().umo, getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*4.5));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*5), unit*2, unit*2);
    shape(new QuadTank(1).umo, getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*4.5));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*6), getY()-(displayHeight/2)+(unit*10), unit*2, unit*2);
    shape(new TwinFlank(1).umo, getX()-(displayWidth/2)+(unit*6), getY()-(displayHeight/2)+(unit*10));

    GameScreen.resetText();
  }

  void evolve(char evolution) {
    Gunship newPlayer = player;
    switch(key) {
    case '1': 
      //newPlayer = new TripleShot(player.getX(), player.getY()); 
      break;
    case '2': 
      newPlayer = new QuadTank(player.getX(), player.getY()); 
      break;
    case '3': 
      newPlayer = new TwinFlank(player.getX(), player.getY()); 
      break;
    }
    newPlayer.velocity = player.velocity;
    newPlayer.setLevel(player.getLevel());
    newPlayer.setShop(player.getShop());
    newPlayer.getShop().gunship = newPlayer;
    newPlayer.setSkillPoints(player.getSkillPoints());
    newPlayer.setRadius(player.getRadius());
    player = newPlayer;
  }

  boolean canEvolve() {
    //return getLevel() >= 30;
    return false;
  }
}

class Sniper extends Gunship {
  // player constructor 
  Sniper(float x, float y) {
    super(x, y);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));

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
  Sniper(int levelHolder) {
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
    PShape gun = createShape(RECT, -getRadius()/3, 0, getRadius()/3, getRadius()*2);
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);
  }

  void evolve() {
  }
  boolean canEvolve() {
    //return getLevel() >= 30;
     return false;
  }
}

class MachineGun extends Gunship {
  // player constructor
  MachineGun(float x, float y) {
    super(x, y);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));


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
    PShape gun = createShape(TRIANGLE, 0, 0, -getRadius(), 1.5*getRadius(), getRadius(), 1.5*getRadius());
    gun.setFill(color(0));

    umo.addChild(gun);
    umo.addChild(body);
  }

  void evolve() {
  }
  boolean canEvolve() {
    //return getLevel() >= 30;
     return false;
  }
}

class FlankGuard extends Gunship {
  // player constructor
  FlankGuard(float x, float y) {
    super(x, y);
    setGuns(new ArrayList<Gun>());
    getGuns().add(new Gun(this, 0));
    getGuns().add(new Gun(this, 180));

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
  FlankGuard(int levelHolder) {
    super(levelHolder);
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
    PShape gun1 = createShape(RECT, -getRadius()/3, 0, 2*getRadius()/3, 1.5*getRadius());
    gun1.setFill(color(0));
    rectMode(CORNER);
    PShape gun2 = createShape(RECT, getRadius()/3, 0, -2*getRadius()/3, -1.3*getRadius());
    gun2.setFill(color(0));

    umo.addChild(gun1);
    umo.addChild(gun2);
    umo.addChild(body);
  }

  void displayEvolutions() {
    fill(0);
    textSize(unit);
    textAlign(CENTER);

    text("EVOLVE", getX()-(displayWidth/2)+(unit*5.5), getY()-(displayHeight/2)+(unit*2));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*5), unit*2, unit*2);
    //shape(new TripleShot().umo, getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*4.5));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*5), unit*2, unit*2);
    //shape(new QuadTank().umo, getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*4.5));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*10), unit*2, unit*2);
    shape(new TwinFlank(1).umo, getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*10));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*10), unit*2, unit*2);
    //shape(new Auto3().umo, getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*10));

    GameScreen.resetText();
  }

  void evolve(char evolution) {
    Gunship newPlayer = player;
    switch(key) {
    case '1': 
      //newPlayer = new TripleShot(player.getX(), player.getY()); 
      break;
    case '2': 
      newPlayer = new QuadTank(player.getX(), player.getY()); 
      break;
    case '3': 
      newPlayer = new TwinFlank(player.getX(), player.getY()); 
      break;
    case '4':
      //  newPlayer = new Auto3(player.getX(), player.getY());
      break;
    }
    newPlayer.velocity = player.velocity;
    newPlayer.setLevel(player.getLevel());
    newPlayer.setShop(player.getShop());
    newPlayer.getShop().gunship = newPlayer;
    newPlayer.setSkillPoints(player.getSkillPoints());
    newPlayer.setRadius(player.getRadius());
    player = newPlayer;
  }

  void evolve() {
  }
  boolean canEvolve() {
    //return getLevel() >= 30;
    return false;
  }
}
