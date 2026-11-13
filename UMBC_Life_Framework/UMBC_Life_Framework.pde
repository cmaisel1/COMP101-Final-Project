// UMBC LIFE - COMP 101
// Demo: Weeks 1 and 2 only, with four decisions per week (eight total).
// The full game is planned for 15 weeks. Weeks 3-15 are not written yet.
//Images are loaded once and stored in the "data" folder.

int Grades = 50;       // Academic progress.
int Money = 50;        // Money available.
int Health = 50;       // Physical well-being.
int Happiness = 50;    // Mood and social well-being.

// Weeks are numbered 1-15 so the number matches what the player sees.
int totalWeeks = 15;
int playableWeeks = 2; // Add the next week in drawScenario and handleChoice before increasing.
int currentWeek = 1;
int currentNode = 0;   // Position in this week's decision tree.
int decisionsMade = 0; // Counts choices in the current week; resets each week.
int gameState = 0;     // 0 = playing, 1 = ended.
boolean winState = false;
boolean demoComplete = false; // Finishing the demo is different from winning Week 15.

// Eight images: campus backgrounds at positions 0-6, mascot at position 7.
// exam.jpg is also used for ordinary classroom visits for now.
String[] imageFiles = {
  "dorm.jpg", "library.jpg", "cafe.jpg", "exam.jpg",
  "workout.jpg", "friends.jpg", "bills.jpg", "TrueGritMascot.jpeg"
};
PImage[] sceneImages = new PImage[8];

// Image positions for nodes 0-7. Both weeks reuse these locations.
int[] sceneForNode = {0, 1, 2, 3, 4, 5, 6, 0};

void setup() {
  // Processing runs setup once at startup.
  size(800, 600);
  textFont(createFont("Arial", 16));
  initializeGame();

  // Load all eight images once, including the mascot.
  for (int i = 0; i < sceneImages.length; i++) {
    sceneImages[i] = loadImage(imageFiles[i]);
  }
}

void initializeGame() {
  // Reset everything so a new game always starts with stat bars at 50%.
  Health = 50;
  Happiness = 50;
  Grades = 50;
  Money = 50;
  currentWeek = 1;
  currentNode = 0;
  decisionsMade = 0;
  gameState = 0;
  winState = false;
  demoComplete = false;
}

void draw() {
  // Background first, then buttons and bars, then story text.
  int sceneIndex = sceneForNode[currentNode];
  drawSceneBackground(sceneIndex);
  drawBase();
  drawLayout();

  if (gameState == 0) {
    drawScenario();
  } else {
    drawEnding();
  }
}

void drawSceneBackground(int sceneIndex) {
  background(30);
  PImage scene = sceneImages[sceneIndex];
  if (scene != null && scene.width > 0 && scene.height > 0) {
    float sceneHeight = 450;
    // Calculate the scale in each direction using division.
    float widthScale = (float) width / scene.width;
    float heightScale = sceneHeight / scene.height;

    // Use the smaller scale so the whole photo fits in the available space. Still needs work.
    float scale = widthScale;
    if (heightScale < widthScale) {
      scale = heightScale;
    }

    float imageWidth = scene.width * scale;
    float imageHeight = scene.height * scale;
    // Divide the leftover space by two to center the photo.
    float imageX = (width - imageWidth) / 2;
    float imageY = (sceneHeight - imageHeight) / 2;
    // Attempting to fill side gaps behind the centered photo.
    image(scene, 0, 0, width, height);
    image(scene, imageX, imageY, imageWidth, imageHeight);
  } else {
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(17);
    text("Image unavailable: " + imageFiles[sceneIndex], width / 2, 200);
  }
}

void drawOverlayText(String label, float x, float y) {
  // Draw a dark shadow, then white text at the requested position.
  fill(0, 220);
  text(label, x + 2, y + 2);
  fill(255);
  text(label, x, y);
}

