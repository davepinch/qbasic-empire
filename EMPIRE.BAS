
' The Galactic Empire
' Version 1.0
'
' (C) 1992 David J. Pinch
' All rights reserved.
'
' To begin, press Shift + F5.
' To exit QBASIC, press Alt, F, X.

  DECLARE SUB BattleMode (id AS INTEGER)
  DECLARE SUB DoWindow (id AS INTEGER)
  DECLARE SUB DrawGrid ()
  DECLARE SUB DrawMenu ()
  DECLARE SUB DrawMenuItem (itemId AS INTEGER, selected AS INTEGER)
  DECLARE SUB DrawStatus (status AS STRING)
  DECLARE SUB DrawTable ()
  DECLARE SUB DrawTableRow (x AS INTEGER)
  DECLARE SUB DrawWindow (id AS INTEGER)
  DECLARE SUB DrawWindowField (wid AS INTEGER, fid AS INTEGER)
  DECLARE SUB DrawWindowOutline (wid AS INTEGER, atX AS INTEGER, atY AS INTEGER)
  DECLARE SUB FindDistance ()
  DECLARE SUB InitData ()
  DECLARE SUB LoadMenu ()
  DECLARE SUB LoadWindows ()
  DECLARE SUB MakeAtlas ()
  DECLARE SUB NextMonth ()
  DECLARE SUB MoveWindow (id AS INTEGER)
  DECLARE SUB NewGame ()
  DECLARE SUB OrderAttack ()
  DECLARE SUB PlayGame ()
  DECLARE SUB SelectAlert ()
  DECLARE SUB Setup ()
  DECLARE SUB ViewPage ()
  DECLARE SUB WaitForKeyPress ()

  DECLARE FUNCTION CalcDistance (first AS INTEGER, second AS INTEGER)
  DECLARE FUNCTION DoMenu ()
  DECLARE FUNCTION GetKey$ ()

  TYPE ASTEROIDTYPE
    Control AS INTEGER
    Detect  AS INTEGER
    local1  AS INTEGER
    local2  AS INTEGER
    mined   AS INTEGER
    Produce AS INTEGER
    ruler   AS INTEGER
    ships   AS INTEGER
    Shield  AS INTEGER
    Supply  AS INTEGER
    tech    AS INTEGER
  END TYPE

  TYPE MISSIONTYPE
    distance  AS INTEGER
    goal      AS INTEGER
    ruler     AS INTEGER
    ships     AS INTEGER
    source    AS INTEGER
    target    AS INTEGER
    techlevel AS INTEGER
  END TYPE

  ' =================================================================
  ' ASCII Character Constants
  ' =================================================================
  CONST ASCII.Backspace = 8
  CONST ASCII.Return = 13
  CONST ASCII.Escape = 27
  CONST ASCII.Space = 32

  ' =================================================================
  ' Boolean Constants
  ' =================================================================
  CONST True = -1
  CONST False = NOT True

  ' =================================================================
  ' Control Character Constants
  ' =================================================================
  CONST Control.D = 4
  CONST Control.E = 5
  CONST Control.O = 15
  CONST Control.S = 19
  CONST Control.X = 24

  ' =================================================================
  ' Field Kinds
  ' =================================================================
  CONST FieldKind.None = 0
  CONST FieldKind.Button = 1
  CONST FieldKind.Integer = 2
  CONST FieldKind.Boolean = 3

  ' =================================================================
  ' GridStyle constants
  ' =================================================================
  CONST GridStyle.Backcolor = 0
  CONST GridStyle.Border = 2
  CONST GridStyle.Forecolor = 1

  ' =================================================================
  ' Maximum UI elements
  ' =================================================================
  CONST MaxMenus = 5
  CONST MaxFields = 10
  CONST MaxWindows = 50

  ' =================================================================
  ' MenuStyle Constants
  ' =================================================================
  CONST MenuStyle.BackColor = 7
  CONST MenuStyle.ForeColor = 0
  CONST MenuStyle.SelectedBackColor = 0
  CONST MenuStyle.SelectedForeColor = 15
                                       
  ' =================================================================
  ' ScanCode Constants
  ' =================================================================
  CONST ScanCode.Home = 71
  CONST ScanCode.Up = 72
  CONST ScanCode.Left = 75
  CONST ScanCode.Right = 77
  CONST ScanCode.End = 79
  CONST ScanCode.Down = 80

  ' =================================================================
  ' StatusStyle constants
  ' =================================================================
  CONST StatusStyle.Foreground = 15
  CONST StatusStyle.Background = 0

  ' =================================================================
  ' TableStyle constants
  ' =================================================================
  CONST TableStyle.Backcolor = 0
  CONST TableStyle.Border = 2
  CONST TableStyle.Forecolor = 7

  ' =================================================================
  ' WinStyle constants
  ' =================================================================
  CONST WinStyle.Backcolor = 1
  CONST WinStyle.Forecolor = 7
  CONST WinStyle.Border = 1
  CONST WinStyle.OutlineBackcolor = 2
  CONST WinStyle.OutlineForecolor = 7
  CONST WinStyle.SelectedBackcolor = 7
  CONST WinStyle.SelectedForecolor = 0
  CONST WinStyle.Shadow = 1
  CONST WinStyle.ShadowChar = 176
  CONST WinStyle.ShadowForecolor = 8
  CONST WinStyle.ShadowBackcolor = 0

  ' =================================================================
  ' FieldType
  ' =================================================================
  TYPE FieldType
    kind  AS INTEGER
    posX  AS INTEGER
    posY  AS INTEGER
    sizeX AS INTEGER
  END TYPE

  ' =================================================================
  ' MenuType
  ' =================================================================
  TYPE MenuType
    posX AS INTEGER
    text AS STRING * 10
    wid  AS INTEGER
  END TYPE

  ' =================================================================
  ' WindowType
  ' =================================================================
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
  ' Window definitions
  '
  DIM SHARED bar(1 TO MaxMenus) AS MenuType
  DIM SHARED fld(1 TO MaxWindows, 1 TO MaxFields) AS FieldType
  DIM SHARED win(1 TO MaxWindows) AS WindowType

  REM Window-definition variables.
    DIM SHARED fieldtext(1 TO 50, 1 TO MaxFields)   AS STRING
    DIM SHARED text(1 TO 50, 1 TO 20)        AS STRING

  REM Global variables.
    DIM SHARED arrowexit         AS INTEGER
    DIM SHARED asteroid(1 TO 19) AS ASTEROIDTYPE
    DIM SHARED asteroids         AS INTEGER
    DIM SHARED display           AS INTEGER
    DIM SHARED empire.shown      AS INTEGER
    DIM SHARED mission(1 TO 100) AS MISSIONTYPE
    DIM SHARED missions          AS INTEGER
    DIM SHARED players           AS INTEGER
    DIM SHARED pressed           AS STRING
    DIM SHARED turn              AS INTEGER
   
  Setup
  PlayGame

  ' =================================================================
  ' Menu bar data
  ' =================================================================
  DATA 5
  DATA " Atlas ", 10
  DATA " Game ", 11
  DATA " Mission ", 12
  DATA " Options ", 13
  DATA " Special ", 14

  REM Window 1
    DATA "Start"
    DATA 8,25
    DATA "                                "
    DATA " Welcome to the Galactic Empire "
    DATA "                                "
    DATA "    Please select an option.    "
    DATA "                                "
    DATA "           @New Game@           "
    DATA "           @Old Game@           "
    DATA "                                "
 
  REM Window 2
    DATA "Start"
    DATA 10,11
    DATA "                    Initialization Mode                   "
    DATA "-"
    DATA " How many people are playing?  [Def=3]                ##  "
    DATA " How many asteroids should be in the game?  [Def=15]  ##  "

  REM Window 3
    DATA "Start"
    DATA 11,24
    DATA " Error: Only 1 to 10 people can "
    DATA " play the game.                 "

  REM Window 4
    DATA "Start"
    DATA 10,21
    DATA "Help", 8
    DATA " Error: The number of asteroids cannot "
    DATA " be less than the number of players.   "
    DATA "-"
    DATA " Press ? for more information.         "

  REM Window 5
    DATA "Start"
    DATA 11,20
    DATA " Error: The maximum number of asteroids "
    DATA " allowed is nineteen.                   "

  REM Window 6
    DATA "Start"
    DATA 10,19
    DATA "Help", 7
    DATA " Error: It is impossible to play the game "
    DATA " with only one player and one asteroid.   "
    DATA "-"
    DATA " Press ? for more information.            "

  REM Window 7
    DATA "Start"
    DATA 9,10
    DATA " When you start out the game, asteroids are automatically "
    DATA " assigned to the players.  Because you only have one      "
    DATA " asteroid to give to a single player, there are no other  "
    DATA " asteroids to conquer.  This makes it impossible to solve "
    DATA " the game.  Correct the problem by selecting a higher     "
    DATA " number of asteroids.                                     "

  REM Window 8
    DATA "Start"
    DATA 10,10
    DATA " When you start out the game, asteroids are automatically "
    DATA " assigned to the players.  Because you have selected less "
    DATA " asteroids than players, not every player can be assigned "
    DATA " an asteroid.  Correct the problem by selecting enough    "
    DATA " asteroids to cover all the players.                      "

  REM Window 9
    DATA "Start"
    DATA 3,3
    DATA "@Look Behind Window  @"
    DATA "@Next Step...        @"
    DATA "-"
    DATA "@Cluster Together    @"
    DATA "@Orbital Belt        @"
    DATA "@Plot Manually       @"
    DATA "@Random Setting      @"
    DATA "@Replot Player's Only@"

  REM Window 10
    DATA "Start"
    DATA 2,2
    DATA "@View all conquered@"
    DATA "@View data page    @"
    DATA "@View empire       @"
    DATA "@View next empire  @"

  REM Window 11
    DATA "Start"
    DATA 2,9
    DATA "@Load a game       @"
    DATA "@Next player's turn@"
    DATA "@Reset the game    @"
    DATA "@Save the game     @"
    DATA "@Shell to DOS      @"
    DATA "@Quit the game     @"
   
  REM Window 12
    DATA "Start"
    DATA 2,15
    DATA "@Assist another       @"
    DATA "@Attack an asteroid   @"
    DATA "@List all known       @"
    DATA "@Destroy an asteroid  @"
    DATA "@Raid an asteroid     @"
    DATA "@Reinforce an asteroid@"
    DATA "@Spy on an asteroid   @"

  REM Window 13
    DATA "Start"
    DATA 2,24
    DATA "@Alerting the next player@"
    DATA "@Border                  @"
    DATA "@Command entry           @"
    DATA "@Confirming actions      @"
    DATA "@Shadow                  @"
    DATA "@Sound effects           @"

  REM Window 14
    DATA "Start"
    DATA 2,33
    DATA "@About...           @"
    DATA "@Calculate distance @"
    DATA "@Find current winner@"
    DATA "@Move ahead in time @"
    DATA "@Search for value   @"

  REM Window 15
    DATA "Start"
    DATA 3,15
    DATA " Enter the source asteroid:    ##  "
    DATA " Enter the target asteroid:    ##  "
    DATA " Enter the number of ships:  #  #  "
                                            
  REM Window 16
    DATA "Start"
    DATA 4,11
    DATA " Error: The source asteroid does not exist. "

  REM Window 17
    DATA "Start"
    DATA 4,10
    DATA " Error: You cannot control the source asteroid. "
   
  REM Window 18
    DATA "Start
    DATA 4,11
    DATA " Error: The target asteroid does not exist. "

  REM Window 19
    DATA "Start"
    DATA 4,10
    DATA " Error: The same asteroid has been specified "
    DATA " for both the target and source.             "
   
  REM Window 20
    DATA "Start"
    DATA 4,10
    DATA " Error: You cannot send the specified number of ships. "

  REM Window 21
    DATA "Start"
    DATA 3,18
    DATA " The ships will arrive at the "
    DATA " destination in               "

  REM Window 22
    DATA "Start"
    DATA 3,33
    DATA " Enter the first asteroid:   ##  "
    DATA " Enter the second asteroid:  ##  "

  REM Window 23
    DATA "Start"
    DATA 3,28
    DATA " Error: The first asteroid does not exist. "

  REM Window 24
    DATA "Start"
    DATA 3,28
    DATA " Error: The second asteroid does not exist. "

  REM Window 25
    DATA "Start"
    DATA 3,34
    DATA " Error: The same asteroid has "
    DATA " been specified both times.   "
   
  REM Window 26
    DATA "Start"
    DATA 3,34
    DATA " The calculated distance is    "

  REM Window 27
    DATA "Start"
    DATA 9,19
    DATA " Do you wish to alert the others with "
    DATA " a bell after a player has made his   "
    DATA " turn?  This minimizes cheating.      "
    DATA "-"
    DATA "                 & &                  "
   
  REM Window 28
    DATA "Start"
    DATA 5,20
    DATA "                                        "
    DATA "           Battle Looms Ahead!          "
    DATA "                                        "
    DATA " The attacker is ruler                  "
    DATA "   Ships:                               "
    DATA "   Technology:                          "
    DATA "                                        "
    DATA " The defender is                        "
    DATA "   Shield:                              "
    DATA "   Ships:                               "
    DATA "   Technology:                          "
    DATA "                                        "
    DATA " Press any key to begin...              "
    DATA "                                        "

  REM Window 29
    DATA "Start"
    DATA 9,19
    DATA " WARNING TO ALL PLAYERS: The current "
    DATA " player has attempted to turn off    "
    DATA " the Alert Next Player option.  Is   "
    DATA " this person trying to cheat?        "
    DATA "-"
    DATA "                & &                  "

  REM Window 30
    DATA "Start"
    DATA 10,25
    DATA "   The Galactic Empire   "
    DATA "-"
    DATA " (C) 1992 David J. Pinch "
  
  REM Window 31
    DATA "Start"
    DATA 6,12
    DATA "                                                      "
    DATA " Battle Round:                                        "
    DATA "                                                      "
    DATA " Attacker's ships:                                    "
    DATA " [__________________________________________________] "
    DATA "                                                      "
    DATA " Defender's ships:                                    "
    DATA " [__________________________________________________] "
    DATA "                                                      "
   
    DATA "End of windows"

