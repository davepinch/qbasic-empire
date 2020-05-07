
' The Galactic Empire
' Version 1.0
'
' (C) 1992 David J. Pinch
' All rights reserved.
'
' To begin, press Shift + F5.
' To exit QBASIC, press Alt, F, X.

  DECLARE SUB BattleMode (id AS INTEGER)
  DECLARE SUB DataPage ()
  DECLARE SUB DataLine (x AS INTEGER)
  DECLARE SUB DoWindow (id AS INTEGER)
  DECLARE SUB DrawGrid ()
  DECLARE SUB FindDistance ()
  DECLARE SUB GetWindows ()
  DECLARE SUB InitData ()
  DECLARE SUB MakeAtlas ()
  DECLARE SUB NextMonth ()
  DECLARE SUB MoveWindow (id AS INTEGER)
  DECLARE SUB NewGame ()
  DECLARE SUB OrderAttack ()
  DECLARE SUB Page ()
  DECLARE SUB PlayGame ()
  DECLARE SUB Scan ()
  DECLARE SUB SelectAlert ()
  DECLARE SUB Setup ()
  DECLARE SUB ViewPage ()

  DECLARE FUNCTION CalcDistance (first AS INTEGER, second AS INTEGER)
  DECLARE FUNCTION Menu ()

  CONST true = -1
  CONST false = NOT true

  TYPE ASTEROIDTYPE
    control AS INTEGER
    detect  AS INTEGER
    local1  AS INTEGER
    local2  AS INTEGER
    mined   AS INTEGER
    produce AS INTEGER
    ruler   AS INTEGER
    ships   AS INTEGER
    shield  AS INTEGER
    supply  AS INTEGER
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

  REM Window-definition variables.
    DIM SHARED fieldplace1(1 TO 50, 1 TO 20) AS INTEGER
    DIM SHARED fieldplace2(1 TO 50, 1 TO 20) AS INTEGER
    DIM SHARED fields(1 TO 50)               AS INTEGER
    DIM SHARED fieldtext(1 TO 50, 1 TO 20)   AS STRING
    DIM SHARED fieldtype(1 TO 50, 1 TO 20)   AS INTEGER
    DIM SHARED height(1 TO 50)               AS INTEGER
    DIM SHARED length(1 TO 50)               AS INTEGER
    DIM SHARED place1(1 TO 50)               AS INTEGER
    DIM SHARED place2(1 TO 50)               AS INTEGER
    DIM SHARED text(1 TO 50, 1 TO 20)        AS STRING

  REM Global variables.
    DIM SHARED arrowexit         AS INTEGER
    DIM SHARED asteroid(1 TO 19) AS ASTEROIDTYPE
    DIM SHARED asteroids         AS INTEGER
    DIM SHARED bar               AS STRING
    DIM SHARED border            AS INTEGER
    DIM SHARED current           AS INTEGER
    DIM SHARED display           AS INTEGER
    DIM SHARED empire.shown      AS INTEGER
    DIM SHARED menutext(1 TO 5)  AS STRING
    DIM SHARED mission(1 TO 100) AS MISSIONTYPE
    DIM SHARED missions          AS INTEGER
    DIM SHARED outline           AS INTEGER
    DIM SHARED players           AS INTEGER
    DIM SHARED pressed           AS STRING
    DIM SHARED setcurrent        AS INTEGER
    DIM SHARED shadow            AS INTEGER
    DIM SHARED turn              AS INTEGER
   
  Setup
  PlayGame

  REM Menu bar
    DATA " Atlas "," Game "," Mission "," Options "," Special "

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
    DATA "Separate"
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
    DATA " Error: The number of asteroids cannot "
    DATA " be less than the number of players.   "
    DATA "Separate"
    DATA " Press ? for more information.         "

  REM Window 5
    DATA "Start"
    DATA 11,20
    DATA " Error: The maximum number of asteroids "
    DATA " allowed is nineteen.                   "

  REM Window 6
    DATA "Start"
    DATA 10,19
    DATA " Error: It is impossible to play the game "
    DATA " with only one player and one asteroid.   "
    DATA "Separate"
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
    DATA "Separate"
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
    DATA "Separate"
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
    DATA "Separate"
    DATA "                & &                  "

  REM Window 30
    DATA "Start"
    DATA 10,25
    DATA "   The Galactic Empire   "
    DATA "Separate"
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
 
  COLOR 0, 7: LOCATE place1(28) + 4, place2(28) + 24
  PRINT CHR$(mission(id).ruler + 64); "."
  LOCATE place1(28) + 5, place2(28) + 10: PRINT mission(id).ships
  LOCATE place1(28) + 6, place2(28) + 15: PRINT mission(id).techlevel
  LOCATE place1(28) + 8, place2(28) + 18
  IF asteroid(trg).ruler = 0 THEN
    PRINT "independent."
  ELSE
    PRINT "ruler "; CHR$(asteroid(trg).ruler + 64); "."
  END IF
  LOCATE place1(28) + 9, place2(28) + 11
  PRINT asteroid(trg).shield
  LOCATE place1(28) + 10, place2(28) + 10
  PRINT asteroid(trg).ships
  LOCATE place1(28) + 11, place2(28) + 15
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
    LOCATE place1(31) + 2, place2(31) + 15
    COLOR 0, 7: PRINT round: COLOR 7, 0
    attacked = 0: defended = 0
    start1 = mission(id).ships: start2 = asteroid(trg).ships
    DO
      IF turn = 0 AND attacked <= start1 THEN 'Attacker fires
        shot = INT(RND * 3 - 1 + 2 ^ (mission(id).techlevel / 10))
        shot = shot - shot * (asteroid(trg).shield) / 100
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

      
      
   
   
   
  

   
   
 
  END

