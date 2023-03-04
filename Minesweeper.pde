import de.bezier.guido.*;
public final static int NUM_ROWS = 9;
public final static int NUM_COLS = 9;
public final static int NUM_MINES = 7;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int i = 0; i < NUM_ROWS; i ++)
      for (int j = 0; j < NUM_COLS; j ++)
        buttons[i][j] = new MSButton(i, j);
    
    setMines();
}
public void setMines()
{
    while (mines.size() < NUM_MINES) {
      int row = (int)(Math.random() * NUM_ROWS);
      int col = (int)(Math.random() * NUM_COLS);
      if (!mines.contains(buttons[row][col])) {
        mines.add(buttons[row][col]);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for (int r = 0; r < NUM_ROWS; r ++) {
      for (int c = 0; c < NUM_COLS; c ++) {
        if (isValid(r, c) && !mines.contains(buttons[r][c]) && buttons[r][c].clicked == false)
            return false;
      }
    }
    return true;
}
public void displayLosingMessage()
{
    for (int i = 0; i < mines.size(); i ++) {
      mines.get(i).setLabel("BOMB");
      
      }
    fill(244, 8, 9);
    text("You Lose", 200, 200);
  // noLoop();
}
public void displayWinningMessage()
{
    //buttons[0][0].setLabel("YOU WON");
    text("You Won", 200, 200);
    noLoop();
    
}
public boolean isValid(int r, int c)
{
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
      return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int r = row - 1; r <= row + 1; r ++)
      for (int c = col - 1; c <= col + 1; c ++)
        if (isValid(r, c)  && mines.contains(buttons[r][c]))
          //count number of mines around the tile 
          numMines ++;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged, cantChange;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        
        if (mouseButton == RIGHT) {
          if (isFlagged() == true)
            //unflag the tile if flagged
            flagged = false;
            
          else if (isFlagged() == false)
            //flag and unclick the tile if not flagged
            flagged = true;
            clicked = false;
          }
          
          else if (isFlagged() == false && mines.contains(this))
            //you lose if tile clicked is a mine
            displayLosingMessage();
            
          else if (countMines(myRow, myCol) > 0)
            setLabel(countMines(myRow, myCol));
            
          else { 
            for (int r = myRow - 1; r <= myRow + 1; r ++) {
              for (int c = myCol - 1; c <= myCol + 1; c ++){
                //if there are no mines around the button pressed, review those buttons around it
                if (isValid(r, c) && buttons[r][c].clicked == false) {
                  buttons[r][c].mousePressed();
                }
              }
                }
          }
    }
    
    public void draw () {
      fill(0, 90, 150);
      if (cantChange == true) {
            //if you already clicked on the tile, the color stays the same, whiteish gray
           fill(200);
         }
            
        else if (isFlagged())
            //change tile to black to flag
            fill(0);
            
        else if(clicked && mines.contains(this)) 
            //change tile to red if tile clicked is a mine
            fill(255,0,0);

        else if(clicked) {
            //when clicked is true, set the tiles to whiteish grey
            cantChange = true;
            fill( 200 );
        }
        
        else
            //set tiles to dark grey
            fill( 100 );

        rect(x, y, width, height);
        fill(0, 90, 150);
        text(myLabel,x+width/2,y+height/2);

    }
        public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