SUB BattleMode (id AS INTEGER)
 
  DIM attacked AS INTEGER
  DIM defended AS INTEGER
  DIM round    AS INTEGER
  DIM shot     AS INTEGER
  DIM start1   AS INTEGER
  DIM start2   AS INTEGER
  DIM trg      AS INTEGER
  DIM x        AS INTEGER

  trg = mission(id).target

  DoWindow 28
 
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
  PRINT asteroid(trg).Shield
 
  LOCATE win(28).posY + 10, win(28).posX + 10
  PRINT asteroid(trg).ships
 
  LOCATE win(28).posY + 11, win(28).posX + 15
  PRINT asteroid(trg).tech
  COLOR 7, 0

  DO
    FOR x = 1200 TO 800 STEP -35
      SOUND x, .2
    NEXT
    FOR x = 800 TO 1200 STEP 35
      SOUND x, .2
    NEXT
  LOOP UNTIL LEN(INKEY$)

  PCOPY display, 0: DoWindow 31
 
  DO
    round = round + 1
    LOCATE win(31).posY + 2, win(31).posX + 15
    COLOR 0, 7: PRINT round: COLOR 7, 0
    attacked = 0: defended = 0
    start1 = mission(id).ships: start2 = asteroid(trg).ships
    DO
      IF turn = 0 AND attacked <= start1 THEN 'Attacker fires
        shot = INT(RND * 3 - 1 + 2 ^ (mission(id).techlevel / 10))
        shot = shot - shot * (asteroid(trg).Shield) / 100
        asteroid(id).ships = asteroid(id).ships - shot
        IF asteroid(id).ships < 1 THEN asteroid(id).ships = 0
        attacked = attacked + 1
      ELSEIF turn = 1 AND defended <= start2 THEN 'Defender fires
        shot = INT(RND * 3 - 1 + 2 ^ (asteroid(trg).tech / 10))
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

  DIM dist AS INTEGER

  dist = (asteroid(first).local1 - asteroid(second).local1) ^ 2
  dist = dist + (asteroid(first).local2 - asteroid(second).local2) ^ 2
  dist = INT(SQR(dist))

  CalcDistance = dist

