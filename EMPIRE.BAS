
' The Galactic Empire
' By David Pinch, 1991-2020
'
' MIT License
' https://github.com/davepinch/qbasic-empire
'
' To begin, press Shift + F5.
' To exit QBASIC, press Alt, F, X.

'
' AsteroidType
'
TYPE AsteroidType
  Control AS INTEGER
  detect  AS INTEGER
  local1  AS INTEGER
  local2  AS INTEGER
  mined   AS INTEGER
  produce AS INTEGER ' Ships produced per month
  ruler   AS INTEGER ' The player who rules the asteroid
  ships   AS INTEGER ' Number of ships docked at the asteroid
  shield  AS INTEGER
  supply  AS INTEGER
  tech    AS INTEGER
END TYPE

'
' FieldType
'
' Contains information about an input field in a window.
'
TYPE FieldType
  kind  AS INTEGER
  cid   AS INTEGER
  posX  AS INTEGER
  posY  AS INTEGER
  sizeX AS INTEGER
END TYPE

'
' MenuType
'
TYPE MenuType
  posX AS INTEGER
  text AS STRING * 10
  wid  AS INTEGER
END TYPE

'
' MissionType
'
TYPE MissionType
  distance  AS INTEGER
  goal      AS INTEGER
  ruler     AS INTEGER
  ships     AS INTEGER
  source    AS INTEGER
  target    AS INTEGER
  techlevel AS INTEGER
END TYPE

'
' PlayerType
'
TYPE PlayerType
  viewFilter AS INTEGER
  viewPage   AS INTEGER
END TYPE

'
' WindowType
'
TYPE WindowType
  canceled AS INTEGER
  fields   AS INTEGER
  helpWid  AS INTEGER
  posX     AS INTEGER
  posY     AS INTEGER
  selected AS INTEGER
  sizeX    AS INTEGER
  sizeY    AS INTEGER
END TYPE

'
' Execute* subroutines
'
' Each subroutine executes a different menu command. Review the comments
' in the Execute(cid) function to learn how to implement a command.
'
DECLARE SUB Execute (cid AS INTEGER)
DECLARE SUB ExecuteAbout ()
DECLARE SUB ExecuteDistance ()
DECLARE SUB ExecuteFilterPlayer ()
DECLARE SUB ExecuteFilterNone ()
DECLARE SUB ExecuteFilterPlayers ()
DECLARE SUB ExecuteNextMonth ()
DECLARE SUB ExecuteNextTurn ()
DECLARE SUB ExecuteOptionAlerts ()
DECLARE SUB ExecuteOrderAttack ()
DECLARE SUB ExecuteViewAtlas ()
DECLARE SUB ExecuteViewTable ()

'
' SetupGame.* subroutines
'
' These subroutines prepare a game for play.
'
DECLARE SUB SetupGame ()
DECLARE SUB SetupGame.Atlas ()
DECLARE SUB SetupGame.New ()

'
' Status* subroutines
'
' These subroutines change the status bar on the bottom of the page.
'
DECLARE SUB StatusDebug (text AS STRING)
DECLARE SUB StatusLevel (text AS STRING, level AS INTEGER)
DECLARE SUB StatusUpdate (text AS STRING)
DECLARE SUB StatusClear ()

'
' Win* declarations
'
' These functions are used to create and manipulate windows on the
' screen. Note: due to lengthly parameters in some cases, the
' functions are defined with data type characters instead of "AS".
'
DECLARE FUNCTION WinAppend% (wid%, f AS FieldType, text$)
DECLARE FUNCTION WinAppendBoolean% (wid%, text$)
DECLARE FUNCTION WinAppendButton% (wid%, cid%, text$)
DECLARE FUNCTION WinAppendLabel% (wid%, text$)
DECLARE FUNCTION WinAppendSeparator% (wid%)
DECLARE FUNCTION WinDefine% (wid%, f AS FieldType, text$)
DECLARE FUNCTION WinDefineButton% (wid%, posX%, posY%, sizeX%, cid%, text$)
DECLARE FUNCTION WinDefineLabel% (wid%, posX%, posY%, text$)
DECLARE FUNCTION WinDefineInteger% (wid%, posX%, posY%, sizeX%, text$)
DECLARE FUNCTION WinIsSelectable% (wid%, fid%)
DECLARE FUNCTION WinParseCommand% (text$)

DECLARE SUB WinDraw (id AS INTEGER)
DECLARE SUB WinDrawField (wid AS INTEGER, fid AS INTEGER)
DECLARE SUB WinDrawOutline (wid AS INTEGER, atX AS INTEGER, atY AS INTEGER)
DECLARE SUB WinKey (wid%, fid%, keypress$)
DECLARE SUB WinKeyBoolean (wid%, fid%, keypress$)
DECLARE SUB WinKeyInteger (wid%, fid%, keypress$)
DECLARE SUB WinLoad ()
DECLARE SUB WinMove (id AS INTEGER)
DECLARE SUB WinSelectNext (wid%)
DECLARE SUB WinSelect (wid%, fid%)
DECLARE SUB WinSelectPrevious (wid%)
DECLARE SUB WinSelectFirst (wid%)
DECLARE SUB WinSelectLast (wid%)
DECLARE SUB WinShow (wid AS INTEGER)

'
' Declarations
'
DECLARE SUB BattleMode (id AS INTEGER)
DECLARE SUB DrawFile (filename AS STRING)
DECLARE SUB DrawGrid ()
DECLARE SUB DrawGridCells ()
DECLARE SUB DrawMenu ()
DECLARE SUB DrawMenuItem (itemId AS INTEGER, selected AS INTEGER)
DECLARE SUB DrawTable ()
DECLARE SUB DrawTableRow (x AS INTEGER)
DECLARE SUB DrawText (text AS STRING)
DECLARE SUB LoadMenu ()
DECLARE SUB PlayGame ()
DECLARE SUB RefreshPages ()
DECLARE SUB WaitForKeyPress ()

DECLARE FUNCTION CalcDistance (first AS INTEGER, second AS INTEGER)
DECLARE FUNCTION DoMenu ()
DECLARE FUNCTION GetCellScreenX% (cellX AS INTEGER)
DECLARE FUNCTION GetCellScreenY% (cellY AS INTEGER)
DECLARE FUNCTION GetKey$ ()
DECLARE FUNCTION IsFiltered% (aid AS INTEGER)

'
' ASCII character constants
'
CONST ASCII.Backspace = 8
CONST ASCII.Return = 13
CONST ASCII.Escape = 27
CONST ASCII.Space = 32

'
' Boolean constants
'
CONST True = -1
CONST False = NOT True

'
' Command.* constants
'
' These constants assign a unique ID to each type of menu command.
'
CONST Command.About = 1
CONST Command.Distance = 2
CONST Command.EndGame = 3
CONST Command.FilterNone = 4
CONST Command.FilterPlayer = 5
CONST Command.FilterPlayers = 6
CONST Command.NextMonth = 7
CONST Command.NextTurn = 8
CONST Command.OptionAlerts = 9
CONST Command.OrderAttack = 10
CONST Command.ViewAtlas = 11
CONST Command.ViewTable = 12

'
' Control Character constants
'
CONST Control.D = 4
CONST Control.E = 5
CONST Control.O = 15
CONST Control.S = 19
CONST Control.X = 24

'
' Field Kinds
'
CONST FieldKind.None = 0
CONST FieldKind.Boolean = 1
CONST FieldKind.Button = 2
CONST FieldKind.Integer = 3
CONST FieldKind.Label = 4
CONST FieldKind.Separator = 5

'
' Filter constants
'
CONST Filter.None = 0
CONST Filter.Player = 1
CONST Filter.Players = 2

'
' GridStyle constants
'
CONST GridStyle.Backcolor = 0
CONST GridStyle.Border = 2
CONST GridStyle.Forecolor = 1
CONST GridStyle.CellBackcolor = 0
CONST GridStyle.CellForecolor = 7
CONST GridStyle.FilterBackcolor = 7
CONST GridStyle.FilterForecolor = 15

'
' Maximum UI elements
'
CONST MaxMenus = 5
CONST MaxFields = 15
CONST MaxPlayers = 5
CONST MaxWindows = 50

'
' MenuStyle constants
'
CONST MenuStyle.BackColor = 7
CONST MenuStyle.ForeColor = 0
CONST MenuStyle.SelectedBackColor = 0
CONST MenuStyle.SelectedForeColor = 15
                                    
'
' ScanCode constants
'
CONST ScanCode.Home = 71
CONST ScanCode.Up = 72
CONST ScanCode.Left = 75
CONST ScanCode.Right = 77
CONST ScanCode.End = 79
CONST ScanCode.Down = 80

'
' StatusLevel constants
'
CONST StatusLevel.Normal = 0
CONST StatusLevel.Debug = 1

'
' StatusStyle.* constants
'
' These constants define the style of the status bar on the bottom
' of the screen. The status bar is used to display quick updates and
' error/debug information.
'
CONST StatusStyle.NormalForecolor = 15
CONST StatusStyle.NormalBackcolor = 0
CONST StatusStyle.DebugBackcolor = 4
CONST StatusStyle.DebugForecolor = 15

'
' TableStyle.* constants
'
' These constants define the style of the data table.
'
CONST TableStyle.Backcolor = 0
CONST TableStyle.Border = 2
CONST TableStyle.FilterBackcolor = 7
CONST TableStyle.FilterForecolor = 15
CONST TableStyle.HeaderBackcolor = 0
CONST TableStyle.HeaderForecolor = 7
CONST TableStyle.RowBackcolor = 0
CONST TableStyle.RowForecolor = 7
CONST TableStyle.Forecolor = 1

'
' VideoPage.* constants
'
' These constants define how each video page is used.
'
CONST VideoPage.Display = 0
CONST VideoPage.Working = 1
CONST VideoPage.Atlas = 2
CONST VideoPage.Table = 3

'
' WinStyle.* constants
'
' These constants define the colors and other styles of windows.
'
CONST WinStyle.Backcolor = 1
CONST WinStyle.Forecolor = 7
CONST WinStyle.Border = 1
CONST WinStyle.OutlineBackcolor = 2
CONST WinStyle.OutlineForecolor = 7
CONST WinStyle.SelectedBackcolor = 7
CONST WinStyle.SelectedForecolor = 0
CONST WinStyle.Shadow = 0
CONST WinStyle.ShadowChar = 176
CONST WinStyle.ShadowForecolor = 8
CONST WinStyle.ShadowBackcolor = 0

'
' Global window variables
'
DIM SHARED bar(1 TO MaxMenus) AS MenuType
DIM SHARED fld(1 TO MaxWindows, 1 TO MaxFields) AS FieldType
DIM SHARED win(1 TO MaxWindows) AS WindowType
DIM SHARED txt(1 TO MaxWindows, 1 TO MaxFields) AS STRING