END SUB

FUNCTION CalcDistance (first AS INTEGER, second AS INTEGER)

  DIM dist AS INTEGER

  dist = (asteroid(first).local1 - asteroid(second).local1) ^ 2
  dist = dist + (asteroid(first).local2 - asteroid(second).local2) ^ 2
  dist = INT(SQR(dist))

  CalcDistance = dist

END FUNCTION

SUB DataLine (x AS INTEGER)

  LOCATE x + 4, 3: PRINT USING "##"; x;
  IF asteroid(x).ruler > 0 THEN
    LOCATE , 9: PRINT CHR$(64 + x);
    LOCATE , 15: PRINT USING "##"; asteroid(x).tech;
    LOCATE , 21: PRINT USING "###"; asteroid(x).mined;
    LOCATE , 28: PRINT USING "####"; asteroid(x).supply;
    LOCATE , 37: PRINT USING "##"; asteroid(x).detect;
    LOCATE , 45: PRINT USING "###"; asteroid(x).control;
    LOCATE , 54: PRINT USING "###"; asteroid(x).shield;
    LOCATE , 62: PRINT USING "###"; asteroid(x).produce;
    LOCATE , 72: PRINT USING "####"; asteroid(x).ships;
  ELSE
    LOCATE , 6: PRINT "[data not available]";
  END IF

END SUB

SUB DataPage

  DIM x AS INTEGER

  PCOPY 1, 3: SCREEN , , 3, 3: display = 3

  LOCATE 3, 2: PRINT " Id  Ruler  Tech  Mined  ";
  PRINT "Supply  Detect  Control  Shield  Produce  Available";

  LOCATE 4, 1
  IF border = 1 THEN
    PRINT CHR$(204); STRING$(77, 205); CHR$(185)
  ELSE
    PRINT CHR$(195); STRING$(77, 196); CHR$(180)
  END IF

  FOR x = 1 TO asteroids
    DataLine x
  NEXT

  PCOPY 3, 0: SCREEN , , 0, 0

END SUB

