class PlayerGunship extends Gunship { 
  // player constructor
  PlayerGunship(int level) { //level for respawn mechanic
    super(level);
    position.set(width/2, height/2);
    setMinimap(new Minimap(this)); 
    setNumberOfEvolutions(4);
  }
  
  void display() {
    //rotate
    pushMatrix();
    translate(getX(), getY());
    rotate(getAngle()-HALF_PI); // dont know why HALF_PI is necesassary. But if not present, rotation is of by 90 degrees.
    scale(getRadius()/unit);
    if (getInvincible() > 1) {
      if (getInvincible() % 2 == 0) {
        shape(umo, 0, 0);
      } else {
        //umo.setFill(color(255));
        //shape(umo, 0, 0);
        //umo.setFill(color(165, 42, 42));
      }
    } else {
      shape(umo, 0, 0);
    }
    popMatrix();

    if (getHealth() != getMaxHealth()) {
      displayHealthBar();
    }

    displayExpBar();
    if (canEvolve()) {
      displayEvolutions();
    }

    if (DEBUG) {
      text(""+getHealth(), getX() - unit, getY());
      text("x: "+round(getX()) + "; y: "+round(getY()), getX()+unit*2, getY()-unit*2);
      text("dx: "+round(getDX()) + "; dy: "+round(getDY()), getX()+unit*2, getY()-unit);
      text("mag: "+round(velocity.mag()), getX()+unit*2, getY());
      text("shootCooldown: "+getShootCooldown(), getX()+unit*2, getY()+unit);
      text("Level: "+getLevel() + "; Exp: "+getExp() + "; SP: "+getSkillPoints(), getX()+unit*2, getY()+unit*2);
      text("timeSinceLastHit: "+getTimeSinceLastHit(), getX()+unit*2, getY()+unit*3);
      text("maxHealth: "+getMaxHealth(), getX()+unit*2, getY()+unit*4);
      text("collisionDamage: "+getCollisionDamage(), getX()+unit*2, getY()+unit*5);
      text("AutoFire: "+getAutoFire() + "; AutoRotate: "+getAutoRotate(), getX()+unit*2, getY()+unit*6);
      text("Invincible: "+getInvincible(), getX()+unit*2, getY()+unit*7);
      text("radius: "+getRadius(), getX()+unit*2, getY()+unit*8);
    }
  }
  
  /**
   Loops over all bullets, updates and displays them,
   Decrements shoot cooldown by 1,
   Levels up if it has enough exp,
   Regens health,
   Decrments hit cooldown by 1,
   Dies if health is at 0,
   Applies acceleration from Controller, velocity, and friction
   checks for collisions with Polygons and Borders
   */
  void update() {
    if (getInvincible() > 0) {
      setInvincible(getInvincible() - 1);
    }

    // check for what directions are being pressed
    float xdir = 0;
    float ydir = 0;
    if (input.inputs[0]) { // LEFT
      xdir = -1;
    }
    if (input.inputs[1]) { // UP
      ydir = -1;
    }
    if (input.inputs[2]) { // RIGHT
      xdir = 1;
    }
    if (input.inputs[3]) { // DOWN
      ydir = 1;
    }

    PVector accelerationNow = new PVector(acceleration.x*xdir, acceleration.y*ydir);
    //apply acceleration
    if (xdir != 0 && ydir != 0) {
      accelerationNow.mult(1.0/sqrt(2));
    }
    velocity.add(accelerationNow);

    //don't fly
    if (velocity.mag() > unit/2) {
      velocity.setMag(unit/2);
    }

    // apply velocity
    position.add(velocity);

    // apply friction
    velocity.mult(getFriction());

    if (getAutoRotate()) {
      autoRotate();
    } else {
      setAngle(getAngleToMouse());
    } 

    if (getAutoFire()) {
      autoFire();
    }
    // update all guns
    for (Gun gun : getGuns()) {
      gun.update();
    }

    // decrement shoot cooldown by 1
    if (getShootCooldown() > 0) {
      setShootCooldown(getShootCooldown()-1);
    }

    // check if player has enough exp for level up
    if (getExp() >= getExpRequiredForNextLevel() && player.getLevel() < 30) {
      setExp(getExp()-getExpRequiredForNextLevel());
      setLevel(getLevel()+1);
      setSkillPoints(getSkillPoints()+1);
      //increase stats upon level up
      getShop().maxHealth.base += 2;
      setRadius(unit * pow(1.01, getLevel()-1)); //confirmed from wiki
      acceleration.mult(0.985); //confirmed from website
      getShop().update(); // to update maxHealth;
    }   

    heal();

    // check for collisions
    collisionWithBorder();
    collisionWithUMO();

    if (getTimeSinceLastHit() > 0) {
      setTimeSinceLastHit(getTimeSinceLastHit() - 1);
    }

    if (int(getHealth()) == 0) {
      die();
    }

    if (player.getHealth() == 0) {
      setGameState(LOST);
    }
  }
  
  void die() {
    setInvincible(0);
    setGameState(LOST);
  }  
  
  void displayEvolutions() {
    GameScreen.smallText(CENTER);

    text("EVOLVE", getX()-(displayWidth/2)+(unit*5.5), getY()-(displayHeight/2)+(unit*2));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*5), unit*2, unit*2);
    shape(new PlayerTwin(0, 0, getLevel()).umo, getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*4.5));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*5), unit*2, unit*2);
    shape(new PlayerSniper(0, 0, getLevel()).umo, getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*4.5));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*10), unit*2, unit*2);
    shape(new PlayerMachineGun(0, 0, getLevel()).umo, getX()-(displayWidth/2)+(unit*3), getY()-(displayHeight/2)+(unit*10));

    fill(200, 230);
    rectMode(RADIUS);
    rect(getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*10), unit*2, unit*2);
    shape(new PlayerFlankGuard(0, 0, getLevel()).umo, getX()-(displayWidth/2)+(unit*8), getY()-(displayHeight/2)+(unit*10));

    GameScreen.resetText();
  }

  void evolve(char evolution) {
    PlayerGunship newPlayer = player;
    switch(key) {
    case '1': 
      newPlayer = new PlayerTwin(player.getX(), player.getY(), getLevel()); 
      break;
    case '2': 
      unit*=.8; // increase fov
      newPlayer = new PlayerSniper(player.getX(), player.getY(), getLevel()); 
      break;
    case '3': 
      newPlayer = new PlayerMachineGun(player.getX(), player.getY(), getLevel()); 
      break;
    case '4': 
      newPlayer = new PlayerFlankGuard(player.getX(), player.getY(), getLevel()); 
      break;
    }
    newPlayer.velocity = player.velocity;
    newPlayer.setShop(player.getShop());
    newPlayer.getShop().gunship = newPlayer;
    newPlayer.setSkillPoints(player.getSkillPoints());
    newPlayer.setRadius(player.getRadius());
    newPlayer.setHealth(player.getHealth());
    newPlayer.setShootCooldown(player.getShootCooldown());
    newPlayer.setTimeSinceLastHit(player.getTimeSinceLastHit());
    player = newPlayer;
    player.updateStats();
    getShop().update();
  }
}
  
  