END FUNCTION

' ===================================================================
' DoMenu
' -------------------------------------------------------------------
' Returns the selected menu from the top-level menu bar.
' ===================================================================
FUNCTION DoMenu

  CONST MenusClosed = 0
  CONST MenusOpen = 1

  DIM keypress  AS STRING
  DIM mode      AS INTEGER
  DIM selection AS INTEGER

  PCOPY display, 0: selection = 1
   
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
      DoWindow bar(selection).wid
      arrowexit = 0
     
      IF win(bar(selection).wid).canceled THEN
       
        mode = MenusClosed
     
      ELSE

        SELECT CASE pressed
          CASE CHR$(ASCII.Return)
            DoMenu = bar(selection).wid
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

SUB DoWindow (wid AS INTEGER)

  DIM oldSelected AS INTEGER

  DO
   
    SCREEN , , 0, display: COLOR 0, 7
    DrawWindow wid
    SCREEN , , 0, 0: COLOR 7, 0
   
    '
    ' Set focus to a field
    '
    IF win(wid).selected = 0 AND win(wid).fields > 0 THEN
      win(wid).selected = 1
    END IF

    DO

      '
      ' Draw the selected field (if any)
      '
      oldSelected = win(wid).selected
      IF oldSelected <> 0 THEN
        DrawWindowField wid, oldSelected
      END IF

      '
      ' TODO: Remove this Scan() and pressed global reference.
      ' It cannot be removed now because other code is dependent
      ' on the pressed variable getting set. That will be fixed
      ' when the windowing system is addressed.
      '
      pressed = GetKey$
      SELECT CASE pressed
     
        CASE CHR$(0) + CHR$(ScanCode.Down), CHR$(ASCII.Space)
          '
          ' Down
          '
          IF win(wid).fields > 0 THEN
            IF win(wid).selected = win(wid).fields THEN
              win(wid).selected = 1
            ELSE
              win(wid).selected = win(wid).selected + 1
            END IF
          END IF

        CASE CHR$(0) + CHR$(ScanCode.Up), CHR$(ASCII.Backspace)
          '
          ' Up
          '
          IF win(wid).fields > 0 THEN
            IF win(wid).selected = 1 THEN
              win(wid).selected = win(wid).fields
            ELSE
              win(wid).selected = win(wid).selected - 1
            END IF
          END IF

        CASE CHR$(0) + CHR$(ScanCode.Home)
          '
          ' Home (first field)
          '
          IF win(wid).fields > 0 THEN
            win(wid).selected = 1
          END IF

        CASE CHR$(0) + CHR$(ScanCode.End)
          '
          ' End (last field)
          '
          IF win(wid).fields > 0 THEN
            win(wid).selected = win(wid).fields
          END IF

        CASE "/", "?"
          '
          ' Help
          '
          IF win(wid).helpWid <> 0 THEN
            DoWindow win(wid).helpWid
            DrawWindow wid
          END IF

        ' Left or Right
        CASE CHR$(0) + CHR$(ScanCode.Left), CHR$(0) + CHR$(ScanCode.Right)
          IF arrowexit THEN
            win(wid).canceled = False
            PCOPY display, 0
            EXIT SUB
          END IF
       
        CASE CHR$(Control.D), CHR$(Control.E), CHR$(19), CHR$(24)
          MoveWindow wid
          EXIT DO

        CASE CHR$(ASCII.Return)
          win(wid).canceled = False
          PCOPY display, 0
          EXIT SUB
       
        CASE CHR$(ASCII.Escape)
          win(wid).canceled = True
          PCOPY display, 0
          EXIT SUB

        CASE "N"
          IF win(wid).selected > 0 THEN
            IF fld(wid, win(wid).selected).kind = FieldKind.Boolean THEN
              fieldtext(wid, win(wid).selected) = " No  "
            END IF
          END IF

        CASE "Y"
          IF win(wid).selected > 0 THEN
            IF fld(wid, win(wid).selected).kind = FieldKind.Boolean THEN
              fieldtext(wid, win(wid).selected) = " Yes "
            END IF
          END IF

        CASE ELSE
          IF win(wid).selected > 0 THEN
            IF fld(wid, win(wid).selected).kind = FieldKind.Integer THEN
              IF ASC(pressed) >= 48 AND ASC(pressed) <= 57 THEN
                fieldtext(wid, win(wid).selected) = fieldtext(wid, win(wid).selected) + pressed
                fieldtext(wid, win(wid).selected) = RIGHT$(fieldtext(wid, win(wid).selected), LEN(fieldtext(wid, win(wid).selected)) - 1)
              END IF
            END IF
          END IF

      END SELECT
   
      '
      ' Change selected field
      '
      IF oldSelected <> win(wid).selected THEN
        DrawWindowField wid, oldSelected
        DrawWindowField wid, win(wid).selected
      END IF

    LOOP
  LOOP

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

