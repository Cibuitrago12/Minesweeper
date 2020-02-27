import de.bezier.guido.*;
public final static int NUM_COLS = 5;
public final static int NUM_ROWS = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private int NUM_MINES = 1;//(NUM_COLS * NUM_ROWS)/5;
void setup ()
{
    size(400, 500);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < buttons[r].length; c++)
            buttons[r][c] = new MSButton(r, c); 

    
    setMines();
}
public void setMines()
{
    for(int i = 0; i < NUM_MINES; i++){
        int ranRow = (int)(Math.random() * NUM_ROWS);
        int ranCol = (int)(Math.random() * NUM_COLS);
        if(!mines.contains(buttons[ranRow][ranCol])){
            mines.add(buttons[ranRow][ranCol]);
            System.out.println("Mines at: " + ranRow + ", " + ranCol);
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
    int numFlaggedMines = 0;
    for(int i = 0; i < mines.size(); i++){
        if(mines.get(i).isFlagged()){
            numFlaggedMines++;
        }
    }
    if(numFlaggedMines == mines.size())
        return true;
    return false;
}
public void displayLosingMessage()
{
    System.out.println("boom");
    background(230);
    fill(255);
    textSize(50);
    text("You Lose!",width/2, 450);
    noLoop();
    
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < buttons[r].length; c++)
            buttons[r][c].clicked = true; 
}
public void displayWinningMessage()
{
    System.out.println("You win!");
    fill(255);
    textSize(50);
    text("You Win!",width/2, height/2);
    noLoop();

    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < buttons[r].length; c++)
            buttons[r][c].clicked = true; 
}
public boolean isValid(int r, int c)
{
    if(r < NUM_ROWS && c < NUM_COLS && r >= 0 && c >= 0)
        return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row -1; r <= row+1; r++){
        for(int c = col - 1; c <= col+1; c++){
            if(isValid(r, c)){
                if(mines.contains(buttons[r][c])){ 
                    numMines++;
                }
            }
        }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
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
        System.out.println("Clicked: "+ myRow + ", " + myCol);
        clicked = true;
        if(mouseButton == RIGHT){   
            flagged = !flagged;
            System.out.println("Flagged: "+ myRow + ", " + myCol);
            if(mines.contains(this)){
                System.out.println("Mine flagged");
            }
            if(flagged)
                clicked = false;
        }

        else if(mines.contains(buttons[myRow][myCol])){
            displayLosingMessage();
        } 
        else if(countMines(myRow, myCol) > 0){
            setLabel(countMines(myRow, myCol));
        }
        else {
            if(isValid(myRow, myCol-1) && !buttons[myRow][myCol-1].clicked)
               buttons[myRow][myCol-1].mousePressed();

            if(isValid(myRow, myCol+1) && !buttons[myRow][myCol+1].clicked)
               buttons[myRow][myCol+1].mousePressed();

            if(isValid(myRow+1, myCol) && !buttons[myRow+1][myCol].clicked)
               buttons[myRow+1][myCol].mousePressed();

            if(isValid(myRow-1, myCol) && !buttons[myRow-1][myCol].clicked)
               buttons[myRow-1][myCol].mousePressed();

        }
        
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) {
             fill(255,0,0);
         }
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        textSize(400/NUM_ROWS);
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
