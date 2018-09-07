// maze creator      -    main program
// alien math game
// by Jack Kallas

import java.util.ArrayDeque;

Box[][] grid;
Box current;

ArrayDeque<Box> stack; 

//
// MAZE ROW SIZE VARIABLES  -  Change to increase/decrease maze size 
//
int rowSize = 15;
int numAliens = 25;
//
//   Can also change the size function parameters on line 44 / at beginning of setup()
//

int boxSize; 

boolean mazeCreated;
boolean quizActive;
boolean gameWon;

//Images used
PImage chest;
PImage alien;
PImage bigAlien;

int popNum = 0;
float rand; 

int numGuess = 0;
MultQ quiz;          // quiz object
String pGuess;         // player's guess
int numCorrect;
int numWrong;

void setup()
{
  frameRate( 300 );
  size( 700, 700 );
  
  boxSize = width/rowSize;

  mazeCreated = false;
  quizActive = false;
  gameWon = false;
  
  pGuess = "";       //  initialize player's guess
  numCorrect = 0;
  numWrong = 0;
  
  grid = new Box[rowSize][rowSize];
  stack = new ArrayDeque<Box>();
  
  chest = loadImage( "C:\\Users\\Student\\Pictures\\chest.png" );
  chest.resize( width/rowSize, width/rowSize );
  
  alien = loadImage( "C:\\Users\\Student\\Pictures\\spaceMonster.png" );
  bigAlien = loadImage( "C:\\Users\\Student\\Pictures\\spaceMonster.png" );
  bigAlien.resize( 300, 300 );
  alien.resize( width/rowSize, width/rowSize );
  
  
  for ( int j = 0; j < rowSize; j++ ){
    for ( int i = 0; i < rowSize; i++ ){
      grid[i][j] = new Box(    i * boxSize   ,     j * boxSize    );
      grid[i][j].column = i;
      grid[i][j].row = j;
    }    
  }
  
  // selects positions for aliens ( within 0 to rowSize-1 )
  for ( int i = 0; i < numAliens; i++ ){
    grid[ (int) random(rowSize) ][ (int) random(rowSize) ].monster = true; 
  }    
  
  // set treasure location to top right corner
  grid[rowSize - 1][0].treasure = true;
  grid[rowSize - 1][0].monster = false;
  
  current = grid[0][rowSize-1];
  current.selected = true;
  current.visited = true;  

}

void draw()
{ 
  if ( !allVisited() ) { //Maze being generated i.e. not all boxes visited yet
  
    background(0);
    for ( int j = 0; j < rowSize; j++ ){
      for ( int i = 0; i < rowSize; i++ ){
        grid[i][j].display();
      }   
    }

   Box neighbor; 

   if ( (neighbor = findNeighbor( current.column, current.row )) != null ) //if found unvisited NEIGHBOR
    {
      
      int oldI = current.column;
      int oldJ = current.row;
      
      int newI = neighbor.column;
      int newJ = neighbor.row;
      
      if ( newI > oldI ){ //neighbor on right
        current.right = false;
        neighbor.left = false;
      }
      if ( newI < oldI ){ //neighbor on left
        current.left = false;
        neighbor.right = false;
      }
      if ( newJ > oldJ ){ //neighbor is below
        current.bottom = false;
        neighbor.top = false;
      }
      if ( newJ < oldJ ){ //neighbor is above
        current.top = false;
        neighbor.bottom = false;
      }
      
      stack.push( current );
      
      current.selected = false; 
      current = neighbor;
      current.visited = true;
      current.selected = true;
    }
    
    else if ( !stack.isEmpty() ){ 
      current.selected = false;
      current = stack.pop();
      current.selected = true;
      println( "popping..." + (++popNum) );
    }

  } 
  else { // Maze generated. Game active.
    if ( mazeCreated == false ) { // game is just beginning
      mazeCreated = true;
      current.selected = false;
      current = grid[0][rowSize - 1];
      current.selected = true;
    }
    if ( gameWon ) {    // game won, treasure found
      background( 0 );
      fill( 255, 50, 0 );
      if ( numWrong == 0 ){
        text( "WOW! Perfect score.", width/3, height/4 );
      } else {
        text( "Even Newton and Einstein made mistakes. Nice job!", 50, height/4 );
      }
      
      text( "You are the winner!", width/4, height/5 );
      text( "Number correct: " + numCorrect, width/4, height/2 );
      text( "Number incorrect: " + numWrong, width/4, height/2 + 25 );
      
      fill( 200, 20, 0 );
      text( "Press ENTER to play again.", width / 5, height /2 + 75 );
      
    }
    if ( quizActive == true ) {
      background( 0, 0, 0 );
      
      fill( 20, 150, 20 );
      textSize( 18 );
      text( "Correct answers: " + numCorrect, width/4 + 70, 25);
      
      fill( 200, 50, 0 );
      textSize( 18 );
      text( "Chances before disintegration: " + numGuess, width/4, 50 ); 
      
      image( bigAlien, width/2 - 160, height/4 - 50 );
      
      textSize( 25 );
      fill( 55, 20, 200 );
      text( "Ouchie says, \"My friend! What is " + quiz.expr + "?!\"", 65, height/1.2 - 50 );
      
      fill( 5, 150, 50 );
      text( "You say: \"  " + pGuess + "  \"", 65, height/1.2 + 25 );   
    }
    if ( !quizActive && !gameWon ){ // regular maze mode
      background( 0 );
      for ( int j = 0; j < rowSize; j++ ){
        for ( int i = 0; i < rowSize; i++ ){
          grid[i][j].display();
        }   
      }
    }
  }

}

