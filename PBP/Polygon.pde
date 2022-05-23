class Polygon extends UMO{
  private int heldExp;
  private String shape;
  
  Polygon(String name){
    setX(Math.random() * width);
    setY(Math.random() * height);
    while (Math.abs(getX() - player.getX()) < player.getRadius()){
      setX(Math.random() * width);
    }
    while (Math.abs(getY() - player.getY()) < player.getRadius()){
      setY(Math.random() * height);
    }
    polygon.add(this);
    if (name.equals("square")){
      heldExp = 10;
      setMaxHealth(10);
      setCurrentHealth(10);
      setCollisionDamage(8);
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