SUB DoWindow (id AS INTEGER)

  DIM format AS STRING
  DIM x      AS INTEGER
 
  DO
    REM Draw the window
      SCREEN , , 0, display: COLOR 0, 7
      LOCATE place1(id), place2(id)
      IF border = 1 THEN
        PRINT CHR$(201); STRING$(length(id), 205); CHR$(187)
      ELSE
        PRINT CHR$(218); STRING$(length(id), 196); CHR$(191)
      END IF
      FOR x = 1 TO height(id)
        LOCATE place1(id) + x, place2(id)
        IF border = 1 THEN
          PRINT CHR$(186); text(id, x); CHR$(186);
        ELSE
          PRINT CHR$(179); text(id, x); CHR$(179);
        END IF
        IF shadow THEN PRINT CHR$(177)
      NEXT
      LOCATE place1(id) + height(id) + 1, place2(id)
      IF border = 1 THEN
        PRINT CHR$(200); STRING$(length(id), 205); CHR$(188);
      ELSE
        PRINT CHR$(192); STRING$(length(id), 196); CHR$(217);
      END IF
      IF shadow THEN
        PRINT CHR$(177);
        LOCATE place1(id) + height(id) + 2, place2(id) + 1
        PRINT STRING$(length(id) + 2, 177);
      END IF
      FOR current = 1 TO fields(id)
        IF fieldtype(id, current) = 2 THEN GOSUB DrawField
      NEXT
      SCREEN , , 0, 0: COLOR 7, 0
   
    IF setcurrent = 0 THEN current = 1 ELSE current = setcurrent
    setcurrent = 0
   
    DO
      IF fields(id) = 0 THEN EXIT SUB
      GOSUB DrawField
      Scan
      SELECT CASE pressed
        CASE CHR$(0) + CHR$(71)
          COLOR 0, 7: GOSUB DrawField: COLOR 7, 0
          current = 1
        CASE CHR$(0) + CHR$(72), CHR$(8)
          COLOR 0, 7: GOSUB DrawField: COLOR 7, 0
          current = current - 1: IF current = 0 THEN current = fields(id)
        CASE CHR$(0) + CHR$(75), CHR$(0) + CHR$(77)
          IF arrowexit THEN PCOPY display, 0: EXIT SUB
        CASE CHR$(0) + CHR$(79)
          COLOR 0, 7: GOSUB DrawField: COLOR 7, 0
          current = fields(id)
        CASE CHR$(0) + CHR$(80), CHR$(32)
          COLOR 0, 7: GOSUB DrawField: COLOR 7, 0
          current = current + 1: IF current > fields(id) THEN current = 1
        CASE CHR$(4), CHR$(5), CHR$(19), CHR$(24)
          MoveWindow id
          EXIT DO
        CASE CHR$(13), CHR$(27)
          PCOPY display, 0
          EXIT SUB
        CASE "N"
          IF fieldtype(id, current) = 3 THEN fieldtext(id, current) = " No  "
        CASE "Y"
          IF fieldtype(id, current) = 3 THEN fieldtext(id, current) = " Yes "
        CASE ELSE
          IF fieldtype(id, current) = 2 THEN
            IF ASC(pressed) >= 48 AND ASC(pressed) <= 57 THEN
              fieldtext(id, current) = fieldtext(id, current) + pressed
              fieldtext(id, current) = RIGHT$(fieldtext(id, current), LEN(fieldtext(id, current)) - 1)
            END IF
          END IF
      END SELECT
    LOOP
  LOOP

REM **** Subroutines ****

DrawField:
  SELECT CASE fieldtype(id, current)
    CASE 1, 3
      LOCATE fieldplace1(id, current), fieldplace2(id, current)
       PRINT fieldtext(id, current);
    CASE 2
      format = " " + STRING$(LEN(fieldtext(id, current)), "#") + " "
      LOCATE fieldplace1(id, current), fieldplace2(id, current) - 1
      PRINT USING format; VAL(fieldtext(id, current));
  END SELECT
  RETURN