// Takes current box's column and row AND returns a suitable box to move toward
Box findNeighbor( int i, int j ){
  int rand;
  boolean leftBound, rightBound, aboveBound, belowBound;    // bounds for edge cases
  leftBound = rightBound = aboveBound = belowBound = false; // set to false
  ArrayDeque<Box> neighbors = new ArrayDeque<Box>();
  
  // set out of bound sides to true
  //
  if ( i + 1 >= rowSize )  rightBound = true;
  if ( i - 1 < 0 )         leftBound = true; 
  if ( j + 1 >= rowSize )  belowBound = true;
  if ( j - 1 < 0 )         aboveBound = true; 

  //add Boxes to possible neighbors array if they aren't out of bounds and haven't been visited
  if ( !rightBound ){
    if ( !grid[ i + 1 ][ j ].beenVisited() ){
      neighbors.push( grid[ i + 1 ][ j ] );
    }
  }
  if ( !leftBound ){
    if ( !grid[ i - 1 ][ j ].beenVisited() ){
      neighbors.push( grid[ i - 1 ][ j ] );
    }
  }
  
  if ( !belowBound ){
    if ( !grid[ i ][ j + 1 ].beenVisited() ){
      neighbors.push( grid[ i ][ j + 1 ] );
    }
  }
  
  if ( !aboveBound ){
    if ( !grid[ i ][ j - 1 ].beenVisited() ){
      neighbors.push( grid[ i ][ j - 1 ] );
    }
  }
  
  // array is empty -> return null cuz no neighbors
  if ( neighbors.isEmpty() ){
    return null;  
  }
  
  // convert ArrayDequeue to array for element access
  Box[] boxes = neighbors.toArray( new Box[0] );
  
  // Pick random neighbor from pool of potential neighbors and then return it
  rand = round( random( 0, neighbors.size() - 1) );
  return boxes[rand];
}


boolean allVisited()
{
  for ( int j = 0; j < rowSize; j++ ){
    for ( int i = 0; i < rowSize; i++ ){
       if ( grid[i][j].visited == false ) return false;
    }
  }
  return true;
}


void keyPressed()
{
  int index;
  if ( mazeCreated == true && quizActive == false && gameWon == false ) {
    if ( keyCode == UP ){
      index = current.row - 1;
      if ( index >= 0 ){
        if ( grid[current.column][current.row - 1].bottom == false ){
          current.selected = false;
          current = grid[current.column][current.row - 1];
          current.selected = true;
          if ( current.treasure == true ){
            gameWon = true; 
          }
          if ( current.monster == true ){
            startQuiz();
          }
        }
      }
    }
    if ( keyCode == DOWN ){
      index = current.row + 1;
      if ( index < rowSize ){
        if ( grid[current.column][current.row + 1].top == false ){
          current.selected = false;
          current = grid[current.column][current.row + 1];
          current.selected = true;  
          if ( current.treasure == true ){
            gameWon = true; 
          }
          if ( current.monster == true ){
            startQuiz();
          }
        }
      }
    }
  
    if ( keyCode == LEFT ){
      index = current.column - 1;
      if ( index >= 0 ) {
        if ( grid[current.column - 1][current.row].right == false ){
          current.selected = false;
          current = grid[current.column - 1][current.row];
          current.selected = true;  
          if ( current.treasure == true ){
            gameWon = true; 
          }
          if ( current.monster == true ){
            startQuiz();
          }
        }
      }
    }
    if ( keyCode == RIGHT ){
      index = current.column + 1;
      if ( index < rowSize ){
        if ( grid[current.column + 1][current.row].left == false ){
          current.selected = false;
          current = grid[current.column + 1][current.row];
          current.selected = true;  
          if ( current.treasure == true ){
            gameWon = true; 
          }
          if ( current.monster == true ){
            startQuiz();
          }
        }
      }
    }
  } else if ( quizActive ) {
    if ( keyCode == ENTER ){
      if ( quiz.checkAnswer( parseInt( pGuess ) ) == true ){ // user's answer was correct
        numCorrect++;
        endQuiz();
      }
      else {                                                 // user's answer was incorrect
        numGuess--;
        if ( numGuess == 0 ){
          numWrong++;
          endQuiz();
        }
      }
    }
    else if ( keyCode == BACKSPACE && pGuess.length() > 0 ){
      pGuess = pGuess.substring( 0, pGuess.length() - 1 );
    }
    else {
      pGuess = pGuess + key;
    }  
  }
  if ( gameWon ) {
    if ( keyCode == ENTER ) {  // User wants to play again -> rerun program
      setup();
    }
  }
}

// Create multiplication problem and set number of guesses to 2
void startQuiz(){
  MultQ q = new MultQ(); // creates new multiplication problem
  quizActive = true; 
  numGuess = 2; 
  pGuess = "";
  quiz = q; 
}

void endQuiz(){
  quizActive = false;
  current.monster = false;
}
