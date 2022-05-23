void setup(){
  size(1000, 1000);
  Gunship player = new Gunship ();
}

void draw(){
  circle(height / 2, width / 2, 50);
}

void keyPressed(){
  switch (key){
    case 'w':
      ddy += 2.55; break;
    case UP:
      ddy += 2.55; break;
    case 's':
      ddy -= 2.55; break;
    case DOWN:
      ddy -= 2.55; break;
    case 'a':
      ddx -= 2.55; break;
    case LEFT:
      ddx -= 2.55; break;
    case 'd':
      ddx += 2.55; break;
    case RIGHT:
      ddx += 2.55; break;
  }
}
