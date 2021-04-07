
CONST SpriteKind.None = 0
CONST SpriteKind.Avatar = 1
CONST SpriteKind.Beam = 2
CONST SpriteKind.Cycle = 3
CONST SpriteKind.File = 4
CONST SpriteKind.Icewave = 5
CONST SpriteKind.Icicle = 6
CONST SpriteKind.Stars = 7
CONST SpriteKind.Zipper = 8

TYPE SpriteType
  kind     AS INTEGER
  drawsize AS INTEGER
  param    AS INTEGER
  text     AS STRING * 30
  sx       AS INTEGER
  sy       AS INTEGER
END TYPE

DECLARE SUB DrawColor (attr%)
DECLARE SUB DrawStars (length%, rate!)
DECLARE SUB DrawText (text AS STRING)
DECLARE FUNCTION DrawLength% (text$)

DECLARE SUB Frame (spid%)
DECLARE SUB FrameAvatar (spid%)
DECLARE SUB FrameBeam (spid%)
DECLARE SUB FrameCycle (spid%)
DECLARE SUB FrameFile (spid%)
DECLARE SUB FrameIcewave (spid%)
DECLARE SUB FrameIcicle (spid%)
DECLARE SUB FrameStars (spid%)
DECLARE SUB FrameZipper (spid%)

DECLARE FUNCTION Spawn% (kind%, sx%, sy%, text$)
DECLARE FUNCTION SpawnAvatar% ()
DECLARE FUNCTION SpawnBeam% (sx%)
DECLARE FUNCTION SpawnCycle% (sx%, repeat%, text$)
DECLARE FUNCTION SpawnFile% (filename$)
DECLARE FUNCTION SpawnIcewave% (sx%)
DECLARE FUNCTION SpawnIcicle% (sx%)
DECLARE FUNCTION SpawnStars% (sx%, length%)
DECLARE FUNCTION SpawnZipper% (sx%)


DECLARE SUB SpriteKey (s AS ANY, keypress$)
DIM aspid AS INTEGER
DIM SHARED sprite(1 TO 100) AS SpriteType
aspid = SpawnAvatar%

'VIEW PRINT 3 TO 24
RANDOMIZE TIMER

DO

  DO

    k$ = INKEY$
    IF k$ = "" THEN
      EXIT DO
    END IF

    SELECT CASE k$
      CASE CHR$(27)
        END

      CASE ELSE
        SpriteKey sprite(aspid), k$
 
    END SELECT

  LOOP

  SCREEN , , 1, 0
  FOR spid% = 1 TO UBOUND(sprite)
    IF sprite(spid%).kind > 0 THEN
      Frame spid%
    END IF
  NEXT
  PRINT
  PCOPY 1, 0
  SCREEN , , 0, 0

LOOP

VIEW PRINT

CHAIN "EMPIRE.BAS"

SUB DrawBackground (sx1%, sy1%, sx2%, sy2%, backcolor%)
  
   DIM at% ' Attribute
   DIM ch% ' Character
   DIM sx% ' Screen x-coordinate
   DIM sy% ' Screen y-coordinate

   FOR sy% = sy1% TO sy2%

     '
     ' Move the cursor to the start of the row
     '
     LOCATE sy%, sx1%

     FOR sx% = sx1% TO sx2%
    
       ch% = SCREEN(sy%, sx%)
       at% = SCREEN(sy%, sx%, 1) AND &HF

       COLOR at%, backcolor%
       PRINT CHR$(ch%);

     NEXT
  
   NEXT

END SUB

SUB DrawColor (attr%)
  COLOR (attr% AND &HF) + (attr% AND &H80) / 8, (attr% AND &H70) / 16
END SUB

FUNCTION DrawLength% (text$)

  DIM char  AS STRING * 1
  DIM count AS INTEGER
  DIM i     AS INTEGER
  DIM state AS INTEGER

  FOR i = 1 TO LEN(text$)

    char = MID$(text$, i, 1)

    SELECT CASE state
     
      CASE 0:
        IF char = "@" THEN
          state = 1
        ELSE
          count = count + 1
        END IF
     
      CASE 1:
        IF char = "X" THEN
          state = 2
        ELSE
          count = count + 2
          state = 0
        END IF
     
      CASE 2:
        state = 3

      CASE 3:
        state = 0

    END SELECT

  NEXT

  DrawLength% = count

