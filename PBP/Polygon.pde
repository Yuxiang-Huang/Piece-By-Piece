class Polygon extends UMO{
  private int heldExp;
  private String shape;
  
  Polygon(String name){
    if (name.equals("square")){
      heldExp = 10;
    }
  }
  
  void die(){
  
  }
  
  void display(){
  
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
