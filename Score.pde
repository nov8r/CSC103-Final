class Score {
  int money;         
  int targetMoney;   
  float timeLimit;   
  float elapsedTime;

  Score(int targetMoney, float timeLimit) {
    this.money = 0;
    this.targetMoney = targetMoney;
    this.timeLimit = timeLimit * totalCycleTime;
    this.elapsedTime = 0;
  }

  void update() {
    elapsedTime++;
  }

  /*
    The addMoney function increases the amount of money the player currently has as they catch more fish
  */
  void addMoney(int amount) {
    money += amount;
  }

  /*
    The hasWon function just checks if money is greater than the target money to initiate the next level
  */
  boolean hasWon() {
    return money >= targetMoney;
  }

  /*
    The hasLost is the opposite of the hasWon function, it just checks if the elapsed time is greater than timeLimit and money is less than targetMoney
  */
  boolean hasLost() {
    return elapsedTime >= timeLimit && money < targetMoney;
  }

  /*
    The display function is pretty self explanatory, it just shows the score, target score, and time limit
  */
  void display() {
    fill(#369CFF);
    textAlign(LEFT, TOP);
    textSize(20);
    text("Money: $" + money, 10, 30);
    text("Target: $" + targetMoney, 10, 60);

    int remainingTime = int((timeLimit - elapsedTime) / 60);
    text("Time Left: " + remainingTime + "s", 10, 90);
  }
}