END SUB

SUB DrawGrid

  DIM block AS STRING
  DIM grid  AS STRING
  DIM x     AS INTEGER

  REM Top of grid
    IF border = 1 THEN block = CHR$(204) ELSE block = CHR$(195)
    FOR x = 1 TO 25
      IF border = 1 THEN
        block = block + STRING$(2, 205) + CHR$(209)
      ELSE
        block = block + STRING$(2, 196) + CHR$(194)
      END IF
    NEXT
    IF border = 1 THEN
      block = block + STRING$(2, 205) + CHR$(185) + CHR$(13)
    ELSE
      block = block + STRING$(2, 196) + CHR$(180) + CHR$(13)
    END IF
    grid = block
  
  REM Middle of grid
    IF border = 1 THEN block = CHR$(186) ELSE block = CHR$(179)
    FOR x = 1 TO 25
      block = block + "  " + CHR$(179)
    NEXT
    IF border = 1 THEN
      block = block + "  " + CHR$(186) + CHR$(13) + CHR$(199)
    ELSE
      block = block + "  " + CHR$(179) + CHR$(13) + CHR$(195)
    END IF
    FOR x = 1 TO 25
      block = block + STRING$(2, 196) + CHR$(197)
    NEXT
    IF border = 1 THEN
      block = block + STRING$(2, 196) + CHR$(182) + CHR$(13)
    ELSE
      block = block + STRING$(2, 196) + CHR$(180) + CHR$(13)
    END IF
    FOR x = 1 TO 10
      grid = grid + block
    NEXT
 
  REM Bottom of grid
    IF border = 1 THEN block = CHR$(186) ELSE block = CHR$(179)
    FOR x = 1 TO 25
      block = block + "  " + CHR$(179)
    NEXT
    IF border = 1 THEN
      block = block + "  " + CHR$(186) + CHR$(13) + CHR$(204)
    ELSE
      block = block + "  " + CHR$(179) + CHR$(13) + CHR$(195)
    END IF
    FOR x = 1 TO 25
      IF border = 1 THEN
        block = block + STRING$(2, 205) + CHR$(207)
      ELSE
        block = block + STRING$(2, 196) + CHR$(193)
      END IF
    NEXT
    IF border = 1 THEN
      block = block + STRING$(2, 205) + CHR$(185)
    ELSE
      block = block + STRING$(2, 196) + CHR$(180)
    END IF
    grid = grid + block

  LOCATE 2, 1: PRINT grid;

END SUB

SUB FindDistance

  DIM ast1 AS INTEGER
  DIM ast2 AS INTEGER

  DO
    DoWindow 22
    IF pressed = CHR$(27) THEN EXIT DO
    ast1 = VAL(fieldtext(22, 1)): ast2 = VAL(fieldtext(22, 2))
    IF ast1 < 1 OR ast1 > asteroids THEN
      DoWindow 23
      Scan
    ELSEIF ast2 < 1 OR ast2 > asteroids THEN
      DoWindow 24
      Scan
    ELSEIF ast1 = ast2 THEN
      DoWindow 25
      Scan
    ELSE
      DoWindow 26
      LOCATE place1(26) + 1, place2(26) + 28
      COLOR 0, 7: IF CalcDistance(ast1, ast2) > 9 THEN PRINT " ";
      PRINT USING "##."; CalcDistance(ast1, ast2);
      COLOR 7, 0: Scan: PCOPY display, 0
      EXIT DO
    END IF
    PCOPY display, 0
  LOOP
 
END SUB

