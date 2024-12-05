import processing.sound.*;

/*
  Ethan Posey
 Fishing Game
 12/02/24
 */

/*------------------------------------VARS--------------------------------------*/

// Font stuff
PFont Bahnschrift;

// Sound variables
SoundFile oceanSound;
SoundFile fishingSound;

// ArrayLists for fish and clouds
ArrayList<Fish> redFishes = new ArrayList<Fish>();
ArrayList<Fish> orangeFishes = new ArrayList<Fish>();
ArrayList<Cloud> clouds = new ArrayList<Cloud>();

// Boat variables
Boat playerBoat;

// Water variables
float waveAmplitude = 20;
float noiseOffset = 0;

// Sun/Moon cycle variables
int totalCycleTime = 2 * 60 * 60;
float timeElapsed = 0.0;

// Sky color transitions
color daySkyColor = color(143, 199, 242);
color sunsetSkyColor = color(255, 153, 51);
color nightSkyColor = color(20, 24, 82);
color sunriseSkyColor = color(255, 204, 153);

// Level system
int currentLevel = 1;
int maxLevels = 3;
boolean levelComplete = false;
int transitionTimer = 0;
int transitionDuration = 180;

// Score instance
Score score;

// Game state
String gameState = "menu";
/*------------------------------------VARS--------------------------------------*/



/*------------------------------------SETUP-------------------------------------*/

/*
  Setup function
 */
void setup() {
  size(800, 600);
  noStroke();

  playerBoat = new Boat(width / 2, height / 2, 2);

  // Load sounds
  oceanSound = new SoundFile(this, "waves.wav");
  fishingSound = new SoundFile(this, "fishing.wav");
  oceanSound.loop();
  oceanSound.amp(0.1);

  // Generate clouds
  for (int i = 0; i < 5; i++) {
    int cloudX = int(random(width));
    int cloudY = int(random(50, 150));
    float cloudSpeed = random(0.5, 1.5) * (random(1) > 0.5 ? 1 : -1);
    clouds.add(new Cloud(cloudX, cloudY, cloudSpeed));
  }

  Bahnschrift = loadFont("Bahnschrift-20.vlw");
  textFont(Bahnschrift);

  // Start the first level
  startLevel(1);
}
/*------------------------------------SETUP-------------------------------------*/




/*-------------------------------------DRAW-------------------------------------*/

/*
  Draw function
 */