END SUB

' ===================================================================
' DrawMenu
' ===================================================================
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

' ===================================================================
' DrawMenuItem
' ===================================================================
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

' ===================================================================
' DrawStatus
' ===================================================================
SUB DrawStatus (status AS STRING)

  '
  ' Set a viewport and clear the last row of the screen
  '
  VIEW PRINT 25 TO 25
  COLOR StatusStyle.Foreground, StatusStyle.Background
  CLS
 
  '
  ' Print the updated status and reset the viewport
  '
  PRINT status;
  VIEW PRINT

END SUB

' ===================================================================
' DrawTable
' ===================================================================
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
  PRINT " Id  Ruler  Tech  Mined  Supply  Detect  Control  Shield  Produce  Available ";
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

' ===================================================================
' DrawTableRow
' ===================================================================
SUB DrawTableRow (x AS INTEGER)

  IF x > asteroids THEN
    EXIT SUB
  END IF

  LOCATE x + 4, 3: PRINT USING "##"; x;

  IF asteroid(x).ruler > 0 THEN
    LOCATE , 9: PRINT CHR$(64 + x);
    LOCATE , 15: PRINT USING "##"; asteroid(x).tech;
    LOCATE , 21: PRINT USING "###"; asteroid(x).mined;
    LOCATE , 28: PRINT USING "####"; asteroid(x).Supply;
    LOCATE , 37: PRINT USING "##"; asteroid(x).Detect;
    LOCATE , 45: PRINT USING "###"; asteroid(x).Control;
    LOCATE , 54: PRINT USING "###"; asteroid(x).Shield;
    LOCATE , 62: PRINT USING "###"; asteroid(x).Produce;
    LOCATE , 72: PRINT USING "####"; asteroid(x).ships;
  ELSE
    LOCATE , 6: PRINT "[data not available]";
  END IF