SUB GetWindows

  DIM block   AS STRING
  DIM char    AS STRING
  DIM ending  AS INTEGER
  DIM start   AS INTEGER
  DIM x       AS INTEGER

  DO
    READ block
    SELECT CASE block
      CASE "End of windows"
        EXIT SUB
      CASE "Separate"
        height(x) = height(x) + 1
        text(x, height(x)) = STRING$(length(x), 196)
      CASE "Start"
        x = x + 1
        READ place1(x), place2(x)
      CASE ELSE
        height(x) = height(x) + 1
        text(x, height(x)) = block
        IF length(x) = 0 THEN length(x) = LEN(block)
        IF INSTR(text(x, height(x)), "@") THEN
          char = "@"
          GOSUB ProcessData
          fieldtype(x, fields(x)) = 1
          fieldtext(x, fields(x)) = MID$(text(x, height(x)), start, ending)
        ELSEIF INSTR(text(x, height(x)), "#") THEN
          char = "#"
          GOSUB ProcessData
          fieldtype(x, fields(x)) = 2
          fieldtext(x, fields(x)) = STRING$(ending, 32)
        ELSEIF INSTR(text(x, height(x)), "&") THEN
          char = "&"
          GOSUB ProcessData
          fieldtype(x, fields(x)) = 3
          fieldtext(x, fields(x)) = " Yes "
        END IF
    END SELECT
  LOOP

REM **** Subroutines ****

ProcessData:
  start = INSTR(text(x, height(x)), char)
  MID$(text(x, height(x)), start, 1) = " "
  ending = INSTR(text(x, height(x)), char)
  MID$(text(x, height(x)), ending, 1) = " "
  ending = ending - start + 1
  fields(x) = fields(x) + 1
  fieldplace1(x, fields(x)) = place1(x) + height(x)
  fieldplace2(x, fields(x)) = place2(x) + start
  RETURN

END SUB

SUB InitData

  DIM x AS INTEGER

  FOR x = 1 TO asteroids
    asteroid(x).control = INT(RND * 10)
    asteroid(x).detect = INT(RND * 10)
    asteroid(x).mined = INT(RND * 50) + 50
    IF x <= players THEN asteroid(x).ruler = x ELSE asteroid(x).ruler = 0
    asteroid(x).produce = 50
    asteroid(x).tech = 10
    asteroid(x).shield = 0
    asteroid(x).ships = 200
    asteroid(x).supply = 0
  NEXT

END SUB

SUB MakeAtlas

  DIM band     AS INTEGER
  DIM cluster1 AS INTEGER
  DIM cluster2 AS INTEGER
  DIM last     AS INTEGER
  DIM r1       AS INTEGER
  DIM r2       AS INTEGER
  DIM temp1    AS INTEGER
  DIM temp2    AS INTEGER
  DIM x        AS INTEGER

  DrawGrid
  PCOPY 0, 2: display = 2: current = 3: last = 3

  DO
    SELECT CASE current
      CASE 1
        LOCATE 25, 2: COLOR 0, 7
        PRINT " Press any key to restore the window..."; : Scan
        LOCATE 25, 2: PRINT STRING$(77, 32); : COLOR 7, 0
      CASE 2
        EXIT SUB
      CASE ELSE
        IF current = 3 OR current = 4 THEN
          cluster1 = INT(RND * 5) + 1
          cluster2 = INT(RND * 20) + 1
          band = INT(RND * 9) + 2
        END IF
        FOR x = 1 TO asteroids
          SCREEN , , 2, 2
          SELECT CASE current
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
                SELECT CASE last
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
          IF pressed = CHR$(27) THEN EXIT FOR
        NEXT
        PCOPY 2, 0: SCREEN , , 0, 0
    END SELECT
    setcurrent = current: DoWindow 9
    SELECT CASE current
      CASE 3, 4, 6
        SCREEN , , 2, 2
        FOR x = 1 TO asteroids
          LOCATE asteroid(x).local1 * 2 + 1, asteroid(x).local2 * 3 - 1
          PRINT "  ";
        NEXT
        last = current
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
  r1 = asteroid(x).local1: r2 = asteroid(x).local2
  DO
    LOCATE r1 * 2 + 1, r2 * 3 - 1
    IF x <= players THEN COLOR 21, 7 ELSE COLOR 21, 0
    PRINT USING "##"; x; : COLOR 7, 0: Scan
    LOCATE r1 * 2 + 1, r2 * 3 - 1: PRINT "  ";
    SELECT CASE pressed
      CASE CHR$(13), CHR$(27)
        EXIT DO
      CASE "E", CHR$(5), CHR$(0) + CHR$(72)
        temp1 = r1 - 1: temp2 = r2
        IF temp1 < 1 THEN temp1 = 1
      CASE "D", CHR$(4), CHR$(0) + CHR$(77)
        temp1 = r1: temp2 = r2 + 1
        IF temp2 > 26 THEN temp2 = 26
      CASE "S", CHR$(19), CHR$(0) + CHR$(75)
        temp1 = r1: temp2 = r2 - 1
        IF temp2 < 1 THEN temp2 = 1
      CASE "X", CHR$(19), CHR$(0) + CHR$(80)
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