'
' Global variables
'
DIM SHARED arrowexit               AS INTEGER
DIM SHARED asteroid(1 TO 19)       AS AsteroidType
DIM SHARED asteroids               AS INTEGER
DIM SHARED mission(1 TO 100)       AS MissionType
DIM SHARED missions                AS INTEGER
DIM SHARED player(1 TO MaxPlayers) AS PlayerType
DIM SHARED players                 AS INTEGER
DIM SHARED pressed                 AS STRING
DIM SHARED turn                    AS INTEGER

'
' Main
'
SetupGame
PlayGame

'
' Menu bar data
'
' These are loaded by the LoadMenu subroutine.
'
DATA 5
DATA " View ", 10
DATA " Game ", 11
DATA " Mission ", 12
DATA " Options ", 13
DATA " Special ", 14

'
' Window Definitions
'
' These are loaded by the WinLoad subroutine.
'

REM Window 1
  DATA "Start"
  DATA 10,22
  DATA "$", 0, 1, " Select an option to get started: "
  DATA "@", 12, 3, 10, "<command>", " New Game "
  DATA "@", 12, 4, 10, "<command>", " Old Game "

REM Window 2
  DATA "Start"
  DATA 10,11
  DATA "$", 0, 1, "Initialization Mode"
  DATA "+-"
  DATA "+$", "How many people are playing?  [Def=3]"
  DATA "+$", "How many asteroids should be in the game?  [Def=15]"
  DATA "#", 56, 3, 2, 3
  DATA "#", 56, 4, 2, 15

REM Window 3
  DATA "Start"
  DATA 11,24
  DATA "+$", " Error: Too many players. "

REM Window 4
  DATA "Start"
  DATA 10,21
  DATA "Help", 8
  DATA "+$", " Error: The number of asteroids cannot "
  DATA "+$", " be less than the number of players.   "
  DATA "+-"
  DATA "+$", " Press ? for more information.         "

REM Window 5
  DATA "Start"
  DATA 11,20
  DATA "+$", " Error: The maximum number of asteroids "
  DATA "+$", " allowed is nineteen.                   "

REM Window 6
  DATA "Start"
  DATA 10,19
  DATA "Help", 7
  DATA "+$", " Error: It is impossible to play the game "
  DATA "+$", " with only one player and one asteroid.   "
  DATA "+-"
  DATA "+$", " Press ? for more information.            "

REM Window 7
  DATA "Start"
  DATA 9,10
  DATA "+$", " When you start out the game, asteroids are automatically "
  DATA "+$", " assigned to the players.  Because you only have one      "
  DATA "+$", " asteroid to give to a single player, there are no other  "
  DATA "+$", " asteroids to conquer.  This makes it impossible to solve "
  DATA "+$", " the game.  Correct the problem by selecting a higher     "
  DATA "+$", " number of asteroids.                                     "

REM Window 8
  DATA "Start"
  DATA 10,10
  DATA "+$", " When you start out the game, asteroids are automatically "
  DATA "+$", " assigned to the players.  Because you have selected less "
  DATA "+$", " asteroids than players, not every player can be assigned "
  DATA "+$", " an asteroid.  Correct the problem by selecting enough    "
  DATA "+$", " asteroids to cover all the players.                      "

REM Window 9
  DATA "Start"
  DATA 3,3
  DATA "+@", "<command>", "Look Behind Window"
  DATA "+@", "<command>", "Next Step..."
  DATA "+-"
  DATA "+@", "<command>", "Cluster Together"
  DATA "+@", "<command>", "Orbital Belt"
  DATA "+@", "<command>", "Plot Manually"
  DATA "+@", "<command>", "Random Setting"
  DATA "+@", "<command>", "Replot Player's Only"

REM Window 10
  DATA "Start"
  DATA 2,2
  DATA "+@", "ViewAtlas", "Show atlas"
  DATA "+@", "ViewTable", "Show table"
  DATA "+-"
  DATA "+@", "FilterPlayer", "Filter you"
  DATA "+@", "FilterPlayers", "Filter players"
  DATA "+@", "FilterNone", "Remove Filter"

REM Window 11
  DATA "Start"
  DATA 2,9
  DATA "+@", "<command>", "Load a game"
  DATA "+@", "NextTurn", "Next turn"
  DATA "+@", "NextMonth", "Next month"
  DATA "+@", "<command>", "Save the game"
  DATA "+@", "EndGame", "Quit the game"
   
REM Window 12
  DATA "Start"
  DATA 2,15
  DATA "+@", "<command>", "Assist another"
  DATA "+@", "OrderAttack", "Attack an asteroid"
  DATA "+@", "<command>", "List all known"
  DATA "+@", "<command>", "Destroy an asteroid"
  DATA "+@", "<command>", "Raid an asteroid"
  DATA "+@", "<command>", "Reinforce an asteroid"
  DATA "+@", "<command>", "Spy on an asteroid"

REM Window 13
  DATA "Start"
  DATA 2,24
  DATA "+@", "OptionAlerts", "Alerting the next player"
  DATA "+@", "<command>", "Border"
  DATA "+@", "<command>", "Command entry"
  DATA "+@", "<command>", "Confirming actions"
  DATA "+@", "<command>", "Shadow"
  DATA "+@", "<command>", "Sound effects"

REM Window 14
  DATA "Start"
  DATA 2,33
  DATA "+@", "About", "About..."
  DATA "+@", "Distance", "Calculate distance"
  DATA "+@", "<command>", "Find current winner"
  DATA "+@", "<command>", "Move ahead in time"
  DATA "+@", "<command>", "Search for value"

REM Window 15
  DATA "Start"
  DATA 3,15
  DATA "+$", " Enter the source asteroid:"
  DATA "+$", " Enter the target asteroid:"
  DATA "+$", " Enter the number of ships:"
  DATA "#", 32, 1, 2, 0                      
  DATA "#", 32, 2, 2, 0
  DATA "#", 30, 3, 4, 0

REM Window 16
  DATA "Start"
  DATA 4,11
  DATA "+$", " Error: The source asteroid does not exist. "

REM Window 17
  DATA "Start"
  DATA 4,10
  DATA "+$", " Error: You cannot control the source asteroid. "
   
REM Window 18
  DATA "Start
  DATA 4,11
  DATA "+$", " Error: The target asteroid does not exist. "

REM Window 19
  DATA "Start"
  DATA 4,10
  DATA "+$", " Error: The same asteroid has been specified "
  DATA "+$", " for both the target and source.             "
   
REM Window 20
  DATA "Start"
  DATA 4,10
  DATA "+$", " Error: You cannot send the specified number of ships. "

REM Window 21
  DATA "Start"
  DATA 3,34
  ' HACK: create a field at index 1 to hold the distance value
  DATA "$", 10, 1, "   "
  DATA "$", 1, 1, "Distance:"

REM Window 22
  DATA "Start"
  DATA 3,33
  DATA "#", 30, 1, 2, 0
  DATA "#", 30, 2, 2, 0
  DATA "$", 1, 1, " Enter the first asteroid:"
  DATA "$", 1, 2, " Enter the second asteroid:"

REM Window 23
  DATA "Start"
  DATA 3,28
  DATA "+$", " Error: The first asteroid does not exist. "

REM Window 24
  DATA "Start"
  DATA 3,28
  DATA "+$", " Error: The second asteroid does not exist. "

REM Window 25
  DATA "Start"
  DATA 3,34
  DATA "+$", " Error: The same asteroid has "
  DATA "+$", " been specified both times.   "
   
REM Window 26
  DATA "Start"
  DATA 3,34
  ' HACK: create a field at index 1 to hold the distance value
  DATA "$", 10, 1, "   "
  DATA "$", 1, 1, "Distance:"

REM Window 27
  DATA "Start"
  DATA 9,19
  DATA "+$", " Do you wish to alert the others with "
  DATA "+$", " a bell after a player has made his   "
  DATA "+$", " turn?  This minimizes cheating.      "
  DATA "+-"
  DATA "+&", "Yes"

REM Window 28
  DATA "Start"
  DATA 5,20
  DATA "+$", "           Battle Looms Ahead!          "
  DATA "+$", "                                        "
  DATA "+$", " The attacker is ruler                  "
  DATA "+$", "   Ships:                               "
  DATA "+$", "   Technology:                          "
  DATA "+$", "                                        "
  DATA "+$", " The defender is                        "
  DATA "+$", "   Shield:                              "
  DATA "+$", "   Ships:                               "
  DATA "+$", "   Technology:                          "
  DATA "+$", "                                        "
  DATA "+$", " Press any key to begin...              "

REM Window 29
  DATA "Start"
  DATA 9,19
  DATA "+$", " WARNING TO ALL PLAYERS: The current "
  DATA "+$", " player has attempted to turn off    "
  DATA "+$", " the Alert Next Player option.  Is   "
  DATA "+$", " this person trying to cheat?        "
  DATA "+-"
  DATA "+&", "No"

REM Window 30
  DATA "Start"
  DATA 10,25
  DATA "+$", "   The Galactic Empire   "
  DATA "+-"
  DATA "+$", " (C) 1992 David J. Pinch "
  
REM Window 31
  DATA "Start"
  DATA 6,12
  DATA "+$", " Battle Round:                                        "
  DATA "+$", "                                                      "
  DATA "+$", " Attacker's ships:                                    "
  DATA "+$", " [__________________________________________________] "
  DATA "+$", "                                                      "
  DATA "+$", " Defender's ships:                                    "
  DATA "+$", " [__________________________________________________] "
   
DATA "End of windows"

SUB BattleMode (id AS INTEGER)
  '
  ' Executes a battle (not finished)
  '
 
  DIM attacked AS INTEGER
  DIM defended AS INTEGER
  DIM round    AS INTEGER
  DIM shot     AS INTEGER
  DIM start1   AS INTEGER
  DIM start2   AS INTEGER
  DIM trg      AS INTEGER
  DIM x        AS INTEGER

  trg = mission(id).target

  WinShow 28
 
  COLOR 0, 7: LOCATE win(28).posY + 4, win(28).posX + 24
  PRINT CHR$(mission(id).ruler + 64); "."
  LOCATE win(28).posY + 5, win(28).posX + 10: PRINT mission(id).ships
  LOCATE win(28).posY + 6, win(28).posX + 15: PRINT mission(id).techlevel
  LOCATE win(28).posY + 8, win(28).posX + 18
  IF asteroid(trg).ruler = 0 THEN
    PRINT "independent."
  ELSE
    PRINT "ruler "; CHR$(asteroid(trg).ruler + 64); "."
  END IF
 
  LOCATE win(28).posY + 9, win(28).posX + 11
  PRINT asteroid(trg).shield
 
  LOCATE win(28).posY + 10, win(28).posX + 10
  PRINT asteroid(trg).ships
 
  LOCATE win(28).posY + 11, win(28).posX + 15
  PRINT asteroid(trg).tech
  COLOR 7, 0

  ' HACK: remove this during development
  'DO
  '  FOR x = 1200 TO 800 STEP -35
  '    SOUND x, .2
  '  NEXT
  '  FOR x = 800 TO 1200 STEP 35
  '    SOUND x, .2
  '  NEXT
  'LOOP UNTIL LEN(INKEY$)

  WinShow 31
 
  DO
    round = round + 1
    LOCATE win(31).posY + 2, win(31).posX + 15
    COLOR 0, 7: PRINT round: COLOR 7, 0
    attacked = 0: defended = 0
   
    start1 = mission(id).ships
    start2 = asteroid(trg).ships
   
    DO
      IF turn = 0 AND attacked <= start1 THEN 'Attacker fires
       
        '
        ' Calculate the power of the attack
        '
        shot = INT(RND * 3 - 1 + 2 ^ (mission(id).techlevel / 10))
        shot = shot - shot * (asteroid(trg).shield) / 100
       
        '
        ' Destroy ships on the target asteroid
        '
        asteroid(id).ships = asteroid(id).ships - shot
        IF asteroid(id).ships < 1 THEN asteroid(id).ships = 0
        attacked = attacked + 1
     
      ELSEIF turn = 1 AND defended <= start2 THEN 'Defender fires
       
        '
        ' Calculate the power of the counter-attck
        '
        shot = INT(RND * 3 - 1 + 2 ^ (asteroid(trg).tech / 10))
       
        '
        ' Destroy attacking ships
        '
        mission(id).ships = mission(id).ships - shot
        IF mission(id).ships < 1 THEN mission(id).ships = 0
        defended = defended + 1
     
      END IF
     
      IF turn = 0 THEN turn = 1 ELSE turn = 0
      IF mission(id).ships = 0 OR asteroid(trg).ships = 0 THEN EXIT DO
   
    LOOP UNTIL attacked = start1 AND defended = start2
  LOOP UNTIL mission(id).ships = 0 OR asteroid(id).ships = 0

  ' LAST
  END

