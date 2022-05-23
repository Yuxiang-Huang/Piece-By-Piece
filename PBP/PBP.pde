Gunship player;

void setup() {
  size(900, 900);
  player = new Gunship ();
}

void draw() {
  circle(height / 2, width / 2, 50);
}

void keyPressed() {
  switch (key) {
  case 'w':
    player.setDDY(player.getDDY() + 2.55); 
    break;
  case UP:
    player.setDDY(player.getDDY() + 2.55); 
    break;
  case 's':
    player.setDDY(player.getDDY() - 2.55); 
    break;
  case DOWN:
    player.setDDY(player.getDDY() - 2.55); 
    break;
  case 'a':
    player.setDDX(player.getDDX() - 2.55); 
    break;
  case LEFT:
    player.setDDX(player.getDDX() - 2.55); 
    break;
  case 'd':
    player.setDDX(player.getDDX() + 2.55); 
    break;
  case RIGHT:
    player.setDDX(player.getDDX() + 2.55); 
    break;
  }
}
