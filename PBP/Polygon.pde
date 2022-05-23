class Polygon extends UMO{
  private int heldExp;
  private String shape;
  private int radius;
  
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
      setHeldExp(10);
      setShape("square");
      setMaxHealth(10);
      setCurrentHealth(10);
      setCollisionDamage(8);
    }
    if (name.equals("triangle")){
      setHeldExp(25);
      setShape("triangle");
      setMaxHealth(25);
      setCurrentHealth(25);
      setCollisionDamage(8);
    }
  }
  
  void die(){
    polygons.remove(this);
    player.setExp(player.getExp() + getHeldExp());
  }
  
  void display(){
    if (shape.equals("square")){
      square(getX(), getY(), 10);
    } else if (shape.equals("triangle")){
      triangle(getX(), getY() + radius, 
      getX() - radius * sqrt(3) / 2, getY() - radius / 2, 
      
      radius * sqrt(3) / 2);
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
  
  int getRadius(){
    return radius; 
  }
  
  void setRadius(int radiusNow){
    radius = radiusNow; 
  }
}