END SUB

FUNCTION CalcDistance (first AS INTEGER, second AS INTEGER)
  '
  ' Calculates the distance between two asteroids
  '
  DIM dist AS INTEGER

  dist = (asteroid(first).local1 - asteroid(second).local1) ^ 2
  dist = dist + (asteroid(first).local2 - asteroid(second).local2) ^ 2
  dist = INT(SQR(dist))

  CalcDistance = dist

END FUNCTION

FUNCTION DoMenu
  '
  ' Returns the command ID of an item selected from the menu.
  '
  CONST MenusClosed = 0
  CONST MenusOpen = 1

  DIM keypress  AS STRING
  DIM mode      AS INTEGER
 
  STATIC selection AS INTEGER

  IF selection = 0 THEN
    selection = 1
  END IF

  DO
   
    '
    ' Draw the selected menu item
    '
    DrawMenuItem selection, 1

    IF mode = MenusOpen THEN
      '
      ' The menu is open (a window is displayed)
      '
      arrowexit = 1
      WinShow bar(selection).wid
      arrowexit = 0
     
      IF win(bar(selection).wid).canceled THEN
       
        mode = MenusClosed
     
      ELSE

        SELECT CASE pressed
          CASE CHR$(ASCII.Return)
           
            DIM wid AS INTEGER
            DIM fid AS INTEGER

            wid = bar(selection).wid
            fid = win(wid).selected
            
            DoMenu = fld(wid, fid).cid
            EXIT FUNCTION

          CASE CHR$(0) + CHR$(ScanCode.Left)
            GOSUB NavigateLeft
          CASE CHR$(0) + CHR$(ScanCode.Right)
            GOSUB NavigateRight
        END SELECT

      END IF

    ELSE
      '
      ' The menu is closed
      '
      keypress = GetKey$
   
      SELECT CASE keypress
    
        CASE CHR$(0) + CHR$(ScanCode.Left)
          '
          ' Move left
          '
          GOSUB NavigateLeft

        CASE CHR$(0) + CHR$(ScanCode.Right)
          '
          ' Move right
          '
          GOSUB NavigateRight

        CASE CHR$(ASCII.Return)
          '
          ' Enter (open menu)
          '
          mode = MenusOpen
       
        CASE CHR$(0) + CHR$(ScanCode.Down)
          '
          ' Down (open menu)
          '
          mode = MenusOpen

      END SELECT

    END IF
   
  LOOP

REM *** Subroutines ***

NavigateLeft:
  '
  ' Moves to the menu item to the left
  '
  DrawMenuItem selection, 0
  selection = selection - 1: IF selection = 0 THEN selection = 5
  RETURN

NavigateRight:
  '
  ' Moves to the menu item to the right
  '
  DrawMenuItem selection, 0
  selection = selection + 1: IF selection = 6 THEN selection = 1
  RETURN

END FUNCTION

SUB DrawFile (filename AS STRING)
  '
  ' Draws a PCB file containing embedded color codes
  '

  DIM text AS STRING

  OPEN filename FOR INPUT ACCESS READ AS #1

  DO WHILE NOT EOF(1)
    LINE INPUT #1, text
    DrawText text + CHR$(ASCII.Return)
  LOOP

  CLOSE #1

END SUB

SUB DrawGrid

  DIM cellDivide  AS STRING * 1
  DIM cellLeft    AS STRING * 1
  DIM cellRight   AS STRING * 1
  DIM lowerDivide AS STRING * 1
  DIM lowerFlat   AS STRING * 1
  DIM lowerLeft   AS STRING * 1
  DIM lowerRight  AS STRING * 1
  DIM divideCross AS STRING * 1
  DIM divideFlat  AS STRING * 1
  DIM divideLeft  AS STRING * 1
  DIM divideRight AS STRING * 1
  DIM upperDivide AS STRING * 1
  DIM upperFlat   AS STRING * 1
  DIM upperLeft   AS STRING * 1
  DIM upperRight  AS STRING * 1

  '
  ' Initialize grid characters based on border style
  '
  SELECT CASE GridStyle.Border
   
    CASE 1
      cellDivide = CHR$(179)
      cellLeft = CHR$(179)
      cellRight = CHR$(179)
      divideCross = CHR$(197)
      divideFlat = CHR$(196)
      divideLeft = CHR$(195)
      divideRight = CHR$(180)
      lowerDivide = CHR$(193)
      lowerFlat = CHR$(196)
      lowerLeft = CHR$(192)
      lowerRight = CHR$(217)
      upperDivide = CHR$(194)
      upperFlat = CHR$(196)
      upperLeft = CHR$(218)
      upperRight = CHR$(191)

    CASE 2
      cellDivide = CHR$(179)
      cellLeft = CHR$(186)
      cellRight = CHR$(186)
      divideCross = CHR$(197)
      divideFlat = CHR$(196)
      divideLeft = CHR$(199)
      divideRight = CHR$(182)
      lowerDivide = CHR$(207)
      lowerFlat = CHR$(205)
      lowerLeft = CHR$(200)
      lowerRight = CHR$(188)
      upperDivide = CHR$(209)
      upperFlat = CHR$(205)
      upperLeft = CHR$(201)
      upperRight = CHR$(187)

  END SELECT

  '
  ' Set grid colors
  '
  COLOR GridStyle.Forecolor, GridStyle.Backcolor

  '
  ' Upper left corner
  '
  LOCATE 2, 1
  PRINT upperLeft;

  '
  ' Upper center border
  '
  FOR x = 1 TO 25
    PRINT upperFlat; upperFlat; upperDivide;
  NEXT
  
  '
  ' Upper right corner
  '
  PRINT upperFlat; upperFlat; upperRight

  FOR row = 1 TO 10

    '
    ' Left side of cell row
    '
    PRINT cellLeft;

    '
    ' Cells
    '
    FOR x = 1 TO 25
      PRINT "  "; cellDivide;
    NEXT

    '
    ' Right side of cell row
    '
    PRINT "  "; cellRight

    '
    ' Left side of divider row
    '
    PRINT divideLeft;

    '
    ' Inner divider
    '
    FOR x = 1 TO 25
      PRINT divideFlat; divideFlat; divideCross;
    NEXT

    '
    ' Right side of divider row
    '
    PRINT divideFlat; divideFlat; divideRight

  NEXT

  '
  ' Last cell row
  '
  PRINT cellLeft;
  FOR x = 1 TO 25
    PRINT "  "; cellDivide;
  NEXT
  PRINT "  "; cellRight

  '
  ' Bottom right corner
  '
  PRINT lowerLeft;
  FOR x = 1 TO 25
    PRINT lowerFlat; lowerFlat; lowerDivide;
  NEXT
  PRINT lowerFlat; lowerFlat; lowerRight;

  DrawGridCells

END SUB

SUB DrawGridCells

  DIM aid AS INTEGER
  DIM sx  AS INTEGER
  DIM sy  AS INTEGER

  '
  ' Plot asteroids
  '
  FOR aid = 1 TO asteroids
  
    '
    ' Get the screen coordinates of the cell for this asteroid
    '
    sx = GetCellScreenX(asteroid(aid).local2)
    sy = GetCellScreenY(asteroid(aid).local1)

    '
    ' Plot the asteroid on the grid
    '
    LOCATE sy, sx
    IF IsFiltered(aid) THEN
      COLOR GridStyle.FilterForecolor, GridStyle.FilterBackcolor
    ELSE
      COLOR GridStyle.CellForecolor, GridStyle.CellBackcolor
    END IF

    PRINT USING "##"; aid;
   
  NEXT

END SUB

SUB DrawMenu

  '
  ' Clear the menu space on the top row of the screen
  '
  VIEW PRINT 1 TO 1
  COLOR MenuStyle.ForeColor, MenuStyle.BackColor
  CLS
  VIEW PRINT

  '
  ' Draw each menu item
  '
  DIM i AS INTEGER
  FOR i = LBOUND(bar) TO UBOUND(bar)
    DrawMenuItem i, 0
  NEXT

END SUB

SUB DrawMenuItem (itemId AS INTEGER, selected AS INTEGER)

  '
  ' Move to the screen location of the item
  '
  LOCATE 1, bar(itemId).posX

  '
  ' Set the color depending on whether this item is selected
  '
  IF selected THEN
    COLOR MenuStyle.SelectedForeColor, MenuStyle.SelectedBackColor
  ELSE
    COLOR MenuStyle.ForeColor, MenuStyle.BackColor
  END IF

  PRINT bar(itemId).text;

END SUB

