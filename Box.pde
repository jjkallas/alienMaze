//
// box class
//
// grid will be composed of boxes
//
// maze will be cut out of the grid

class Box
{
  PVector loc;
  color c;
  boolean top;
  boolean bottom;
  boolean left;
  boolean right;
 
  int column;
  int row;

  boolean monster;
  boolean treasure;
  
  boolean selected;
  boolean visited;
  
  Box( float x, float y )
  {
    loc = new PVector( x, y ) ;
    c = color( 50, 100, 100 );
    top = bottom = left = right = true;
    selected = false;
    visited = false;
    monster = false;
    treasure = false;
  }
  
  
  void display()
  {
    noStroke();
    
    if ( selected ) {
      fill( 0, 73, 180, 200 ); 
    }
    else if ( visited ) {
      fill( 50, 50, 255, 100 );  
    }  
    else {
      fill( c );
    }
    
    rect( loc.x, loc.y, boxSize, boxSize );
    
    if ( treasure ){
      image( chest, loc.x, loc.y );
    } else if ( monster ){
      image( alien, loc.x, loc.y );
    }
    
    stroke( 0 ); 
    if ( top ) line( loc.x, loc.y, loc.x + boxSize, loc.y );
    if ( bottom ) line( loc.x, loc.y + boxSize, loc.x + boxSize, loc.y + boxSize );
    if ( left ) line( loc.x, loc.y, loc.x, loc.y + boxSize );
    if ( right ) line( loc.x + boxSize, loc.y, loc.x + boxSize, loc.y + boxSize );
  }
  
  boolean beenVisited()
  {
    return visited; 
  }
 
}
