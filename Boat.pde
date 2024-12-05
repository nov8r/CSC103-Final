class Boat {
  float x, y;
  int speed;
  boolean fishing = false;
  float lineY;
  boolean lineGoingDown = true;
  float lureRadius = 5;

  Boat(float x, float y, int speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.lineY = y;
  }

  /*
    The update function handles moving left and right, checks if the player is actively fishing, 
    updates the boat's position for bobbing, and manages the fishing line mechanics.
  */
  void update() {
    if (!fishing) {
      if (keyPressed) {
        if (key == CODED) {
          if (keyCode == LEFT && x > 20) {
            x -= speed;
          }
          if (keyCode == RIGHT && x < width - 20) {
            x += speed;
          }
        }
      }
    }

    // Boat bobbing logic
    float waterLevelAtBoat = height / 2 + waveAmplitude * noise(x * 0.02 + noiseOffset) * 2 - waveAmplitude;
    y = waterLevelAtBoat - 20;

    // Handle the fishing line if active
    if (fishing) {
      if (lineGoingDown) {
        lineY += 4; // Move the line down faster
        if (lineY >= height) {
          lineGoingDown = false; // Start retracting if it reaches the bottom
        }
        checkFishCaught();
      } else {
        lineY -= 4; // Move the line back up
        if (lineY <= y + 10) { // Line retracts to just below the boat
          fishing = false; // Reset fishing once the line returns
          lineGoingDown = true;
        }
      }
    }
  }

  /*
    The display function handles drawing the boat, sail, the fishing line, and the lure.
  */
  void display() {
    // Boat
    fill(139, 69, 19);
    arc(x, y + 10, 60, 40, 0, PI);
    
    // Line connecting the sail to the boat
    stroke(139, 69, 19);
    strokeWeight(2);
    line(x, y - 40, x, y + 10);
    
    // Sail
    noStroke();
    fill(255);
    triangle(x, y - 43, x, y + 10, x + 30, y - 20);

    // Fishing line
    if (fishing) {
      stroke(255, 255, 255);
      strokeWeight(2);
      line(x - 15, y + 10, x - 15, lineY);

      // Lure
      fill(255, 0, 0);
      noStroke();
      ellipse(x - 15, lineY, lureRadius * 2, lureRadius * 2);
    }
  }

  /*
    The startFishing function initiates the fishing process.
  */
  void startFishing() {
    if (!fishing) {
      fishing = true;
      lineY = y + 10;
    }
  }

  /*
    The checkFishCaught function determines whether the fishing line (and lure) has touched a fish 
    and removes the fish if caught.
  */
  void checkFishCaught() {
    for (Fish fish : redFishes) {
      if (dist(x - 15, lineY, fish.x, fish.y) < lureRadius + 10) { // Check for collision with the lure
        println("You caught a red fish!");
        redFishes.remove(fish);
        score.addMoney(5); // Add $5 for a red fish
        fishing = false;
        lineGoingDown = true;
        return;
      }
    }

    for (Fish fish : orangeFishes) {
      if (dist(x - 15, lineY, fish.x, fish.y) < lureRadius + 10) { // Check for collision with the lure
        println("You caught an orange fish!");
        orangeFishes.remove(fish);
        score.addMoney(10); // Add $10 for an orange fish
        fishing = false;
        lineGoingDown = true;
        return;
      }
    }
  }
}