SUB DrawTable

  DIM divideLine AS STRING * 1
  DIM divideLeft AS STRING * 1
  DIM divideRight AS STRING * 1
  DIM lowerLeft AS STRING * 1
  DIM lowerRight AS STRING * 1
  DIM upperLeft AS STRING * 1
  DIM upperRight AS STRING * 1
  DIM horizontal AS STRING * 1
  DIM vertical AS STRING * 1

  '
  ' Select the border characters based on the border style
  '
  SELECT CASE TableStyle.Border
    CASE 1
      divideLeft = CHR$(195)
      divideLine = CHR$(196)
      divideRight = CHR$(180)
      lowerLeft = CHR$(192)
      lowerRight = CHR$(217)
      upperLeft = CHR$(218)
      upperRight = CHR$(191)
      horizontal = CHR$(196)
      vertical = CHR$(179)
    CASE 2
      divideLeft = CHR$(199)
      divideLine = CHR$(196)
      divideRight = CHR$(182)
      lowerLeft = CHR$(200)
      lowerRight = CHR$(188)
      upperLeft = CHR$(201)
      upperRight = CHR$(187)
      horizontal = CHR$(205)
      vertical = CHR$(186)
  END SELECT

  '
  ' Draw the top border of the table
  '
  LOCATE 2, 1
  COLOR TableStyle.Forecolor, TableStyle.Backcolor
  PRINT upperLeft; STRING$(77, horizontal); upperRight

  '
  ' Draw the header names
  '
  PRINT vertical;
  COLOR TableStyle.HeaderForecolor, TableStyle.HeaderBackcolor
  PRINT " Id  Ruler  Tech  Mined  Supply  Detect  Control  Shield  Produce  Available ";
  COLOR TableStyle.Forecolor, TableStyle.Backcolor
  PRINT vertical

  '
  ' Draw the heading separator
  '
  PRINT divideLeft; STRING$(77, divideLine); divideRight

  '
  ' Draw each row of data
  '
  DIM x AS INTEGER
  FOR x = 3 TO 23
   
    LOCATE x, 1: PRINT vertical
    LOCATE x, 79: PRINT vertical;

  NEXT

  '
  ' Draw the bottom border
  '
  LOCATE 24, 1
  PRINT lowerLeft; STRING$(77, horizontal); lowerRight;

  ' Draw asteroids
  FOR x = 1 TO asteroids
    DrawTableRow x
  NEXT

END SUB

SUB DrawTableRow (aid AS INTEGER)

  IF aid > asteroids THEN
    EXIT SUB
  END IF

  '
  ' Move to the first character of the row (inside border)
  '
  LOCATE aid + 4, 3

  '
  ' Determine whether this asteroid is being filtered
  '
  IF IsFiltered(aid) THEN
    COLOR TableStyle.FilterForecolor, TableStyle.FilterBackcolor
  ELSE
    COLOR TableStyle.RowForecolor, TableStyle.RowBackcolor
  END IF
 
  '
  ' Print the asteroid ID
  '
  PRINT USING "##"; aid;

  '
  ' Print visible data
  '
  IF asteroid(aid).ruler > 0 THEN
    LOCATE , 9: PRINT CHR$(64 + aid);
    LOCATE , 15: PRINT USING "##"; asteroid(aid).tech;
    LOCATE , 21: PRINT USING "###"; asteroid(aid).mined;
    LOCATE , 28: PRINT USING "####"; asteroid(aid).supply;
    LOCATE , 37: PRINT USING "##"; asteroid(aid).detect;
    LOCATE , 45: PRINT USING "###"; asteroid(aid).Control;
    LOCATE , 54: PRINT USING "###"; asteroid(aid).shield;
    LOCATE , 62: PRINT USING "###"; asteroid(aid).produce;
    LOCATE , 72: PRINT USING "####"; asteroid(aid).ships;
  ELSE
    LOCATE , 6: PRINT "[data not available]";
  END IF

END SUB

SUB DrawText (text AS STRING)

  ' A PCBoard color code has the following format:
  '
  '   @X##
  '   ||||
  '   |||+-- Background attribute
  '   ||+--- Foreground attribute
  '   |+---- + character
  '   +----- @ character

  DIM backcolor AS INTEGER
  DIM forecolor AS INTEGER
  DIM nextAt    AS INTEGER
  DIM startAt   AS INTEGER
 
  LET startAt = 1

  DO
 
    '
    ' Get the index of the next code
    '
    nextAt = INSTR(startAt, text, "@X")

    IF nextAt = 0 THEN
      '
      ' No further codes found; print remaining characters
      '
      IF startAt <= LEN(text) THEN
        PRINT RIGHT$(text, LEN(text) - startAt + 1);
      END IF
      EXIT DO

    ELSEIF nextAt > LEN(text) - 3 THEN
      '
      ' Code found, but not enough space for 4 characters
      '
      PRINT RIGHT$(text, LEN(text) - startAt + 1);
      EXIT DO

    ELSE
      '
      ' Code found; print characters up to the character code.
      '
      PRINT MID$(text, startAt, nextAt - startAt);

      '
      ' Read the color values
      '   
      backcolor = VAL("&H" + MID$(text, nextAt + 2, 1))
      forecolor = VAL("&H" + MID$(text, nextAt + 3, 1))
      COLOR forecolor, backcolor

      '
      ' Continue with the next character in the text
      '
      startAt = nextAt + 4
    END IF

  LOOP

END SUB

SUB Execute (cid AS INTEGER)

  ' Executes the specified command. Command ID values are defined
  ' in the Command.* set of global constants, e.g., Command.About.
  '
  ' To create a new command:
  '
  ' 1. Define a unique integer value for the command. To do this,
  '    review the Command.* global constants and add an entry for the
  '    new command. Command values must be unique.
  '
  ' 2. Optional. If you want reference the command in the DATA window
  '    definitions, then update WinParseCommand to translate a string
  '    name into an integer value.
  '
  ' 3. Define a new subroutine to implement the command. As a best
  '    practice, name the subroutine ExecuteXXX where XXX matches the
  '    command constant name. For example, Command.About corresponds
  '    to ExecuteAbout. This convention makes it easier to stay organized.
  '
  ' 4. Add an entry below to execute your command.
 
  SELECT CASE cid
   
    CASE Command.About
      ExecuteAbout

    CASE Command.Distance
      ExecuteDistance
      
    CASE Command.FilterNone
      ExecuteFilterNone

    CASE Command.FilterPlayer
      ExecuteFilterPlayer

    CASE Command.FilterPlayers
      ExecuteFilterPlayers

    CASE Command.NextMonth
      ExecuteNextMonth

    CASE Command.NextTurn
      ExecuteNextTurn

    CASE Command.OptionAlerts
      ExecuteOptionAlerts
       
    CASE Command.OrderAttack
      ExecuteOrderAttack
       
    CASE Command.ViewAtlas
      ExecuteViewAtlas
     
    CASE Command.ViewTable
      ExecuteViewTable

    CASE ELSE
      StatusDebug "Execute(" + LTRIM$(STR$(cid)) + "): unrecognized cid"

  END SELECT

END SUB

SUB ExecuteAbout
  '
  ' Displays a window showing information about the game.
  '
  WinShow 30
END SUB

SUB ExecuteDistance
  '
  ' Displays a dialog box for calculating distances between asteroids.
  '
 
  CONST DistanceWid = 22

  DIM ast1 AS INTEGER
  DIM ast2 AS INTEGER
  DIM dist AS INTEGER

  DO
   
    '
    ' Get the two asteroids for which to calculate distance
    '
    WinShow DistanceWid
    IF win(DistanceWid).canceled THEN
      EXIT DO
    END IF
   
    ast1 = VAL(txt(DistanceWid, 1))
    ast2 = VAL(txt(DistanceWid, 2))
   
    ' Ensure the first asteroid exists
    IF ast1 < 1 OR ast1 > asteroids THEN
      WinShow 23
   
    ' Ensure the second asteroid exists
    ELSEIF ast2 < 1 OR ast2 > asteroids THEN
      WinShow 24
   
    ' Ensure the same asteroid is not specified
    ELSEIF ast1 = ast2 THEN
      WinShow 25
  
    ELSE
    
      dist = CalcDistance(ast1, ast2)

      txt(26, 1) = STR$(dist)
      WinShow 26
      EXIT DO
   
    END IF
   
  LOOP
 
END SUB

SUB ExecuteFilterNone
  '
  ' Removes the current filter (no asteroids filtered)
  '
  player(turn).viewFilter = Filter.None
  RefreshPages

END SUB

SUB ExecuteFilterPlayer
  '
  ' Filters asteroids to the current player
  '
 
  player(turn).viewFilter = Filter.Player
  RefreshPages

END SUB

SUB ExecuteFilterPlayers
  '
  ' Filters asteroids to those controlled by a player
  '
  player(turn).viewFilter = Filter.Players
  RefreshPages

END SUB

SUB ExecuteNextMonth
  '
  ' Changes to the next month sets the turn to the first player
  '

  DIM x AS INTEGER

  '
  ' Move each mission closer to their targets.
  '
  FOR x = 1 TO missions
    mission(x).distance = mission(x).distance - 1
    IF mission(x).distance = 0 THEN
      SELECT CASE mission(x).goal
        CASE 1
          BattleMode (x)
      END SELECT
    END IF
  NEXT

  '
  ' Calculate ships produced for each asteroid
  '
  FOR x = 1 TO asteroids
    asteroid(x).ships = asteroid(x).ships + asteroid(x).produce
  NEXT

  '
  ' Reset to the first player
  '
  turn = 1

END SUB

SUB ExecuteNextTurn
  '
  ' Moves to the next turn
  '
  turn = turn + 1

  IF turn > players THEN
    ExecuteNextMonth
    turn = 1
  END IF

  RefreshPages

END SUB

SUB ExecuteOptionAlerts

  DIM original AS STRING
  DIM x        AS INTEGER
  DIM y        AS INTEGER

  original = txt(27, 1)

  WinShow 27

  IF original = " Yes " AND txt(27, 1) = " No  " THEN
    IF players > 1 THEN
      FOR x = 1 TO 3
        FOR y = 300 TO 60 STEP -10
          SOUND y, .2
        NEXT
      NEXT
      WinShow 29
      IF txt(29, 1) = " Yes " THEN
        txt(27, 1) = " Yes "
      END IF
    END IF
  END IF

END SUB

SUB ExecuteOrderAttack
  '
  ' Orders an attack on an asteroid
  '
 
  DIM num AS INTEGER
  DIM src AS INTEGER
  DIM trg AS INTEGER

  DO
   
    '
    ' Get the source, target, and fleet size
    '
    WinShow 15
    IF win(15).canceled THEN
      EXIT SUB
    END IF

    src = VAL(txt(15, 4))
    trg = VAL(txt(15, 5))
    num = VAL(txt(15, 6))
   
    IF src < 1 OR src > asteroids THEN
      WinShow 16
    ELSEIF asteroid(src).ruler <> turn THEN
      WinShow 17
    ELSEIF trg < 1 OR trg > asteroids THEN
      WinShow 18
    ELSEIF src = trg THEN
      WinShow 19
    ELSEIF num < 1 OR num > asteroid(src).ships THEN
      WinShow 20
    ELSE
      EXIT DO
    END IF
 
  LOOP
    
  '
  ' Initialize mission data
  '
  missions = missions + 1
  mission(missions).distance = CalcDistance(src, trg)
  mission(missions).goal = 1
  mission(missions).ruler = turn
  mission(missions).ships = num
  mission(missions).source = src
  mission(missions).target = trg
  mission(missions).techlevel = asteroid(src).tech
    
  '
  ' Deduct ships from the source asteroid
  '
  asteroid(src).ships = asteroid(src).ships - num
    
  '
  ' Show the distance
  '
  txt(21, 1) = STR$(mission(missions).distance)
  WinShow 21
  
END SUB