END SUB

' ===================================================================
' DrawWindow
' ===================================================================
SUB DrawWindow (wid AS INTEGER)

  DIM i AS INTEGER

  '
  ' Set the display color of the window
  '
  COLOR WinStyle.Forecolor, WinStyle.Backcolor

  '
  ' Draw the top border
  '
  LOCATE win(wid).posY, win(wid).posX
  SELECT CASE WinStyle.Border
    CASE 1
      PRINT CHR$(218); STRING$(win(wid).sizeX, 196); CHR$(191)
    CASE 2
      PRINT CHR$(201); STRING$(win(wid).sizeX, 205); CHR$(187)
  END SELECT

  '
  ' Draw each row of the window
  '
  FOR r = 1 TO win(wid).sizeY
   
    LOCATE win(wid).posY + r, win(wid).posX
   
    SELECT CASE WinStyle.Border
      CASE 1
        PRINT CHR$(179); text(wid, r); CHR$(179);
      CASE 2
        PRINT CHR$(186); text(wid, r); CHR$(186);
    END SELECT

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
  SELECT CASE WinStyle.Border
    CASE 1
      PRINT CHR$(192); STRING$(win(wid).sizeX, 196); CHR$(217);
    CASE 2
      PRINT CHR$(200); STRING$(win(wid).sizeX, 205); CHR$(188);
  END SELECT
 
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
    DrawWindowField wid, i
  NEXT

END SUB

' ===================================================================
' DrawWindowField
' ===================================================================
SUB DrawWindowField (wid AS INTEGER, fid AS INTEGER)

  DIM backcolor AS INTEGER
  DIM forecolor AS INTEGER

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
   
    CASE FieldKind.Button, FieldKind.Boolean
      '
      ' Button and Boolean (text)
      '
      LOCATE fld(wid, fid).posY, fld(wid, fid).posX
      PRINT fieldtext(wid, fid);
   
    CASE FieldKind.Integer
      '
      ' Integer Input
      '
      DIM format AS STRING
      format = " " + STRING$(LEN(fieldtext(wid, fid)), "#") + " "
      LOCATE fld(wid, fid).posY, fld(wid, fid).posX - 1
      PRINT USING format; VAL(fieldtext(wid, fid));
 
  END SELECT

END SUB

' ===================================================================
' DrawWindowOutline
' ===================================================================
SUB DrawWindowOutline (wid AS INTEGER, atX AS INTEGER, atY AS INTEGER)

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

SUB FindDistance

  DIM ast1 AS INTEGER
  DIM ast2 AS INTEGER

  DO
   
    ' Get the two asteroids for which to calculate distance
    DoWindow 22
    IF win(22).canceled THEN
      EXIT DO
    END IF
   
    ast1 = VAL(fieldtext(22, 1))
    ast2 = VAL(fieldtext(22, 2))
   
    ' Ensure the first asteroid exists
    IF ast1 < 1 OR ast1 > asteroids THEN
      DoWindow 23
   
    ' Ensure the second asteroid exists
    ELSEIF ast2 < 1 OR ast2 > asteroids THEN
      DoWindow 24
   
    ' Ensure the same asteroid is not specified
    ELSEIF ast1 = ast2 THEN
      DoWindow 25
  
    ELSE
      DoWindow 26
      LOCATE win(26).posY + 1, win(26).posX + 28
      COLOR 0, 7: IF CalcDistance(ast1, ast2) > 9 THEN PRINT " ";
      PRINT USING "##."; CalcDistance(ast1, ast2);
      COLOR 7, 0: WaitForKeyPress: PCOPY display, 0
      EXIT DO
    END IF
   
    PCOPY display, 0
  LOOP
 
END SUB

' ===================================================================
' GetKey$
' -------------------------------------------------------------------
' Waits for a key to be pressed and returns the string representing
' the character or the keystroke. This function is the same as INKEY$
' except it does not return until a key is actually pressed.
' ===================================================================
FUNCTION GetKey$

  DIM k AS STRING

  DO
    k = INKEY$
  LOOP UNTIL LEN(k)

  GetKey$ = k

END FUNCTION

