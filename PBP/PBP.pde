Gunship player;
boolean[] keysPressed; 
ArrayList<Polygon> polygons;

void setup() {
  size(800, 800);
  player = new Gunship(width/2, height/2);
  keysPressed = new boolean[4];
  //creating polygons
  polygons = new ArrayList<Polygon> ();
  for (int x = 0; x < 9; x++){
    int rand = (int) random(3);
    if (rand == 0){
      Polygon now = new Polygon("square");
    }
    if (rand == 1){
      Polygon now = new Polygon("triangle");
    }
    if (rand == 2){
      Polygon now = new Polygon("pentagon");
    }
  }
}

void keyPressed() {
  if (key == 'a' || keyCode == LEFT) {
    keysPressed[0] = true;
  }
  if (key == 'w' || keyCode == UP) {
    keysPressed[1] = true;
  } 
  if (key == 'd' || keyCode == RIGHT) {
    keysPressed[2] = true;
  }
  if (key == 's' || keyCode == DOWN) {
    keysPressed[3] = true;
  }
}

void keyReleased() {
  if (key == 'a' || keyCode == LEFT) {
    keysPressed[0] = false;
  }
  if (key == 'w' || keyCode == UP) {
    keysPressed[1] = false;
  }   
  if (key == 'd' || keyCode == RIGHT) {
    keysPressed[2] = false;
  }
  if (key == 's' || keyCode == DOWN) {
    keysPressed[3] = false;
  }
}

void draw() {
  background(255);
  player.update();
  player.display();
  for (int i = 0; i < polygons.size(); i++){
    polygons.get(i).display();
  }
}
