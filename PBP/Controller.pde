class Controller {
  boolean[] inputs;

  Controller() {
    inputs = new boolean[4]; // 4 valid buttons
  }

  boolean isPressed(int code) {
    return inputs[code];
  }

  void press(int code) {
    if (getGameState() == INTRO) {
      setGameState(CONTROLS);
    } else if (getGameState() == CONTROLS) {
      setGameState(PLAYING);
    } else {
      // Game info
      if (key == '`') {
        DEBUG = !DEBUG;
      }

      if (key == 'r') {
        player = new Gunship(width/2, height/2);
        polygons.clear();
        for (int i = 0; i < 30; i++) {
          Polygon polygon = new Polygon();
          polygons.add(polygon);
        }
        enemies.clear();
        setTimeSinceEnemySpawn(600);
        setGameState(PLAYING);
        boss = null;
      }

      if (key == 'p') {
        if (getGameState() == PLAYING) {
          setGameState(PAUSED);
        } else if (getGameState() == PAUSED) {
          setGameState(PLAYING);
        }
      }

      if (key == 'r') {
        player = new Gunship(width/2, height/2);
        polygons.clear();
        for (int i = 0; i < 100; i++) {
          Polygon polygon = new Polygon();
          polygons.add(polygon);
        }
        enemies.clear();
        setTimeSinceEnemySpawn(600);
        setGameState(INTRO);
      }

      if (getGameState() == PLAYING) {
        if (DEBUG) {
          //create enemy
          if (key == 'j') {
            spawnAnEnemy();
          }

          //full health
          if (key == 'h') {
            player.setHealth(player.getMaxHealth());
          }

          //invincibility
          if (key == 'y') {
            player.setInvincible(600);
          }

          //randomUpgrade
          if (key == 'u') {
            player.getShop().randomUpgrade();
          }

          //level up
          if (key == 'l') {
            player.setExp(player.getExpRequiredForNextLevel());
          }

          //50 damage to each enemy
          if (key == 'k') {
            for (Gunship enemy : enemies) {
              enemy.setHealth(enemy.getHealth() - 50);
            }
          }

          //create enemy
          if (key == 'j') {
            spawnAnEnemy();
          }

          //full health
          if (key == 'h') {
            player.setHealth(player.getMaxHealth());
          }
        }

        // Gun controls
        if (key == 'e') {
          player.setAutoFire(!player.getAutoFire());
        }
        if (key == 'q') {
          player.setAutoRotate(!player.getAutoRotate());
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
      }

      // Evolution
      if (player.canEvolve()) {
        if ('1' <= key && key <= char(player.getNumberOfEvolutions()) + '1') {
          player.evolve(key);
        }
      }
      // Shop upgrades
      else if (player.getSkillPoints() > 0) {
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