SUB InitData

  DIM x AS INTEGER

  FOR x = 1 TO asteroids
    asteroid(x).Control = INT(RND * 10)
    asteroid(x).Detect = INT(RND * 10)
    asteroid(x).mined = INT(RND * 50) + 50
    IF x <= players THEN asteroid(x).ruler = x ELSE asteroid(x).ruler = 0
    asteroid(x).Produce = 50
    asteroid(x).tech = 10
    asteroid(x).Shield = 0
    asteroid(x).ships = 200
    asteroid(x).Supply = 0
  NEXT

END SUB

' ===================================================================
' LoadMenu
' -------------------------------------------------------------------
' Loads the menu bar. This subroutine should only be called once.
' ===================================================================
SUB LoadMenu

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

' ===================================================================
' LoadWindows
' -------------------------------------------------------------------
' Loads Window definitions. This should only be called once.
' ===================================================================
SUB LoadWindows

  DIM block   AS STRING
  DIM char    AS STRING
  DIM ending  AS INTEGER
  DIM fid     AS INTEGER
  DIM start   AS INTEGER
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
     
      CASE "Help"
        '
        ' Set Help Window
        '
        READ win(wid).helpWid

      CASE "-"
        '
        ' Append separator
        '
        win(wid).sizeY = win(wid).sizeY + 1
        text(wid, win(wid).sizeY) = STRING$(win(wid).sizeX, 196)

      CASE "End of windows"
        '
        ' End of window data
        '
        EXIT SUB
     
      CASE ELSE
        '
        ' Add a line of content to the window definition
        '
        win(wid).sizeY = win(wid).sizeY + 1
        text(wid, win(wid).sizeY) = block
       
        IF win(wid).sizeX = 0 THEN win(wid).sizeX = LEN(block)
       
        IF INSTR(text(wid, win(wid).sizeY), "@") THEN
          '
          ' Parse a button field
          '
          char = "@"
          GOSUB ProcessData
          fld(wid, win(wid).fields).kind = FieldKind.Button
          fieldtext(wid, win(wid).fields) = MID$(text(wid, win(wid).sizeY), start, ending)
       
        ELSEIF INSTR(text(wid, win(wid).sizeY), "#") THEN
          '
          ' Parse a numeric input field
          '
          char = "#"
          GOSUB ProcessData
          fld(wid, win(wid).fields).kind = FieldKind.Integer
          fieldtext(wid, win(wid).fields) = STRING$(ending, 32)
       
        ELSEIF INSTR(text(wid, win(wid).sizeY), "&") THEN
          '
          ' Parse a boolean input field
          '
          char = "&"
          GOSUB ProcessData
          fld(wid, win(wid).fields).kind = FieldKind.Boolean
          fieldtext(wid, win(wid).fields) = " Yes "
        END IF
    END SELECT
  LOOP

REM **** Subroutines ****

ProcessData:
 
  ' Get the index of the start of the field and replace with a space
  start = INSTR(text(wid, win(wid).sizeY), char)
  MID$(text(wid, win(wid).sizeY), start, 1) = " "
 
  ' Get the index of the end of the field and replace with a space
  ending = INSTR(text(wid, win(wid).sizeY), char)
  MID$(text(wid, win(wid).sizeY), ending, 1) = " "
  ending = ending - start + 1
 
  ' Add field data
  win(wid).fields = win(wid).fields + 1
  fld(wid, win(wid).fields).posY = win(wid).posY + win(wid).sizeY
  fld(wid, win(wid).fields).posX = win(wid).posX + start
  RETURN

END SUB

SUB MakeAtlas

  DIM band     AS INTEGER
  DIM cluster1 AS INTEGER
  DIM cluster2 AS INTEGER
  DIM keypress AS STRING
  DIM LAST     AS INTEGER
  DIM r1       AS INTEGER
  DIM r2       AS INTEGER
  DIM selected AS INTEGER
  DIM temp1    AS INTEGER
  DIM temp2    AS INTEGER
  DIM x        AS INTEGER

  DrawGrid
  PCOPY 0, 2: display = 2: selected = 3: LAST = 3

  DO
    SELECT CASE selected
     
      CASE 1
        '
        ' Hide the window in order to see the grid
        '
        DrawStatus "Press any key to restore the window..."
        WaitForKeyPress
        DrawStatus ""
     
      CASE 2
        '
        ' Finished
        '
        EXIT SUB
     
      CASE ELSE
        IF selected = 3 OR selected = 4 THEN
          cluster1 = INT(RND * 5) + 1
          cluster2 = INT(RND * 20) + 1
          band = INT(RND * 9) + 2
        END IF
        FOR x = 1 TO asteroids
          SCREEN , , 2, 2
          SELECT CASE selected
            CASE 3
              GOSUB GetCluster
            CASE 4
              GOSUB GetOrbital
            CASE 5
              GOSUB GetManual
            CASE 6
              GOSUB GetRandom
            CASE 7
              IF x <= players THEN
                SELECT CASE LAST
                  CASE 3
                    GOSUB GetCluster
                  CASE 4
                    GOSUB GetOrbital
                  CASE 6
                    GOSUB GetRandom
                END SELECT
              ELSE
                r1 = asteroid(x).local1: r2 = asteroid(x).local2
              END IF
          END SELECT
          LOCATE r1 * 2 + 1, r2 * 3 - 1
          IF x <= players THEN COLOR 0, 7
          PRINT USING "##"; x; : COLOR 7, 0
          asteroid(x).local1 = r1: asteroid(x).local2 = r2
          IF keypress = CHR$(ASCII.Escape) THEN EXIT FOR
        NEXT
        PCOPY 2, 0: SCREEN , , 0, 0
    END SELECT

    '
    ' Show the atlas editor menu
    '
    win(9).selected = selected
    DoWindow 9
    selected = win(9).selected

    SELECT CASE selected
      CASE 3, 4, 6
        SCREEN , , 2, 2
        FOR x = 1 TO asteroids
          LOCATE asteroid(x).local1 * 2 + 1, asteroid(x).local2 * 3 - 1
          PRINT "  ";
        NEXT
        LAST = selected
      CASE 7
        SCREEN , , 2, 2
        FOR x = 1 TO players
          LOCATE asteroid(x).local1 * 2 + 1, asteroid(x).local2 * 3 - 1
          PRINT "  ";
        NEXT x
    END SELECT
  LOOP
 