SUB ExecuteViewAtlas
  '
  ' Displays the atlas
  '
 
  PCOPY VideoPage.Atlas, VideoPage.Display
  player(turn).viewPage = VideoPage.Atlas

END SUB

SUB ExecuteViewTable
  '
  ' Displays the data table
  '
 
  player(turn).viewPage = VideoPage.Table
  PCOPY VideoPage.Table, VidePage.Display

END SUB

FUNCTION GetCellScreenX% (cellX AS INTEGER)
  GetCellScreenX = cellX * 3 - 1
END FUNCTION

FUNCTION GetCellScreenY% (cellY AS INTEGER)
  GetCellScreenY = cellY * 2 + 1
END FUNCTION

FUNCTION GetKey$
  '
  ' Waits for a key to be pressed and returns the string representing
  ' the character or the keystroke. This function is the same as INKEY$
  ' except it does not return until a key is actually pressed.
  '

  DIM k AS STRING

  DO
    k = INKEY$
  LOOP UNTIL LEN(k)

  GetKey$ = k

END FUNCTION

FUNCTION IsFiltered% (aid AS INTEGER)

  DIM filtering AS INTEGER
  LET filtering = player(turn).viewFilter

  IF aid < 1 OR aid > asteroids THEN
    '
    ' Invalid asteroid
    '
    IsFiltered = False
 
  ELSEIF filtering = Filter.None THEN
    '
    ' No filter is applied
    '
    IsFiltered = False

  ELSEIF filtering = Filter.Player THEN
    '
    ' Filter asteroids ruled by current player
    '
    IsFiltered = asteroid(aid).ruler = turn

  ELSEIF filtering = Filter.Players THEN
    '
    ' Filter asteroids with a ruler
    '
    IsFiltered = asteroid(aid).ruler > 0

  ELSE

    IsFiltered = False

  END IF

END FUNCTION

SUB LoadMenu
  '
  ' Loads the menu bar. This subroutine should only be called once.
  '

  DIM count AS INTEGER
  DIM i     AS INTEGER
  DIM posX  AS INTEGER

  '
  ' Read the number of menu items in the bar
  '
  READ count

  '
  ' Load each menu definition
  '
  posX = 2
  FOR i = 1 TO count
   
    '
    ' Load the menu text and window ID
    '
    READ bar(i).text
    READ bar(i).wid
    
    '
    ' Calculate the horizontal position of this menu item
    '
    bar(i).posX = posX
    posX = posX + LEN(bar(i).text)

  NEXT

END SUB

SUB PlayGame

  DIM cid AS INTEGER
  DIM wid AS INTEGER

  SCREEN , , 0, 0
  ExecuteNextTurn
 
  DO
   
    DO
     
      '
      ' Wait for a command from the menu bar
      '
      cid = DoMenu
     
      '
      ' Get the command ID for the selected menu item.
      '
      Execute cid
      IF cid = Command.EndGame THEN
        EXIT SUB
      END IF
    LOOP
   
    IF txt(27, 1) = " Yes " THEN
      FOR x = 1 TO 5: SOUND 800, .8: SOUND 1200, .8: NEXT
    END IF

  LOOP

END SUB

SUB RefreshPages

  '
  ' Refresh the atlas
  '
  SCREEN , , VideoPage.Atlas, VideoPage.Display
  DrawGrid

  '
  ' Refresh the table
  '
  SCREEN , , VideoPage.Table, VideoPage.Display
  DrawTable

  '
  ' Copy the current view page
  '
  IF player(turn).viewPage > 0 THEN
    PCOPY player(turn).viewPage, VideoPage.Display
  END IF

  SCREEN , , VideoPage.Display, VideoPage.Display

END SUB

SUB SetupGame

  SCREEN 0, 0, 0, 0: WIDTH 80: COLOR 7, 0: KEY OFF: CLS : RANDOMIZE TIMER
 
  '
  ' Load menus and windows
  '
  StatusUpdate "Please wait..."
  LoadMenu
  WinLoad

  '
  ' Draw master screens
  '
  SCREEN , , VideoPage.Table, VideoPage.Display
  DrawTable
  DrawMenu
  StatusClear

  SCREEN , , VideoPage.Atlas, VideoPage.Display
  DrawGrid
  DrawMenu
  StatusClear

  '
  ' Draw title screen
  '
  SCREEN , , VideoPage.Working, VideoPage.Display
  DrawFile "TITLE.PCB"
  PCOPY VideoPage.Working, VideoPage.Display
  SCREEN , , VideoPage.Display, VideoPage.Display
  StatusClear

  '
  ' Show starting window #1
  '
  WinShow 1
  IF win(1).canceled THEN
    END
  ELSE
    SetupGame.New
  END IF

END SUB

SUB SetupGame.Atlas

  '
  ' Plotting options
  '
  CONST PlotBanded = 1     ' Asteroids plotted in a narrow horizontal band
  CONST PlotClustered = 2  ' Asteroids plotted close together in a cluster
  CONST PlotRandom = 3     ' Asteroids plotted randomly

  '
  ' Grid dimensions
  '
  CONST GridSizeX = 26
  CONST GridSizeY = 11

  '
  ' Define grid to hold temporary asteroid locations
  '
  DIM grid(1 TO GridSizeX, 1 TO GridSizeY) AS INTEGER
 
  DIM i        AS INTEGER
  DIM j        AS INTEGER
  DIM lastPlot AS INTEGER
  DIM mx       AS INTEGER
  DIM my       AS INTEGER
  DIM nx       AS INTEGER
  DIM ny       AS INTEGER
  DIM sx       AS INTEGER
  DIM sy       AS INTEGER
  DIM keypress AS STRING

  '
  ' Draw the grid onto its master video page to copy to the display page
  '
  PCOPY VideoPage.Atlas, VideoPage.Display
  SCREEN , , VideoPage.Display, VideoPage.Display

  '
  ' Initially select the button to accept the generated atlas
  '
  WinSelect 9, 2
  GOSUB ReplotClustered

  DO
   
    '
    ' Show the editor menu
    '
    WinShow 9

    SELECT CASE win(9).selected
     
      CASE 1
        '
        ' Hide the window in order to see the grid
        '
        StatusUpdate "Press any key to restore the window..."
        WaitForKeyPress
        StatusClear
     
      CASE 2
        GOSUB SaveLocations
        EXIT SUB
     
      CASE 4:
        GOSUB ReplotClustered

      CASE 5:
        GOSUB ReplotBanded

      CASE 6:
        GOSUB ReplotManual

      CASE 7:
        GOSUB ReplotRandom
    
      CASE 8:
        GOSUB ReplotPlayers

    END SELECT

  LOOP

  EXIT SUB

REM *** SUBROUTINES ***

CalcCoord:
  '
  ' Calculates the cursor coordinates of grid cell
  '
  ' Input:
  '
  '     nx = x coordinate of cell
  '     ny = y coordinate of cell
  '
  ' Output:
  '
  '     sx = x coordinate of the cell on the screen
  '     sy = y coordinate of the cell on the screen
  '
  sx = nx * 3 - 1
  sy = ny * 2 + 1
  RETURN

FindCell:
  '
  ' Finds the grid coordinates of an asteroid
  '
  ' Input:
  '
  '     aid = The ID of the asteroid
  '
  ' Output:
  '
  '     nx = The grid x-coordinate of the asteroid.
  '     ny = The grid y-coordinate of the asteroid.
  '
  FOR nx = 1 TO GridSizeX
    FOR ny = 1 TO GridSizeY
      IF grid(nx, ny) = aid THEN
        RETURN
      END IF
    NEXT
  NEXT

  nx = 0
  ny = 0
  RETURN

ClearCell:
  '
  ' Clears an asteroid from the grid.
  '
  ' Input:
  '
  '     nx = The x-coordinate of the cell.
  '     ny = The y-coordinate of the cell.
  '
  ' Output:
  '
  '     sx = The x-coordinate of the screen location that was cleared.
  '     sy = The y-coordinate of the screen location that was cleared.
  '
  IF grid(nx, ny) > 0 THEN
    grid(nx, ny) = 0
    GOSUB CalcCoord
    LOCATE sy, sx
    COLOR GridStyle.Forecolor, GridStyle.Backcolor
    PRINT "  ";
  END IF

  RETURN

ClearGrid:
  '
  ' Clears asteroids from the grid
  '
  ' Input:
  '
  '     None
  '
  ' Output:
  '
  '     nx, ny, cx, cy are zerod
  '
  FOR nx = 1 TO GridSizeX
    FOR ny = 1 TO GridSizeY
      IF grid(nx, ny) > 0 THEN
        GOSUB ClearCell
      END IF
    NEXT
  NEXT

  nx = 0
  ny = 0
  sx = 0
  sy = 0

  RETURN

Normalize:
  '
  ' Normalizes the nx,ny coordinates
  '
  ' Input:
  '
  '     nx = x-coordinate
  '     ny = y-coordinate
  '
  ' Output:
  '
  '     nx = x-coordinate normalized to fit in grid
  '     ny = y-coordinate normalized to fit in grid
  '
  IF nx < 1 THEN nx = nx + GridSizeX
  IF ny < 1 THEN ny = ny + GridSizeY
  IF nx > GridSizeX THEN nx = nx - GridSizeX
  IF ny > GridSizeY THEN ny = ny - GridSizeY
  RETURN

SetCell:
  '
  ' Sets the value of a cell on the grid
  '
  ' Input:
  '
  '     aid = The ID of the asteroid
  '     nx  = The new X position of the asteroid
  '     ny  = The new Y position of the asteroid
  '
  ' Output:
  '
  '     sx = The screen x-coordinate of the asteroid cell
  '     sy = The screen y-coordinate of the asteroid cell
  '
  grid(nx, ny) = aid
  GOSUB CalcCoord
  LOCATE sy, sx
  COLOR GridStyle.CellForecolor, GridStyle.CellBackcolor
  PRINT USING "##"; aid;
  RETURN

NextBanded:
  '
  ' Finds a slot in the same orbital band
  '
  IF nx = 0 THEN
    GOSUB NextRandom
  ELSE
 
    DO
      '
      ' Select random X coordinate, nearby Y coordinate
      '
      nx = INT(RND * GridSizeX) + 1
      ny = INT(RND * 3) - 1 + ny
      GOSUB Normalize

    LOOP UNTIL grid(nx, ny) = 0
               
  END IF
  RETURN

NextClustered:
  '
  ' Finds a clustered slot
  '
  IF nx = 0 THEN
    '
    ' No asteroids have been plotted. Seed the initial asteroid.
    '
    GOSUB NextRandom
 
  ELSE
    '
    ' Find slot near the last asteroid.
    '
    DO
      '
      ' Random spot within -2, -1, 0, +1, +2 from last spot
      '
      nx = INT(RND * 5) - 2 + nx
      ny = INT(RND * 5) - 2 + ny
      GOSUB Normalize

    LOOP UNTIL grid(nx, ny) = 0

  END IF
  RETURN

