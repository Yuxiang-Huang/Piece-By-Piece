class Polygon extends UMO{
  private int heldExp;
  private String shape;
  
  Polygon(String name){
    setX(Math.random() * width);
    setY(Math.random() * width);
    if (name.equals("square")){
      heldExp = 10;
    }
  }
  
  void die(){
    polygons.remove(this);
    player.setExp(player.getExp() + getHeldExp());
  }
  
  void display(){
    if (name.equals("square")){
      square(getX(), getY(), 10);
    }
  }
  
  int getHeldExp(){
    return heldExp; 
  }
  
  void setHeldExp(int heldExpNow){
    heldExp = heldExpNow; 
  }
  
  String getShape(){
    return shape; 
  }
  
  void setShape(String shapeNow){
    shape = shapeNow; 
  }
}