FUNCTION Menu

  DIM mode     AS INTEGER
  DIM position AS INTEGER

  PCOPY display, 0: position = 1
   
  DO
    GOSUB DrawMenuText
    IF mode = 1 THEN
      arrowexit = 1: DoWindow position + 9: arrowexit = 0
    ELSE
      Scan
    END IF
    SELECT CASE pressed
      CASE CHR$(0) + CHR$(75), CHR$(8), CHR$(19), "S"
        COLOR 0, 7: GOSUB DrawMenuText: COLOR 7, 0
        position = position - 1: IF position = 0 THEN position = 5
      CASE CHR$(0) + CHR$(77), CHR$(4), CHR$(32), "D"
        COLOR 0, 7: GOSUB DrawMenuText: COLOR 7, 0
        position = position + 1: IF position = 6 THEN position = 1
      CASE CHR$(0) + CHR$(80), CHR$(24), "X"
        IF mode = 0 THEN mode = 1
      CASE CHR$(13)
        IF mode = 1 THEN Menu = position: EXIT FUNCTION
      CASE CHR$(27)
        mode = 0
    END SELECT
  LOOP

REM *** Subroutines ***

DrawMenuText:
  LOCATE 1, INSTR(bar, menutext(position)) + 1
  PRINT menutext(position)
  RETURN

END FUNCTION

SUB MoveWindow (id AS INTEGER)

  DIM diff1     AS INTEGER
  DIM diff2     AS INTEGER
  DIM newplace1 AS INTEGER
  DIM newplace2 AS INTEGER
  DIM x         AS INTEGER

  newplace1 = place1(id): newplace2 = place2(id)

  DO
    PCOPY display, 0: GOSUB DrawOutline
    Scan
    SELECT CASE pressed
      CASE CHR$(4), "D", CHR$(0) + CHR$(77)
        newplace2 = newplace2 + 1
      CASE CHR$(5), "E", CHR$(0) + CHR$(72)
        newplace1 = newplace1 - 1
      CASE CHR$(13)
        diff1 = newplace1 - place1(id): diff2 = newplace2 - place2(id)
        FOR x = 1 TO fields(id)
          fieldplace1(id, x) = fieldplace1(id, x) + diff1
          fieldplace2(id, x) = fieldplace2(id, x) + diff2
        NEXT
        place1(id) = newplace1: place2(id) = newplace2
        EXIT SUB
      CASE CHR$(15), "O"
        IF outline = 0 THEN outline = 1 ELSE outline = 0
      CASE CHR$(19), "S", CHR$(0) + CHR$(75)
        newplace2 = newplace2 - 1
      CASE CHR$(24), "X", CHR$(0) + CHR$(80)
        newplace1 = newplace1 + 1
      CASE CHR$(27)
        newplace1 = place1(id): newplace2 = place2(id)
    END SELECT
    GOSUB CheckPlace
  LOOP

REM *** Subroutines ***

