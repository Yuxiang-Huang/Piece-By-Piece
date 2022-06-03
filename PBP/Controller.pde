class Controller {
  boolean[] inputs;

  public Controller() {
    inputs = new boolean[4]; // 4 valid buttons
  }

  boolean isPressed(int code) {
    return inputs[code];
  }

  void press(int code) {
    // Game info
    if (key == '`') {
      DEBUG = !DEBUG;
    }
    
    if (DEBUG && key == 'k') {
      player.setExp(player.getExpRequiredForNextLevel());
    }
    
    // Gun controls
    if (key == 'e') {
      player.setAutoFire(!player.getAutoFire());
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
      Shop shop = player.getShop();
      if (key == '1' && !shop.healthRegen.isMaxLevel()) {
        shop.healthRegen.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '2' && !shop.maxHealth.isMaxLevel()) {
        shop.maxHealth.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '3' && !shop.bodyDamage.isMaxLevel()) {
        shop.bodyDamage.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '4' && !shop.bulletSpeed.isMaxLevel()) {
        shop.bulletSpeed.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '5' && !shop.bulletPenetration.isMaxLevel()) {
        shop.bulletPenetration.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '6' && !shop.bulletDamage.isMaxLevel()) {
        shop.bulletDamage.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '7' && !shop.reload.isMaxLevel()) {
        shop.reload.upgrade();
        shop.update();
        player.setSkillPoints(player.getSkillPoints()-1);
      }
      if (key == '8' && !shop.movementSpeed.isMaxLevel()) {
        shop.movementSpeed.upgrade();
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
