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
    text("Gunship:", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*3);

    smallText(LEFT);
    text("1. Press the 'WASD' or Arrow keys to move in all 8 directions!", player.getX() - displayWidth/2 + unit*2, player.getY()-unit);

    text("2. Move the Mouse to rotate to where you want look,", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-1);
    text("    or press the 'q' key to rotate automatically.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-2);

    text("3. Press the Mouse to shoot a bullet out of your guns,", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-4);
    text("    or press the 'e' key to shoot automatically.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-5);

    text("4. Whenever you have a skill point to spend,", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-7);
    text("    press the corresponding number key to upgrade a stat.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-8);

    text("5. Whenever you reach a certain level, you can evolve,", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-10);
    text("    press the corresponding number key to evolve.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-11);

    text("6. Press 'p' to pause the game at any time.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-13);
    text("    You can also press 'r' to restart the game.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-14);

    mediumText(LEFT);
    text("Hacks:", player.getX(), player.getY()-unit*3);

    smallText(LEFT);
    text("Press '`' (below the 'esc' key) to activate debug mode.", player.getX(), player.getY()-unit);
    text("debug mode displays alot of useful information.", player.getX(), player.getY());

    text("When debug mode is active, you can do the following: ", player.getX(), player.getY()-unit*-2);

    text("1. Press 'l' to level up your player one level.", player.getX(), player.getY()-unit*-4);

    text("2. Press 'k' to instantly deal 50 damage to all enemies.", player.getX(), player.getY()-unit*-6);
    text("    You can also hold down 'k' do instantly kill all enemies.", player.getX(), player.getY()-unit*-7);

    text("3. Press 'j' to instantly spawn in an enemy.", player.getX(), player.getY()-unit*-9);

    text("4. Press 'h' to instantly heal yourself.", player.getX(), player.getY()-unit*-11);

    text("5. Press 'u' to instantly buy a random upgrade from the shop.", player.getX(), player.getY()-unit*-13);

    text("6. Press 'y' to instantly give yourself invincibility for 10s.", player.getX(), player.getY()-unit*-15);

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