NextManual:
  '
  ' Returns the next manually-selected position.
  '
  ' Input:
  '
  '     nx = The x-coordinate of the asteroid to move.
  '     ny = The y-coordinate of the asteroid to move.
  '
  ' Output:
  '
  '     nx = The new x-coordinate of the selected position.
  '     ny = The new y-coordinate of the selected position.
  '
  DO
  
    GOSUB CalcCoord
  
    '
    ' Highlight the current location
    '
    LOCATE sy, sx
    IF grid(nx, ny) <= players THEN COLOR 21, 7 ELSE COLOR 21, 0
    PRINT USING "##"; aid;
    COLOR 7, 0
  
    keypress = GetKey$
  
    '
    ' Erase the cell location
    '
    LOCATE sy, sx
    PRINT "  ";

    SELECT CASE keypress
     
      CASE CHR$(ASCII.Return), CHR$(ASCII.Escape)
        EXIT DO

      CASE CHR$(0) + CHR$(ScanCode.Up)
        '
        ' Up
        '
        mx = nx
        my = ny - 1
        IF my < 1 THEN my = GridSizeY
    
      CASE CHR$(0) + CHR$(ScanCode.Right)
        '
        ' Right
        '
        mx = nx + 1
        my = ny
        IF mx > GridSizeX THEN mx = 1
    
      CASE CHR$(0) + CHR$(ScanCode.Left)
        '
        ' Left
        '
        mx = nx - 1
        my = ny
        IF mx < 1 THEN mx = GridSizeX
    
      CASE CHR$(0) + CHR$(ScanCode.Down)
        '
        ' Down
        '
        mx = nx
        my = ny + 1
        IF my > GridSizeY THEN my = 1
   
    END SELECT
   
    IF grid(mx, my) = 0 THEN
      nx = mx
      ny = my
    END IF

  LOOP
  RETURN

NextRandom:
  '
  ' Finds a random slot
  '
  DO
    nx = INT(RND * GridSizeX) + 1
    ny = INT(RND * GridSizeY) + 1
  LOOP UNTIL grid(nx, ny) = 0
  RETURN

ReplotBanded:
  '
  ' Replots all asteroids in an orbital band
  '
  GOSUB ClearGrid
  FOR aid = 1 TO asteroids
    GOSUB NextBanded
    GOSUB SetCell
  NEXT
  lastPlot = PlotBanded
  RETURN

ReplotClustered:
  '
  ' Replots all asteroids in a cluster
  '
  GOSUB ClearGrid
  FOR aid = 1 TO asteroids
    GOSUB NextClustered
    GOSUB SetCell
  NEXT
  lastPlot = PlotClustered
  RETURN

ReplotManual:
  '
  ' Manually replots asteroids
  '
  FOR aid = 1 TO asteroids
   
    GOSUB FindCell
    grid(nx, ny) = 0

    GOSUB NextManual
    GOSUB SetCell
 
    IF keypress = CHR$(ASCII.Escape) THEN
      EXIT FOR
    END IF

  NEXT
  RETURN

ReplotRandom:
  '
  ' Replots all asteroids randomly
  '

  GOSUB ClearGrid
  FOR aid = 1 TO asteroids
    GOSUB NextRandom
    GOSUB SetCell
  NEXT
  lastPlot = PlotRandom
  RETURN

ReplotPlayers:
  '
  ' Replots player asteroids using same mode as last time
  '
  FOR i = 1 TO GridSizeX
    FOR j = 1 TO GridSizeY
     
      aid = grid(i, j)
    
      IF aid = 0 THEN
        ' Do nothing (note: QBASIC does not support shortcircuit eval).
      ELSEIF asteroid(aid).ruler = 0 THEN
        ' Do nothing
      ELSE
        '
        ' This asteroid is owned by a player. Replot it.
        '
        nx = i
        ny = j
        GOSUB ClearCell

        SELECT CASE lastPlot
          CASE PlotBanded
            GOSUB NextBanded
          
          CASE PlotClustered
            GOSUB NextClustered

          CASE PlotRandom
            GOSUB NextRandom

        END SELECT

        GOSUB SetCell

      END IF

    NEXT
  NEXT
  RETURN

SaveLocations:
  '
  ' Commits the grid locations to the asteroids
  '
  FOR i = 1 TO GridSizeX
    FOR j = 1 TO GridSizeY
          
      '
      ' Get the ID of the asteroid at this grid location
      '
      aid = grid(i, j)
          
      '
      ' If an asteroid is found, commit its new position.
      '
      IF aid > 0 THEN
        asteroid(aid).local1 = j
        asteroid(aid).local2 = i
      END IF

    NEXT
  NEXT
  RETURN

END SUB

' =========================================================
' SetupGameNew
' ---------------------------------------------------------
' Sets up a new game.
' =========================================================
SUB SetupGame.New

  DIM aid AS INTEGER
  DIM pid AS INTEGER

  DO
   
    '
    ' Prompt for the number of players and asteroids
    '
    WinShow 2
    players = VAL(txt(2, 5)): IF players = 0 THEN players = 3
    asteroids = VAL(txt(2, 6)): IF asteroids = 0 THEN asteroids = 15
   
    '
    ' Validate initial game options
    '
    IF players > MaxPlayers THEN
      '
      ' Too many players
      '
      WinShow 3
   
    ELSEIF asteroids < players THEN
      '
      ' Not enough asteroids
      '
      WinShow 4

    ELSEIF asteroids > 19 THEN
      '
      ' Too many asteroids
      '
      WinShow 5

    ELSEIF players = 1 AND asteroids = 1 THEN
      '
      ' Can't have one player and one asteroid
      '
      WinShow 6
   
    ELSE
      EXIT DO
    END IF
   
  LOOP

  '
  ' Initialize players
  '
  FOR pid = 1 TO players
    player(pid).viewFilter = Filter.None
    player(pid).viewPage = VideoPage.Table
  NEXT

  '
  ' Initialize asteroid data
  '
  FOR aid = 1 TO asteroids
    asteroid(aid).Control = INT(RND * 10)
    asteroid(aid).detect = INT(RND * 10)
    asteroid(aid).mined = INT(RND * 50) + 50
    IF aid <= players THEN
      asteroid(aid).ruler = aid
    ELSE
      asteroid(aid).ruler = 0
    END IF
    asteroid(aid).produce = 50
    asteroid(aid).tech = 10
    asteroid(aid).shield = 0
    asteroid(aid).ships = 200
    asteroid(aid).supply = 0
  NEXT

  SetupGame.Atlas

END SUB

SUB StatusClear
  '
  ' Clears the status bar
  '
  StatusLevel "", StatusLevel.Normal

END SUB

SUB StatusDebug (text AS STRING)
  '
  ' Writes a debug message to the status bar
  '
  StatusLevel text, StatusLevel.Debug

END SUB

SUB StatusLevel (text AS STRING, level AS INTEGER)

  '
  ' Set the viewport to the last row of the screen
  '
  VIEW PRINT 25 TO 25
 
  '
  ' Set the color based on the status level
  '
  SELECT CASE level
    CASE StatusLevel.Debug:
      COLOR StatusStyle.DebugForecolor, StatusStyle.DebugBackcolor
    CASE ELSE
      COLOR StatusStyle.NormalForecolor, StatusStyle.NormalBackcolor
  END SELECT

  '
  ' Print the updated status and reset the viewport
  '
  CLS
  PRINT text;
  VIEW PRINT
  
END SUB

SUB StatusUpdate (text AS STRING)
  '
  ' Writes text to the status bar
  '
  StatusLevel text, StatusLevel.Normal

END SUB

SUB WaitForKeyPress
  '
  ' Waits for any key to be pressed. The key is discarded from input.
  '
  DIM k AS STRING

  DO
    k = INKEY$
  LOOP UNTIL LEN(k)

END SUB

FUNCTION WinAppend% (wid%, f AS FieldType, text$)
  '
  ' Position the field below the bottom of the window
  '
  f.posY = win(wid%).sizeY + 1

  '
  ' Add the field definition to the window (the window will autosize)
  '
  WinAppend% = WinDefine(wid%, f, text$)

END FUNCTION

FUNCTION WinAppendBoolean% (wid%, text$)

  DIM f AS FieldType

  f.kind = FieldKind.Boolean
  f.posX = 0 ' Center

  WinAppendBoolean% = WinAppend(wid%, f, text$)

END FUNCTION

FUNCTION WinAppendButton% (wid%, cid%, text$)

  DIM f AS FieldType

  f.kind = FieldKind.Button
  f.cid = cid%
  f.posX = 1

  WinAppendButton% = WinAppend(wid%, f, text$)

END FUNCTION

FUNCTION WinAppendLabel% (wid%, text$)

  DIM f AS FieldType

  f.kind = FieldKind.Label
  f.posX = 1

  WinAppendLabel% = WinAppend(wid%, f, text$)

END FUNCTION

FUNCTION WinAppendSeparator% (wid%)

  DIM f AS FieldType

  f.kind = FieldKind.Separator

  WinAppendSeparator% = WinAppend(wid%, f, "-")

END FUNCTION

' ===================================================================
' WinDefine
' -------------------------------------------------------------------
' Defines a new field in a window and returns the field ID. Any code
' that creates new fields should ultimately call this function
' because it applies certain rules such as adjusting the window size.
' ===================================================================
FUNCTION WinDefine% (wid%, f AS FieldType, text$)

  DIM fid  AS INTEGER
  DIM minX AS INTEGER

  '
  ' Increment the number of fields
  '
  win(wid%).fields = win(wid%).fields + 1
  fid = win(wid%).fields

  '
  ' Save the field properties
  '
  fld(wid%, fid) = f
  txt(wid%, fid) = text$

  '
  ' Find the minimum permitted size of the window
  '
  minX = f.posX + f.sizeX - 1
  IF minX < LEN(text$) THEN minX = LEN(text$)

  '
  ' Expand window horizontally if necessary
  '
  IF win(wid%).sizeX < minX THEN
    win(wid%).sizeX = minX
  END IF

  '
  ' Expand window vertically if necessary
  '
  IF win(wid%).sizeY < f.posY THEN
    win(wid%).sizeY = f.posY
  END IF

  WinDefine = fid

END FUNCTION

FUNCTION WinDefineButton% (wid%, posX%, posY%, sizeX%, cid%, text$)
  '
  ' Defines a button field in a window.
  '

  DIM f AS FieldType

  f.kind = FieldKind.Button
  f.cid = cid%
  f.posX = posX%
  f.posY = posY%
  f.sizeX = sizeX%

  WinDefineButton = WinDefine(wid%, f, text$)

END FUNCTION

FUNCTION WinDefineInteger% (wid%, posX%, posY%, sizeX%, text$)
  '
  ' Defines an integer field in a window.
  '
 
  DIM f AS FieldType

  f.kind = FieldKind.Integer
  f.posX = posX%
  f.posY = posY%
  f.sizeX = sizeX%

  WinDefineInteger% = WinDefine(wid%, f, text$)

END FUNCTION

