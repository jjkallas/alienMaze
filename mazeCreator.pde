// maze creator      -    main program
//
// by jack kallas

import java.util.ArrayDeque;

Box[][] grid;

Box current;

ArrayDeque<Box> stack; 


//
// MAZE ROW SIZE VARIABLES  -  Change to increase/decrease maze size 
//
int rowSize = 16;
//
//   Can also change the size function parameters on line 39
//



int boxSize; 

boolean mazeCreated;
PImage alien;

int popNum = 0;
float rand;

// answer to math question
int answer; 


void setup()
{
  frameRate( 300 );
  size( 600, 600 );
  boxSize = width/rowSize;

  mazeCreated = false;
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
  for ( int i = 0; i < 25; i++ ){
    
    grid[(int) random(rowSize)][(int) random(rowSize)].treasure = true;

  }    
  
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
    mazeCreated = true;
    //background(0);
    for ( int j = 0; j < rowSize; j++ ){
      for ( int i = 0; i < rowSize; i++ ){
        grid[i][j].display();
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
  
  // Pick random neighbor from pool of potential neighbors
  rand = round( random( 0, neighbors.size() - 1) );
  
  // convert to array for element access and return it
  Box[] boxes = neighbors.toArray( new Box[0] );
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
  if ( mazeCreated == true ) {
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