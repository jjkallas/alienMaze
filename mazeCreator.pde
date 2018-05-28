
// alien maze creator    -    main program
//
// by jack kallas

import java.util.ArrayDeque;

Box[][] grid;

Box current;

ArrayDeque<Box> stack; 

int rowSize = 16;
int boxSize; 

boolean over;
PImage alien;

int popNum = 0;
float rand;


void setup()
{
  frameRate( 300 );
  size( 600, 600 );
  boxSize = width/rowSize;

  over = false;
  grid = new Box[rowSize][rowSize];
  stack = new ArrayDeque<Box>();
  
  alien = loadImage( "C:\\Users\\Jack\\workspace\\SpaceGame\\spaceMonster.png" );
  alien.resize( width/rowSize, width/rowSize );
  
  for ( int j = 0; j < rowSize; j++ ){
    for ( int i = 0; i < rowSize; i++ ){
      grid[i][j] = new Box(    i * boxSize   ,     j * boxSize    );
      grid[i][j].column = i;
      grid[i][j].row = j;
    }    
  }

// set treasure location
// grid[rowSize-1, 0 ];
  grid[(int) random(rowSize)][(int) random(rowSize)].treasure = true;

  current = grid[0][rowSize-1];
  current.selected = true;
  current.visited = true;

}

