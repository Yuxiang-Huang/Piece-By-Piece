class Controller {
  boolean[] inputs;

  public Controller() {
    inputs = new boolean[4]; // 4 valid buttons
  }

  boolean isPressed(int code) {
    return inputs[code];
  }

  void press(int code) {
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
    Shop shop = player.shop;
    
    if (key == '1' && !player.shop.healthRegen.isMaxLevel()) {
      player.shop.healthRegen.upgrade();
      player.setMaxHealth(shop.maxHealth.getBase() + (shop.maxHealth.getModifier()*shop.maxHealth.getLevel())); 
    }
    if (key == '2' && !player.shop.maxHealth.isMaxLevel()) {
      player.shop.maxHealth.upgrade();
    }
    if (key == '3' && !player.shop.bodyDamage.isMaxLevel()) {
      player.shop.bodyDamage.upgrade();
      player.setCollisionDamage(shop.bodyDamage.getBase() + (shop.bodyDamage.getModifier()*shop.bodyDamage.getLevel()));
    }
    if (key == '4' && !player.shop.bulletSpeed.isMaxLevel()) {
      player.shop.bulletSpeed.upgrade();
    }
    if (key == '5' && !player.shop.bulletPenetration.isMaxLevel()) {
      player.shop.bulletPenetration.upgrade();
    }
    if (key == '6' && !player.shop.bulletDamage.isMaxLevel()) {
      player.shop.bulletDamage.upgrade();
    }
    if (key == '7' && !player.shop.reload.isMaxLevel()) {
      player.shop.reload.upgrade();
      player.setReloadSpeed(shop.reload.getBase() + (shop.reload.getModifier()*shop.reload.getLevel()));
    }
    if (key == '8' && !player.shop.movementSpeed.isMaxLevel()) {
      player.shop.movementSpeed.upgrade();
      player.setMaxSpeed(shop.movementSpeed.getBase() + (shop.movementSpeed.getModifier()*shop.movementSpeed.getLevel()));
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
