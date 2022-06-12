 class GameScreen {
  
  void displayIntro() {
    displayLightGreyRect();

    largeText(CENTER);
    text("Piece-By-Piece", player.getX(), player.getY() - displayHeight/2 + unit*9);

    mediumText(CENTER);
    text("Made by: Daniel Yentin & Yuxiang Huang", player.getX(), player.getY()-unit*4);

    smallText(CENTER);
    text("Press any key to continue...", player.getX(), player.getY() + displayHeight/2 - unit*2);
    resetText();
  }

  void displayInfo() {
    displayLightGreyRect();
    largeText(CENTER);
    text("INFORMATION", player.getX(), player.getY() - displayHeight/2 + 9*unit);

    mediumText(LEFT);
    text("Gunship:", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*6);

    smallText(LEFT);
    text("1. Press the 'wasd' or the arrow keys to move in all 8 directions!", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*4);

    text("2. Move the mouse to rotate to where you want aim,", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*2);
    text("    or press the 'q' key to rotate automatically.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*1);

    text("3. Press the mouse to shoot a bullet out of your guns,", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-1);
    text("    or press the 'e' key to shoot automatically.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-2);

    text("4. Whenever you have a skill point to spend,", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-4);
    text("    press the corresponding number key to upgrade a stat.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-5);

    text("5. Whenever you reach a certain level, you can evolve,", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-7);
    text("    press the corresponding number key to evolve.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-8);

    text("6. Press 'p' to pause the game at any time.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-10);
    text("    You can also press 'r' to restart the game,", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-11);
    text("    or 'R' to completly reset the game.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-12);

    mediumText(LEFT);
    text("Hacks:", player.getX(), player.getY()-unit*6);

    smallText(LEFT);
    text("Press '`' (below the 'esc' key) to activate debug mode.", player.getX(), player.getY()-unit*4);
    text("debug mode displays alot of useful information.", player.getX(), player.getY()-unit*3);

    text("When debug mode is active, you can do the following: ", player.getX(), player.getY()-unit*1);

    text("1. Press 'l' to level up your player one level,", player.getX(), player.getY()-unit*-1);
    text("    or press 'L' to level up your player to the next evolution.", player.getX(), player.getY()-unit*-2);

    text("2. Press 'k' to instantly deal 50 damage to all enemies,", player.getX(), player.getY()-unit*-4);
    text("    or press 'K' do instantly kill all enemies.", player.getX(), player.getY()-unit*-5);

    text("3. Press 'j' to instantly spawn in an enemy,", player.getX(), player.getY()-unit*-7);
    text("    or press 'J' to instantly spawn in 10 enemies.", player.getX(), player.getY()-unit*-8);

    text("4. Press 'h' to instantly heal yourself for 50hp,", player.getX(), player.getY()-unit*-10);
    text("    or 'H' to instantly heal yourself.", player.getX(), player.getY()-unit*-11);

    text("5. Press 'u' to instantly buy a random upgrade from the shop,", player.getX(), player.getY()-unit*-13);
    text("    or press 'U' to instantly buy all upgrades from the shop.", player.getX(), player.getY()-unit*-14);

    text("6. Press 'y' to instantly give yourself invincibility for 10s.", player.getX(), player.getY()-unit*-16);
    text("    Press 'Y' to instantly give yourself a little bit of health.", player.getX(), player.getY()-unit*-17);

    smallText(CENTER);
    text("Press any key to continue...", player.getX(), player.getY() + displayHeight/2 - unit*2);

    resetText();
  }

  void displayPaused() {
    displayLightGreyRect();
    largeText(CENTER);
    text("GAME PAUSED", player.getX(), player.getY());
    resetText();
  }

  void displayLost() {
    displayLightGreyRect();
    largeText(CENTER);
    text("GAME LOST", player.getX(), player.getY());
    resetText();
  }

  void displayWon() {
    displayLightGreyRect();
    largeText(CENTER);
    text("GAME WON", player.getX(), player.getY());
    resetText();
  }

  void displayLightGreyRect() {
    fill(128, 128, 128, 200);
    rect(player.getX()-(displayWidth/2), player.getY()-(displayHeight/2), displayWidth, displayHeight);
  }

  void resetText() {
    fill(0);
    textSize(unit*3.0/4);
    textAlign(LEFT);
  }

  void smallText(int allignment) {
    fill(0);
    textSize(unit);
    textAlign(allignment);
  }

  void mediumText(int allignment) {
    fill(0);
    textSize(unit*2);
    textAlign(allignment);
  }

  void largeText(int allignment) {
    fill(0);
    textSize(unit*9);
    textAlign(allignment);
  }
}
