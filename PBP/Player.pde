class Player extends Gunship {
  
  void display() {
    //rotate
    setAngle(getAngleToMouse());
    pushMatrix();
    translate(getX(), getY());
    //translate(width/2, height/2);
    rotate(getAngle()-HALF_PI); // dont know why HALF_PI is necesassary. But if not present, rotation is of by 90 degrees. 
    scale(getRadius()/unit);
    shape(umo, 0, 0);
    popMatrix();

    if (getHealth() != getMaxHealth()) {
      displayHealthBar();
    }

    displayExpBar();

    if (DEBUG) {
      text(""+getHealth(), getX() - unit, getY());
      text("x: "+round(getX()) + "; y: "+round(getY()), getX()+unit*2, getY()-unit*2);
      text("dx: "+round(getDX()) + "; dy: "+round(getDY()), getX()+unit*2, getY()-unit);
      text("mag: "+round(velocity.mag()), getX()+unit*2, getY());
      text("shootCooldown: "+getShootCooldown(), getX()+unit*2, player.getY()+unit);
      text("Level: "+getLevel() + "; Exp: "+getExp(), getX()+unit*2, getY()+unit*2);
      text("timeSinceLastHit: "+getTimeSinceLastHit(), getX()+unit*2, getY()+unit*3);
      text("maxHealth: "+getMaxHealth(), getX()+unit*2, getY()+unit*4);
    }  
  }
  
    void update() {
    // update and display all bullets
    for (int b = 0; b < bullets.size(); b++) {
      Bullet bullet = bullets.get(b);
      bullet.update();
      bullet.display();
    }

    // decrement shoot cooldown by 1
    if (shootCooldown > 0) {
      setShootCooldown(getShootCooldown()-1);
    }

    // check if gunship has enough exp for level up
    if (getExp() >= getExpRequiredForNextLevel()) {
      setExp(getExp()-getExpRequiredForNextLevel());
      setLevel(getLevel()+1);
      setSkillPoints(getSkillPoints()+1);
      //increase stats upon level up
      shop.maxHealth.base += 2;
      setRadius(getRadius() * 1.01); //confirmed from wiki
      acceleration.mult(0.985); //confirmed from website
      shop.update(); // to update maxHealth;
    }  

    heal();

    if (getTimeSinceLastHit() > 0) {
      setTimeSinceLastHit(getTimeSinceLastHit() - 1);
    }

    //should be in UMO.update
    if (int(getHealth()) == 0) {
      die();
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

    //apply acceleration
    velocity.add(new PVector(acceleration.x*xdir, acceleration.y*ydir));
    if (velocity.mag() > getMaxSpeed()) {
      velocity.setMag(getMaxSpeed());
    }

    // apply velocity
    position.add(velocity);
    //pos.add(new PVector(-velocity.x, -velocity.y));

    // apply friction
    if (!input.inputs[0] && !input.inputs[1] && !input.inputs[2] && !input.inputs[3]) {
      velocity.mult(getFriction());
    }

    // check for collisions
    collisionWithBorder();
    collisionWithUMO();

    // update and display all bullets
    for (int b = 0; b < bullets.size(); b++) {
      Bullet bullet = bullets.get(b);
      bullet.update();
      bullet.display();
    }

    // decrement shoot cooldown by 1
    if (shootCooldown > 0) {
      setShootCooldown(getShootCooldown()-1);
    }

    // check if gunship has enough exp for level up
    if (getExp() >= getExpRequiredForNextLevel()) {
      setExp(getExp()-getExpRequiredForNextLevel());
      setLevel(getLevel()+1);
      setSkillPoints(getSkillPoints()+1);
      //increase stats upon level up
      setMaxHealth((int)getMaxHealth() + 2);
      setHealth(getHealth() + 2);
      setRadius(getRadius() * 1.07); //not confirmed
    }  

    if (int(getHealth()) == 0) {
      die();
    }

    heal();
    if (getTimeSinceLastHit() > 0) {
      setTimeSinceLastHit(getTimeSinceLastHit() - 1);
    }
  }
  
}