void draw() {
  if (gameState.equals("menu")) {
    drawMainMenu();
    return;
  }

  if (levelComplete) {
    background(#4698E8);
    textAlign(CENTER, CENTER);
    textSize(30);
    fill(0);

    // Switch case to handle different messages
    switch (currentLevel) {
      case 2: // After Level 1
        text("Level 1 Complete!", width / 2, height / 2 - 20);
        textSize(20);
        text("This game is fin-tastic!", width / 2, height / 2 + 20);
        break;

      case 3: // After Level 2
        text("Level 2 Complete!", width / 2, height / 2 - 20);
        textSize(20);
        text("You’re really reeling in the fun!", width / 2, height / 2 + 20);
        break;

      case 4: // Final win
        text("You Won!", width / 2, height / 2 - 20);
        textSize(20);
        text("You're the catch of the day!", width / 2, height / 2 + 20);
        oceanSound.stop();
        fishingSound.stop();
        break;

      case -1: // Losing case
        text("You Lose!", width / 2, height / 2 - 20);
        textSize(20);
        text("Better luck next time!", width / 2, height / 2 + 20);
        oceanSound.stop();
        fishingSound.stop();
        break;
    }

    // Increment the transition timer
    transitionTimer++;
    if (transitionTimer > transitionDuration) {
      levelComplete = false;
      transitionTimer = 0;

      if (currentLevel > 0 && currentLevel <= maxLevels) {
        startLevel(currentLevel);
      } else if (currentLevel == 4 || currentLevel == -1) {
        noLoop();
      }
    }
    return;
  }

  // Normal game logic
  background(0);

  drawSky();
  drawSunAndMoon();
  drawWater();
  playerBoat.update();
  playerBoat.display();

  for (Cloud cloud : clouds) {
    cloud.display();
    cloud.move();
  }

  for (Fish fish : redFishes) {
    fish.move();
    fish.display();
  }

  for (Fish fish : orangeFishes) {
    fish.move();
    fish.display();
  }

  // Update and display the score
  score.update();
  score.display();

  // Check win/lose conditions
  if (score.hasWon()) {
    if (currentLevel < maxLevels) {
      currentLevel++;
      levelComplete = true;
    } else {
      currentLevel = 4; // Mark as final win
      levelComplete = true;
    }
  } else if (score.hasLost()) {
    currentLevel = -1; // Mark as losing case
    levelComplete = true;
  }

  // Update time for the sun and moon cycle
  timeElapsed++;
  if (timeElapsed >= totalCycleTime) {
    timeElapsed = 0.0;
  }
}

/*
  Draws the main menu screen.
 */
void drawMainMenu() {
  background(143, 199, 242);
  drawWater();

  for (Cloud cloud : clouds) {
    cloud.display();
    cloud.move();
  }

  fill(0);
  textAlign(CENTER, TOP);
  Bahnschrift = loadFont("Bahnschrift-50.vlw");
  textFont(Bahnschrift);
  textSize(50);
  text("Fishing Adventure", width / 2, 50);
  textSize(25);
  text("Press P to Play", width / 2, 120);
}

/*-------------------------------------DRAW-------------------------------------*/




/*----------------------------------START-LEVEL---------------------------------*/

/*
  Function to start a level
 */
void startLevel(int level) {
  // Reset the cycle
  timeElapsed = 0.0;

  // Clear fish from previous level
  redFishes.clear();
  orangeFishes.clear();

  // Set level-specific parameters
  int targetMoney;
  float timeLimit;
  int numRedFish, numOrangeFish;
  float fishSpeedMultiplier;

  if (level == 1) {
    targetMoney = 75;
    timeLimit = 1;                  // Day cycles
    numRedFish = 5;
    numOrangeFish = 5;
    fishSpeedMultiplier = 1.0;
  } else if (level == 2) {
    targetMoney = 105;
    timeLimit = 1;
    numRedFish = 7;
    numOrangeFish = 7;
    fishSpeedMultiplier = 1.2;
  } else if (level == 3) {
    targetMoney = 150;
    timeLimit = 1;
    numRedFish = 10;
    numOrangeFish = 10;
    fishSpeedMultiplier = 1.5;
  } else {
    noLoop(); // Stop the game
    return;
  }

  // Initialize score for the level
  score = new Score(targetMoney, timeLimit);

  // Generate fish
  for (int i = 0; i < numRedFish; i++) {
    float x = random(width);
    float y = random(height / 2 + 50, height - 50);
    float speed = random(0.5, 1.5) * fishSpeedMultiplier * (random(1) > 0.5 ? 1 : -1);
    redFishes.add(new Fish(x, y, speed, color(255, 0, 0)));
  }

  for (int i = 0; i < numOrangeFish; i++) {
    float x = random(width);
    float y = random(height / 2 + 50, height - 50);
    float speed = random(1.0, 2.0) * fishSpeedMultiplier * (random(1) > 0.5 ? 1 : -1);
    orangeFishes.add(new Fish(x, y, speed, color(255, 165, 0)));
  }
}
/*----------------------------------START-LEVEL---------------------------------*/




/*-----------------------------------DRAW-SKY-----------------------------------*/

/*
  Function to draw the sky
 */
void drawSky() {
  float cycleProgress = timeElapsed / totalCycleTime;

  color skyColor;
  if (cycleProgress < 0.1) {
    skyColor = lerpColor(nightSkyColor, sunriseSkyColor, map(cycleProgress, 0, 0.1, 0, 1));
  } else if (cycleProgress < 0.25) {
    skyColor = lerpColor(sunriseSkyColor, daySkyColor, map(cycleProgress, 0.1, 0.25, 0, 1));
  } else if (cycleProgress < 0.5) {
    skyColor = lerpColor(daySkyColor, sunsetSkyColor, map(cycleProgress, 0.25, 0.5, 0, 1));
  } else if (cycleProgress < 0.75) {
    skyColor = lerpColor(sunsetSkyColor, nightSkyColor, map(cycleProgress, 0.5, 0.75, 0, 1));
  } else {
    skyColor = nightSkyColor;
  }
  background(skyColor);
}
/*-----------------------------------DRAW-SKY-----------------------------------*/




/*----------------------------------DRAW-WATER----------------------------------*/

/*
  Function to draw the water
  Waves use perlin noise wave to simulate water
  Docs I used: https://processing.org/examples/noisewave.html
 */
void drawWater() {
  fill(28, 107, 160);
  beginShape();
  for (int x = 0; x <= width; x += 10) {
    float y = height / 2 + waveAmplitude * noise(x * 0.02 + noiseOffset) * 2 - waveAmplitude;
    vertex(x, y);
  }
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);

  noiseOffset += 0.01;
}
/*----------------------------------DRAW-WATER----------------------------------*/




/*-----------------------------------SUN-MOON-----------------------------------*/

/*
  Function to draw the sun and moon
*/
void drawSunAndMoon() {
  float centerX = width / 2;
  float centerY = height / 2 + 150;

  float cycleProgress = timeElapsed / totalCycleTime;

  if (cycleProgress < 0.5) {
    float sunX = centerX + 350 * cos(TWO_PI * cycleProgress);
    float sunY = centerY - 300 * sin(TWO_PI * cycleProgress);
    fill(255, 204, 0);
    ellipse(sunX, sunY, 80, 80);
  } else {
    float moonX = centerX + 350 * cos(TWO_PI * (cycleProgress - 0.5));
    float moonY = centerY - 300 * sin(TWO_PI * (cycleProgress - 0.5));
    fill(255);
    ellipse(moonX, moonY, 60, 60);
  }
}
/*-----------------------------------SUN-MOON-----------------------------------*/




/*
  When the user presses space, it plays a fishing sound
 Eventually it will also drop the fishing line for the player
 */
void keyPressed() {
  if (gameState.equals("menu") && key == 'p') {
    gameState = "playing";
    startLevel(1);
    return;
  }

  if (key == ' ') {
    if (!fishingSound.isPlaying()) {
      playerBoat.startFishing();
      fishingSound.play();
    }
  }
}

/*
  TODO:
 - Add Sound (DONE)
 - Add more fish
 - Add a scoring system (DONE)
 - Add a main menu
 - Add the fishing line mechanic (DONE)
 - Add a win lose  (Done)
 */