FUNCTION WinDefineLabel% (wid%, posX%, posY%, text$)
  '
  ' Defines a label field in a window. A label field is non-editable
  ' text that cannot be selected (receive focus) or edited directly
  ' by the user.
  '

  DIM f AS FieldType

  f.kind = FieldKind.Label
  f.posX = posX%
  f.posY = posY%
  f.sizeX = LEN(text$)

  WinDefineLabel = WinDefine(wid%, f, text$)

END FUNCTION

' ===================================================================
' WinDraw
' -------------------------------------------------------------------
' Draws the window to the active video page.
' ===================================================================
SUB WinDraw (wid AS INTEGER)

  DIM i          AS INTEGER
  DIM lowerLeft  AS STRING * 1
  DIM lowerFlat  AS STRING * 1
  DIM lowerRight AS STRING * 1
  DIM sideLeft   AS STRING * 1
  DIM sideRight  AS STRING * 1
  DIM upperLeft  AS STRING * 1
  DIM upperFlat  AS STRING * 1
  DIM upperRight AS STRING * 1

  '
  ' Setup border characters
  '
  SELECT CASE WinStyle.Border
    CASE 1
      lowerFlat = CHR$(196)
      lowerLeft = CHR$(192)
      lowerRight = CHR$(217)
      sideLeft = CHR$(179)
      sideRight = CHR$(179)
      upperLeft = CHR$(218)
      upperFlat = CHR$(196)
      upperRight = CHR$(191)
    CASE 2
      lowerFlat = CHR$(205)
      lowerLeft = CHR$(200)
      lowerRight = CHR$(188)
      sideLeft = CHR$(179)
      sideRight = CHR$(179)
      upperLeft = CHR$(201)
      upperFlat = CHR$(205)
      upperRight = CHR$(187)
  END SELECT

  '
  ' Set the display color of the window
  '
  COLOR WinStyle.Forecolor, WinStyle.Backcolor

  '
  ' Draw the top border
  '
  LOCATE win(wid).posY, win(wid).posX
  PRINT upperLeft; STRING$(win(wid).sizeX, upperFlat); upperRight

  '
  ' Draw each row of the window
  '
  FOR r = 1 TO win(wid).sizeY
   
    LOCATE win(wid).posY + r, win(wid).posX
    PRINT sideLeft;
    PRINT STRING$(win(wid).sizeX, CHR$(ASCII.Space));
    PRINT sideRight;

    SELECT CASE WinStyle.Shadow
      CASE 1
        COLOR WinStyle.ShadowForecolor, WinStyle.ShadowBackcolor
        PRINT CHR$(WinStyle.ShadowChar)
        COLOR WinStyle.Forecolor, WinStyle.Backcolor
    END SELECT

  NEXT
    
  '
  ' Draw the lower border
  '
  LOCATE win(wid).posY + win(wid).sizeY + 1, win(wid).posX
  PRINT lowerLeft; STRING$(win(wid).sizeX, lowerFlat); lowerRight;
 
  '
  ' Draw the shadow (including the shadow of the lower border)
  '
  SELECT CASE WinStyle.Shadow
    CASE 1
      COLOR WinStyle.ShadowForecolor, WinStyle.ShadowBackcolor
      PRINT CHR$(WinStyle.ShadowChar);
      LOCATE win(wid).posY + win(wid).sizeY + 2, win(wid).posX + 1
      PRINT STRING$(win(wid).sizeX + 2, WinStyle.ShadowChar);
      COLOR WinStyle.Forecolor, WinStyle.Backcolor
  END SELECT

  '
  ' Draw fields
  '
  FOR i = 1 TO win(wid).fields
    WinDrawField wid, i
  NEXT

END SUB

SUB WinDrawField (wid AS INTEGER, fid AS INTEGER)

  DIM backcolor AS INTEGER
  DIM forecolor AS INTEGER
  DIM posX      AS INTEGER
  DIM posY      AS INTEGER
  DIM sizeX     AS INTEGER
  DIM sx        AS INTEGER
  DIM sy        AS INTEGER
 
  '
  ' Adjust the field size (if zero, then fill width of window)
  '
  sizeX = fld(wid, fid).sizeX
  IF sizeX = 0 THEN
    sizeX = win(wid).sizeX
  END IF
 
  '
  ' Adjust the position of the field (if zero, center)
  '
  posX = fld(wid, fid).posX
  posY = fld(wid, fid).posY
  IF posX = 0 THEN
    posX = INT((win(wid).sizeX - sizeX) / 2) + 1
  END IF

  '
  ' Calculate the screen coordinates of the field
  '
  sx = posX + win(wid).posX
  sy = posY + win(wid).posY
  LOCATE sy, sx

  '
  ' Set the color depending on whether the field is selected
  '
  IF win(wid).selected = fid THEN
    backcolor = WinStyle.SelectedBackcolor
    forecolor = WinStyle.SelectedForecolor
  ELSE
    backcolor = WinStyle.Backcolor
    forecolor = WinStyle.Forecolor
  END IF
  COLOR forecolor, backcolor

  '
  ' Get the kind of field
  '
  SELECT CASE fld(wid, fid).kind
   
    CASE FieldKind.Button, FieldKind.Boolean, FieldKind.Label
      '
      ' Button and Boolean (text)
      '
      PRINT txt(wid, fid);
     
      '
      ' Pad remaining spaces
      '
      PRINT STRING$(sizeX - LEN(txt(wid, fid)), ASCII.Space);

    CASE FieldKind.Separator
      '
      ' Separator
      '
      PRINT STRING$(win(wid).sizeX, 196);

    CASE FieldKind.Integer
      '
      ' Integer Input
      '
      DIM format AS STRING
      format = STRING$(fld(wid, fid).sizeX, "#")
      PRINT USING format; VAL(txt(wid, fid));
 
  END SELECT

END SUB

SUB WinDrawOutline (wid AS INTEGER, atX AS INTEGER, atY AS INTEGER)

  '
  ' Set the color of the outline
  '
  COLOR WinStyle.OutlineForecolor, WinStyle.OutlineBackcolor

  '
  ' Draw upper-left corner
  '
  LOCATE atY, atX
  SELECT CASE WinStyle.Border
    CASE 1
      PRINT CHR$(218); CHR$(196);
    CASE 2
      PRINT CHR$(201); CHR$(205);
  END SELECT
  LOCATE atY + 1, atX
  SELECT CASE WinStyle.Border
    CASE 1
      PRINT CHR$(179);
    CASE 2
      PRINT CHR$(186);
  END SELECT

  '
  ' Draw lower-left corner
  '
  LOCATE atY + win(wid).sizeY, atX
  IF WinStyle.Border = 2 THEN PRINT CHR$(186);  ELSE PRINT CHR$(179);
  LOCATE atY + win(wid).sizeY + 1, atX
  SELECT CASE WinStyle.Border
    CASE 1
      PRINT CHR$(192); CHR$(196);
    CASE 2
      PRINT CHR$(200); CHR$(205);
  END SELECT

  '
  ' Draw upper-right corner
  '
  LOCATE atY, atX + win(wid).sizeX
  IF WinStyle.Border = 2 THEN
    PRINT CHR$(205); CHR$(187);
  ELSE
    PRINT CHR$(196); CHR$(191);
  END IF
  LOCATE atY + 1, atX + win(wid).sizeX + 1
  IF WinStyle.Border = 2 THEN PRINT CHR$(186);  ELSE PRINT CHR$(179);

  '
  ' Draw lower-right corner
  '
  LOCATE atY + win(wid).sizeY, atX + win(wid).sizeX + 1
  IF WinStyle.Border = 2 THEN PRINT CHR$(186);  ELSE PRINT CHR$(179);
  LOCATE atY + win(wid).sizeY + 1, atX + win(wid).sizeX
  IF WinStyle.Border = 2 THEN
    PRINT CHR$(205); CHR$(188);
  ELSE
    PRINT CHR$(196); CHR$(217);
  END IF

END SUB

FUNCTION WinIsSelectable% (wid%, fid%)
  '
  ' Returns True or False depending on whether the specified
  ' field is selectable (i.e., can receive focus for input or
  ' selection).
  '
  
  IF wid% < 0 OR fid% <= 0 THEN

    WinIsSelectable = False

  ELSEIF fid% > win(wid%).fields THEN
   
    WinIsSelectable% = False
 
  ELSE

    SELECT CASE fld(wid%, fid%).kind
      CASE FieldKind.Button
        WinIsSelectable = True

      CASE FieldKind.Boolean
        WinIsSelectable = True

      CASE FieldKind.Integer
        WinIsSelectable = True

      CASE ELSE
        WinIsSelectable = False

    END SELECT

  END IF

END FUNCTION

SUB WinKey (wid%, fid%, keypress$)

  SELECT CASE fld(wid%, fid%).kind
   
    CASE FieldKind.Boolean
      WinKeyBoolean wid%, fid%, keypress$

    CASE FieldKind.Integer
      WinKeyInteger wid%, fid%, keypress$

  END SELECT

END SUB

SUB WinKeyBoolean (wid%, fid%, keypress$)
  '
  ' Sends a keystroke to a boolean field.
  '
 
  SELECT CASE keypress$

    CASE "n", "N"
      txt(wid%, fid%) = " No  "

    CASE "y", "Y"
      txt(wid%, fid%) = " Yes "

  END SELECT

END SUB

SUB WinKeyInteger (wid%, fid%, keypress$)
  '
  ' Sends a key to an integer field
  '

  DIM buf$
  LET buf$ = txt(wid%, fid%)

  SELECT CASE keypress$
   
    CASE CHR$(ASCII.Backspace)

      IF LEN(buf$) > 0 THEN
        buf$ = LEFT$(buf$, LEN(buf$) - 1)
      END IF

    CASE "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"

      IF LEN(buf$) < fld(wid%, fid%).sizeX THEN
        buf$ = buf$ + keypress$
      END IF

  END SELECT

  txt(wid%, fid%) = buf$

END SUB

SUB WinLoad
  '
  ' Loads Window definitions. This should only be called once.
  '
  DIM block   AS STRING
  DIM cid     AS INTEGER
  DIM fid     AS INTEGER
  DIM posX    AS INTEGER
  DIM posY    AS INTEGER
  DIM sizeX   AS INTEGER
  DIM wid     AS INTEGER

  DO
    READ block
    SELECT CASE block
     
      CASE "Start"
        '
        ' Start a new window definition
        '
        wid = wid + 1
        READ win(wid).posY, win(wid).posX
   
      CASE "+$"
        READ block
        fid = WinAppendLabel(wid, block)

      CASE "+-", "-"
        fid = WinAppendSeparator(wid)

      CASE "+@"
        READ block: cid = WinParseCommand(block)
        READ block
        ' HACK: pad the button text for now
        fid = WinAppendButton(wid, cid, " " + block + " ")
     
      CASE "+&"
        READ block
        fid = WinAppendBoolean(wid, block)

      CASE "$"
        READ posX
        READ posY
        READ block
        fid = WinDefineLabel(wid, posX, posY, block)

      CASE "@"
        READ posX
        READ posY
        READ sizeX
        READ block: cid = WinParseCommand(block)
        READ block
        fid = WinDefineButton(wid, posX, posY, sizeX, cid, block)

      CASE "#"
        READ posX
        READ posY
        READ sizeX
        READ block
        fid = WinDefineInteger(wid, posX, posY, sizeX, block)

      CASE "Help"
        '
        ' Set Help Window
        '
        READ win(wid).helpWid

      CASE "End of windows"
        '
        ' End of window data
        '
        EXIT SUB
    
      CASE ELSE

        PRINT "Expected token for wid="; wid; " block="; block
        END

    END SELECT
  LOOP

