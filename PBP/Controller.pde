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
      setGameState(INFO);
    } else if (getGameState() == INFO) {
      setGameState(PLAYING);
    } else {
      // Game info
      if (key == 'i'){
        setGameState(INFO);
      }
      
      if (key == '`') {
        DEBUG = !DEBUG;
      }

      if (key == 'r' || key == 'R') {
        unit = min(displayWidth/70, displayHeight/35);
        if (key == 'r') {
          player = new Gunship(width/2, height/2, player.getLevel() / 2 + 1);
        } else if (key == 'R') {
          player = new Gunship(width/2, height/2, 1);
        }
        polygons.clear();
        for (int i = 0; i < (((width/unit)*(height/unit)*.2)/(unit*1.77)); i++) { // ~20% of screen should be polygons
          Polygon polygon = new Polygon();
          polygons.add(polygon);
        }
        enemies.clear();
        setTimeSinceEnemySpawn(600);
        setTimeUntilBossSpawn(600);
        if (key  == 'r') {
          setGameState(PLAYING);
        } else if (key == 'R') {
          setGameState(INTRO);
        }
        boss = null;
      }

      if (key == 'p') {
        if (getGameState() == PLAYING) {
          setGameState(PAUSED);
        } else if (getGameState() == PAUSED) {
          setGameState(PLAYING);
        }
      }

      if (getGameState() == PLAYING) {
        if (DEBUG) {
          //level up
          if (key == 'l') {
            player.setExp(player.getExpRequiredForNextLevel());
          }
          //level up to 29
          if (key == 'L') {
            if (player.getLevel() < 15-1) {
              while (player.getLevel() < 15-1) {
                player.setExp(player.getExpRequiredForNextLevel());
                player.playerUpdate();
              }
            } else if (player.getLevel() < 30-1)
              while (player.getLevel() < 30-1) {
                player.setExp(player.getExpRequiredForNextLevel());
                player.playerUpdate();
              }
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
          //1000000 health
          if (key == 'H') {
            player.getShop().maxHealth.base = 1000000;
            player.getShop().update();
            player.setHealth(player.getMaxHealth());
          }

          //randomUpgrade
          if (key == 'u') {
            player.getShop().randomUpgrade();
          }

          //invincibility
          if (key == 'y') {
            player.setInvincible(600);
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