END FUNCTION

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

  DIM batr AS INTEGER
  DIM fatr AS INTEGER

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

    'ELSEIF nextAt > LEN(text) - 3 THEN
    '  '
    '  ' Code found, but not enough space for 4 characters
    '  '
    '  PRINT RIGHT$(text, LEN(text) - startAt + 1);
    '  EXIT DO

    ELSE
      '
      ' Code found; print characters up to the color code.
      '
      PRINT MID$(text, startAt, nextAt - startAt);

      '
      ' Read the color values
      '
      DrawColor VAL("&H" + MID$(text, nextAt + 2, 2))

      '
      ' Continue with the next character after the code
      '
      startAt = nextAt + 4
    END IF

  LOOP

END SUB

SUB Frame (spid%)

  SELECT CASE sprite(spid%).kind
   
    CASE SpriteKind.Avatar
      FrameAvatar spid%

    CASE SpriteKind.Beam
      FrameBeam spid%

    CASE SpriteKind.Cycle
      FrameCycle spid%

    CASE SpriteKind.File
      FrameFile spid%

    CASE SpriteKind.Icewave
      FrameIcewave spid%

    CASE SpriteKind.Icicle
      FrameIcicle spid%

    CASE SpriteKind.Stars
      FrameStars spid%

    CASE SpriteKind.Zipper
      FrameZipper spid%

  END SELECT

END SUB

SUB FrameAvatar (spid%)
  LOCATE sprite(spid%).sy, sprite(spid%).sx
  DrawText RTRIM$(sprite(spid%).text)
END SUB

SUB FrameBeam (spid%)

  DIM newspid AS INTEGER

  SELECT CASE sprite(spid%).param
 
    CASE 0:
      newspid = SpawnCycle(sprite(spid%).sx, 1, "@X01°@X01±@X01²@X01±@X01°")

    CASE 1:
      newspid = SpawnCycle(sprite(spid%).sx - 1, 1, "@X01°@X01±@X01²@X01±@X01°")
      newspid = SpawnCycle(sprite(spid%).sx + 1, 1, "@X01°@X01±@X01²@X01±@X01°")

    CASE 2:
      sprite(spid%).kind = 0

  END SELECT

  sprite(spid%).param = sprite(spid%).param + 1

END SUB

SUB FrameCycle (spid%)

  DIM a AS INTEGER     ' Current color attribute
  DIM c AS STRING * 1  ' Current character
  DIM p AS INTEGER     ' Current position in cycle
  DIM r AS INTEGER     ' Number of repeats
  DIM t AS STRING      ' Trimmed text

  '
  ' Get the string of cycled characters
  '
  t = RTRIM$(sprite(spid%).text)
  IF LEN(t) = 0 THEN
    sprite(spid%).kind = 0
    EXIT SUB
  END IF

  p = sprite(spid%).param AND &HFF
 
  IF p = 0 THEN
   
    '
    ' Initialize the cycle position
    '
    p = 1
    sprite(spid%).param = sprite(spid%).param OR 1

  ELSEIF p > LEN(t) THEN
   
    '
    ' Get the number of times to repeat the cycle
    '
    r = (sprite(spid%).param AND &HFF00) \ 256
    IF r = 0 THEN
      sprite(spid%).kind = 0
      EXIT SUB
    END IF

    r = r - 1
    sprite(spid%).param = r * 256 + p

  END IF

  '
  ' Apply color code(s)
  '
  c = MID$(t, p)

  WHILE c = "@"
    a = VAL("&H" + MID$(t, p + 2, 2))
    DrawColor a
    p = p + 4
    c = MID$(t, p)
  WEND
  
  LOCATE sprite(spid%).sy, sprite(spid%).sx
  PRINT c;
  p = p + 1

  sprite(spid%).param = (sprite(spid%).param AND &HFF00) + p

END SUB

