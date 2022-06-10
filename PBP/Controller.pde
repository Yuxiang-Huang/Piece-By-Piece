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
      if (key == 'i') {
        setGameState(INFO);
      }

      if (key == '`') {
        DEBUG = !DEBUG;
      }

      if (key == 'r' || key == 'R') {
        unit = min(displayWidth/70, displayHeight/35);
        if (key == 'r') {
          int newLevel;
          if (player.getLevel() <= 2) {
            newLevel = 1;
          } else {
            newLevel = (player.getLevel()/2)+1;
          }
          player = new Gunship(width/2, height/2, newLevel);
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
          if (key == 'K') {
            for (Gunship enemy : enemies) {
              enemy.setHealth(0);
            }
          }

          //create enemy
          if (key == 'j') {
            spawnAnEnemy();
          }
          if (key == 'J') {
            for (int i = 0; i < 10; i++) {
              spawnAnEnemy();
            }
          }

          // 50 health
          if (key == 'h') {
            player.setHealth(player.getHealth()+50);
          }
          // full health
          if (key == 'H') {
            player.setHealth(player.getMaxHealth());
          }

          // randomUpgrade
          if (key == 'u') {
            player.getShop().randomUpgrade();
          }
          // upgrade everything
          if (key == 'U') {
            int maxLevel = 7;
            player.getShop().getHealthRegen().setLevel(maxLevel);
            player.getShop().getMaxHealth().setLevel(maxLevel);
            player.getShop().getBodyDamage().setLevel(maxLevel);
            player.getShop().getBulletSpeed().setLevel(maxLevel);
            player.getShop().getBulletPenetration().setLevel(maxLevel);
            player.getShop().getBulletDamage().setLevel(maxLevel);
            player.getShop().getReload().setLevel(maxLevel);
            player.getShop().getMovementSpeed().setLevel(maxLevel);
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