DrawOutline:
  LOCATE newplace1, newplace2
   IF outline = 1 THEN
     PRINT CHR$(201); CHR$(205);
   ELSE
     PRINT CHR$(218); CHR$(196);
   END IF
  LOCATE newplace1 + 1, newplace2
   IF outline = 1 THEN PRINT CHR$(186);  ELSE PRINT CHR$(179);
  LOCATE newplace1 + height(id), newplace2
   IF outline = 1 THEN PRINT CHR$(186);  ELSE PRINT CHR$(179);
  LOCATE newplace1 + height(id) + 1, newplace2
   IF outline = 1 THEN
     PRINT CHR$(200); CHR$(205);
   ELSE
     PRINT CHR$(192); CHR$(196);
   END IF
  LOCATE newplace1, newplace2 + length(id)
   IF outline = 1 THEN
     PRINT CHR$(205); CHR$(187);
   ELSE
     PRINT CHR$(196); CHR$(191);
   END IF
  LOCATE newplace1 + 1, newplace2 + length(id) + 1
   IF outline = 1 THEN PRINT CHR$(186);  ELSE PRINT CHR$(179);
  LOCATE newplace1 + height(id), newplace2 + length(id) + 1
   IF outline = 1 THEN PRINT CHR$(186);  ELSE PRINT CHR$(179);
  LOCATE newplace1 + height(id) + 1, newplace2 + length(id)
   IF outline = 1 THEN
     PRINT CHR$(205); CHR$(188);
   ELSE
     PRINT CHR$(196); CHR$(217);
   END IF
  RETURN

CheckPlace:
  IF newplace1 < 2 THEN newplace1 = 2
  IF newplace1 > 23 - height(id) THEN newplace1 = 23 - height(id)
  IF newplace2 < 1 THEN newplace2 = 1
  IF newplace2 > 78 - length(id) THEN newplace2 = 78 - length(id)
  RETURN

END SUB

SUB NewGame

  DO
    DoWindow 2
    players = VAL(fieldtext(2, 1)): IF players = 0 THEN players = 3
    asteroids = VAL(fieldtext(2, 2)): IF asteroids = 0 THEN asteroids = 15
    IF players > 10 THEN
      DoWindow 3
      Scan
    ELSEIF asteroids < players THEN
      DoWindow 4
      Scan
      IF pressed = "/" OR pressed = "?" THEN PCOPY 1, 0: DoWindow 8: Scan
    ELSEIF asteroids > 19 THEN
      DoWindow 5
      Scan
    ELSEIF players = 1 AND asteroids = 1 THEN
      DoWindow 6
      Scan
      IF pressed = "/" OR pressed = "?" THEN PCOPY 1, 0: DoWindow 7: Scan
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
      asteroid(x).ships = asteroid(x).ships + asteroid(x).produce
    NEXT

END SUB

SUB OrderAttack

  DIM num AS INTEGER
  DIM src AS INTEGER
  DIM trg AS INTEGER

  DO
    DoWindow 15
    IF pressed = CHR$(27) THEN EXIT DO
    src = VAL(fieldtext(15, 1))
    trg = VAL(fieldtext(15, 2))
    num = VAL(fieldtext(15, 3))
    IF src < 1 OR src > asteroids THEN
      DoWindow 16
      Scan
    ELSEIF asteroid(src).ruler <> turn THEN
      DoWindow 17
      Scan
    ELSEIF trg < 1 OR trg > asteroids THEN
      DoWindow 18
      Scan
    ELSEIF src = trg THEN
      DoWindow 19
      Scan
    ELSEIF num < 1 OR num > asteroid(src).ships THEN
      DoWindow 20
      Scan
    ELSE
      missions = missions + 1
      mission(missions).distance = CalcDistance(src, trg)
      mission(missions).goal = 1
      mission(missions).ruler = turn
      mission(missions).ships = num
      mission(missions).source = src
      mission(missions).target = trg
      mission(missions).techlevel = asteroid(src).tech
      asteroid(src).ships = asteroid(src).ships - num
      SCREEN , , 3, 0: DataLine src
      IF display = 3 THEN SCREEN , , 0, 0: DataLine src
      DoWindow 21
      COLOR 0, 7: LOCATE place1(21) + 2, place2(21) + 16
      IF mission(missions).distance > 9 THEN PRINT " ";
      PRINT USING "## month"; mission(missions).distance;
      IF mission(missions).distance > 1 THEN PRINT "s";
      PRINT "."; : COLOR 7, 0: Scan: PCOPY display, 0
      EXIT DO
    END IF
    PCOPY display, 0
  LOOP
     
  fieldtext(15, 1) = "  "
  fieldtext(15, 2) = "  "
  fieldtext(15, 3) = "    "

