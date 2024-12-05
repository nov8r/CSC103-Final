class Cloud {
  float x, y;
  float speed;
  
  Cloud(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
  }
  
  
  /*
    The display function just draws the clouds out with three ellipses
  */
  void display() {
    fill(255);
    noStroke();
    ellipse(x, y, 50, 30);
    ellipse(x + 20, y + 10, 50, 30);
    ellipse(x - 20, y + 10, 50, 30);
  }
  
  
  /*
    The move function just moves the cloud in which ever direction it's going as well
    as wraps it across the screen once it goes off screen
  */
  void move() {
    x += speed;
    if (x > width + 50) x = -50;
  }
}
