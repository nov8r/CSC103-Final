class Fish {
  float x, y;
  float speed;
  color bodyColor;

  Fish(float x, float y, float speed, color bodyColor) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.bodyColor = bodyColor;
  }

  /*
    The move function just moves the fish in which ever direction it's going as well
    as wraps it across the screen once it goes off screen
  */
  void move() {
    x += speed;
    if (x > width + 20) x = -20;
    if (x < -20) x = width + 20;
  }

  
  /*
    The display function draws the fish as well as makes sure it's facing the way it's
    moving. I used push and pop matrix here so that it wouldn't effect all the fish, just
    each fish separately. I also used scale to flip the fish.
  */
  void display() {
    pushMatrix();
    translate(x, y);
    scale(speed > 0 ? 1 : -1, 1);

    // draw the fish
    fill(bodyColor);
    ellipse(0, 0, 30, 15);                 // fish body
    triangle(-15, 0, -25, -5, -25, 5);     // fish tail
    fill(0); 
    popMatrix();
  }
}
