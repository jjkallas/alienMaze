// Jack Kallas
// MultQ class
// data structure to hold multiplication expression && answer

class MultQ {
  String expr; 
  int answer;
  
  MultQ() {
    int term1 = round( random( 0, 9) );
    int term2 = round( random( 0, 9) );
    
    this.answer = term1 * term2;
    this.expr = term1 + " x " + term2;
  }
  
  boolean checkAnswer( int guess ){
    if ( guess == answer ){
      return true;
    }
    return false;
  }
}
