final int MANA_MAX = 6, CARD_AMOUNT = 9;
int currManaMax = 2, health = 20;
int mana = currManaMax;
int rows = 4, cols = 4;
Card[] field = new Card[rows * cols];
Hand hand;
AI ai;
DrawDeck drawDeck;
DrawDeck discardDeck;
boolean turnEnd = false;


String[] cardNames = {"cat", "wolf", "bear", "lizard", "rat", "poisonous_frog", "rock", "elk", "turtle"};
int[] manaCosts    = {    2,      4,      6,        1,     1,                3,      1,     3,        3};
int[] attacks      = {    1,      3,      3,        1,     0,                1,      0,     2,        1};
int[] healthValues = {    2,      2,      6,        1,     2,                1,      5,     5,        8};
int[] abilities    = {    2,      1,      0,        0,     3,                5,      0,     0,        0};

// abilities:
// 0 = nothign, 1 = wolf pack, +1 atk to wolves, 2 = nine lives aced, cat card returned to hand on death
// 3 = rat scavenger, return 1 card from dead zone to hand, 4 = buff (later) 5 = poison (insta kill card on death)
 
PImage[] cards = new PImage[cardNames.length];

void setup(){
  size(1000, 650);
  hand = new Hand();
  for(int i = 0; i < 4; i++){
    int n = int(random(CARD_AMOUNT));
    hand.drawCard(new Card((cardNames[n] + ".png"), manaCosts[n], attacks[n], healthValues[n], abilities[n]));
  }
  drawDeck = new DrawDeck();
  for(int i = 0; i < 15; i++){
    int n = int(random(CARD_AMOUNT));
    drawDeck.addCard(new Card((cardNames[n] + ".png"), manaCosts[n], attacks[n], healthValues[n], abilities[n]));
  }
  AI AI = new AI();
  for(int i = 0; i < 4; i++){
    int n = int(random(CARD_AMOUNT));
    AI.drawCard(new Card((cardNames[n] + ".png"), manaCosts[n], attacks[n], healthValues[n], abilities[n]));
  }
}

void draw() {
  background(200);
  hand.display();
  //field.display();

  // set up the ai health
  ellipse(0, width / 2, 50, 75);
  text(ai.health, 40, 50);

  circle(width - 50, height - 50, 50);
  text(health, 40, 40);

  rect(0, 300, 100, 50);
  text("End Turn", 90, 40);

  discardDeck.display();
  drawDeck.display();

  if (turnEnd) {
    AI.startTurn();
  }
  //if ai's turn ends, startround();
  startRound();
}

void startRound() {
  hand.drawCard();
  drawDeck.remove();
}


/*
 * check if click is on a card
 * check if next click is on a valid field
 * if click somewhere else, unselect
 */
void mouseClicked() {
  int a;
  if(hand.selected == -1 && hand.n > 0) { //if no card selected, check if card selected;
    a = hand.select();
  } else { //if card was already selected, see if the click is on a EMPTY field tile
    for (int i = 0; i < field.length; i++) {
      if ((mouseX > field[i].x && mouseX < field[i].x + width) && (mouseY > field[i].y && mouseY < field[i].y + height)) {
        //if tile was clicked on, set field[i] = hand.inHand[selected];
        hand.selected = -1;
        break;
      }
    }
    if (hand.selected == hand.select()) { //if the selected card was clikced on, deselected
      hand.selected = -1;
    }
    //if mouse clicks on "END TURN" button, end turn
    if (mouseX > 0 && mouseX < 100 && mouseY > 300 && mouseY < 350) {
      turnEnd = true;
    }
  }
}