void drawBase() {
  // Only the choice panels have an opaque gray background.
  stroke(20);
  fill(#656C65);
  rect(0, 450, 400, 150);
  rect(400, 450, 400, 150);

  // Position 7 holds the mascot loaded in setup().
  PImage Mascot = sceneImages[7];
  // Fit it inside the frame, with a label if the file is missing.
  if (Mascot != null && Mascot.width > 0 && Mascot.height > 0) {
    float avatarScale = 80.0 / max(Mascot.width, Mascot.height);
    float avatarWidth = Mascot.width * avatarScale;
    float avatarHeight = Mascot.height * avatarScale;
    image(Mascot, 700 + (80 - avatarWidth) / 2, 20 + (80 - avatarHeight) / 2,
          avatarWidth, avatarHeight);
  } else {
    textSize(12);
    textAlign(CENTER, CENTER);
    drawOverlayText("Avatar", 740, 60);
  }

  // Draw the border last so it stays visible over the picture.
  noFill();
  stroke(255);
  rect(700, 20, 80, 80);
}

void drawLayout() {
  // Show the current week, upcoming choice number, and four stats.
  textAlign(CENTER, CENTER);
  textSize(14);
  drawOverlayText("Week " + currentWeek + " of " + totalWeeks, 400, 25);
  if (gameState == 0) {
    drawOverlayText("Decision " + (decisionsMade + 1) + " this week", 400, 44);
  }
  drawStatBar("Health", Health, 20, 20, #E30909);
  drawStatBar("Happiness", Happiness, 20, 50, #C909E3);
  drawStatBar("Grades", Grades, 20, 80, #0927E3);
  drawStatBar("Money", Money, 20, 110, #09E30A);
}

void drawStatBar(String label, int value, int x, int y, color barColor) {
  int barWidth = 130;
  int barHeight = 25;
  stroke(0);
  fill(0, 150); // Translucent empty portion over the scene.
  rect(x, y, barWidth, barHeight);
  noStroke();
  fill(barColor);
  // Leave a one-pixel border on each side of the colored fill.
  float filledWidth = (barWidth - 2) * value / 100.0;
  rect(x + 1, y + 1, filledWidth, barHeight - 2);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(12);
  text(label + ": " + value + "%", x + barWidth / 2, y + barHeight / 2);
}

void drawScenario() {
  // Match this text to the same week/node choices in handleChoice().
  String heading = "";
  String story = "";
  String optionA = "";
  String optionB = "";
  if (currentWeek == 1) {
    if (currentNode == 0) {
      heading = "Move-in Day";
      story = "Your first week at UMBC begins. How will you spend tonight?";
      optionA = "Study and settle in";
      optionB = "Go out and meet people";
    }
    else if (currentNode == 1) {
      heading = "The Library";
      story = "You have some time before the first class check-in.";
      optionA = "Review the first lesson";
      optionB = "Take a break at the RAC";
    }
    else if (currentNode == 2) {
      heading = "Campus Cafe";
      story = "You recognize a few classmates from move-in. How will you spend lunch?";
      optionA = "Ask about a study group";
      optionB = "Buy lunch and check your budget";
    }
    else if (currentNode == 3) {
      heading = "First Class Check-In";
      story = "Your instructor gives a short practice quiz to see how everyone is settling in.";
      optionA = "Try the challenge questions";
      optionB = "Review feedback and head home";
    }
    else if (currentNode == 4) {
      heading = "Workout at the RAC";
      story = "A workout could lift your mood, but you still have reading to do.";
      optionA = "Do a full workout";
      optionB = "Do a quick workout, then study";
    }
    else if (currentNode == 5) {
      heading = "Meet the Study Group";
      story = "Your classmates are deciding what to do after the first meeting.";
      optionA = "Review the reading together";
      optionB = "Take a break with your new friends";
    }
    else if (currentNode == 6) {
      heading = "Move-in Expenses";
      story = "Between supplies and eating out, the first week cost more than expected.";
      optionA = "Pick up a paid shift";
      optionB = "Plan cheaper meals and review notes";
    }
    else if (currentNode == 7) {
      heading = "Back at the Dorm";
      story = "The first week is winding down. How will you get ready for Week 2?";
      optionA = "Get an early night";
      optionB = "Organize your notes and schedule";
    }
  }
  else if (currentWeek == 2) {
    if (currentNode == 0) {
      heading = "A Week 2 Routine";
      story = "You're back in your dorm with your first assignment due this week.";
      optionA = "Head to the library";
      optionB = "Catch up with classmates at the cafe";
    }
    else if (currentNode == 1) {
      heading = "Return to the Library";
      story = "Your assignment is taking shape, and there's time for one more activity today.";
      optionA = "Finish a draft before class";
      optionB = "Save the draft and visit the RAC";
    }
    else if (currentNode == 2) {
      heading = "Lunch at the Cafe";
      story = "You run into friends as you're deciding what to do after lunch.";
      optionA = "Meet up for group study";
      optionB = "Head home and review your expenses";
    }
    else if (currentNode == 3) {
      heading = "Class Feedback";
      story = "Your instructor offers feedback on the first assignment.";
      optionA = "Revise the hardest section";
      optionB = "Fix the essentials and take a break";
    }
    else if (currentNode == 4) {
      heading = "Back at the RAC";
      story = "You have time for a workout before the assignment is due.";
      optionA = "Do a full workout";
      optionB = "Stretch, then finish the assignment";
    }
    else if (currentNode == 5) {
      heading = "Study with Friends";
      story = "Your group has time to work together or relax after class.";
      optionA = "Proofread each other's assignments";
      optionB = "Relax together before heading home";
    }
    else if (currentNode == 6) {
      heading = "Week 2 Budget";
      story = "You need to cover your expenses and submit your assignment.";
      optionA = "Work a paid shift";
      optionB = "Cut spending and finish the assignment";
    }
    else if (currentNode == 7) {
      heading = "End of Week 2";
      story = "Back in your dorm, you have one last evening to prepare for the week ahead.";
      optionA = "Rest and reset";
      optionB = "Review your work and plan ahead";
    }
  }

  // Story overlays the scene above the choice panels.
  textAlign(CENTER, CENTER);
  textSize(22);
  drawOverlayText(heading, 400, 340);
  textSize(16);
  fill(0, 220);
  text(story, 92, 372, 620, 60);
  fill(255);
  text(story, 90, 370, 620, 60);
  // Draw choice labels inside the existing bottom UI rectangles.
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(17);
  text("A: " + optionA, 20, 470, 360, 110);
  text("B: " + optionB, 420, 470, 360, 110);
}

void mousePressed() {
  // Only clicks inside the bottom panels for selecting an option or restarting.
  if (mouseY < 450 || mouseY >= height) {
    return;
  }
  if (gameState == 0) {
    // The window is 800 pixels wide, so 400 is the dividing line.
    if (mouseX < 400) {
      handleChoice(0);
    } else {
      handleChoice(1);
    }
  } else {
    initializeGame();
  }
}

void handleChoice(int choice) {
  // Select week, then node, then option: 0 = A, 1 = B.
  // Ignore choices after an ending.
  if (gameState != 0) {
    return;
  }

  // Each branch sets a destination; -1 ends the week.
  // updateStats arguments: Grades, Health, Happiness, Money.
  int nextScene = -1;
  if (currentWeek == 1) {
    // Node 0: Move-in Day.
    if (currentNode == 0) {
      if (choice == 0) {
        // Study and settle in.
        updateStats(15, -5, -5, 0);
        nextScene = 1; // library
      }
      else {
        // Go out and meet people.
        updateStats(-10, -5, 15, -5);
        nextScene = 2; // cafe
      }
    }
    // Node 1: The Library.
    else if (currentNode == 1) {
      if (choice == 0) {
        // Review the first lesson.
        updateStats(10, -5, -5, 0);
        nextScene = 3; // classroom
      }
      else {
        // Take a break at the RAC.
        updateStats(0, 0, 5, 0);
        nextScene = 4; // RAC gym
      }
    }
    // Node 2: Campus Cafe.
    else if (currentNode == 2) {
      if (choice == 0) {
        // Ask about a study group.
        updateStats(5, 0, 5, 0);
        nextScene = 5; // study group
      }
      else {
        // Buy lunch and check your budget.
        updateStats(0, 5, 10, -10);
        nextScene = 6; // budget check
      }
    }
    // Node 3: First Class Check-In.
    else if (currentNode == 3) {
      if (choice == 0) {
        // Try the challenge questions.
        updateStats(10, -5, 0, 0);
        nextScene = 7; // dorm
      }
      else {
        // Review feedback and head home.
        updateStats(5, 5, 5, 0);
        nextScene = 7; // dorm
      }
    }
    // Node 4: Workout at the RAC.
    else if (currentNode == 4) {
      if (choice == 0) {
        // Do a full workout.
        updateStats(-10, 20, 15, 0);
        nextScene = 7; // dorm
      }
      else {
        // Do a quick workout, then study.
        updateStats(10, 10, 10, 0);
        nextScene = 7; // dorm
      }
    }
    // Node 5: Meet the Study Group.
    else if (currentNode == 5) {
      if (choice == 0) {
        // Review the reading together.
        updateStats(15, -5, 10, 0);
        nextScene = 7; // dorm
      }
      else {
        // Take a break with your new friends.
        updateStats(-5, 5, 15, -5);
        nextScene = 7; // dorm
      }
    }
    // Node 6: Move-in Expenses.
    else if (currentNode == 6) {
      if (choice == 0) {
        // Pick up a paid shift.
        updateStats(-5, -10, -5, 20);
        nextScene = 7; // dorm
      }
      else {
        // Plan cheaper meals and review notes.
        updateStats(5, 0, -5, 10);
        nextScene = 7; // dorm
      }
    }
    // Node 7: Back at the Dorm.
    else if (currentNode == 7) {
      if (choice == 0) {
        // Get an early night.
        updateStats(0, 15, 5, 0);
        nextScene = -1; // End this week.
      }
      else {
        // Organize your notes and schedule.
        updateStats(10, -5, 0, 0);
        nextScene = -1; // End this week.
      }
    }
  }
  else if (currentWeek == 2) {
    // Node 0: A Week 2 Routine.
    if (currentNode == 0) {
      if (choice == 0) {
        // Head to the library.
        updateStats(5, 0, -5, 0);
        nextScene = 1; // library
      }
      else {
        // Catch up with classmates at the cafe.
        updateStats(0, 0, 10, -5);
        nextScene = 2; // cafe
      }
    }
    // Node 1: Return to the Library.
    else if (currentNode == 1) {
      if (choice == 0) {
        // Finish a draft before class.
        updateStats(10, -5, -5, 0);
        nextScene = 3; // classroom
      }
      else {
        // Save the draft and visit the RAC.
        updateStats(0, 0, 5, 0);
        nextScene = 4; // RAC gym
      }
    }
    // Node 2: Lunch at the Cafe.
    else if (currentNode == 2) {
      if (choice == 0) {
        // Meet up for group study.
        updateStats(5, 0, 5, 0);
        nextScene = 5; // study group
      }
      else {
        // Head home and review your expenses.
        updateStats(0, 0, 0, 5);
        nextScene = 6; // budget check
      }
    }
    // Node 3: Class Feedback.
    else if (currentNode == 3) {
      if (choice == 0) {
        // Revise the hardest section.
        updateStats(15, -10, -5, 0);
        nextScene = 7; // dorm
      }
      else {
        // Fix the essentials and take a break.
        updateStats(5, 5, 5, 0);
        nextScene = 7; // dorm
      }
    }
    // Node 4: Back at the RAC.
    else if (currentNode == 4) {
      if (choice == 0) {
        // Do a full workout.
        updateStats(-10, 15, 15, 0);
        nextScene = 7; // dorm
      }
      else {
        // Stretch, then finish the assignment.
        updateStats(10, 10, 5, 0);
        nextScene = 7; // dorm
      }
    }
    // Node 5: Study with Friends.
    else if (currentNode == 5) {
      if (choice == 0) {
        // Proofread each other's assignments.
        updateStats(15, -5, 5, 0);
        nextScene = 7; // dorm
      }
      else {
        // Relax together before heading home.
        updateStats(-5, 10, 15, -5);
        nextScene = 7; // dorm
      }
    }
    // Node 6: Week 2 Budget.
    else if (currentNode == 6) {
      if (choice == 0) {
        // Work a paid shift.
        updateStats(-5, -10, -5, 20);
        nextScene = 7; // dorm
      }
      else {
        // Cut spending and finish the assignment.
        updateStats(10, 0, -5, 5);
        nextScene = 7; // dorm
      }
    }
    // Node 7: End of Week 2.
    else if (currentNode == 7) {
      if (choice == 0) {
        // Rest and reset.
        updateStats(0, 15, 10, 0);
        nextScene = -1; // End this week.
      }
      else {
        // Review your work and plan ahead.
        updateStats(10, -5, 0, 5);
        nextScene = -1; // End this week.
      }
    }
  }
  // Count once per click.
  decisionsMade++;

  // End the game if any stat reaches zero; otherwise advance.
  if (Health == 0 || Happiness == 0 || Grades == 0 || Money == 0) {
    gameState = 1;
  } else {
    nextNode(nextScene);
  }
}

void updateStats(int gradeMod, int staminaMod, int happyMod, int cashMod) {
  // staminaMod affects Health. Keep every stat between 0 and 100.
  Grades = constrain(Grades + gradeMod, 0, 100);
  Health = constrain(Health + staminaMod, 0, 100);
  Happiness = constrain(Happiness + happyMod, 0, 100);
  Money = constrain(Money + cashMod, 0, 100);
}

void nextNode(int nextScene) {
  // A node number stays in this week; -1 triggers the week-ending checks.
  if (nextScene != -1) {
    currentNode = nextScene;
  } else if (currentWeek == totalWeeks) {
    // Only the full semester uses the final win requirements.
    winState = Health >= 30 && Happiness >= 35 && Grades >= 60 && Money >= 30;
    gameState = 1;
  } else if (currentWeek == playableWeeks) {
    // Stop after Week 2 until more weekly stories are implemented.
    demoComplete = true;
    gameState = 1;
  } else {
    // Carry stats into the next week. Reset only its scene and decision count.
    currentWeek++;
    currentNode = 0;
    decisionsMade = 0;
  }
}

void drawEnding() {
  // For setting up the demo, win, or loss message, then show the ending stats.
  textAlign(CENTER, CENTER);
  textSize(34);
  if (demoComplete) {
    drawOverlayText("DEMO COMPLETE", 400, 220);
    textSize(17);
    drawOverlayText("You finished the first " + currentWeek + " weeks.", 400, 260);
  } else {
    if (winState) {
      drawOverlayText("YOU WIN!", 400, 240);
    } else {
      drawOverlayText("GAME OVER", 400, 240);
    }
  }
  textSize(17);
  drawOverlayText("Ending stats: Health " + Health + " | Happiness " + Happiness +
       " | Grades " + Grades + " | Money " + Money, 400, 300);
  text("Click either bottom panel to play again", 400, 520);
}