SUB FrameFile (spid%)
  '
  ' Draws the next line from a file sprite
  '
 
  IF sprite(spid%).param = 0 THEN
    '
    ' File not opened yet
    '
    sprite(spid%).param = FREEFILE
    OPEN sprite(spid%).text FOR INPUT ACCESS READ AS #sprite(spid%).param
  END IF

  IF EOF(sprite(spid%).param) THEN
   
    CLOSE #sprite(spid%).param
    sprite(spid%).param = 0
    sprite(spid%).kind = 0

  ELSE
 
    LOCATE sprite(spid%).sy, sprite(spid%).sx
    LINE INPUT #sprite(spid%).param, textline$
    DrawText textline$

  END IF

END SUB

SUB FrameIcewave (spid%)

  sprite(spid%).param = sprite(spid%).param + 1 + INT(RND * 4)
  IF sprite(spid%).param > 79 THEN
    sprite(spid%).kind = 0
    EXIT SUB
  END IF

  DIM ispid AS INTEGER
  LET ispid = SpawnIcicle(sprite(spid%).param)

END SUB

SUB FrameIcicle (spid%)

  SELECT CASE sprite(spid%).param
     
    CASE 0
      '
      ' Last one was a space
      '
      SELECT CASE INT(RND * 3)
        CASE 0
          sprite(spid%).param = 1
        CASE ELSE
          sprite(spid%).kind = 0
          EXIT SUB
      END SELECT
 
    CASE 1
      '
      ' Last one was dark
      '
      SELECT CASE INT(RND * 4)
        CASE 0
          sprite(spid%).param = 0
        CASE 1
          sprite(spid%).param = 2
        CASE ELSE
          sprite(spid%).param = 1
      END SELECT
 
    CASE 2
      '
      ' Last one was medium
      '
      SELECT CASE INT(RND * 4)
        CASE 0
          sprite(spid%).param = 1
        CASE 1
          sprite(spid%).param = 3
        CASE ELSE
          sprite(spid%).param = 2
      END SELECT
 
    CASE 3
      '
      ' Last one was bright
      '
      SELECT CASE INT(RND * 4)
        CASE 0
          sprite(spid%).param = 3
       
        CASE ELSE
          sprite(spid%).param = 2
      END SELECT

  END SELECT
    
  LOCATE sprite(spid%).sy, sprite(spid%).sx

  SELECT CASE sprite(spid%).param
    CASE 1
      COLOR 8
      PRINT CHR$(179);
    CASE 2
      COLOR 7
      PRINT CHR$(179);
    CASE 3
      COLOR 15
      PRINT CHR$(179);
  END SELECT
  
END SUB

SUB FrameStars (spid%)

  LOCATE sprite(spid%).sy, sprite(spid%).sx

  DIM n%
  FOR n% = 1 TO sprite(spid%).param
  
    IF RND <= .1 THEN
   
      '
      ' Random color
      '
      SELECT CASE INT(RND * 3)
        CASE 0: COLOR 8, 0
        CASE 1: COLOR 7, 0
        CASE 2: COLOR 15, 0
      END SELECT

      '
      ' Random star
      '
      SELECT CASE INT(RND * 3)
        CASE 0: PRINT CHR$(249); ' ù
        CASE 1: PRINT CHR$(250); ' ú
        CASE 2: PRINT ".";
      END SELECT

    ELSE
      PRINT " ";
    END IF

  NEXT

END SUB

SUB FrameZipper (spid%)

  '
  ' Randomly end the zipper
  '
  IF RND < .01 THEN
    sprite(spid%).kind = 0
    EXIT SUB
  END IF

  DIM sx%
  DIM sy%

  sx% = sprite(spid%).sx
  sy% = sprite(spid%).sy

  '
  ' Calculate how far the zipper moves
  '
  DIM offset%
  LET offset% = INT(RND * 11) - 5

  '
  ' Normalize screen coordinates
  '
  SELECT CASE sx% + offset%
    CASE IS < 1
      offset% = offset% + 10
    CASE IS > 79
      offset% = offset% - 10
  END SELECT

  DrawColor sprite(spid%).param

  IF offset% = 0 THEN

    LOCATE sy%, sx%
    PRINT CHR$(179);

  ELSEIF offset% > 0 THEN

    LOCATE sy%, sx%
    PRINT CHR$(192);
    PRINT STRING$(offset% - 1, CHR$(196));
    PRINT CHR$(191);

  ELSE
 
    LOCATE sy%, sx% + offset%
    PRINT CHR$(218);
    PRINT STRING$((-1 * offset%) - 1, CHR$(196));
    PRINT CHR$(217);

  END IF

  sprite(spid%).sx = sx% + offset%