void draw()
{ 
  if ( !allVisited() ) { 

    //background(0);
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
  else { // if cells all visited
    over = true;
    //background(0);
    for ( int j = 0; j < rowSize; j++ ){
      for ( int i = 0; i < rowSize; i++ ){
        grid[i][j].display();
      }   
    }
  }

}

// this function is insanity that I realized I could rewrite in a handful of lines.

Box findNeighbor( int i, int j  )
{
  if ( i == 0 && j == 0 ){        // top left corner case
    
    if ( grid[i + 1][ j ].beenVisited() && grid[i][j + 1].beenVisited() )
    {
      return null; 
    }
    if ( grid[i + 1][j].beenVisited() ){
      return grid[i][j + 1]; 
    } 
    else if ( grid[i][j+1].beenVisited() ){
      return grid[i + 1][j];  
    }
    else if ( random( 1 ) > 0.5 ){
      return grid[i][j + 1];  
    }
    else {
      return grid[i + 1][j];  
    }
  }
  
  else if ( i == rowSize - 1 && j == rowSize - 1 ){   // bottom right corner case
    
    if ( grid[i - 1][ j ].beenVisited() && grid[i][j - 1].beenVisited() )
    {
      return null; 
    }
    if ( grid[i - 1][j].beenVisited() ){
      return grid[i][j - 1]; 
    } 
    else if ( grid[i][j - 1].beenVisited() ){
      return grid[i - 1][j];  
    }
    else if ( random( 1 ) > 0.5 ){
      return grid[i][j - 1];  
    }
    else {
      return grid[i - 1][j];  
    }
 
  }
  
  else if ( i == 0 && j == rowSize - 1 ){   // bottom left corner case
  
    if ( grid[i + 1][ j ].beenVisited() && grid[i][j - 1].beenVisited() )
    {
      return null; 
    }
    if ( grid[i + 1][j].beenVisited() ){
      return grid[i][j - 1]; 
    } 
    else if ( grid[i][j - 1].beenVisited() ){
      return grid[i + 1][j];  
    }
    else if ( random( 1 ) > 0.5 ){
      return grid[i][j - 1];  
    }
    else {
      return grid[i + 1][j];  
    }  
    
  }
  
  else if ( i == rowSize - 1 && j == 0 ){ //top right corner case
   
    if ( grid[i - 1][ j ].beenVisited() && grid[i][j + 1].beenVisited() )
    {
      return null; 
    }
    if ( grid[i - 1][j].beenVisited() ){
      return grid[i][j + 1]; 
    } 
    else if ( grid[i][j + 1].beenVisited() ){
      return grid[i - 1][j];  
    }
    else if ( random( 1 ) > 0.5 ){
      return grid[i][j + 1];  
    }
    else {
      return grid[i - 1][j];  
    }
    
  }
  
  else if ( j == 0 ) {  // TOP ROW CASE
    //             right                             below                        left
    if ( grid[i + 1][ j ].beenVisited() && grid[i][j + 1].beenVisited() && grid[i - 1][j].beenVisited() )
    {
      return null; 
    }
    
    if ( grid[i + 1][j].beenVisited() && grid[i - 1][j].beenVisited() ){ 
      return grid[i][j + 1]; // return below if right + left visited
    } 
    
    if ( grid[i + 1][j].beenVisited() && grid[i][j + 1].beenVisited() ){
      return grid[i - 1][j];  //return left if right + below visited
    }
    
    if ( grid[i - 1][j].beenVisited() && grid[i][j + 1].beenVisited() ){
      return grid[i + 1][j]; // return right if left + below visited  
    }
    
    if ( grid[i - 1][j].beenVisited() ){ // if left been visited, decide between right + below
      if ( random( 1 ) > 0.5 ){
        return grid[i][j + 1];  
      }
      else {
        return grid[i + 1][j];  
      }      
    }
    
    if ( grid[i + 1][j].beenVisited() ){ // if right been visited, decide between left + below
      if ( random( 1 ) > 0.5 ){
        return grid[i][j + 1];  
      }
      else {
        return grid[i - 1][j];  
      }      
    }
    
    if ( grid[i][j + 1].beenVisited() ){ // if below been visited, decide between left + right
      if ( random( 1 ) > 0.5 ){
        return grid[i - 1][j];  
      }
      else {
        return grid[i + 1][j];  
      }      
    }
    
    else if ( (rand = random( 1 )) > 0.66 ){ // none visited, randomly decide between the 3 neighbors
      return grid[i - 1][j];
    }
    else if ( rand > 0.33 ){
      return grid[i + 1][j]; 
    }
    else {
      return grid[i][j + 1]; 
    }
    
  } // end TOP ROW case
  
  else if ( i == 0 ){   // LEFT COLUMN case
    
    if ( grid[i + 1][ j ].beenVisited() && grid[i][j + 1].beenVisited() && grid[i][j - 1].beenVisited() )
    {
      return null; 
    }
    
    if ( grid[i + 1][j].beenVisited() && grid[i][j - 1].beenVisited() ){ 
      return grid[i][j + 1]; // return below if right + above visited
    } 
    
    if ( grid[i + 1][j].beenVisited() && grid[i][j + 1].beenVisited() ){
      return grid[i][j - 1];  //return above if right + below visited
    }
    
    if ( grid[i][j - 1].beenVisited() && grid[i][j + 1].beenVisited() ){
      return grid[i + 1][j]; // return right if above + below visited  
    }
    
    if ( grid[i][j - 1].beenVisited() ){ // if above been visited, decide between right + below
      if ( random( 1 ) > 0.5 ){
        return grid[i][j + 1];  
      }
      else {
        return grid[i + 1][j];  
      }      
    }
    
    if ( grid[i + 1][j].beenVisited() ){ // if right been visited, decide between above + below
      if ( random( 1 ) > 0.5 ){
        return grid[i][j + 1];  
      }
      else {
        return grid[i][j - 1];  
      }      
    }
    
    if ( grid[i][j + 1].beenVisited() ){ // if below been visited, decide between above + right
      if ( random( 1 ) > 0.5 ){
        return grid[i][j - 1];  
      }
      else {
        return grid[i + 1][j];  
      }      
    }
    
    else if ( (rand = random( 1 )) > 0.66 ){ // none visited, randomly decide between the 3 neighbors
      return grid[i][j - 1];
    }
    else if ( rand > 0.33 ){
      return grid[i + 1][j]; 
    }
    else {
      return grid[i][j + 1]; 
    }
    
  } // end LEFT COLUMN case
  
  else if ( j == rowSize - 1 ){ // BOTTOM ROW case
  
      if ( grid[i + 1][ j ].beenVisited() && grid[i][j - 1].beenVisited() && grid[i - 1][j].beenVisited() )
    {
      return null; 
    }
    
    if ( grid[i + 1][j].beenVisited() && grid[i - 1][j].beenVisited() ){ 
      return grid[i][j - 1]; // return above if right + left visited
    } 
    
    if ( grid[i + 1][j].beenVisited() && grid[i][j - 1].beenVisited() ){
      return grid[i - 1][j];  //return left if right + above visited
    }
    
    if ( grid[i - 1][j].beenVisited() && grid[i][j - 1].beenVisited() ){
      return grid[i + 1][j]; // return right if left + above visited  
    }
    
    if ( grid[i - 1][j].beenVisited() ){ // if left been visited, decide between right + above
      if ( random( 1 ) > 0.5 ){
        return grid[i][j - 1];  
      }
      else {
        return grid[i + 1][j];  
      }      
    }
    
    if ( grid[i + 1][j].beenVisited() ){ // if right been visited, decide between left + above
      if ( random( 1 ) > 0.5 ){
        return grid[i][j - 1];  
      }
      else {
        return grid[i - 1][j];  
      }      
    }
    
    if ( grid[i][j - 1].beenVisited() ){ // if above been visited, decide between left + right
      if ( random( 1 ) > 0.5 ){
        return grid[i - 1][j];  
      }
      else {
        return grid[i + 1][j];  
      }      
    }
    
    else if ( (rand = random( 1 )) > 0.66 ){ // none visited, randomly decide between the 3 neighbors
      return grid[i - 1][j];
    }
    else if ( rand > 0.33 ){
      return grid[i + 1][j]; 
    }
    else {
      return grid[i][j - 1]; 
    }

  } // end BOTTOM ROW case
  
  else if ( i == rowSize - 1 ){ // RIGHT COLUMN case
   
   if ( grid[i][ j - 1 ].beenVisited() && grid[i][j + 1].beenVisited() && grid[i - 1][j].beenVisited() )
    {
      return null; 
    }
    
    if ( grid[i][j - 1].beenVisited() && grid[i - 1][j].beenVisited() ){ 
      return grid[i][j + 1]; // return below if above + left visited
    } 
    
    if ( grid[i][j - 1].beenVisited() && grid[i][j + 1].beenVisited() ){
      return grid[i - 1][j];  //return left if above + below visited
    }
    
    if ( grid[i - 1][j].beenVisited() && grid[i][j + 1].beenVisited() ){
      return grid[i][j - 1]; // return above if left + below visited  
    }
    
    if ( grid[i - 1][j].beenVisited() ){ // if left been visited, decide between right + below
      if ( random( 1 ) > 0.5 ){
        return grid[i][j + 1];  
      }
      else {
        return grid[i][j - 1];  
      }      
    }
    
    if ( grid[i][j - 1].beenVisited() ){ // if above been visited, decide between left + below
      if ( random( 1 ) > 0.5 ){
        return grid[i][j + 1];  
      }
      else {
        return grid[i - 1][j];  
      }      
    }
    
    if ( grid[i][j + 1].beenVisited() ){ // if below been visited, decide between left + above
      if ( random( 1 ) > 0.5 ){
        return grid[i - 1][j];  
      }
      else {
        return grid[i][j - 1];  
      }      
    }
    
    else if ( (rand = random( 1 )) > 0.66 ){ // none visited, randomly decide between the 3 neighbors
      return grid[i - 1][j];
    }
    else if ( rand > 0.33 ){
      return grid[i][j - 1]; 
    }
    else {
      return grid[i][j + 1]; 
    }
  
  } // end RIGHT COLUMN case
  
  else { // DEFAULT case
    
    int done = 0;
    Box tester = new Box( 0, 0);
    
    if ( grid[i + 1][ j ].beenVisited() && grid[i][j + 1].beenVisited() 
    && grid[i - 1][j].beenVisited() && grid[i][j - 1].beenVisited() )
    {
      return null; 
    }
    
    while ( done == 0 ){
      
      if ( (rand = random( 1 )) > 0.75 ){
        tester = grid[i - 1][j];
      } else if ( rand > .5 ){
        tester = grid[i + 1][j];    
      } else if ( rand > .25 ){
        tester = grid[i][j - 1];
      } else {
        tester = grid[i][j + 1];  
      }
      
      if ( !tester.beenVisited() ){
        done = 1;
      }
    }
    
    return tester;
   
  } // end DEFAULT case
  
}// end findNeighbor() function






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
  if ( over == true ) {
    if ( keyCode == UP ){
      index = current.row - 1;
      if ( index >= 0 ){
        if ( grid[current.column][current.row - 1].bottom == false ){
          current.selected = false;
          current = grid[current.column][current.row - 1];
          current.selected = true;
          if ( current.treasure == true ){
            gameOver();
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
            gameOver();
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
            gameOver();
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
            gameOver();
          }
          
        }
      }
    }
  }
}

void gameOver(){
  background( 0, 0, 0 );
  textSize( 25 );
  fill( 55, 20, 200 );
  text( "Ouchie says, \"YOU LOSE! GOOD DAY, SIR!\"", 65, height/2 );
  noLoop();
}
