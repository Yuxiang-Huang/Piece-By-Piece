class Controller {
  boolean[] inputs;

  public Controller() {
    inputs = new boolean[4]; // 4 valid buttons
  }

  boolean isPressed(int code) {
    return inputs[code];
  }

  void press(int code) {
    if (key == '`') {
      DEBUG = !DEBUG;
    }
    
    // Movement controls
    if (key == 'a' || keyCode == LEFT) {
      inputs[0] = true;
    }
    if (key == 'w' || keyCode == UP) {
      inputs[1] = true;
    } 
    if (key == 'd' || keyCode == RIGHT) {
      inputs[2] = true;
    }
    if (key == 's' || keyCode == DOWN) {
      inputs[3] = true;
    }

    // Shop upgrades
    if (player.getSkillPoints() > 0) {
      Shop shop = player.shop;
      if (key == '1' && !player.shop.healthRegen.isMaxLevel()) {
        player.shop.healthRegen.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '2' && !player.shop.maxHealth.isMaxLevel()) {
        player.shop.maxHealth.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '3' && !player.shop.bodyDamage.isMaxLevel()) {
        player.shop.bodyDamage.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '4' && !player.shop.bulletSpeed.isMaxLevel()) {
        player.shop.bulletSpeed.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '5' && !player.shop.bulletPenetration.isMaxLevel()) {
        player.shop.bulletPenetration.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '6' && !player.shop.bulletDamage.isMaxLevel()) {
        player.shop.bulletDamage.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '7' && !player.shop.reload.isMaxLevel()) {
        player.shop.reload.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '8' && !player.shop.movementSpeed.isMaxLevel()) {
        player.shop.movementSpeed.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
    }
  }


  void release(int code) {
    if (key == 'a' || keyCode == LEFT) {
      inputs[0] = false;
    }
    if (key == 'w' || keyCode == UP) {
      inputs[1] = false;
    }   
    if (key == 'd' || keyCode == RIGHT) {
      inputs[2] = false;
    }
    if (key == 's' || keyCode == DOWN) {
      inputs[3] = false;
    }
  }
}
