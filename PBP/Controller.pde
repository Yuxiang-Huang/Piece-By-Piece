class Controller {
  static final int P1_LEFT = 0;
  static final int P1_RIGHT = 1;
  boolean [] inputs;

  public Controller() {
    inputs = new boolean[4]; // 4 valid buttons
  }

  boolean isPressed(int code) {
    return inputs[code];
  }

  void press(int code) {
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
