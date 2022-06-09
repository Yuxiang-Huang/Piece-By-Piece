class GameScreen {
  void displayIntro() {
    displayLightGreyRect();
    largeText();
    text("PRESS ANY KEY", player.getX(), player.getY());
    text("TO PLAY", player.getX(), player.getY()+(unit*9));
    resetText();
  }

  void displayControls() {
    displayLightGreyRect();
    largeText();
    text("CONTROLS", player.getX(), player.getY() - displayHeight/2 + 9*unit);

    mediumText();
    text("Gunship:", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*3);

    smallText();
    text("1. Press the 'WASD' keys to move in all 8 directions!", player.getX() - displayWidth/2 + unit*2, player.getY()-unit);
    
    text("2. Move the Mouse to rotate to where you want look", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-1);
    text("    or press the 'q' key to rotate automaticly.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-1);
    
    text("3. Press the Mouse to shoot a bullet out of your guns", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-1);
    text("    or press the 'e' key to shoot automaticly.", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-1);
    
    text("4. Whenever you have a skill point to spend,", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-1);
    text("    press the corresponding number key to upgrade a stat.", player.getX()text(". ", player.getX() - displayWidth/2 + unit*2, player.getY()-unit*-2);

    resetText();
  }

  void displayPaused() {
    displayLightGreyRect();
    largeText();
    text("GAME PAUSED", player.getX(), player.getY());
    resetText();
  }

  void displayLost() {
    displayLightGreyRect();
    largeText();
    text("GAME LOST", player.getX(), player.getY());
    resetText();
  }

  void displayWon() {
    displayLightGreyRect();
    largeText();
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

  void smallText() {
    fill(0);
    textSize(unit);
    textAlign(LEFT);
  }

  void mediumText() {
    fill(0);
    textSize(unit*2);
    textAlign(LEFT);
  }

  void largeText() {
    fill(0);
    textSize(unit*9);
    textAlign(CENTER);
  }
}