END SUB

SUB Page

  DIM flat AS STRING
  DIM side AS STRING
  DIM x    AS INTEGER

  IF border = 1 THEN
    side = CHR$(186)
    flat = CHR$(204) + STRING$(77, 205) + CHR$(185)
  ELSE
    side = CHR$(179)
    flat = CHR$(195) + STRING$(77, 196) + CHR$(180)
  END IF

  LOCATE 1, 1: PRINT side; : COLOR 0, 7: PRINT bar; : COLOR 7, 0: PRINT side
  LOCATE 2, 1: PRINT flat
  FOR x = 3 TO 23
    LOCATE x, 1: PRINT side: LOCATE x, 79: PRINT side
  NEXT
  LOCATE 24, 1: PRINT flat;
  LOCATE 25, 1: PRINT side; : COLOR 0, 7: PRINT STRING$(77, 32);
  COLOR 7, 0: PRINT side;

END SUB

SUB PlayGame

  DIM position AS INTEGER
  DIM x        AS INTEGER
  
  SCREEN , , 0, 0: turn = 1
 
  DO
    empire.shown = turn
    DO
      position = Menu
      SELECT CASE position
        CASE 1
          ViewPage
        CASE 2
          SELECT CASE current
            CASE 1, 2, 3, 4, 5
              EXIT DO
            CASE 6
              END
          END SELECT
        CASE 3
          SELECT CASE current
            CASE 2
              OrderAttack
          END SELECT
        CASE 4
          SELECT CASE current
            CASE 1
              SelectAlert
          END SELECT
        CASE 5
          SELECT CASE current
            CASE 1
              DoWindow 30
              Scan
              PCOPY 1, 0
            CASE 2
              FindDistance
          END SELECT
      END SELECT
    LOOP
    IF fieldtext(27, 1) = " Yes " THEN
      FOR x = 1 TO 5: SOUND 800, .8: SOUND 1200, .8: NEXT
    END IF
    turn = turn + 1: IF turn > players THEN NextMonth: turn = 1
  LOOP

END SUB

SUB Scan

  DO: pressed = INKEY$: LOOP UNTIL LEN(pressed)

  pressed = UCASE$(pressed)

END SUB

SUB SelectAlert

  DIM original AS STRING
  DIM x        AS INTEGER
  DIM y        AS INTEGER

  original = fieldtext(27, 1)

  DoWindow 27

  IF original = " Yes " AND fieldtext(27, 1) = " No  " THEN
    IF players > 1 THEN
      FOR x = 1 TO 3
        FOR y = 300 TO 60 STEP -10
          SOUND y, .2
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
 
  border = 0: display = 1: outline = 1: arrowexit = false: shadow = true

  REM Define Bar
    FOR x = 1 TO 5: READ menutext(x): bar = bar + menutext(x): NEXT
    bar = " " + bar + STRING$(76 - LEN(bar), 32)
 
  Page
  PCOPY 0, 1: LOCATE 25, 3: COLOR 0, 7: PRINT "Please wait..."; : GetWindows
  LOCATE 25, 2: PRINT STRING$(77, 32); : COLOR 7, 0: DoWindow 1

  IF current = 1 THEN NewGame

  DataPage

END SUB

SUB ViewPage

  DIM x AS INTEGER

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