REM *** Subroutines ***

GetCluster:
  DO
    r1 = INT(RND * 7) + cluster1
    r2 = INT(RND * 7) + cluster2
  LOOP UNTIL SCREEN(r1 * 2 + 1, r2 * 3) = 32
  RETURN

GetOrbital:
  DO
    r1 = band + INT(RND * 3) - 1
    r2 = INT(RND * 26) + 1
  LOOP UNTIL SCREEN(r1 * 2 + 1, r2 * 3) = 32
  RETURN

GetManual:
 
  r1 = asteroid(x).local1
  r2 = asteroid(x).local2
 
  DO
    LOCATE r1 * 2 + 1, r2 * 3 - 1
    IF x <= players THEN COLOR 21, 7 ELSE COLOR 21, 0
    PRINT USING "##"; x; : COLOR 7, 0
   
    keypress = GetKey$
   
    LOCATE r1 * 2 + 1, r2 * 3 - 1: PRINT "  ";
    SELECT CASE keypress
     
      CASE CHR$(ASCII.Return), CHR$(ASCII.Escape)
        EXIT DO
     
      CASE "E", CHR$(Control.E), CHR$(0) + CHR$(ScanCode.Up)
        temp1 = r1 - 1: temp2 = r2
        IF temp1 < 1 THEN temp1 = 1
     
      CASE "D", CHR$(Control.D), CHR$(0) + CHR$(ScanCode.Right)
        temp1 = r1: temp2 = r2 + 1
        IF temp2 > 26 THEN temp2 = 26
     
      CASE "S", CHR$(Control.S), CHR$(0) + CHR$(ScanCode.Left)
        temp1 = r1: temp2 = r2 - 1
        IF temp2 < 1 THEN temp2 = 1
     
      CASE "X", CHR$(Control.X), CHR$(0) + CHR$(ScanCode.Down)
        temp1 = r1 + 1: temp2 = r2
        IF temp1 > 11 THEN temp1 = 11
    END SELECT
    IF SCREEN(temp1 * 2 + 1, temp2 * 3) = 32 THEN r1 = temp1: r2 = temp2
  LOOP
  RETURN

GetRandom:
  DO
    r1 = INT(RND * 11) + 1
    r2 = INT(RND * 26) + 1
  LOOP UNTIL SCREEN(r1 * 2 + 1, r2 * 3) = 32
  RETURN

END SUB

SUB MoveWindow (wid AS INTEGER)

  DIM diff1     AS INTEGER
  DIM diff2     AS INTEGER
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
    PCOPY display, 0
    DrawWindowOutline wid, toX, toY

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
        diff1 = toY - win(wid).posY
        diff2 = toX - win(wid).posX
       
        FOR x = 1 TO win(wid).fields
          fld(wid, x).posX = fld(wid, x).posX + diff2
          fld(wid, x).posY = fld(wid, x).posY + diff1
        NEXT
        win(wid).posX = toX
        win(wid).posY = toY
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

SUB NewGame

  DO
   
    DoWindow 2
    players = VAL(fieldtext(2, 1)): IF players = 0 THEN players = 3
    asteroids = VAL(fieldtext(2, 2)): IF asteroids = 0 THEN asteroids = 15
   
    IF players > 10 THEN
      '
      ' Too many players
      '
      DoWindow 3
   
    ELSEIF asteroids < players THEN
      '
      ' Not enough asteroids
      '
      DoWindow 4

    ELSEIF asteroids > 19 THEN
      '
      ' Too many asteroids
      '
      DoWindow 5

    ELSEIF players = 1 AND asteroids = 1 THEN
      '
      ' Can't have one player and one asteroid
      '
      DoWindow 6
   
    ELSE
      EXIT DO
    END IF
   
    PCOPY 1, 0
  LOOP

  MakeAtlas
  InitData

END SUB

SUB NextMonth

  DIM x AS INTEGER

  REM Move each mission closer to their targets.
    FOR x = 1 TO missions
      mission(x).distance = mission(x).distance - 1
      IF mission(x).distance = 0 THEN
        SELECT CASE mission(x).goal
          CASE 1
            BattleMode (x)
        END SELECT
      END IF
    NEXT

  REM Calculate ships produced for each asteroid
    FOR x = 1 TO asteroids
      asteroid(x).ships = asteroid(x).ships + asteroid(x).Produce
    NEXT

END SUB