END SUB

FUNCTION Spawn% (kind%, sx%, param%, text$)

  DIM spid%
  FOR spid% = 1 TO UBOUND(sprite)
    IF sprite(spid%).kind = 0 THEN
    
      sprite(spid%).kind = kind%
      sprite(spid%).drawsize = 0
      sprite(spid%).param = param%
      sprite(spid%).sx = sx%
      sprite(spid%).sy = 24
      sprite(spid%).text = text$

      Spawn% = spid%
      EXIT FUNCTION
    END IF
  NEXT

END FUNCTION

FUNCTION SpawnAvatar%
  SpawnAvatar% = Spawn%(SpriteKind.Avatar, 40, 0, "@X84@X0Cðð@X84@X07")
END FUNCTION

FUNCTION SpawnBeam% (sx%)
  SpawnBeam% = Spawn%(SpriteKind.Beam, sx%, 0, "")
END FUNCTION

FUNCTION SpawnCycle% (sx%, repeat%, text$)
  SpawnCycle% = Spawn%(SpriteKind.Cycle, sx%, (repeat% AND &HFF) * 256, text$)
END FUNCTION

FUNCTION SpawnFile% (filename$)
  SpawnFile% = Spawn%(SpriteKind.File, INT(RND * 60) + 1, 0, filename$)
END FUNCTION

FUNCTION SpawnIcewave% (sx%)
  SpawnIcewave% = Spawn%(SpriteKind.Icewave, sx%, 0, "")
END FUNCTION

FUNCTION SpawnIcicle% (sx%)
  SpawnIcicle% = Spawn%(SpriteKind.Icicle, sx%, 1, "")
END FUNCTION

FUNCTION SpawnStars% (sx%, length%)
  SpawnStars% = Spawn%(SpriteKind.Stars, sx%, length%, "")
END FUNCTION

FUNCTION SpawnZipper% (sx%)
  SpawnZipper% = Spawn%(SpriteKind.Zipper, sx%, INT(RND * 256), "")
END FUNCTION

SUB SpriteKey (s AS SpriteType, keypress$)
 
  DIM spid AS INTEGER

  SELECT CASE keypress$
   
    CASE "b"
      spid = SpawnBeam(s.sx)

    CASE "c"
      spid = SpawnCycle(s.sx, 10, "@X08*@X07*@X0F*@X07*@X08*")

    CASE "i"
      spid = SpawnIcicle(s.sx)

    CASE "m"
      spid = SpawnFile("MONSTER.PCB")
    
    CASE "s"
      spid = SpawnStars(1, 78)

    CASE "t"
      spid = SpawnFile("SPR-TOWR.PCB")

    CASE "w"
      spid = SpawnIcewave(s.sx)
    
    CASE "z"
      spid = SpawnZipper(s.sx)

    CASE " "
      s.param = s.param + 1
      IF s.param > 20 THEN s.param = 20
      s.text = "@X84@X0C" + STRING$(s.param, "ð") + "@X84@X07"
      s.drawsize = DrawLength%(s.text)
      
    CASE CHR$(8)
      s.param = s.param - 1
      IF s.param < 0 THEN s.param = 0
      s.text = "@X84@X0C" + STRING$(s.param, "ð") + "@X84@X07"
      s.drawsize = DrawLength%(s.text)

    CASE "a", CHR$(0) + CHR$(75)
      '
      ' Left
      '
      s.sx = s.sx - 1
      IF s.sx < 1 THEN s.sx = 80 - s.drawsize
       
    CASE "d", CHR$(0) + CHR$(77)
      '
      ' Right
      '
      s.sx = s.sx + 1
      IF s.sx > 80 - s.drawsize THEN s.sx = 1

  END SELECT

END SUB