END SUB

SUB WinMove (wid AS INTEGER)

  DIM keypress  AS STRING
  DIM toX       AS INTEGER
  DIM toY       AS INTEGER
  DIM x         AS INTEGER

  '
  ' Get the starting location of the window
  '
  toX = win(wid).posX
  toY = win(wid).posY

  DO
   
    '
    ' Copy the display page to the working video page
    '
    PCOPY VideoPage.Display, VideoPage.Working

    '
    ' Manipulate the working video page
    '
    SCREEN , , VideoPage.Working, VideoPage.Working

    '
    ' Draw the outline and wait for a keyboard command
    '
    WinDrawOutline wid, toX, toY
    keypress = GetKey$

    SELECT CASE keypress

      CASE CHR$(Control.D), "D", CHR$(0) + CHR$(ScanCode.Right)
        '
        ' Move right
        '
        toX = toX + 1
     
      CASE CHR$(Control.E), "E", CHR$(0) + CHR$(ScanCode.Up)
        '
        ' Move Up
        '
        toY = toY - 1
     
      CASE CHR$(ASCII.Return)
        '
        ' Enter (final position selected)
        '
        win(wid).posX = toX
        win(wid).posY = toY

        '
        ' Restore the display page
        '
        SCREEN , , VideoPage.Display, VideoPage.Display
        EXIT SUB
     
      CASE CHR$(Control.O), "O"
        '
        ' Change outline
        '
        ' TODO: support?
        'IF outline = 0 THEN outline = 1 ELSE outline = 0
     
      CASE CHR$(Control.S), CHR$(0) + CHR$(ScanCode.Left)
        '
        ' Move Left
        '
        toX = toX - 1
     
      CASE CHR$(Control.X), CHR$(0) + CHR$(ScanCode.Down)
        '
        ' Move Down
        '
        toY = toY + 1
     
      CASE CHR$(ASCII.Escape)
        '
        ' Escape (restore original location)
        '
        toX = win(wid).posX
        toY = win(wid).posY
   
    END SELECT

    GOSUB CheckPlace
 
  LOOP

REM *** Subroutines ***

CheckPlace:
  IF toY < 2 THEN toY = 2
  IF toY > 23 - win(wid).sizeY THEN toY = 23 - win(wid).sizeY
  IF toX < 1 THEN toX = 1
  IF toX > 78 - win(wid).sizeX THEN toX = 78 - win(wid).sizeX
  RETURN

END SUB

FUNCTION WinParseCommand% (text$)
  '
  ' Translates a command name into an integer value. This is used when
  ' loading window definitions so that the developer can refer to a
  ' command with a human-friendly string instead of an integer.
  ' When creating new commands, add an entry to this function that
  ' maps a human-friendly name to a value in the Command.* constants.

  DIM cid AS INTEGER

  SELECT CASE UCASE$(text$)
   
    CASE "ABOUT"
      cid = Command.About

    CASE "DISTANCE":
      cid = Command.Distance

    CASE "ENDGAME":
      cid = Command.EndGame

    CASE "FILTERNONE":
      cid = Command.FilterNone

    CASE "FILTERPLAYER":
      cid = Command.FilterPlayer

    CASE "FILTERPLAYERS":
      cid = Command.FilterPlayers

    CASE "NEXTMONTH":
      cid = Command.NextMonth

    CASE "NEXTTURN":
      cid = Command.NextTurn

    CASE "OPTIONALERTS":
      cid = Command.OptionAlerts

    CASE "ORDERATTACK":
      cid = Command.OrderAttack

    CASE "VIEWATLAS":
      cid = Command.ViewAtlas

    CASE "VIEWTABLE":
      cid = Command.ViewTable

    CASE "", "<COMMAND>"
      ' HACK: ignore <command> as it is a development placeholder
      cid = 0

    CASE ELSE
      StatusDebug "WinParseCommand: " + text$ + " not recognized"
      cid = 0

  END SELECT

  WinParseCommand = cid

END FUNCTION

SUB WinSelect (wid%, fid%)
  '
  ' Selects the specified field (gives it focus)
  '
 
  IF fid% > 0 THEN

    ' If a non-zero field ID is specified, make sure the field is
    ' actually selectable. Note that fid% can be zero in cases where
    ' the caller wants to unselect all fields.

    IF NOT WinIsSelectable(wid%, fid%) THEN
      StatusDebug "WinSelect(" + STR$(wid%) + "," + STR$(fid%) + "): fid is not selectable"
    END IF

  END IF

  win(wid%).selected = fid%

END SUB

SUB WinSelectFirst (wid%)
  '
  ' Selects the first selectable field
  '

  IF win(wid%).fields = 0 THEN
    '
    ' This window has no fields
    '
    WinSelect wid%, 0

  ELSE
 
    DIM fid%
    FOR fid% = 1 TO win(wid%).fields
      IF WinIsSelectable(wid%, fid%) THEN
        WinSelect wid%, fid%
        EXIT SUB
      END IF
    NEXT

    '
    ' None of the fields were selectable
    '
    WinSelect wid%, 0

  END IF

END SUB

SUB WinSelectLast (wid%)
  '
  ' Selects the last selectable field
  '

  IF win(wid%).fields = 0 THEN
    '
    ' This window has no fields
    '
    WinSelect wid%, 0

  ELSE

    DIM fid%
    FOR fid% = win(wid%).fields TO 1 STEP -1
      IF WinIsSelectable(wid%, fid%) THEN
        WinSelect wid%, fid%
        EXIT SUB
      END IF
    NEXT

    '
    ' None of the fields were selectable
    '
    WinSelect wid%, 0

  END IF

END SUB

SUB WinSelectNext (wid%)
  '
  ' Selects the next selectable field
  '

  DIM fid%
  DIM firstFid%

  IF win(wid%).fields = 0 THEN
    '
    ' No fields are defined
    '
    fid% = 0
 
  ELSE

    '
    ' Get the starting field
    '
    LET firstFid% = win(wid%).selected
    IF firstFid% = 0 THEN
      firstFid% = 1
    END IF

    LET fid% = firstFid%

    DO
    
      '
      ' Move to the next field
      '
      fid% = fid% + 1
      IF fid% > win(wid%).fields THEN
        fid% = 1
      END IF

    LOOP UNTIL (fid% = firstFid%) OR WinIsSelectable(wid%, fid%)

  END IF

  '
  ' Select the field
  '
  WinSelect wid%, fid%

END SUB

SUB WinSelectPrevious (wid%)
  '
  ' Selects the field before the current one (looping around)
  '

  DIM fid%
  DIM startingFid%

  IF win(wid%).fields = 0 THEN
    '
    ' No fields are defined
    '
    fid% = 0

  ELSE

    '
    ' Get the starting field
    '
    LET startingFid% = win(wid%).selected
    IF startingFid% = 0 THEN
      startingFid% = 1
    END IF

    LET fid% = startingFid%

    '
    ' Loop through each field and find the next selectable one
    '
    DO
   
      fid% = fid% - 1
      IF fid% = 0 THEN
        fid% = win(wid%).fields
      END IF

    LOOP UNTIL (fid% = startingFid%) OR WinIsSelectable(wid%, fid%)

  END IF

  '
  ' Select the field
  '
  WinSelect wid%, fid%

END SUB

SUB WinShow (wid AS INTEGER)
  '
  ' Displays and runs the specified window
  '
 
  DIM oldSelected AS INTEGER

  DO
   
    '
    ' Show the display page but write to the working page
    '
    SCREEN , , VideoPage.Working, VideoPage.Display

    '
    ' Copy the display page to the working page
    '
    PCOPY VideoPage.Display, VideoPage.Working

    '
    ' Draw the window onto the working page
    '
    WinDraw wid
   
    '
    ' Set the working page as the visual page
    '
    SCREEN , , VideoPage.Working, VideoPage.Working
   
    '
    ' Set focus to a field
    '
    IF win(wid).selected = 0 THEN
      WinSelectFirst wid
    END IF

    DO

      '
      ' Get the current field that has focus
      '
      oldSelected = win(wid).selected
      IF oldSelected <> 0 THEN
        '
        ' If a field is selected, draw it now.
        '
        WinDrawField wid, oldSelected
      END IF

      '
      ' Wait for a keystroke
      '
      pressed = GetKey$
      SELECT CASE pressed
     
        CASE CHR$(ASCII.Return)
          '
          ' Return/Enter
          '
          win(wid).canceled = False
        
          '
          ' Restore the display page
          '
          SCREEN , , VideoPage.Display, VideoPage.Display
          EXIT SUB
       
        CASE CHR$(0) + CHR$(ScanCode.Down), CHR$(ASCII.Space)
          '
          ' Down
          '
          WinSelectNext wid

        CASE CHR$(0) + CHR$(ScanCode.Up)
          '
          ' Up
          '
          WinSelectPrevious wid

        CASE CHR$(0) + CHR$(ScanCode.Home)
          '
          ' Home (first field)
          '
          WinSelectFirst wid

        CASE CHR$(0) + CHR$(ScanCode.End)
          '
          ' End (last field)
          '
          WinSelectLast wid

        CASE "/", "?"
          '
          ' Help
          '
          IF win(wid).helpWid <> 0 THEN
            WinShow win(wid).helpWid
          END IF

        CASE CHR$(0) + CHR$(ScanCode.Left), CHR$(0) + CHR$(ScanCode.Right)
          '
          ' Left/right arrow (exit for menu windows)
          '
          IF arrowexit THEN
            ' HACK
            win(wid).canceled = False
           
            '
            ' Restore the display page and exit
            '
            SCREEN , , VideoPage.Display, VideoPage.Display
            EXIT SUB
          END IF
     
        CASE CHR$(ASCII.Escape)
          '
          ' Escape (cancel)
          '
          win(wid).canceled = True
         
          '
          ' Restore the display page
          '
          SCREEN , , VideoPage.Display, VideoPage.Display
                  EXIT SUB

        CASE CHR$(Control.D), CHR$(Control.E), CHR$(19), CHR$(24)
          WinMove wid
          '
          ' Exit the input loop to jump up to the window loop.
          ' This will force a refresh of the window.
          '
          EXIT DO

        CASE ELSE
          WinKey wid, win(wid).selected, pressed

      END SELECT
   
      '
      ' Redraw the old field if selection changed.
      ' The new field will be redrawn at the start of this DO loop.
      '
      IF oldSelected <> win(wid).selected THEN
        WinDrawField wid, oldSelected
      END IF

    LOOP
  LOOP

END SUB