SUB OrderAttack

  DIM num AS INTEGER
  DIM src AS INTEGER
  DIM trg AS INTEGER

  DO
   
    '
    ' Get the source, target, and fleet size
    '
    DoWindow 15
    IF win(15).canceled THEN
      EXIT DO
    END IF

    src = VAL(fieldtext(15, 1))
    trg = VAL(fieldtext(15, 2))
    num = VAL(fieldtext(15, 3))
   
    IF src < 1 OR src > asteroids THEN
      DoWindow 16
    ELSEIF asteroid(src).ruler <> turn THEN
      DoWindow 17
    ELSEIF trg < 1 OR trg > asteroids THEN
      DoWindow 18
    ELSEIF src = trg THEN
      DoWindow 19
    ELSEIF num < 1 OR num > asteroid(src).ships THEN
      DoWindow 20
    ELSE
     
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
     
      SCREEN , , 3, 0: DrawTableRow src
      IF display = 3 THEN SCREEN , , 0, 0: DrawTableRow src
     
      ' BUG: total months is not being shown correctly
      ' This was working in the original, but it may be easier
      ' to accept the bug for now until the field system is
      ' updated in the next set of refactoring.

      DoWindow 21
      COLOR 0, 7: LOCATE win(21).posY + 2, win(21).posX + 16
      IF mission(missions).distance > 9 THEN PRINT " ";
      PRINT USING "## month"; mission(missions).distance;
      IF mission(missions).distance > 1 THEN PRINT "s";
      PRINT "."; : COLOR 7, 0: WaitForKeyPress: PCOPY display, 0
      EXIT DO
    END IF
    PCOPY display, 0
  LOOP
     
  fieldtext(15, 1) = "  "
  fieldtext(15, 2) = "  "
  fieldtext(15, 3) = "    "

END SUB

SUB PlayGame

  DIM wid AS INTEGER
  DIM x   AS INTEGER

  SCREEN , , 0, 0: turn = 1
 
  DO
   
    empire.shown = turn
   
    DO
     
      '
      ' Wait for a command from the menu bar
      '
      wid = DoMenu
     
      SELECT CASE wid
       
        CASE 10
          ViewPage

        CASE 11
          SELECT CASE win(11).selected
            CASE 1, 2, 3, 4, 5
              EXIT DO
            CASE 6
              END
          END SELECT
       
        CASE 12
          SELECT CASE win(12).selected
            CASE 2
              OrderAttack
          END SELECT
       
        CASE 13
          SELECT CASE win(13).selected
            CASE 1
              SelectAlert
          END SELECT

        CASE 14
          SELECT CASE win(14).selected
            CASE 1
              DoWindow 30
              PCOPY 1, 0
            CASE 2
              FindDistance
          END SELECT
      END SELECT
   
    LOOP
   
    IF fieldtext(27, 1) = " Yes " THEN
      FOR x = 1 TO 5: SOUND 800, .8: SOUND 1200, .8: NEXT
    END IF

    '
    ' Next turn
    '
    turn = turn + 1
    IF turn > players THEN
      NextMonth
      turn = 1
    END IF

  LOOP

END SUB

SUB SelectAlert

  DIM original AS STRING
  DIM x        AS INTEGER
  DIM Y        AS INTEGER

  original = fieldtext(27, 1)

  DoWindow 27

  IF original = " Yes " AND fieldtext(27, 1) = " No  " THEN
    IF players > 1 THEN
      FOR x = 1 TO 3
        FOR Y = 300 TO 60 STEP -10
          SOUND Y, .2
        NEXT
      NEXT
      DoWindow 29
      IF fieldtext(29, 1) = " Yes " THEN
        fieldtext(27, 1) = " Yes "
      END IF
    END IF
  END IF

END SUB

SUB Setup

  DIM x AS INTEGER

  SCREEN 0, 0, 0, 0: WIDTH 80: COLOR 7, 0: KEY OFF: CLS : RANDOMIZE TIMER
 
  display = 1: arrowexit = False

  LoadMenu

  DrawMenu
  DrawStatus ""
  PCOPY 0, 1

  DrawStatus "Please wait..."
  LoadWindows
  DrawStatus ""
 
  '
  ' Starting window
  '
  DoWindow 1
  IF win(1).canceled THEN
    END
  ELSEIF win(1).selected = 1 THEN
    NewGame
  END IF


  ' HACK: Setup the table
  PCOPY 1, 3: SCREEN , , 3, 3: display = 3
  DrawTable
  PCOPY 3, 0: SCREEN , , 0, 0

END SUB

SUB ViewPage

  DIM current AS INTEGER
  DIM x AS INTEGER

  ' HACK: get current view
  current = win(10).selected

  IF current = 2 THEN
    PCOPY 3, 0: display = 3: EXIT SUB
  ELSEIF current = 3 THEN
    empire.shown = turn
  ELSEIF current = 4 THEN
    empire.shown = empire.shown + 1
    IF empire.shown > players THEN empire.shown = 1
  END IF

  SCREEN , , 2, 2: display = 2
  FOR x = 1 TO asteroids
    LOCATE asteroid(x).local1 * 2 + 1, asteroid(x).local2 * 3 - 1
    SELECT CASE current
      CASE 1
        IF asteroid(x).ruler > 0 THEN COLOR 0, 7
      CASE 3
        IF asteroid(x).ruler = turn THEN COLOR 0, 7
      CASE 4
        IF asteroid(x).ruler = empire.shown THEN COLOR 0, 7
    END SELECT
    PRINT USING "##"; x; : COLOR 7, 0
  NEXT
  PCOPY 2, 0: SCREEN , , 0, 0

END SUB

' ===================================================================
' WaitForKeyPress
' -------------------------------------------------------------------
' Waits for any key to be pressed. The key is discarded from input.
' ===================================================================
SUB WaitForKeyPress

  DIM k AS STRING

  DO
    k = INKEY$
  LOOP UNTIL LEN(k)

END SUB

