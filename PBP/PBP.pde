Gunship player;
boolean[] keysPressed; 
ArrayList<Polygon> polygons;

void setup() {
  size(1600, 800);
  player = new Gunship(width/2, height/2);
  keysPressed = new boolean[4];
  //creating polygons
  polygons = new ArrayList<Polygon> ();
  for (int x = 0; x < 1; x++){
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
  //draw lines
  for (int row = 0; row < height; row+=20){
    stroke(100);
    line(0, row, width, row);
  }
  for (int col = 0; col < width; col+=20){
    stroke(200);
    line(col, 0, col, height);
  }
  player.update();
  player.display();
  for (int i = 0; i < polygons.size(); i++){
    polygons.get(i).display();
  }
}
