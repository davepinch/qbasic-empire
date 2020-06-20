
' The Galactic Empire
' By David Pinch, 1991-2020
'
' MIT License
' https://github.com/davepinch/qbasic-empire
'
' To begin, press Shift + F5.
' To exit QBASIC, press Alt, F, X.
' To view full screen (in DOSBox), press Alt-Enter.

TYPE AreaType
  allocated AS INTEGER
  hid       AS INTEGER
  energy    AS INTEGER
END TYPE

TYPE AtlasItemType
  allocated AS INTEGER
  cx        AS INTEGER
  cy        AS INTEGER
  labelrid  AS INTEGER
  value     AS INTEGER
END TYPE

TYPE BindingType
  vrid AS INTEGER ' Resource of the value
  xrid AS INTEGER ' Resource of the expression; 0=no binding
END TYPE

TYPE EventType
  namerid AS INTEGER
  value   AS INTEGER
END TYPE

TYPE FieldType
  kind      AS INTEGER
  childwid  AS INTEGER
  cmdrid    AS INTEGER
  offsetX   AS INTEGER
  offsetY   AS INTEGER
  sid       AS INTEGER
  sizeX     AS INTEGER
  sizeY     AS INTEGER
  text      AS BindingType
  value     AS BindingType
END TYPE

TYPE HabitatType
  actionrid AS INTEGER
  backdrop  AS INTEGER
  labelrid  AS INTEGER
  namerid   AS INTEGER
  wid       AS INTEGER
END TYPE

TYPE PersonaType
  labelrid AS INTEGER
  namerid  AS INTEGER
END TYPE

TYPE TriggerType
  eid      AS INTEGER
  operator AS INTEGER
  operand  AS INTEGER
  cmdrid   AS INTEGER
END TYPE

TYPE WinResultType
  action   AS INTEGER
  canceled AS INTEGER
  cmdrid   AS INTEGER
  selected AS INTEGER
END TYPE

TYPE WinStackItem
  wid      AS INTEGER
  backpage AS INTEGER
  workpage AS INTEGER
END TYPE

TYPE WinStyleType
  bordercolor   AS INTEGER
  bordertype    AS INTEGER
  selectedcolor AS INTEGER
  stylename     AS STRING * 10
  textcolor     AS INTEGER
END TYPE

TYPE WinType
  arrowexit AS INTEGER
  fields    AS INTEGER
  helpWid   AS INTEGER
  posX      AS INTEGER
  posY      AS INTEGER
  selected  AS INTEGER
  sid       AS INTEGER
  wname     AS STRING * 20
END TYPE

'
' Assertions
'
DECLARE SUB Assert (truth AS INTEGER, where AS STRING, what AS STRING)
DECLARE SUB AssertFail (where$, what$)
DECLARE SUB AssertIsPositive (value%, where$, what$)
DECLARE SUB AssertIsZero (value%, where$, what$)

'
' Atlas
'
DECLARE SUB AtlasAddItem (cx AS INTEGER, cy AS INTEGER, value AS INTEGER, labelrid AS INTEGER)
DECLARE SUB AtlasDraw ()
DECLARE SUB AtlasDrawBegin ()
DECLARE SUB AtlasDrawCell (cx AS INTEGER, cy AS INTEGER)
DECLARE SUB AtlasDrawEnd ()
DECLARE SUB AtlasDrawGrid ()
DECLARE SUB AtlasDrawItem (idx AS INTEGER)
DECLARE SUB AtlasDrawItems ()
DECLARE SUB AtlasDrawPainted (cx AS INTEGER, cy AS INTEGER, backcolor AS INTEGER)
DECLARE SUB AtlasDrawSelect (cx AS INTEGER, cy AS INTEGER, valid AS INTEGER)
DECLARE SUB AtlasDrawUnselect (cx AS INTEGER, cy AS INTEGER)
DECLARE SUB AtlasMoveItem (idx AS INTEGER, nx AS INTEGER, ny AS INTEGER)
DECLARE SUB AtlasNextBanded (outcx AS INTEGER, outcy AS INTEGER)
DECLARE SUB AtlasNextClustered (outcx AS INTEGER, outcy AS INTEGER)
DECLARE SUB AtlasNextManual (outcx AS INTEGER, outcy AS INTEGER)
DECLARE SUB AtlasNextRandom (outcx AS INTEGER, outcy AS INTEGER)
DECLARE SUB AtlasPlotBanded ()
DECLARE SUB AtlasPlotClustered ()
DECLARE SUB AtlasPlotManual ()
DECLARE SUB AtlasPlotRandom ()
DECLARE SUB AtlasRemoveItem (idx AS INTEGER)
DECLARE SUB AtlasRemoveValue (value AS INTEGER)
DECLARE SUB AtlasSetLabel (idx AS INTEGER, labelrid AS INTEGER)
DECLARE SUB AtlasSetStatus (text$)
DECLARE SUB AtlasSetStatusEx (text$, attr%)
DECLARE FUNCTION AtlasNextIndex% ()
DECLARE FUNCTION AtlasGetScreenX% (cx AS INTEGER)
DECLARE FUNCTION AtlasGetScreenY% (cy AS INTEGER)
DECLARE FUNCTION AtlasGetValue% (cx AS INTEGER, cy AS INTEGER, default AS INTEGER)
DECLARE FUNCTION AtlasIndexOf% (value AS INTEGER)
DECLARE FUNCTION AtlasPrompt (promptFor AS INTEGER, outcx AS INTEGER, outcy AS INTEGER, outpress AS STRING)

'
' Console
'
DECLARE SUB ConsoleBegin ()
DECLARE SUB ConsoleClear ()
DECLARE SUB ConsoleEnd ()
DECLARE SUB ConsoleFile (filename$)
DECLARE SUB ConsolePrint (text$)

'
' Dialog
'
DECLARE SUB DialogNext (outpid%, outtext$)
DECLARE SUB DialogPrint (pid%, text$)
DECLARE SUB DialogTimer ()
DECLARE FUNCTION DialogGarble$ (text$, percent!)

'
' Drawing
'
DECLARE SUB DrawBackground (sx1%, sy1%, sx2%, sy2%, backcolor%)
DECLARE SUB DrawColor (attr%)
DECLARE SUB DrawFile (filename AS STRING)
DECLARE SUB DrawFileAt (filename AS STRING, offsetX AS INTEGER, offsetY AS INTEGER)
DECLARE SUB DrawText (text AS STRING)
DECLARE FUNCTION DrawLength% (text$)

'
' Events
'
DECLARE SUB EventInc (eid%)
DECLARE SUB EventIncName (ename$)
DECLARE SUB EventFire (eid%)
DECLARE FUNCTION EventFind% (name$)
DECLARE FUNCTION EventParseOperator% (opname$)
DECLARE FUNCTION EventTestTrigger% (eid%, tid%)

'
' Execution/commands
'
DECLARE SUB ExecFile (filename AS STRING)
DECLARE FUNCTION ExecCmd% (text AS STRING)
DECLARE FUNCTION ExecCmdEid% (ntoken%, stoken$(), eid%)
DECLARE FUNCTION ExecCmdFid% (ntoken%, stoken$(), wid%, fid%)
DECLARE FUNCTION ExecCmdHid% (ntoken%, stoken$(), hid%)
DECLARE FUNCTION ExecCmdPid% (ntoken%, stoken$(), pid%)
DECLARE FUNCTION ExecCmdRoot% (ntoken%, stoken$(), eid%, hid%, pid%, sid%, tid%, wid%)
DECLARE FUNCTION ExecCmdSid% (ntoken%, stoken$(), sid%)
DECLARE FUNCTION ExecCmdTid% (ntoken%, stoken$(), tid%)
DECLARE FUNCTION ExecCmdWid% (ntoken%, stoken$(), wid%, fid%)
DECLARE FUNCTION ExecResource% (rid AS INTEGER)

'
' Fields
'
DECLARE SUB FieldBindText (wid%, fid%, expr$)
DECLARE SUB FieldBindValue (wid%, fid%, expr$)
DECLARE SUB FieldDraw (wid%, fid%)
DECLARE SUB FieldDrawBox (wid%, fid%)
DECLARE SUB FieldDrawBox0 (wid%, fid%)
DECLARE SUB FieldDrawBox1 (wid%, fid%)
DECLARE SUB FieldDrawBox2 (wid%, fid%)
DECLARE SUB FieldDrawFile (wid%, fid%)
DECLARE SUB FieldDrawNebula (wid%, fid%)
DECLARE SUB FieldDrawSeparator (wid%, fid%)
DECLARE SUB FieldDrawText (wid%, fid%)
DECLARE SUB FieldKey (wid%, fid%, keypress$)
DECLARE SUB FieldKeyBoolean (wid%, fid%, keypress$)
DECLARE SUB FieldKeyInteger (wid%, fid%, keypress$)
DECLARE SUB FieldSetBound (wid%, fid%, b AS BindingType, value$)
DECLARE SUB FieldSetChild (wid%, fid%, wname$)
DECLARE SUB FieldSetCommand (wid%, fid%, cmd$)
DECLARE SUB FieldSetOffsetX (wid%, fid%, offsetX%)
DECLARE SUB FieldSetOffsetY (wid%, fid%, offsetY%)
DECLARE SUB FieldSetSizeX (wid%, fid%, sizeX%)
DECLARE SUB FieldSetSizeY (wid%, fid%, sizeY%)
DECLARE SUB FieldSetStyle (wid%, fid%, sid%)
DECLARE SUB FieldSetText (wid%, fid%, value$)
DECLARE SUB FieldSetValue (wid%, fid%, value$)
DECLARE FUNCTION FieldCreate% (wid%, kind%)
DECLARE FUNCTION FieldGetBound$ (wid%, fid%, b AS BindingType)
DECLARE FUNCTION FieldGetKind% (wid%, fid%)
DECLARE FUNCTION FieldGetStyle% (wid%, fid%)
DECLARE FUNCTION FieldGetText$ (wid%, fid%)
DECLARE FUNCTION FieldGetValue$ (wid%, fid%)
DECLARE FUNCTION FieldIsBound% (wid%, fid%)
DECLARE FUNCTION FieldIsSelectable% (wid%, fid%)

'
' Game
'
DECLARE SUB GameHarvest ()
DECLARE FUNCTION GameAreaEnergy% ()
DECLARE FUNCTION GameArea% ()
DECLARE FUNCTION GameHabitat% ()

'
' Habitats
'
DECLARE SUB HabitatSetAction (hid%, cmd$)
DECLARE SUB HabitatSetBackdrop (hid%, backdrop$)
DECLARE SUB HabitatSetLabel (hid%, label$)
DECLARE SUB HabitatSetName (hid%, hname$)
DECLARE FUNCTION HabitatCreate% ()
DECLARE FUNCTION HabitatGetBackdrop$ (hid%)
DECLARE FUNCTION HabitatGetName$ (hid%)

'
' Inbox
'
DECLARE SUB InboxAdd (subject AS STRING, filename AS STRING)

'
' Nebula
'
DECLARE FUNCTION NebulaLabel$ (energy AS INTEGER)
DECLARE FUNCTION NebulaLabelRid% (energy AS INTEGER)

'
' Persona
'
DECLARE SUB PersonaSetLabel (pid%, label$)
DECLARE SUB PersonaSetName (pid%, text$)
DECLARE FUNCTION PersonaCreate% ()
DECLARE FUNCTION PersonaGetLabel$ (pid%)
DECLARE FUNCTION PersonaGetName$ (pid%)

'
' Resources
'
DECLARE SUB ResourceSet (rid AS INTEGER, value AS STRING)
DECLARE FUNCTION ResourceCreate% (value AS STRING)
DECLARE FUNCTION ResourceGet$ (rid AS INTEGER)

'
' UI
'
DECLARE SUB UI.Action ()
DECLARE SUB UI.ActionNebula (aid AS INTEGER)
DECLARE SUB UI.Run ()
DECLARE SUB UI.RunAtlas ()
DECLARE SUB UI.RunConsole ()
DECLARE SUB UI.SetPage (page AS INTEGER)

'
' Video pages
'
DECLARE SUB VideoFree (pagenum%)
DECLARE SUB VideoPop ()
DECLARE SUB VideoPushActive (active%)
DECLARE SUB VideoScreen (activepage%, visualpage%)
DECLARE FUNCTION VideoAlloc% ()
DECLARE FUNCTION VideoGetActive% ()
DECLARE FUNCTION VideoGetVisual% ()

'
' Windows
'
DECLARE SUB WinClose (wid%)
DECLARE SUB WinDraw (wid%)
DECLARE SUB WinOpen (wid%)
DECLARE SUB WinRefreshField (wid%, fid%)
DECLARE SUB WinRefreshWindow (wid%)
DECLARE SUB WinRun (wid%, result AS WinResultType)
DECLARE SUB WinRunName (idname$)
DECLARE SUB WinSelect (wid%, fid%)
DECLARE SUB WinSelectNext (wid%)
DECLARE SUB WinSelectFirst (wid%)
DECLARE SUB WinSelectLast (wid%)
DECLARE SUB WinSelectPrevious (wid%)
DECLARE SUB WinSetStyle (wid%, sid%)
DECLARE FUNCTION WinAddButton% (wid%, posX%, posY%, sizeX%, text$, value$)
DECLARE FUNCTION WinCreate% ()
DECLARE FUNCTION WinFindSid% (stylename$)
DECLARE FUNCTION WinFindWid% (wname$)
DECLARE FUNCTION WinGetStyle% (wid%)
DECLARE FUNCTION WinMapKey% (wid%, pressed$)

'
' World
'
DECLARE SUB WorldAddCluster (hid AS INTEGER, size AS INTEGER)
DECLARE SUB WorldAddNebula (size AS INTEGER)
DECLARE SUB WorldHarvest (aid%)
DECLARE SUB WorldInit (areas AS INTEGER)
DECLARE SUB WorldRemove (aid%)
DECLARE SUB WorldSetLabel (aid%, labelrid%)
DECLARE FUNCTION WorldAdd% (hid%, cx%, cy%)
DECLARE FUNCTION WorldNextId% ()

'
' Declarations
'
DECLARE SUB SetupGame ()
DECLARE FUNCTION GetKey$ ()
DECLARE FUNCTION Split% (text AS STRING, tokens() AS STRING)

'
' ASCII character constants
'
CONST ASCII.Backspace = 8
CONST ASCII.Tab = 9
CONST ASCII.Return = 13
CONST ASCII.Escape = 27
CONST ASCII.Space = 32

'
' AtlasSelect constants
'
CONST AtlasPromptFor.Cell = 0
CONST AtlasPromptFor.Empty = 1
CONST AtlasPromptFor.EmptyOrSelf = 2
CONST AtlasPromptFor.Item = 3

'
' AtlasStyle constants
'
CONST AtlasStyle.CellBackcolor = 0
CONST AtlasStyle.CellForecolor = 7
CONST AtlasStyle.CellSizeX = 4
CONST AtlasStyle.CellSizeY = 1
CONST AtlasStyle.GridSizeX = 15
CONST AtlasStyle.GridSizeY = 11

'
' Boolean constants
'
CONST True = -1
CONST False = NOT True

'
' Command Results
'
CONST CmdResult.OK = 0
CONST CmdResult.Malformed = 1

'
' Field Kinds
'
CONST FieldKind.None = 0
CONST FieldKind.Boolean = 1
CONST FieldKind.Box = 2
CONST FieldKind.Button = 3
CONST FieldKind.File = 4
CONST FieldKind.Integer = 5
CONST FieldKind.Label = 6
CONST FieldKind.Popup = 7
CONST FieldKind.Separator = 8
CONST FieldKind.Nebula = 100

'
' Operators
'
CONST OpNone = 0
CONST OpEquals = 1

'
' ScanCode constants
'
CONST ScanCode.Home = 71
CONST ScanCode.Up = 72
CONST ScanCode.PageUp = 73
CONST ScanCode.Left = 75
CONST ScanCode.Right = 77
CONST ScanCode.End = 79
CONST ScanCode.Down = 80
CONST ScanCode.PageDown = 81

'
' UIPage.* constants
'
CONST UIPage.None = 0
CONST UIPage.Atlas = 1
CONST UIPage.Console = 2

'
' WinAction* constants
'
CONST WinAction.None = 0
CONST WinAction.Cancel = 1
CONST WinAction.Complete = 2
CONST WinAction.Execute = 3
CONST WinAction.ExitLeft = 4
CONST WinAction.ExitRight = 5
CONST WinAction.Help = 6
CONST WinAction.OpenPopup = 11
CONST WinAction.SelectFirst = 12
CONST WinAction.SelectLast = 13
CONST WinAction.SelectNext = 14
CONST WinAction.SelectPrevious = 15

'
' Global atlas variables
'
DIM SHARED atlasGrid(1 TO AtlasStyle.GridSizeX, 1 TO AtlasStyle.GridSizeY) AS INTEGER
                 
'
' Globals
'
DIM SHARED area(1 TO 30)         AS AreaType
DIM SHARED atlasitem(1 TO 30)    AS AtlasItemType
DIM SHARED atlaspage             AS INTEGER
DIM SHARED event(1 TO 5)         AS EventType
DIM SHARED events                AS INTEGER
DIM SHARED fld(1 TO 15, 1 TO 13) AS FieldType
DIM SHARED habitat(1 TO 8)       AS HabitatType
DIM SHARED habitats              AS INTEGER
DIM SHARED persona(1 TO 10)      AS PersonaType
DIM SHARED personas              AS INTEGER
DIM SHARED resource(1 TO 100)    AS STRING
DIM SHARED resources             AS INTEGER
DIM SHARED trigger(1 TO 5)       AS TriggerType
DIM SHARED triggers              AS INTEGER
DIM SHARED uiCurrentPage         AS INTEGER
DIM SHARED uicx                  AS INTEGER
DIM SHARED uicy                  AS INTEGER
DIM SHARED vallocated            AS INTEGER
DIM SHARED vstack(0 TO 5)        AS INTEGER
DIM SHARED vstacked              AS INTEGER
DIM SHARED win(1 TO 15)          AS WinType
DIM SHARED wincount              AS INTEGER
DIM SHARED winstack(1 TO 3)      AS WinStackItem
DIM SHARED winstacked            AS INTEGER
DIM SHARED winstyle(1 TO 10)     AS WinStyleType
DIM SHARED winstyles             AS INTEGER

ON TIMER(1) GOSUB HandleTimer

SetupGame
UI.Run
END

HandleTimer:
  '
  ' Executed when the game needs to perform periodic tasks
  '
  DialogTimer
  RETURN

SUB Assert (truth AS INTEGER, where AS STRING, what AS STRING)

  IF NOT truth THEN
   
    DIM message AS STRING
    LET message = where + ": " + what

    AtlasSetStatusEx message, &H4F
    ConsolePrint "@X4F" + message + "@X07"

    IF GetKey$ <> CHR$(ASCII.Escape) THEN
      END
    END IF
 
  END IF

END SUB

SUB AssertFail (where$, what$)
  Assert 0, where$, what$
END SUB

SUB AssertIsPositive (value%, where$, what$)

  Assert value% > 0, where$, what$ + " must be > 0 but value =" + STR$(value%)

END SUB

SUB AssertIsZero (value%, where$, what$)
  Assert value% = 0, where$, what$ + " must be 0 but value =" + STR$(value%)
END SUB

SUB AtlasAddItem (cx AS INTEGER, cy AS INTEGER, value AS INTEGER, labelrid AS INTEGER)
  '
  ' Adds an item to the atlas at the specified position.
  '
  DIM idx AS INTEGER
  
  '
  ' Get the index of the new item
  '
  idx = AtlasNextIndex%
  IF idx = 0 THEN
    EXIT SUB
  END IF

  '
  ' Add the item to the item list
  '
  atlasitem(idx).allocated = -1
  atlasitem(idx).cx = cx
  atlasitem(idx).cy = cy
  atlasitem(idx).labelrid = labelrid
  atlasitem(idx).value = value

  '
  ' Reference the item in the grid
  '
  atlasGrid(cx, cy) = idx
  AtlasDrawCell cx, cy

END SUB

SUB AtlasDraw
  AtlasDrawGrid
  AtlasDrawItems
END SUB

SUB AtlasDrawBegin
  VideoPushActive atlaspage
END SUB

SUB AtlasDrawCell (cx AS INTEGER, cy AS INTEGER)

  DIM idx   AS INTEGER
  DIM sx    AS INTEGER
  DIM sy    AS INTEGER
  DIM value AS INTEGER

  AtlasDrawBegin

  '
  ' Get the screen coordinates of the cell
  '
  sx = AtlasGetScreenX(cx)
  sy = AtlasGetScreenY(cy)
  LOCATE sy, sx
 
  '
  ' Set the color of the cell contents
  '
  COLOR AtlasStyle.CellForecolor, AtlasStyle.CellBackcolor

  '
  ' Write the cell contents
  '
  idx = atlasGrid(cx, cy)
  IF idx = 0 THEN
    PRINT STRING$(AtlasStyle.CellSizeX, " ");
  ELSE
    DIM label AS STRING
    LET label = ResourceGet(atlasitem(idx).labelrid)
    DrawText label
  END IF

  AtlasDrawEnd

END SUB

SUB AtlasDrawEnd
  VideoPop
END SUB

SUB AtlasDrawGrid
  AtlasDrawBegin
  DrawFileAt "GRID.PCB", 1, 2
  AtlasDrawEnd
END SUB

SUB AtlasDrawItem (idx AS INTEGER)
 
  AssertIsPositive idx, "AtlasDrawItem", "idx"

  IF atlasitem(idx).allocated THEN
    AtlasDrawCell atlasitem(idx).cx, atlasitem(idx).cy
  END IF

END SUB

SUB AtlasDrawItems
 
  DIM idx AS INTEGER
  FOR idx = 1 TO UBOUND(atlasitem)
    IF atlasitem(idx).allocated THEN
      AtlasDrawCell atlasitem(idx).cx, atlasitem(idx).cy
    END IF
  NEXT

END SUB

SUB AtlasDrawPainted (cx AS INTEGER, cy AS INTEGER, backcolor AS INTEGER)

  DIM col AS INTEGER
  DIM sx1 AS INTEGER
  DIM sy1 AS INTEGER

  AtlasDrawBegin

  '
  ' Get the upper-left screen coordinates of the outer cell
  '
  sx1 = AtlasGetScreenX(cx) - 1
  sy1 = AtlasGetScreenY(cy) - 1

  DrawBackground sx1, sy1, sx1 + AtlasStyle.CellSizeX + 1, sy1 + 2, backcolor

  AtlasDrawEnd

END SUB

SUB AtlasDrawSelect (cx AS INTEGER, cy AS INTEGER, valid AS INTEGER)
  '
  ' Draws the current selection indicator onto the grid
  '

  DIM backcolor AS INTEGER
  IF valid THEN
    backcolor = 2
  ELSE
    backcolor = 4
  END IF

  AtlasDrawPainted cx, cy, backcolor

END SUB

SUB AtlasDrawUnselect (cx AS INTEGER, cy AS INTEGER)
  AtlasDrawPainted cx, cy, 0
  AtlasDrawCell cx, cy
END SUB

FUNCTION AtlasGetScreenX% (cx AS INTEGER)
  '
  ' Returns the screen x-coordinates of the cell x-coordinate
  '
  AtlasGetScreenX% = (cx - 1) * 5 + 2

END FUNCTION

FUNCTION AtlasGetScreenY% (cy AS INTEGER)
  '
  ' Returns the screen y-coordinate of the cell y-coordinate
  '
  AtlasGetScreenY% = (cy - 1) * 2 + 3
END FUNCTION

FUNCTION AtlasGetValue% (cx AS INTEGER, cy AS INTEGER, default AS INTEGER)
  '
  ' Return the item value of the selected cell, or the default if
  ' no item is currently referenced by the cell.
  '

  DIM idx AS INTEGER
  LET idx = atlasGrid(cx, cy)

  IF idx = 0 THEN
    AtlasGetValue% = default
  ELSE
    AtlasGetValue% = atlasitem(idx).value
  END IF

END FUNCTION

FUNCTION AtlasIndexOf% (value AS INTEGER)
  '
  ' Returns the index of the first item with the specified value.
  '

  DIM idx AS INTEGER
  FOR idx = 1 TO UBOUND(atlasitem)
 
    IF atlasitem(idx).value = value THEN
      IF atlasitem(idx).allocated THEN
        AtlasIndexOf% = idx
        EXIT FUNCTION
      END IF
    END IF

  NEXT

  AtlasIndexOf% = 0

END FUNCTION

SUB AtlasMoveItem (idx AS INTEGER, nx AS INTEGER, ny AS INTEGER)
 
  DIM cx AS INTEGER
  DIM cy AS INTEGER

  '
  ' Get the current x and y coordinates
  '
  cx = atlasitem(idx).cx
  cy = atlasitem(idx).cy

  '
  ' Dereference the item from the grid
  '
  IF cx > 0 AND cy > 0 THEN
    atlasGrid(cx, cy) = 0
    AtlasDrawCell cx, cy
  END IF

  '
  ' Update the item location
  '
  atlasitem(idx).cx = nx
  atlasitem(idx).cy = ny

  '
  ' Reference the item in the grid
  '
  atlasGrid(nx, ny) = idx
  AtlasDrawCell nx, ny

END SUB

SUB AtlasNextBanded (outcx AS INTEGER, outcy AS INTEGER)
  '
  ' Updates outcx and outcy with a slot in the same orbital band
  '
 
  IF outcx = 0 OR outcy = 0 THEN
    AtlasNextRandom outcx, outcy
  ELSE

    DO
      '
      ' Select random x-coordinate
      '
      outcx = INT(RND * AtlasStyle.GridSizeX) + 1

      '
      ' Select random y-coordinate near the same row (+/- 1).
      '
      outcy = INT(RND * 3) - 1 + outcy
      IF outcy < 1 THEN outcy = outcy + 1
      IF outcy > AtlasStyle.GridSizeY THEN outcy = outcy - 1

    LOOP UNTIL atlasGrid(outcx, outcy) = 0
              
  END IF

END SUB

SUB AtlasNextClustered (outcx AS INTEGER, outcy AS INTEGER)

  DIM rx AS INTEGER
  DIM ry AS INTEGER
 
  '
  ' Finds a clustered slot
  '
  IF outcx = 0 OR outcy = 0 THEN
   
    AtlasNextRandom outcx, outcy

  ELSE
    '
    ' Find slot near the last coordinates
    '
    DO
      '
      ' Random spot within -2, -1, 0, +1, +2 from last spot
      '
      
      rx = INT(RND * 5) - 2 + outcx
      ry = INT(RND * 5) - 2 + outcy
    
      '
      ' Reflect back into the grid if out of bounds
      '
      IF rx < 1 THEN rx = rx + 2
      IF ry < 1 THEN ry = ry + 2
      IF rx > AtlasStyle.GridSizeX THEN rx = rx - 2
      IF ry > AtlasStyle.GridSizeY THEN ry = ry - 2

      ' BUG: this could fail if x,y is a corner and the nearby
      ' cells of the corner are filled.

    LOOP UNTIL atlasGrid(rx, ry) = 0

    outcx = rx
    outcy = ry

  END IF

END SUB

FUNCTION AtlasNextIndex%
  '
  ' Returns the next open index to hold a new item
  '
 
  STATIC idx AS INTEGER

  DIM try AS INTEGER
  LET try = idx

  DO
    '
    ' Try the next index
    '
    try = try + 1
    IF try > UBOUND(atlasitem) THEN
      try = 1
    END IF

    IF NOT atlasitem(try).allocated THEN
      idx = try
      AtlasNextIndex = idx
      EXIT FUNCTION
    END IF

    IF try = idx THEN
      AtlasNextIndex = 0
      EXIT FUNCTION
    END IF

  LOOP

  AtlasNextIndex% = 0

END FUNCTION

SUB AtlasNextManual (outcx AS INTEGER, outcy AS INTEGER)
  '
  ' Returns the next manually-selected position.
  '
 
  DIM outpress AS STRING

  IF NOT AtlasPrompt(AtlasPromptFor.EmptyOrSelf, outcx, outcy, outpress) THEN
    outcx = 0
    outcy = 0
  END IF

END SUB

SUB AtlasNextRandom (outcx AS INTEGER, outcy AS INTEGER)

  DO
    outcx = INT(RND * AtlasStyle.GridSizeX) + 1
    outcy = INT(RND * AtlasStyle.GridSizeY) + 1
  LOOP UNTIL atlasGrid(outcx, outcy) = 0

END SUB

SUB AtlasPlotBanded

  DIM cx  AS INTEGER
  DIM cy  AS INTEGER
  DIM idx AS INTEGER

  '
  ' Get the initial random spot to start the banding
  '
  AtlasNextRandom cx, cy

  FOR idx = 1 TO UBOUND(atlasitem)
   
    IF atlasitem(idx).allocated THEN
      '
      ' Get the new position near the same row as the prior location
      '
      AtlasNextBanded cx, cy

      '
      ' Move the item to the new location
      '
      AtlasMoveItem idx, cx, cy
    END IF

  NEXT

END SUB

SUB AtlasPlotClustered

  DIM cx  AS INTEGER
  DIM cy  AS INTEGER
  DIM idx AS INTEGER

  '
  ' Get the initial random spot to start the banding
  '
  AtlasNextRandom cx, cy

  FOR idx = 1 TO UBOUND(atlasitem)
  
    IF atlasitem(idx).allocated THEN
      '
      ' Get the new position near the same row as the prior location
      '
      AtlasNextClustered cx, cy

      '
      ' Move the item to the new location
      '
      AtlasMoveItem idx, cx, cy
   
    END IF

  NEXT

END SUB

SUB AtlasPlotManual

  DIM idx AS INTEGER
  DIM cx  AS INTEGER
  DIM cy  AS INTEGER

  FOR idx = 1 TO UBOUND(atlasitem)
 
    IF atlasitem(idx).allocated THEN
  
      '
      ' Get the current position of the item
      '
      cx = atlasitem(idx).cx
      cy = atlasitem(idx).cy

      '
      ' Manually get the new location of the item
      '
      AtlasNextManual cx, cy
      IF cx = 0 THEN
        '
        ' Selection was canceled, so exit
        '
        EXIT FOR
      ELSE

        '
        ' Move the selected item
        '
        AtlasMoveItem idx, cx, cy

      END IF

    END IF

  NEXT

END SUB

SUB AtlasPlotRandom

  DIM cx  AS INTEGER
  DIM cy  AS INTEGER
  DIM idx AS INTEGER

  FOR idx = 1 TO UBOUND(atlasitem)
  
    IF atlasitem(idx).allocated THEN
      '
      ' Get the new position near the same row as the prior location
      '
      AtlasNextRandom cx, cy

      '
      ' Move the item to the new location
      '
      AtlasMoveItem idx, cx, cy
   
    END IF

  NEXT
  
END SUB

FUNCTION AtlasPrompt (promptFor AS INTEGER, outcx AS INTEGER, outcy AS INTEGER, outpress AS STRING)
  '
  ' Prompts the user to select a cell and either returns the
  ' selected coordinates or (0,0) if canceled.
  '

  DIM keypress AS STRING
  DIM mx       AS INTEGER
  DIM my       AS INTEGER
  DIM valid    AS INTEGER

  mx = outcx
  my = outcy

  DO
 
    '
    ' Determine whether the current cell is valid
    '
    SELECT CASE promptFor
     
      CASE AtlasPromptFor.Any
        valid = True
     
      CASE AtlasPromptFor.Empty
        valid = atlasGrid(mx, my) = 0
     
      CASE AtlasPromptFor.EmptyOrSelf
        IF atlasGrid(mx, my) = 0 THEN
          valid = True
        ELSEIF (mx = outcx) AND (my = outcy) THEN
          valid = True
        ELSE
          valid = False
        END IF

      CASE AtlasPromptFor.Item
        valid = atlasGrid(mx, my) <> 0
   
    END SELECT

    '
    ' Highlight the current selection and wait for a key to be pressed
    '
    AtlasDrawSelect mx, my, valid
    keypress = GetKey$
    AtlasDrawUnselect mx, my

    SELECT CASE keypress
  
      CASE CHR$(ASCII.Escape)
        outpress = keypress
        AtlasPrompt = False
        EXIT FUNCTION

      CASE CHR$(ASCII.Return), " "
        IF valid THEN
          outcx = mx
          outcy = my
          outpress = keypress
          AtlasPrompt = True
          EXIT FUNCTION
        END IF

      CASE CHR$(0) + CHR$(ScanCode.Up)
        '
        ' Up
        '
        my = my - 1
        IF my = 0 THEN my = AtlasStyle.GridSizeY
 
      CASE CHR$(0) + CHR$(ScanCode.Down)
        '
        ' Down
        '
        my = my + 1
        IF my > AtlasStyle.GridSizeY THEN my = 1
     
      CASE CHR$(0) + CHR$(ScanCode.Left)
        '
        ' Left
        '
        mx = mx - 1
        IF mx = 0 THEN mx = AtlasStyle.GridSizeX
     
      CASE CHR$(0) + CHR$(ScanCode.Right)
        '
        ' Right
        '
        mx = mx + 1
        IF mx > AtlasStyle.GridSizeX THEN mx = 1

      CASE CHR$(0) + CHR$(ScanCode.Home)
        mx = 1

      CASE CHR$(0) + CHR$(ScanCode.End)
        mx = AtlasStyle.GridSizeX

      CASE CHR$(0) + CHR$(ScanCode.PageUp)
        my = 1

      CASE CHR$(0) + CHR$(ScanCode.PageDown)
        my = AtlasStyle.GridSizeY

    END SELECT

    EventIncName "AtlasMoves"

  LOOP

END FUNCTION

SUB AtlasRemoveItem (idx AS INTEGER)
  '
  ' Removes the specified item from the atlas.
  '

  DIM cx  AS INTEGER
  DIM cy  AS INTEGER

  IF atlasitem(idx).allocated THEN
 
    '
    ' Remove the item from the list
    '
    atlasitem(idx).allocated = False
 
    '
    ' Remove the item from the grid
    '
    cx = atlasitem(idx).cx
    cy = atlasitem(idx).cy

    atlasGrid(cx, cy) = 0
    AtlasDrawCell cx, cy
 
  END IF

END SUB

SUB AtlasRemoveValue (value AS INTEGER)
  '
  ' Removes the item with the specified value from the atlas
  '

  DIM idx AS INTEGER
  LET idx = AtlasIndexOf%(value)

  IF idx > 0 THEN
    AtlasRemoveItem idx
  END IF

END SUB

SUB AtlasSetLabel (idx AS INTEGER, labelrid AS INTEGER)
 
  AssertIsPositive idx, "AtlasSetLabel", "idx"

  atlasitem(idx).labelrid = labelrid
  AtlasDrawItem idx

END SUB

SUB AtlasSetStatus (text$)
  AtlasSetStatusEx text$, 7
END SUB

SUB AtlasSetStatusEx (text$, attr%)

  AtlasDrawBegin
 
  VIEW PRINT 25 TO 25
  DrawColor attr%
  CLS
  DrawText text$
  VIEW PRINT
 
  AtlasDrawEnd

END SUB

SUB ConsoleBegin
  VideoPushActive 0
END SUB

SUB ConsoleClear
  ConsoleBegin
  CLS
  ConsoleEnd
END SUB

SUB ConsoleEnd
  VideoPop
END SUB

SUB ConsoleFile (filename$)
  ConsoleBegin
  LOCATE 24, 1
  DrawFile filename$
  PRINT
  ConsoleEnd
END SUB

SUB ConsolePrint (text$)

  DIM x AS INTEGER
  DIM y AS INTEGER

  ConsoleBegin
  x = POS(0)
  y = CSRLIN
 
  LOCATE 24, 1
  DrawText text$
  PRINT
  LOCATE y, x
  ConsoleEnd

END SUB

FUNCTION DialogGarble$ (text$, percent!)

  CONST GarbleCode = 250
  CONST InSpaces = 0
  CONST InWord = 1
  CONST InGarble = 2

  DIM c AS STRING * 1
  DIM g AS STRING
  DIM i AS INTEGER
  DIM s AS INTEGER

  FOR i = 1 TO LEN(text$)

    c = MID$(text$, i, 1)

    SELECT CASE s
      CASE InSpaces
        IF c <> " " THEN
          IF RND <= percent! THEN
            g = g + "@X08" + CHR$(GarbleCode)
            s = InGarble
          ELSE
            g = g + c
            s = InWord
          END IF
        ELSE
          g = g + " "
        END IF
      CASE InWord
        IF c = " " THEN
          g = g + " "
          s = InSpaces
        ELSE
          g = g + c
        END IF
      CASE InGarble
        IF c = " " THEN
          g = g + "@X07 "
          s = InSpaces
        ELSE
          g = g + CHR$(GarbleCode)
        END IF
    END SELECT

  NEXT

  DialogGarble$ = g + "@X07"

END FUNCTION

SUB DialogNext (outpid%, outtext$)

  DIM handle AS INTEGER
  DIM text   AS STRING

  handle = FREEFILE
  OPEN "EMPIRE.DLG" FOR INPUT ACCESS READ AS #handle

  '
  ' Start on a random line
  '
  SEEK #handle, INT(RND * LOF(handle)) + 1
  LINE INPUT #handle, text
  IF EOF(handle) THEN
    SEEK #handle, 1
  END IF
 
  '
  ' Read the line
  '
  LINE INPUT #handle, text
  CLOSE #handle

  outtext$ = text
  outpid% = INT(RND * personas) + 1

END SUB

SUB DialogPrint (pid%, text$)

  DIM label$
  DIM name$

  name$ = PersonaGetName(pid%)
 
  label$ = PersonaGetLabel(pid%)
  IF label$ = "" THEN
    label$ = "@X1F " + name$ + " @X07"
  END IF

  IF LEFT$(text$, 1) = "(" THEN

    ConsolePrint STRING$((80 - DrawLength(text$)) / 2, " ") + "@X04" + text$ + "@X07"
    ConsolePrint ""

  ELSE

    DIM q$
  
    SELECT CASE INT(RND * 2)
      CASE 0:
        '
        ' Left justified
        '
        q$ = DialogGarble(text$, .2)

        ConsolePrint label$
        ConsolePrint "@X07" + text$ + "@X07"
        ConsolePrint ""

      CASE 1:
        '
        ' Right justified
        '
        q$ = DialogGarble(text$, .7)
      
        ConsolePrint STRING$(78 - DrawLength(label$), " ") + label$
        ConsolePrint STRING$(78 - DrawLength(text$), " ") + "@X07" + q$ + "@X07"
        ConsolePrint ""

    END SELECT

    AtlasSetStatus "@X1F " + name$ + " @X07 " + CHR$(34) + q$ + CHR$(34)

  END IF

END SUB

SUB DialogTimer
  '
  ' Executed periodically
  '

  IF RND > .5 THEN
    EXIT SUB
  END IF

  DIM aid%
  DIM pid%
  DIM text$

  aid% = GameArea%
  IF aid% = 0 THEN
    EXIT SUB
  END IF

  '
  ' Grab the next dialog
  '
  DialogNext pid%, text$

  '
  ' Print the dialog to the console
  '
  DialogPrint pid%, text$

END SUB

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

SUB DrawFile (filename AS STRING)
  '
  ' Draws a PCB file containing embedded color codes
  '

  DIM handle AS INTEGER
  DIM text AS STRING

  handle = FREEFILE
  OPEN filename FOR INPUT ACCESS READ AS #handle

  DO WHILE NOT EOF(handle)
    LINE INPUT #handle, text
    DrawText text + CHR$(ASCII.Return)
  LOOP

  CLOSE #handle

END SUB

SUB DrawFileAt (filename AS STRING, sx AS INTEGER, sy AS INTEGER)

  '
  ' Draws a PCB file containing embedded color codes
  '

  DIM lines AS INTEGER
  DIM text AS STRING

  OPEN filename FOR INPUT ACCESS READ AS #1

  DO WHILE NOT EOF(1)
   
    '
    ' Read the next line from the file
    '
    LINE INPUT #1, text

    '
    ' Position the cursor
    '
    LOCATE sy + lines, sx
    lines = lines + 1

    '
    ' Draw the text while expanding color codes
    '
    DrawText text
 
  LOOP

  CLOSE #1

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

FUNCTION EventFind% (name$)

  DIM eid%
  DIM ename$

  FOR eid% = 1 TO events
   
    ename$ = ResourceGet(event(eid%).namerid)

    IF name$ = ename$ THEN
      EventFind% = eid%
      EXIT FUNCTION
    END IF

  NEXT

  EventFind% = 0

END FUNCTION

SUB EventFire (eid%)

  DIM result%
  DIM tid%
 
  FOR tid% = 1 TO triggers
    IF EventTestTrigger%(eid%, tid%) THEN
      result% = ExecResource(trigger(tid%).cmdrid)
    END IF
  NEXT

END SUB

SUB EventInc (eid%)
  AssertIsPositive eid%, "EventInc", "eid"
  event(eid%).value = event(eid%).value + 1
  EventFire eid%
END SUB

SUB EventIncName (ename$)
  EventInc EventFind(ename$)
END SUB

FUNCTION EventParseOperator% (opname$)

  SELECT CASE opname$
    CASE "="
      EventParseOperator% = OpEquals
    CASE ELSE
      EventParseOperator% = OpNone
  END SELECT

END FUNCTION

SUB EventSet (eid%, value%)

  AssertIsPositive eid%, "EventFire", "eid"
  event(eid%).value = value%
  EventFire eid%

END SUB

FUNCTION EventTestTrigger% (eid%, tid%)

  AssertIsPositive eid%, "EventTestTrigger", "eid"
  AssertIsPositive eid%, "EventTestTrigger", "tid"

  IF trigger(tid%).eid <> eid% THEN
   
    EventTestTrigger = False

  ELSE

    SELECT CASE trigger(tid%).operator
      CASE OpEquals
        EventTestTrigger = trigger(tid%).operand = event(eid%).value
      CASE ELSE
        EventTestTrigger = False
    END SELECT

  END IF

END FUNCTION

FUNCTION ExecCmd% (text AS STRING)

  SHARED eid%
  SHARED fid%
  SHARED hid%
  SHARED pid%
  SHARED sid%
  SHARED tid%
  SHARED wid%

  DIM result%
  DIM ntoken%
  DIM stoken$(0 TO 5)

  ntoken% = Split(text, stoken$())
  IF ntoken% = 0 THEN
    ExecCmd% = CmdResult.OK
    EXIT FUNCTION
  ELSE
    stoken$(0) = LCASE$(stoken$(0))
  END IF

  IF fid% > 0 THEN
    result% = ExecCmdFid%(ntoken%, stoken$(), wid%, fid%)
  ELSEIF wid% > 0 THEN
    result% = ExecCmdWid%(ntoken%, stoken$(), wid%, fid%)
  ELSEIF eid% > 0 THEN
    result% = ExecCmdEid%(ntoken%, stoken$(), eid%)
  ELSEIF hid% > 0 THEN
    result% = ExecCmdHid%(ntoken%, stoken$(), hid%)
  ELSEIF pid% > 0 THEN
    result% = ExecCmdPid%(ntoken%, stoken$(), pid%)
  ELSEIF sid% > 0 THEN
    result% = ExecCmdSid%(ntoken%, stoken$(), sid%)
  ELSEIF tid% > 0 THEN
    result% = ExecCmdTid%(ntoken%, stoken$(), tid%)
  ELSE
    result% = ExecCmdRoot%(ntoken%, stoken$(), eid%, hid%, pid%, sid%, tid%, wid%)
  END IF

  Assert result% = CmdResult.OK, "ExecCmd", "Malformed: " + text

  ExecCmd% = result%

END FUNCTION

FUNCTION ExecCmdEid% (ntoken%, stoken$(), eid%)

  AssertIsPositive eid%, "ExecCmdEid", "eid"

  ExecCmdEid% = CmdResult.OK

  SELECT CASE stoken$(0)
   
    CASE "endevent"
      eid% = 0

    CASE "name"
      event(eid%).namerid = ResourceCreate(stoken$(1))

    CASE "value"
      event(eid%).value = VAL(stoken$(1))

    CASE ELSE
      ExecCmdEid% = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdFid% (ntoken%, stoken$(), wid%, fid%)

  AssertIsPositive wid%, "ExecCmdFid", "wid"
  AssertIsPositive fid%, "ExecCmdFid", "fid"

  DIM endtag AS STRING
  DIM kind%
  LET kind% = FieldGetKind(wid%, fid%)

  SELECT CASE kind%
    CASE FieldKind.Button
      endtag = "endbutton"
    CASE FieldKind.Box
      endtag = "endbox"
    CASE FieldKind.File
      endtag = "endfile"
    CASE FieldKind.Label
      endtag = "endlabel"
    CASE FieldKind.Popup
      endtag = "endpopup"
    CASE FieldKind.Separator
      endtag = "endseparator"
    CASE FieldKind.Boolean
      endtag = "endboolean"
    CASE FieldKind.Integer
      endtag = "endinteger"
    CASE FieldKind.Nebula
      endtag = "endnebula"
    CASE ELSE
      AssertFail "ExecCmdFid", "Unknown kind:" + STR$(kind%)
  END SELECT

  ExecCmdFid% = CmdResult.OK

  SELECT CASE stoken$(0)
    
    CASE endtag
      fid% = 0

    CASE "child"
      FieldSetChild wid%, fid%, stoken$(1)

    CASE "command"
      FieldSetCommand wid%, fid%, stoken$(1)

    CASE "offsetx"
      FieldSetOffsetX wid%, fid%, VAL(stoken$(1))

    CASE "offsety"
      FieldSetOffsetY wid%, fid%, VAL(stoken$(1))

    CASE "sizex"
      FieldSetSizeX wid%, fid%, VAL(stoken$(1))

    CASE "sizey"
      FieldSetSizeY wid%, fid%, VAL(stoken$(1))

    CASE "style"
      FieldSetStyle wid%, fid%, WinFindSid%(stoken$(1))

    CASE "text"
      IF LCASE$(stoken$(1)) = "bind" THEN
        FieldBindText wid%, fid%, stoken$(2)
      ELSE
        FieldSetText wid%, fid%, stoken$(1)
      END IF

    CASE "value"
      IF LCASE$(stoken$(1)) = "bind" THEN
        FieldBindValue wid%, fid%, stoken$(2)
      ELSE
        FieldSetValue wid%, fid%, stoken$(1)
      END IF

    CASE ELSE
      ExecCmdFid% = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdHid% (ntoken%, stoken$(), hid%)

  AssertIsPositive hid%, "ExecCmdHid", "hid"

  ExecCmdHid% = CmdResult.OK

  SELECT CASE stoken$(0)

    CASE "action"
      HabitatSetAction hid%, stoken$(1)
     
    CASE "backdrop"
      HabitatSetBackdrop hid%, stoken$(1)

    CASE "endhabitat"
      hid% = 0

    CASE "label"
      HabitatSetLabel hid%, stoken$(1)

    CASE "name"
      HabitatSetName hid%, stoken$(1)

    CASE "window"
      habitat(hid%).wid = WinFindWid(stoken$(1))

    CASE ELSE
      ExecCmdHid = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdPid% (ntoken%, stoken$(), pid%)

  AssertIsPositive pid%, "ExecCmdPid", "pid"

  SELECT CASE stoken$(0)
   
    CASE "endpersona"
      pid% = 0

    CASE "label"
      PersonaSetLabel pid%, stoken$(1)

    CASE "name"
      PersonaSetName pid%, stoken$(1)

  END SELECT
  
END FUNCTION

FUNCTION ExecCmdRoot% (ntoken%, stoken$(), eid%, hid%, pid%, sid%, tid%, wid%)

  AssertIsZero eid%, "ExecCmdRoot", "eid"
  AssertIsZero hid%, "ExecCmdRoot", "hid"
  AssertIsZero sid%, "ExecCmdRoot", "sid"
  AssertIsZero tid%, "ExecCmdRoot", "tid"
  AssertIsZero wid%, "ExecCmdRoot", "wid"

  ExecCmdRoot% = CmdResult.OK

  SELECT CASE stoken$(0)

    CASE "atlas"
      UI.SetPage UIPage.Atlas
 
    CASE "cls"
      ConsoleClear

    CASE "console"
      UI.SetPage UIPage.Console

    CASE "endgame"
      END

    CASE "event"
      events = events + 1
      eid% = events

    CASE "habitat"
      hid% = HabitatCreate%

    CASE "harvest"
      GameHarvest

    CASE "mail"
      InboxAdd stoken$(1), stoken$(2)
   
    CASE "newgame"
      WorldInit 15

    CASE "persona"
      pid% = PersonaCreate%

    CASE "print"
      ConsolePrint stoken$(1)

    CASE "printfile"
      ConsoleFile stoken$(1)

    CASE "replot"
      '
      ' Replot <band | cluster | manual | random>
      '
      UI.SetPage UIPage.Atlas
      SELECT CASE LCASE$(stoken$(1))
        CASE "b", "band"
          AtlasPlotBanded
        CASE "c", "cluster"
          AtlasPlotClustered
        CASE "m", "manual"
          AtlasPlotManual
        CASE "r", "random"
          AtlasPlotRandom
        CASE ELSE
          ExecCmdRoot% = CmdResult.Malformed
      END SELECT
   
    CASE "run"
      ExecFile stoken$(1)
   
    CASE "style"
      winstyles = winstyles + 1
      sid% = winstyles

    CASE "trigger"
      triggers = triggers + 1
      tid% = triggers

    CASE "window"
      wid% = WinCreate%

    CASE "winrun"
      WinRunName stoken$(1)

    CASE ELSE
      ExecCmdRoot% = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdSid% (ntoken%, stoken$(), sid%)

  AssertIsPositive sid%, "ExecCmdSid", "sid"

  ExecuteCommandSid% = CmdResult.OK

  SELECT CASE stoken$(0)
   
    CASE "bordercolor"
      winstyle(sid%).bordercolor = VAL(stoken$(1))

    CASE "bordertype"
      winstyle(sid%).bordertype = VAL(stoken$(1))

    CASE "endstyle"
      sid% = 0

    CASE "name"
      winstyle(sid%).stylename = stoken$(1)
  
    CASE "selectedcolor"
      winstyle(sid%).selectedcolor = VAL(stoken$(1))

    CASE "textcolor"
      winstyle(sid%).textcolor = VAL(stoken$(1))

    CASE ELSE
      ExecuteCommandSid% = CmdResult.Malformed

  END SELECT
  
END FUNCTION

FUNCTION ExecCmdTid% (ntoken%, stoken$(), tid%)

  AssertIsPositive tid%, "ExecCmdTid", "tid"

  SELECT CASE LCASE$(stoken$(0))

    CASE "command"
      trigger(tid%).cmdrid = ResourceCreate(stoken$(1))

    CASE "endtrigger"
      tid% = 0

    CASE "when"
      trigger(tid%).eid = EventFind(stoken$(1))
      trigger(tid%).operator = EventParseOperator(stoken$(2))
      trigger(tid%).operand = VAL(stoken$(3))

    CASE ELSE
      ExecCmdTid% = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdWid% (ntoken%, stoken$(), wid%, fid%)

  AssertIsPositive wid%, "ExecCmdWid", "wid"
  AssertIsZero fid%, "ExecCmdWid", "fid"

  ExecuteCommandWid% = CmdResult.OK

  IF ntoken% = 1 THEN

    SELECT CASE stoken$(0)
     
      CASE "endwindow"
        wid% = 0
     
      CASE "boolean"
        fid% = FieldCreate%(wid%, FieldKind.Boolean)

      CASE "box"
        fid% = FieldCreate%(wid%, FieldKind.Box)

      CASE "button"
        fid% = FieldCreate%(wid%, FieldKind.Button)
   
      CASE "file"
        fid% = FieldCreate%(wid%, FieldKind.File)

      CASE "integer"
        fid% = FieldCreate%(wid%, FieldKind.Integer)

      CASE "label"
        fid% = FieldCreate%(wid%, FieldKind.Label)
   
      CASE "nebula"
        fid% = FieldCreate%(wid%, FieldKind.Nebula)

      CASE "popup"
        fid% = FieldCreate%(wid%, FieldKind.Popup)

      CASE "separator"
        fid% = FieldCreate%(wid%, FieldKind.Separator)

      CASE ELSE
        ExecuteCommandWid% = CmdResult.Malformed

    END SELECT

    EXIT FUNCTION
  END IF

  IF ntoken% <> 2 THEN
    ExecuteCommandWid% = CmdResult.Malformed
    EXIT FUNCTION
  END IF

  SELECT CASE stoken$(0)

    CASE "arrowexit"
      win(wid%).arrowexit = VAL(stoken$(1))

    CASE "name"
      win(wid%).wname = stoken$(1)
 
    CASE "posx"
      win(wid%).posX = VAL(stoken$(1))

    CASE "posy"
      win(wid%).posY = VAL(stoken$(1))

    CASE "style"
      WinSetStyle wid%, WinFindSid%(stoken$(1))

    CASE ELSE
      result = CmdResult.Malformed

  END SELECT

END FUNCTION

SUB ExecFile (filename AS STRING)

  DIM handle AS INTEGER
  DIM result AS INTEGER
  DIM text   AS STRING

  handle = FREEFILE
  OPEN filename FOR INPUT ACCESS READ AS #handle

  DO WHILE NOT EOF(handle)
    LINE INPUT #handle, text
    result = ExecCmd(text)
  LOOP

  CLOSE #handle

END SUB

FUNCTION ExecResource% (rid AS INTEGER)

  AssertIsPositive rid, "ExecResource", "rid"

  DIM cmd$
  LET cmd$ = ResourceGet$(rid)

  IF LEN(cmd$) > 0 THEN
    ExecResource% = ExecCmd%(cmd$)
  END IF

END FUNCTION

SUB FieldBindText (wid%, fid%, expr$)

  AssertIsPositive wid%, "FieldBindText", "wid"
  AssertIsPositive fid%, "FieldBindText", "fid"

  ResourceSet fld(wid%, fid%).text.xrid, expr$

END SUB

SUB FieldBindValue (wid%, fid%, expr$)

  AssertIsPositive wid%, "FieldBindValue", "wid"
  AssertIsPositive fid%, "FieldBindValue", "fid"

  ResourceSet fld(wid%, fid%).value.xrid, expr$

END SUB

FUNCTION FieldCreate% (wid%, kind%)

  Assert wid% > 0, "FieldCreate", "wid cannot be 0"

  DIM fid%
  LET fid% = win(wid%).fields + 1

  win(wid%).fields = fid%
  fld(wid%, fid%).kind = kind%
  FieldCreate% = fid%

END FUNCTION

SUB FieldDraw (wid%, fid%)

  AssertIsPositive wid%, "FieldDraw", "wid"
  AssertIsPositive fid%, "FieldDraw", "fid"

  SELECT CASE FieldGetKind%(wid%, fid%)
    '
    ' Check the most common kinds first
    '
    CASE FieldKind.Button
      FieldDrawText wid%, fid%

    CASE FieldKind.Box
      FieldDrawBox wid%, fid%

    CASE FieldKind.Label
      FieldDrawText wid%, fid%

    CASE FieldKind.File
      FieldDrawFile wid%, fid%

    CASE FieldKind.Separator
      FieldDrawSeparator wid%, fid%

    CASE FieldKind.Nebula
      FieldDrawNebula wid%, fid%

    CASE ELSE
      FieldDrawText wid%, fid%

  END SELECT

END SUB

SUB FieldDrawBox (wid%, fid%)

  AssertIsPositive wid%, "FieldDrawBox", "wid"
  AssertIsPositive fid%, "FieldDrawBox", "fid"

  DIM sid%
  LET sid% = FieldGetStyle(wid%, fid%)

  SELECT CASE winstyle(sid%).bordertype
 
    CASE 0:
      FieldDrawBox0 wid%, fid%

    CASE 1:
      FieldDrawBox1 wid%, fid%

    CASE 2:
      FieldDrawBox2 wid%, fid%

  END SELECT

END SUB

SUB FieldDrawBox0 (wid%, fid%)

  AssertIsPositive wid%, "FieldDrawBox0", "wid"
  AssertIsPositive fid%, "FieldDrawBox0", "fid"

  DIM row AS INTEGER
  DIM sid AS INTEGER
  DIM sx  AS INTEGER
  DIM sy  AS INTEGER

  sid = FieldGetStyle(wid%, fid%)
  DrawColor winstyle(sid).textcolor
 
  FOR row = 1 TO fld(wid%, fid%).sizeY
   
    sx = win(wid%).posX + fld(wid%, fid%).offsetX
    sy = win(wid%).posY + fld(wid%, fid%).offsetY + row - 1

    LOCATE sy, sx
    PRINT STRING$(fld(wid%, fid%).sizeX, " ");
 
  NEXT

END SUB

SUB FieldDrawBox1 (wid%, fid%)

  AssertIsPositive wid%, "FieldDrawBox1", "wid"
  AssertIsPositive fid%, "FieldDrawBox1", "fid"

  CONST lowerFlat = "Ä"   ' CHR$(196)
  CONST lowerLeft = "À"   ' CHR$(192)
  CONST lowerRight = "Ù"  ' CHR$(217)
  CONST sideLeft = "³"    ' CHR$(179)
  CONST sideRight = "³"   ' CHR$(179)
  CONST upperLeft = "Ú"   ' CHR$(218)
  CONST upperFlat = "Ä"   ' CHR$(196)
  CONST upperRight = "¿"  ' CHR$(191)

  DIM r    AS INTEGER
  DIM sid  AS INTEGER
  DIM sx1  AS INTEGER ' Upper-left x-coord
  DIM sy1  AS INTEGER ' Upper-left y-coord
  DIM sx2  AS INTEGER ' Lower-right x-coord
  DIM sy2  AS INTEGER ' Lower-right y-coord

  '
  ' Calculate screen coordinates
  '
  sx1 = win(wid%).posX + fld(wid%, fid%).offsetX
  sy1 = win(wid%).posY + fld(wid%, fid%).offsetY
  sx2 = sx1 + fld(wid%, fid%).sizeX - 1
  sy2 = sy1 + fld(wid%, fid%).sizeY - 1

  sid = FieldGetStyle(wid%, fid%)

  '
  ' Draw the top border
  '
  LOCATE sy1, sx1
  DrawColor winstyle(sid).bordercolor
  PRINT upperLeft; STRING$(fld(wid%, fid%).sizeX - 2, upperFlat); upperRight;

  '
  ' Draw each row of the border
  '
  FOR r = sy1 + 1 TO sy2 - 1
    LOCATE r, sx1
    PRINT sideLeft;
  
    DrawColor winstyle(sid).textcolor
    PRINT STRING$(fld(wid%, fid%).sizeX - 2, " ");
  
    DrawColor winstyle(sid).bordercolor
    PRINT sideRight;
  NEXT
 
  '
  ' Draw the lower border
  '
  LOCATE sy2, sx1
  PRINT lowerLeft; STRING$(fld(wid%, fid%).sizeX - 2, lowerFlat); lowerRight;

END SUB

SUB FieldDrawBox2 (wid%, fid%)

  AssertIsPositive wid%, "FieldDrawBox2", "wid"
  AssertIsPositive fid%, "FieldDrawBox2", "fid"

  DIM idx AS INTEGER
  DIM row AS INTEGER
  DIM sx  AS INTEGER
  DIM sy  AS INTEGER

  '
  ' Initialize special border characters
  '
  DIM ch(0 TO 8) AS STRING * 1  ' Character
  DIM fc(0 TO 8) AS INTEGER     ' Forecolor
  DIM bc(0 TO 8) AS INTEGER     ' Backcolor

  ch(0) = CHR$(179): bc(0) = 0: fc(0) = 13
  ch(1) = CHR$(219): bc(1) = 5: fc(1) = 13
  ch(2) = CHR$(178): bc(2) = 5: fc(2) = 13
  ch(3) = CHR$(177): bc(3) = 5: fc(3) = 13
  ch(4) = CHR$(176): bc(4) = 5: fc(4) = 13
  ch(5) = CHR$(219): bc(5) = 0: fc(5) = 5
  ch(6) = CHR$(178): bc(6) = 0: fc(6) = 5
  ch(7) = CHR$(177): bc(7) = 0: fc(7) = 5
  ch(8) = CHR$(176): bc(8) = 0: fc(8) = 5

  '
  ' Top border
  '
  sx = win(wid%).posX + fld(wid%, fid%).offsetX
  sy = win(wid%).posY + fld(wid%, fid%).offsetY
  LOCATE sy, sx
  COLOR fc(0), bc(0)
  PRINT CHR$(220);
  PRINT STRING$(fld(wid%, fid%).sizeX - 2, 196);
  PRINT CHR$(191);

  FOR row = 1 TO fld(wid%, fid%).sizeY - 2

    '
    ' Get the index of the left border character
    '
    idx = row
    IF idx > UBOUND(ch) THEN
      idx = 0
    END IF

    '
    ' Left border
    '
    sx = win(wid%).posX + fld(wid%, fid%).offsetX
    sy = win(wid%).posY + fld(wid%, fid%).offsetY + row
    LOCATE sy, sx
    COLOR fc(idx), bc(idx)
    PRINT ch(idx);

    '
    ' Inner space
    '
    COLOR fc(0), bc(0)
    PRINT STRING$(fld(wid%, fid%).sizeX - 2, " ");

    '
    ' Get the index of the right border char
    '
    idx = fld(wid%, fid%).sizeY - row - 1

    IF idx > UBOUND(ch) THEN idx = 0

    '
    ' Right border
    '
    COLOR fc(idx), bc(idx)
    PRINT ch(idx);

  NEXT

  '
  ' Bottom border
  '
  sy = win(wid%).posY + fld(wid%, fid%).sizeY - 1
  LOCATE sy, sx
  COLOR fc(0), bc(0)
  PRINT CHR$(192);
  PRINT STRING$(fld(wid%, fid%).sizeX - 2, 196);
  PRINT CHR$(223);

END SUB

SUB FieldDrawFile (wid%, fid%)

  AssertIsPositive wid%, "FieldDrawFile", "wid"
  AssertIsPositive fid%, "FieldDrawFile", "fid"

  DIM filename AS STRING
  DIM sx AS INTEGER
  DIM sy AS INTEGER

  filename = FieldGetValue$(wid%, fid%)
  IF LEN(filename) = 0 THEN
    EXIT SUB
  END IF

  sx = win(wid%).posX + fld(wid%, fid%).offsetX
  sy = win(wid%).posY + fld(wid%, fid%).offsetY

  DrawFileAt filename, sx, sy

END SUB

SUB FieldDrawNebula (wid%, fid%)

  DIM p  AS INTEGER
  DIM sx AS INTEGER
  DIM sy AS INTEGER
  DIM x  AS INTEGER
  DIM y  AS INTEGER

  COLOR 7, 0

  FOR y = 1 TO fld(wid%, fid%).sizeY
 
    x = INT(RND * fld(wid%, fid%).sizeX) + 1
    p = 1

    sx = win(wid%).posX + fld(wid%, fid%).offsetX + x - 1
    sy = win(wid%).posY + fld(wid%, fid%).offsetY + y - 1
    LOCATE sy, sx

    DO
    
      '
      ' Calculate the next p value. -1=stop, 0=space, or 1,2,3
      '
      SELECT CASE p
  
        CASE 0
          SELECT CASE INT(RND * 3)
            CASE 0
              p = 1
            CASE ELSE
              EXIT DO
          END SELECT
  
        CASE 1
          SELECT CASE INT(RND * 4)
            CASE 0
              p = 0
            CASE 1
              p = 2
            CASE ELSE
              p = 1
          END SELECT
  
        CASE 2
          SELECT CASE INT(RND * 4)
            CASE 0
              p = 1
            CASE 1
              p = 3
            CASE ELSE
              p = 2
          END SELECT
  
        CASE 3
          SELECT CASE INT(RND * 4)
            CASE 0
              p = 3
            CASE ELSE
              p = 2
          END SELECT

      END SELECT
     
      '
      ' Draw the p value
      '
      SELECT CASE p
        CASE 1
          COLOR 8
          PRINT "Ä";
        CASE 2
          COLOR 7
          PRINT "Ä";
        CASE 3
          COLOR 15
          PRINT "Ä";
        CASE 0
          PRINT " ";
      END SELECT
   
      x = x + 1
      IF x > fld(wid%, fid%).sizeX THEN
        EXIT DO
      END IF

    LOOP

  NEXT

END SUB

SUB FieldDrawSeparator (wid%, fid%)

  AssertIsPositive wid%, "FieldDrawSeparator", "wid"
  AssertIsPositive fid%, "FieldDrawSeparator", "fid"

  DIM row AS INTEGER
  DIM sid AS INTEGER
  DIM sx  AS INTEGER
  DIM sy  AS INTEGER

  sid = FieldGetStyle(wid%, fid%)
  sx = win(wid%).posX + fld(wid%, fid%).offsetX
  sy = win(wid%).posY + fld(wid%, fid%).offsetY

  LOCATE sy, sx
  DrawColor winstyle(sid).bordercolor

  IF fld(wid%, fid%).sizeX > 0 THEN
    '
    ' Left edge
    '
    SELECT CASE SCREEN(sy, sx)
      CASE 179            ' ³
        PRINT CHR$(195);  ' Ã
      CASE 186            ' º
        PRINT CHR$(199);  ' Ç
      CASE ELSE           '
        PRINT CHR$(196);  ' Ä
    END SELECT
   
    '
    ' Inner separator
    '
    PRINT STRING$(fld(wid%, fid%).sizeX - 2, 196);

    '
    ' Right edge
    '
    SELECT CASE SCREEN(sy, sx + fld(wid%, fid%).sizeX - 1)
      CASE 179            ' ³
        PRINT CHR$(180);  ' ´
      CASE 186            ' º
        PRINT CHR$(182);  ' ¶
      CASE ELSE           '
        PRINT CHR$(196);  ' Ä
    END SELECT

  ELSEIF fld(wid%, fid%).sizeY > 0 THEN
   
    '
    ' Top edge
    '
    SELECT CASE SCREEN(sy, sx)
      CASE 196            ' Ä
        PRINT CHR$(194);  ' Â
      CASE 205            ' Í
        PRINT CHR$(209);  ' Ñ
      CASE ELSE           '
        PRINT CHR$(179);  ' ³
    END SELECT

    FOR row = sy + 1 TO sy + fld(wid%, fid%).sizeY - 2
      LOCATE row, sx
      PRINT CHR$(179);
    NEXT

    '
    ' Bottom edge
    '
    LOCATE sy + fld(wid%, fid%).sizeY - 1, sx
    SELECT CASE SCREEN(sy + fld(wid%, fid%).sizeY - 1, sx)
      CASE 196            ' Ä
        PRINT CHR$(193);  ' Á
      CASE 205            ' Í
        PRINT CHR$(207);  ' Ï
      CASE ELSE           '
        PRINT CHR$(179);  ' ³
    END SELECT

  END IF

END SUB

SUB FieldDrawText (wid%, fid%)

  AssertIsPositive wid%, "FieldDrawText", "wid"
  AssertIsPositive fid%, "FieldDrawText", "fid"
 
  DIM sid  AS INTEGER
  DIM size AS INTEGER
  DIM sx   AS INTEGER
  DIM sy   AS INTEGER
  DIM text AS STRING

  '
  ' Get field position
  '
  sx = win(wid%).posX + fld(wid%, fid%).offsetX
  sy = win(wid%).posY + fld(wid%, fid%).offsetY
  LOCATE sy, sx

  '
  ' Set style of text
  '
  sid% = FieldGetStyle(wid%, fid%)
  IF win(wid%).selected = fid% THEN
    DrawColor winstyle(sid%).selectedcolor
  ELSE
    DrawColor winstyle(sid%).textcolor
  END IF

  '
  ' Print text clipped to size
  '
  text = FieldGetText(wid%, fid%)
  size = fld(wid%, fid%).sizeX
  IF size < 1 THEN
    PRINT text;
  ELSE
    PRINT LEFT$(text, size);
    IF LEN(text) < size THEN
      PRINT STRING$(size - LEN(text), " ");
    END IF
  END IF

END SUB

FUNCTION FieldGetBound$ (wid%, fid%, b AS BindingType)

  IF b.xrid = 0 THEN
    '
    ' No expression, return value
    '
    FieldGetBound$ = ResourceGet(b.vrid)
    EXIT FUNCTION

  END IF

  '
  ' Get the context of the binding
  '
  DIM aid%: aid% = GameArea%
  DIM hid%: hid% = GameHabitat%

  DIM text$: xtext$ = LCASE$(ResourceGet(b.xrid))

  SELECT CASE xtext$

    CASE "area.energy"
      FieldGetBound$ = STR$(GameAreaEnergy%)
      EXIT FUNCTION

    CASE "habitat.backdrop"
      FieldGetBound$ = HabitatGetBackdrop$(hid%)
      EXIT FUNCTION

    CASE "habitat.title"
      FieldGetBound$ = HabitatGetName$(hid%)
      EXIT FUNCTION

    CASE "sel:value"

      DIM sel%
      LET sel% = win(wid%).selected

      IF sel% = 0 THEN
        '
        ' No selected field to get a value
        '
        FieldGetBound$ = ""
       
      ELSEIF sel% = fid% THEN
        '
        ' Infinite recursion
        '
        FieldGetBound$ = ""
       
      ELSE
        FieldGetBound$ = FieldGetValue(wid%, win(wid%).selected)

      END IF

    CASE ELSE
      AssertFail "FieldGetBound", "Invalid binding: " + xtext$

  END SELECT

END FUNCTION

FUNCTION FieldGetKind% (wid%, fid%)
  FieldGetKind% = fld(wid%, fid%).kind
END FUNCTION

FUNCTION FieldGetStyle% (wid%, fid%)

  AssertIsPositive wid%, "FieldGetStyle", "wid"
  AssertIsPositive fid%, "FieldGetStyle", "fid"

  DIM sid%

  sid% = fld(wid%, fid%).sid
  IF sid% = 0 THEN
    sid% = win(wid%).sid
  END IF

  FieldGetStyle% = sid%
  
END FUNCTION

FUNCTION FieldGetText$ (wid%, fid%)

  FieldGetText$ = FieldGetBound$(wid%, fid%, fld(wid%, fid%).text)

END FUNCTION

FUNCTION FieldGetValue$ (wid%, fid%)

  AssertIsPositive wid%, "FieldGetValue", "wid"
  AssertIsPositive fid%, "FieldGetValue", "fid"

  FieldGetValue$ = FieldGetBound(wid%, fid%, fld(wid%, fid%).value)

END FUNCTION

FUNCTION FieldIsBound% (wid%, fid%)

  IF fld(wid%, fid%).text.xrid > 0 THEN
    FieldIsBound% = True
  ELSEIF fld(wid%, fid%).value.xrid > 0 THEN
    FieldIsBound% = True
  ELSE
    FieldIsBound = False
  END IF

END FUNCTION

FUNCTION FieldIsSelectable% (wid%, fid%)
  '
  ' Returns True or False depending on whether the specified
  ' field is selectable (i.e., can receive focus for input or
  ' selection).
  '
  
  IF wid% < 0 OR fid% <= 0 THEN

    FieldIsSelectable = False

  ELSEIF fid% > win(wid%).fields THEN
   
    FieldIsSelectable% = False
 
  ELSE

    SELECT CASE FieldGetKind%(wid%, fid%)
      CASE FieldKind.Button
        FieldIsSelectable = True

      CASE FieldKind.Boolean
        FieldIsSelectable = True

      CASE FieldKind.Integer
        FieldIsSelectable = True

      CASE FieldKind.Popup
        FieldIsSelectable = True

      CASE ELSE
        FieldIsSelectable = False

    END SELECT

  END IF

END FUNCTION

SUB FieldKey (wid%, fid%, keypress$)
  '
  ' Sends a keystroke to a field
  '
 
  AssertIsPositive wid%, "FieldKey", "wid"

  IF fid% > 0 THEN

    SELECT CASE FieldGetKind%(wid%, fid%)
  
      CASE FieldKind.Boolean
        FieldKeyBoolean wid%, fid%, keypress$

      CASE FieldKind.Integer
        FieldKeyInteger wid%, fid%, keypress$

    END SELECT
 
  END IF

END SUB

SUB FieldKeyBoolean (wid%, fid%, keypress$)
  '
  ' Sends a keystroke to a boolean field.
  '
 
  DIM text AS STRING
  LET text = FieldGetText$(wid%, fid%)

  SELECT CASE keypress$

    CASE " "
      SELECT CASE text
        CASE "No"
          FieldSetText wid%, fid%, "Yes"
        CASE "Yes"
          FieldSetText wid%, fid%, "No"
      END SELECT

    CASE "n", "N"
      FieldSetText wid%, fid%, "No"

    CASE "y", "Y"
      FieldSetText wid%, fid%, "Yes"

  END SELECT

END SUB

SUB FieldKeyInteger (wid%, fid%, keypress$)
  '
  ' Sends a key to an integer field
  '

  DIM buf$
  LET buf$ = FieldGetText$(wid%, fid%)

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

  FieldSetText wid%, fid%, buf$

END SUB

SUB FieldSetBound (wid%, fid%, b AS BindingType, value$)

  AssertIsPositive wid%, "FieldSetBound", "wid"
  AssertIsPositive fid%, "FieldSetBound", "fid"

  IF b.xrid = 0 THEN
    '
    ' No expression, set value directly
    '
    ResourceSet b.vrid, value$
  ELSE
    
    DIM xtext$
    LET xtext$ = ResourceGet(b.xrid)

    SELECT CASE xtext$
     
      CASE "area.energy"
        DIM aid%
        LET aid% = AtlasGetValue(uicx, uicy, 0)
        IF aid% > 0 THEN
          area(aid%).energy = VAL(value$)
        END IF

      CASE ELSE
        AssertFail "FieldSetBound", "Unknown binding: " + xtext$

    END SELECT

  END IF

END SUB

SUB FieldSetChild (wid%, fid%, wname$)

  AssertIsPositive wid%, "FieldSetChild", "wid"
  AssertIsPositive fid%, "FieldSetChild", "fid"

  fld(wid%, fid%).childwid = WinFindWid%(wname$)

END SUB

SUB FieldSetCommand (wid%, fid%, cmd$)

  AssertIsPositive wid%, "FieldSetCommand", "wid"
  AssertIsPositive fid%, "FieldSetCommand", "fid"

  ResourceSet fld(wid%, fid%).cmdrid, cmd$

END SUB

SUB FieldSetOffsetX (wid%, fid%, offsetX%)
  fld(wid%, fid%).offsetX = offsetX%
END SUB

SUB FieldSetOffsetY (wid%, fid%, offsetY%)
  fld(wid%, fid%).offsetY = offsetY%
END SUB

SUB FieldSetSizeX (wid%, fid%, sizeX%)
  fld(wid%, fid%).sizeX = sizeX%
END SUB

SUB FieldSetSizeY (wid%, fid%, sizeY%)
  fld(wid%, fid%).sizeY = sizeY%
END SUB

SUB FieldSetStyle (wid%, fid%, sid%)
  fld(wid%, fid%).sid = sid%
END SUB

SUB FieldSetText (wid%, fid%, value$)

  AssertIsPositive wid%, "FieldSetText", "wid"
  AssertIsPositive fid%, "FieldSetText", "fid"

  FieldSetBound wid%, fid%, fld(wid%, fid%).text, value$

END SUB

SUB FieldSetValue (wid%, fid%, value$)

  AssertIsPositive wid%, "FieldSetValue", "wid"
  AssertIsPositive fid%, "FieldSetValue", "fid"

  FieldSetBound wid%, fid%, fld(wid%, fid%).value, value$

END SUB

FUNCTION GameArea%

  IF (uicx > 0) AND (uicy > 0) THEN
    GameArea% = AtlasGetValue(uicx, uicy, 0)
  END IF

END FUNCTION

FUNCTION GameAreaEnergy%
 
  DIM aid%
  aid% = GameArea
  IF aid% > 0 THEN
    GameAreaEnergy = area(aid%).energy
  END IF

END FUNCTION

FUNCTION GameHabitat%

  DIM aid%: aid% = GameArea%
  IF aid% > 0 THEN
    GameHabitat% = area(aid%).hid
  END IF

END FUNCTION

SUB GameHarvest

  DIM aid%
  DIM energy%

  aid% = GameArea%
  IF aid% > 0 THEN
    WorldHarvest aid%
  END IF

END SUB

FUNCTION GetKey$
  '
  ' Waits for a key to be pressed and returns the string representing
  ' the character or the keystroke. This function is the same as INKEY$
  ' except it does not return until a key is actually pressed.
  '

  DIM k AS STRING

  DO
    'SLEEP (0)
    k = INKEY$
  LOOP UNTIL LEN(k)

  GetKey$ = k

END FUNCTION

FUNCTION HabitatCreate%
  habitats = habitats + 1
  HabitatCreate% = habitats
END FUNCTION

FUNCTION HabitatGetBackdrop$ (hid%)
  IF hid% > 0 THEN
    HabitatGetBackdrop$ = ResourceGet(habitat(hid%).backdrop)
  END IF
END FUNCTION

FUNCTION HabitatGetName$ (hid%)
  IF hid% > 0 THEN
    HabitatGetName$ = ResourceGet$(habitat(hid%).namerid)
  END IF
END FUNCTION

SUB HabitatSetAction (hid%, cmd$)
  ResourceSet habitat(hid%).actionrid, cmd$
END SUB

SUB HabitatSetBackdrop (hid%, backdrop$)
  ResourceSet habitat(hid%).backdrop, backdrop$
END SUB

SUB HabitatSetLabel (hid%, label$)
  ResourceSet habitat(hid%).labelrid, label$
END SUB

SUB HabitatSetName (hid%, hname$)
  ResourceSet habitat(hid%).namerid, hname$
END SUB

SUB InboxAdd (subject AS STRING, filename AS STRING)
 
  DIM fid%
  DIM wid%
 
  SHARED count AS INTEGER

  count = count + 1

  wid% = WinFindWid("Inbox")
  fid% = WinAddButton(wid%, 1, count, 20, " " + subject, filename)

  AtlasSetStatus "Mail arrived"
  ConsoleFile "NEWMAIL.PCB"

END SUB

FUNCTION NebulaLabel$ (energy AS INTEGER)

  DIM label AS STRING

  SELECT CASE energy

    CASE 0:
      label = " @X08Ä  "

    CASE 1:
      SELECT CASE INT(RND * 4)
        CASE 0: label = "@X08Ä - "
        CASE 1: label = "@X08 ÄÄ "
        CASE 2: label = "@X08 Ä Ä"
        CASE 3: label = "@X08Ä  Ä"
      END SELECT

    CASE 2:
      SELECT CASE INT(RND * 4)
        CASE 0: label = "@X08Ä@X07Ä @X08Ä"
        CASE 1: label = "@X08Ä @X07Ä@X08Ä"
        CASE 2: label = " @X08Ä@X07Ä@X08Ä"
        CASE 3: label = "@X08Ä@X07ÄÄ@X08Ä"
      END SELECT

    CASE 3:
      SELECT CASE INT(RND * 3)
        CASE 0: label = "@X08Ä@X07Ä@X0FÄ@X07"
        CASE 1: label = "@X07ÄÄ@X0FÄ@X07Ä"
        CASE 2: label = "@X08Ä @X0FÄ@X08Ä"
      END SELECT

    CASE ELSE
      label = ""

  END SELECT

  NebulaLabel$ = label

END FUNCTION

FUNCTION NebulaLabelRid% (energy AS INTEGER)

  Assert energy >= 0, "NebulaLabelRid", "energy must be 0 or greater"
  Assert energy <= 3, "NebulaLabelRid", "energy must be 3 or less"

  STATIC created AS INTEGER
  STATIC lrid() AS INTEGER

  IF created = 0 THEN
    REDIM lrid(0 TO 3)
    FOR created = 0 TO 3
      lrid(created) = ResourceCreate(NebulaLabel$(created))
    NEXT
  END IF

  NebulaLabelRid% = lrid(energy)

END FUNCTION

FUNCTION PersonaCreate%
  personas = personas + 1
  PersonaCreate% = personas
END FUNCTION

FUNCTION PersonaGetLabel$ (pid%)
  PersonaGetLabel$ = ResourceGet$(persona(pid%).labelrid)
END FUNCTION

FUNCTION PersonaGetName$ (pid%)
  PersonaGetName$ = ResourceGet$(persona(pid%).namerid)
END FUNCTION

SUB PersonaSetLabel (pid%, label$)
  ResourceSet persona(pid%).labelrid, label$
END SUB

SUB PersonaSetName (pid%, text$)
  ResourceSet persona(pid%).namerid, text$
END SUB

FUNCTION ResourceCreate% (value AS STRING)

  IF resources = UBOUND(resource) THEN
   
    AssertFail "ResourceCreate", "Out of resource space"
    ResourceCreate% = 0

  ELSEIF value = "" THEN

    ResourceCreate% = 0

  ELSE

    resources = resources + 1
    resource(resources) = value
    ResourceCreate% = resources

  END IF

END FUNCTION

FUNCTION ResourceGet$ (rid AS INTEGER)
  IF rid = 0 THEN
    '
    ' Resource 0 is always an empty string
    '
    ResourceGet$ = ""
  ELSE
    ResourceGet$ = resource(rid)
  END IF
END FUNCTION

SUB ResourceSet (outrid AS INTEGER, value AS STRING)

  IF outrid = 0 THEN
    outrid = ResourceCreate(value)
  ELSE
    resource(outrid) = value
  END IF

END SUB

SUB SetupGame

  SCREEN 0, 0, 0, 0: WIDTH 80: COLOR 7, 0: KEY OFF: CLS : RANDOMIZE TIMER
 
  '
  ' Load menus and windows
  '
  ExecFile "EMPIRE.CFG"

  '
  ' Setup atlas
  '
  atlaspage = VideoAlloc%
  AtlasDraw

  '
  ' Show starting window #1
  '
  DIM cresult AS INTEGER
  DIM wresult AS WinResultType
 
  WinRun WinFindWid("Start"), wresult
 
  IF wresult.action = WinAction.Execute THEN
    cresult = ExecResource%(wresult.cmdrid)
  END IF

  TIMER ON

END SUB

FUNCTION Split% (text AS STRING, tokens() AS STRING)

  CONST StateNone = 0
  CONST StateToken = 1
  CONST StateComment = 2

  DIM char  AS STRING * 1
  DIM count AS INTEGER
  DIM index AS INTEGER
  DIM lower AS INTEGER
  DIM quote AS STRING
  DIM state AS INTEGER

  '
  ' Calculate how to convert a count (1,2,3...) to an index element.
  '
  DIM offset: offset = LBOUND(tokens) - 1

  FOR index = 1 TO LEN(text)

    char = MID$(text, index, 1)

    SELECT CASE state
      CASE StateNone:
        '
        ' No token being parsed
        '
        IF char = "," THEN
          '
          ' Empty token
          '
          count = count + 1
          tokens(count + offset) = ""

        ELSEIF char = CHR$(34) THEN
          '
          ' Start quoted token
          '
          count = count + 1
          quote = char
          tokens(count + offset) = ""
          state = StateToken
       
        ELSEIF char = ";" THEN
          '
          ' Start comment
          '
          state = StateComment
          EXIT FOR

        ELSEIF char <> " " THEN
          '
          ' Start non-quoted token
          '
          count = count + 1
          quote = ""
          tokens(count + offset) = char
          state = StateToken

        END IF

      CASE StateToken:
        
        IF char = " " THEN
          IF quote = "" THEN
            '
            ' This is not a quoted token
            '
            state = 0
          ELSE
            tokens(count + offset) = tokens(count + offset) + char
          END IF
        ELSEIF char = quote THEN
          state = 0
        ELSE
          tokens(count + offset) = tokens(count + offset) + char
        END IF

    END SELECT

  NEXT

  Split% = count

END FUNCTION

SUB UI.Action
  '
  ' Applies the default action to the currently selected location
  '
 
  DIM aid AS INTEGER
  DIM hid AS INTEGER

  '
  ' Get the current area
  '
  aid = AtlasGetValue(uicx, uicy, 0)
  IF aid > 0 THEN

    '
    ' Get the habitat of the area
    '
    hid = area(aid).hid

    'SELECT CASE habitat(hid).UI
    '  CASE "NEB"
    '    UI.ActionNebula aid
    'END SELECT

  END IF

END SUB

SUB UI.ActionNebula (aid AS INTEGER)

  AssertIsPositive aid, "UI.ActionNebula", "aid"

  DIM energy AS INTEGER
  LET energy = area(aid).energy

  '
  ' Set the default energy
  '
  IF energy = 0 THEN
    energy = 3
  END IF

  IF energy = 1 THEN
   
    '
    ' This is the last extraction
    '
    WorldRemove aid
    EventIncName "NebulaDepleted"

  ELSE
   
    '
    ' Extract one energy
    '
    energy = energy - 1
    area(aid).energy = energy
    WorldSetLabel aid, NebulaLabelRid(energy)

  END IF

END SUB

SUB UI.Run
 
  DIM menuwid AS INTEGER
  DIM cresult AS INTEGER
  DIM wresult AS WinResultType

  UI.SetPage UIPage.Atlas

  menuwid = WinFindWid("Menu")

  DO
    
    Assert uiCurrentPage <> UIPage.None, "UI.Run", "UI page must be set"

    SELECT CASE uiCurrentPage
    
      CASE UIPage.Atlas
        UI.RunAtlas

      CASE UIPage.Console
        UI.RunConsole

    END SELECT

    WinRun menuwid, wresult
    IF wresult.action = WinAction.Execute THEN
      cresult = ExecResource%(wresult.cmdrid)
    END IF

  LOOP

END SUB

SUB UI.RunAtlas
 
  Assert uiCurrentPage = UIPage.Atlas, "UI.RunAtlas", "Wrong UI page"

  DIM aid      AS INTEGER
  DIM cresult  AS INTEGER
  DIM hid      AS INTEGER
  DIM outpress AS STRING
  DIM wresult  AS WinResultType
 
  '
  ' Set the default position if this is the first run
  '
  IF uicx = 0 THEN uicx = 1
  IF uicy = 0 THEN uicy = 1

PromptAgain:

  IF AtlasPrompt(AtlasPromptFor.Item, uicx, uicy, outpress) THEN

    SELECT CASE outpress
     
      CASE CHR$(ASCII.Return)
      
        '
        ' Get the current area
        '
        aid = AtlasGetValue(uicx, uicy, 0)
 
        '
        ' Get the habitat of the area
        '
        hid = area(aid).hid
       
        '
        ' Run the window name handling this habitat
        '
        IF habitat(hid).wid > 0 THEN
          WinRun habitat(hid).wid, wresult
          IF wresult.action = WinAction.Execute THEN
            cresult = ExecResource%(wresult.cmdrid)
          END IF
        END IF

      CASE " "
        UI.Action

    END SELECT

    '
    ' Keep one GOTO in this code just to break the rules.
    '
    GOTO PromptAgain

  ELSE
    '
    ' The player hit escape
    '

  END IF

END SUB

SUB UI.RunConsole

  Assert uiCurrentPage = UIPage.Console, "UI.RunConsole", "Wrong UI page"

  DIM keypress$: keypress$ = GetKey$

END SUB

SUB UI.SetPage (page AS INTEGER)
 
  Assert page <> UIPage.None, "UI.SetPage", "page cannot be 0"

  SELECT CASE page
   
    CASE UIPage.Atlas
      VideoScreen atlaspage, atlaspage

    CASE UIPage.Console
      VideoScreen 0, 0

    CASE ELSE
      VideoScreen 0, 0

  END SELECT

  uiCurrentPage = page
 
END SUB

FUNCTION VideoAlloc%

  DIM bit  AS INTEGER
  DIM mask AS INTEGER

  FOR bit = 1 TO 7
   
    mask = 2 ^ bit

    IF (vallocated AND mask) = 0 THEN
      vallocated = vallocated OR mask
      VideoAlloc% = bit
      EXIT FUNCTION
    END IF

  NEXT

  VideoAlloc% = 0

END FUNCTION

SUB VideoFree (pagenum%)

  DIM mask%
  LET mask% = NOT (2 ^ pagenum%)
  vallocated = vallocated AND mask%

END SUB

FUNCTION VideoGetActive%

  VideoGetActive = (vstack(vstacked) AND &HF0) / 16

END FUNCTION

FUNCTION VideoGetVisual%
  VideoGetVisual% = vstack(vstacked) AND &HF
END FUNCTION

SUB VideoPop

  IF vstacked = 0 THEN
   
    AssertFail "VideoPop", "No page stack to pop"

  ELSE

    vstacked = vstacked - 1
   
    DIM p%: p% = vstack(vstacked)

    SCREEN , , (p% AND &HF0) / 16, (p% AND &HF)

  END IF

END SUB

SUB VideoPushActive (active%)
  '
  ' Use this to temporarily write to a specific video
  ' page and then call VideoPop to restore the current
  ' active and display pages.
  '
  DIM newpages AS INTEGER
 
  newpages = (vstack(vstacked) AND &HF) + (active% * 16)
  vstacked = vstacked + 1
  vstack(vstacked) = newpages

  SCREEN , , active%, vstack(vstacked) AND &HF

END SUB

SUB VideoScreen (activepage%, visualpage%)

  vstack(vstacked) = (activepage% * 16) + visualpage%
  SCREEN , , activepage%, visualpage%
  
END SUB

FUNCTION WinAddButton% (wid%, offsetX%, offsetY%, sizeX%, text$, value$)

  AssertIsPositive wid%, "WinAddButton", "wid"

  DIM fid%
  LET fid% = FieldCreate(wid%, FieldKind.Button)

  fld(wid%, fid%).childwid = 0
  fld(wid%, fid%).cmdrid = 0
  fld(wid%, fid%).offsetX = offsetX%
  fld(wid%, fid%).offsetY = offsetY%
  fld(wid%, fid%).sizeX = sizeX%
  fld(wid%, fid%).text.vrid = ResourceCreate(text$)
  fld(wid%, fid%).text.xrid = 0
  fld(wid%, fid%).value.vrid = ResourceCreate(value$)
  fld(wid%, fid%).value.xrid = 0

  WinAddButton% = fid%

END FUNCTION

SUB WinClose (wid%)

  AssertIsPositive wid%, "WinClose", "wid"

  IF winstacked = 0 THEN
  
    AssertFail "WinClose", "No windows"

  ELSEIF winstack(winstacked).wid <> wid% THEN

    AssertFail "WinClose", "Not supported; specify top window only"

  ELSE

    '
    ' Change active and visual display to the backpage
    '
    VideoScreen winstack(winstacked).backpage, winstack(winstacked).backpage
    VideoFree winstack(winstacked).workpage
    winstacked = winstacked - 1

  END IF

END SUB

FUNCTION WinCreate%
  wincount = wincount + 1
  WinCreate% = wincount
END FUNCTION

SUB WinDraw (wid%)

  AssertIsPositive wid%, "WinDraw", "wid"

  DIM fid%
  FOR fid% = 1 TO win(wid%).fields
    FieldDraw wid%, fid%
  NEXT

END SUB

FUNCTION WinFindSid% (sname$)

  DIM sid%
 
  '
  ' Check for numeric ID
  '
  sid% = VAL(sname$)
  IF sid% > 0 THEN
    IF sid% >= LBOUND(winstyle) AND sid% <= UBOUND(winstyle) THEN
      WinFindSid% = sid%
      EXIT FUNCTION
    END IF
  END IF

  '
  ' Search by name
  '
  FOR sid% = LBOUND(winstyle) TO UBOUND(winstyle)
    IF RTRIM$(winstyle(sid%).stylename) = sname$ THEN
      WinFindSid% = sid%
      EXIT FUNCTION
    END IF
  NEXT

  WinFindSid% = 0

END FUNCTION

FUNCTION WinFindWid% (wname$)
 
  DIM wid%

  FOR wid% = 1 TO wincount
    IF RTRIM$(win(wid%).wname) = wname$ THEN
      WinFindWid% = wid%
      EXIT FUNCTION
    END IF
  NEXT

  WinFindWid% = 0

END FUNCTION

FUNCTION WinGetStyle% (wid%)
  AssertIsPositive wid%, "WinGetStyle", "wid"
  WinGetStyle% = win(wid%).sid
END FUNCTION

FUNCTION WinMapKey% (wid%, pressed$)

  DIM childwid  AS INTEGER
  DIM cmdrid    AS INTEGER
  DIM exitLeft  AS INTEGER
  DIM exitRight AS INTEGER
  DIM selected  AS INTEGER

  '
  ' Examine the field.
  ' ArrowExit bit 0 means to exit when navigating left
  ' ArrowExit bit 1 means to exit when nagivating right
  '
  exitLeft = win(wid%).arrowexit AND &H1
  exitRight = win(wid%).arrowexit AND &H2
  selected = win(wid%).selected
  IF selected > 0 THEN
    childwid = fld(wid%, selected).childwid
    cmdrid = fld(wid%, selected).cmdrid
  END IF

  SELECT CASE pressed$

    CASE CHR$(ASCII.Return)
      IF childwid > 0 THEN
        WinMapKey% = WinAction.OpenPopup
      ELSEIF cmdrid > 0 THEN
        WinMapKey% = WinAction.Execute
      ELSE
        WinMapKey% = WinAction.Complete
      END IF

    CASE CHR$(ASCII.Escape)
      WinMapKey% = WinAction.Cancel

    CASE CHR$(ASCII.Tab)
      WinMapKey% = WinAction.SelectNext

    CASE CHR$(0) + CHR$(ScanCode.Down)
      IF childwid > 0 THEN
        WinMapKey% = WinAction.OpenPopup
      ELSE
        WinMapKey% = WinAction.SelectNext
      END IF

    CASE CHR$(0) + CHR$(ScanCode.End)
      WinMapKey% = WinAction.SelectLast

    CASE CHR$(0) + CHR$(ScanCode.Home)
      WinMapKey% = WinAction.SelectFirst

    CASE CHR$(0) + CHR$(ScanCode.Left)
      IF exitLeft THEN
        WinMapKey% = WinAction.ExitLeft
      ELSE
        WinMapKey% = WinAction.SelectPrevious
      END IF

    CASE CHR$(0) + CHR$(ScanCode.PageDown)
      WinMapKey% = WinAction.SelectLast

    CASE CHR$(0) + CHR$(ScanCode.PageUp)
      WinMapKey% = WinAction.SelectFirst

    CASE CHR$(0) + CHR$(ScanCode.Right)
      IF exitRight THEN
        WinMapKey% = WinAction.ExitRight
      ELSE
        WinMapKey% = WinAction.SelectNext
      END IF

    CASE CHR$(0) + CHR$(ScanCode.Up)
      WinMapKey% = WinAction.SelectPrevious

    CASE "?", "/"
      WinMapKey = WinAction.Help

    CASE ELSE
      WinMapKey = WinAction.None

  END SELECT

END FUNCTION

SUB WinOpen (wid%)
  '
  ' Displays the window and gives it focus
  '
  
  DIM backpage AS INTEGER
  DIM workpage AS INTEGER

  '
  ' Allocate video page
  '
  workpage = VideoAlloc%
  IF winstacked = 0 THEN
    backpage = VideoGetActive%
  ELSE
    backpage = winstack(winstacked).workpage
  END IF

  winstacked = winstacked + 1
 
  winstack(winstacked).wid = wid%
  winstack(winstacked).backpage = backpage
  winstack(winstacked).workpage = workpage

  '
  ' Draw the window
  '
  VideoScreen workpage, backpage
  PCOPY backpage, workpage
  WinDraw wid%
  
  '
  ' Set focus to a field
  '
  IF win(wid%).selected = 0 THEN
    WinSelectFirst wid%
  END IF

  '
  ' Set the working page as the visual page
  '
  VideoScreen workpage, workpage

END SUB

SUB WinRefreshField (wid%, fid%)

  DIM n AS INTEGER

  IF winstacked > 0 THEN
    IF winstack(winstacked).wid = wid% THEN
     
      FieldDraw wid%, fid%
   
      FOR n = 1 TO win(wid%).fields
        '
        ' Look for bound fields, but don't redraw the same field
        '
        IF n <> fid% THEN
          IF FieldIsBound%(wid%, n) THEN
            FieldDraw wid%, n
          END IF
        END IF
      NEXT

    END IF
  END IF

END SUB

SUB WinRefreshWindow (wid%)

  AssertIsPositive wid%, "WinRefreshWindow", "wid"
  AssertIsPositive winstacked, "WinRefreshWindow", "winstacked"
  Assert winstack(winstacked).wid = wid%, "WinRefreshWindow", "top win only"

  VideoScreen winstack(winstacked).workpage, winstack(winstacked).backpage
  PCOPY winstack(winstacked).backpage, winstack(winstacked).workpage
  WinDraw wid%
  VideoScreen winstack(winstacked).workpage, winstack(winstacked).workpage

END SUB

SUB WinRun (wid%, result AS WinResultType)

  AssertIsPositive wid%, "WinRun", "wid"

  DIM nopopups AS INTEGER
  DIM pressed  AS STRING

  WinOpen wid%

  DO

    '
    ' Determine if the selected field is a popup.
    ' If so, that window needs to be displayed now.
    '
    DO

      IF nopopups THEN
              
        EXIT DO

      ELSEIF win(wid%).selected = 0 THEN
       
        EXIT DO

      ELSEIF FieldGetKind%(wid%, win(wid%).selected) <> FieldKind.Popup THEN
       
        EXIT DO

      ELSEIF fld(wid%, win(wid%).selected).childwid = 0 THEN
       
        EXIT DO

      ELSE
     
        WinRun fld(wid%, win(wid%).selected).childwid, result
       
        SELECT CASE result.action
         
          CASE WinAction.Cancel
            '
            ' The user canceled the popup, so disable popups until
            ' the user explicitly opens the popup window.
            '
            nopopups = True
            EXIT DO

          CASE WinAction.Execute
            '
            ' The user selected a command from the popup. The result
            ' will be passed up via the output result parameter.
            '
            WinClose wid%
            EXIT SUB
         
          CASE WinAction.ExitLeft
            WinSelectPrevious wid%
         
          CASE WinAction.ExitRight
            WinSelectNext wid%
         
          CASE ELSE
            EXIT DO

        END SELECT

      END IF

    LOOP

    pressed = GetKey$
   
    SELECT CASE WinMapKey%(wid%, pressed)
     
      CASE WinAction.Cancel
        result.action = WinAction.Cancel
        result.canceled = True
        result.cmdrid = 0
        result.selected = win(wid%).selected
        WinClose wid%
        EXIT SUB

      CASE WinAction.Complete
        result.action = WinAction.Complete
        result.canceled = False
        result.cmdrid = 0
        result.selected = win(wid%).selected
        WinClose wid%
        EXIT SUB

      CASE WinAction.Execute
        result.action = WinAction.Execute
        result.canceled = False
        result.selected = win(wid%).selected
        result.cmdrid = fld(wid%, result.selected).cmdrid
        WinClose wid%
        EXIT SUB

      CASE WinAction.ExitLeft
        result.action = WinAction.ExitLeft
        result.canceled = True
        result.cmdrid = 0
        result.selected = win(wid%).selected
        WinClose wid%
        EXIT SUB

      CASE WinAction.ExitRight
        result.action = WinAction.ExitRight
        result.canceled = True
        result.cmdrid = 0
        result.selected = win(wid%).selected
        WinClose wid%
        EXIT SUB

      CASE WinAction.Help
        IF win(wid%).helpWid <> 0 THEN
          WinRun win(wid%).helpWid, result
        END IF

      CASE WinAction.OpenPopup
        nopopups = False

      CASE WinAction.SelectFirst
        WinSelectFirst wid%

      CASE WinAction.SelectLast
        WinSelectLast wid%

      CASE WinAction.SelectNext
        WinSelectNext wid%

      CASE WinAction.SelectPrevious
        WinSelectPrevious wid%

      CASE ELSE
        FieldKey wid%, (win(wid%).selected), pressed
        WinRefreshField wid%, win(wid%).selected

    END SELECT

  LOOP

END SUB

SUB WinRunName (idname$)
 
  DIM wid AS INTEGER
  DIM result AS WinResultType

  wid = WinFindWid(idname$)
  Assert wid <> 0, "WinRunName", "wid cannot be 0"

  WinRun wid, result

END SUB

SUB WinSelect (wid%, fid%)
  '
  ' Sets focus to a field
  '

  AssertIsPositive wid%, "WinSelect", "wid"
  Assert fid% >= 0, "WinSelect", "fid cannot be negative"

  DIM old%
  LET old% = win(wid%).selected

  IF old% = fid% THEN
    '
    ' Same field
    '
    EXIT SUB
  END IF

  win(wid%).selected = fid%

  IF old% > 0 THEN
    WinRefreshField wid%, old%
  END IF

  IF fid% > 0 THEN
    WinRefreshField wid%, fid%
  END IF

END SUB

SUB WinSelectFirst (wid%)
  '
  ' Selects the first selectable field
  '

  AssertIsPositive wid%, "WinSelectFirst", "wid"

  IF win(wid%).fields = 0 THEN
    '
    ' This window has no fields
    '
    WinSelect wid%, 0

  ELSE
 
    DIM fid%
    FOR fid% = 1 TO win(wid%).fields
      IF FieldIsSelectable(wid%, fid%) THEN
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

  AssertIsPositive wid%, "WinSelectLast", "wid"

  IF win(wid%).fields = 0 THEN
    '
    ' This window has no fields
    '
    WinSelect wid%, 0

  ELSE

    DIM fid%
    FOR fid% = win(wid%).fields TO 1 STEP -1
      IF FieldIsSelectable(wid%, fid%) THEN
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

  AssertIsPositive wid%, "WinSelectNext", "wid"

  DIM fid%
  DIM firstFid%

  IF win(wid%).fields = 0 THEN
   
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

      IF FieldIsSelectable(wid%, fid%) THEN
        EXIT DO
      END IF

      IF fid% = firstFid% THEN
        '
        ' We found ourself, but we are not selectable
        '
        fid% = 0
        EXIT DO
      END IF

    LOOP

  END IF

  WinSelect wid%, fid%

END SUB

SUB WinSelectPrevious (wid%)
  '
  ' Selects the field before the current one (looping around)
  '

  AssertIsPositive wid%, "WinSelectPrevious", "wid"

  DIM fid%
  DIM startingFid%

  IF win(wid%).fields = 0 THEN
   
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

      IF FieldIsSelectable(wid%, fid%) THEN
        EXIT DO
      END IF

      IF fid% = startingFid% THEN
        '
        ' We looped back to ourself, but we are not selectable.
        '
        fid% = 0
        EXIT DO
      END IF

    LOOP

  END IF

  WinSelect wid%, fid%

END SUB

SUB WinSetStyle (wid%, sid%)
  AssertIsPositive wid%, "WinSetStyle", "wid"
  win(wid%).sid = sid%
END SUB

FUNCTION WorldAdd% (hid%, cx%, cy%)

  DIM aid%

  '
  ' Allocate the area
  '
  aid% = WorldNextId%
  area(aid%).allocated = True
  area(aid%).hid = hid%
  area(aid%).energy = 3

  AtlasAddItem cx%, cy%, aid%, habitat(hid%).labelrid

  WorldAdd% = aid%

END FUNCTION

SUB WorldAddCluster (hid AS INTEGER, count AS INTEGER)

  DIM aid   AS INTEGER
  DIM outcx AS INTEGER
  DIM outcy AS INTEGER
  DIM n     AS INTEGER
 
  FOR n = 1 TO count
    AtlasNextClustered outcx, outcy
    aid = WorldAdd%(hid, outcx, outcy)
  NEXT
  
END SUB

SUB WorldAddNebula (size AS INTEGER)

  DIM hid   AS INTEGER
  DIM hname AS STRING

  '
  ' Find the nebula habitat
  '
  FOR hid = 1 TO habitats
   
    IF habitat(hid).namerid > 0 THEN
      hname = ResourceGet(habitat(hid).namerid)
      IF hname = "Nebula" THEN
        WorldAddCluster hid, size
        EXIT SUB
      END IF
    END IF

  NEXT
 
END SUB

SUB WorldHarvest (aid%)

  AssertIsPositive aid%, "WorldHarvest", "aid"

  DIM energy%
  LET energy% = area(aid%).energy

  IF energy% > 0 THEN
    energy% = energy% - 1
    area(aid%).energy = energy%
  END IF

  IF energy% = 0 THEN
    WorldRemove aid%
    EventIncName "NebulaDepleted"
  END IF

END SUB

SUB WorldInit (areas%)
  '
  ' Initializes the world
  '
 
  DIM aid AS INTEGER
  DIM cx  AS INTEGER
  DIM cy  AS INTEGER
  DIM hid AS INTEGER
  DIM i   AS INTEGER

  WorldAddNebula 15

  FOR i = 1 TO areas%

    '
    ' Select a random habitat
    '
    hid = INT(RND * habitats) + 1

    '
    ' Select a random location
    '
    AtlasNextRandom cx, cy
   
    '
    ' Add the area to the world
    '
    aid = WorldAdd%(hid, cx, cy)

  NEXT

END SUB

FUNCTION WorldNextId%
  '
  ' Returns the next index to hold a new area
  '

  STATIC idx AS INTEGER

  DIM try AS INTEGER
  LET try = idx

  DO
    '
    ' Try the next index
    '
    try = try + 1
    IF try > UBOUND(area) THEN
      try = LBOUND(area)
    END IF

    IF NOT area(try).allocated THEN
      '
      ' An open slot was found - return its index
      '
      idx = try
      WorldNextId% = idx
      EXIT FUNCTION
    END IF

    IF try = idx THEN
      '
      ' The loop went all the way around - no open slots
      '
      WorldNextId% = 0
      EXIT FUNCTION
    END IF

  LOOP

END FUNCTION

SUB WorldRemove (aid%)

  AssertIsPositive aid%, "WorldRemove", "aid"

  IF area(aid%).allocated THEN
    area(aid%).allocated = False
    AtlasRemoveValue aid%
  END IF

END SUB

SUB WorldSetLabel (aid%, labelrid%)
  '
  ' Updates the label for the specified area
  '
  AssertIsPositive aid%, "WorldSetLabel", "aid"
  AssertIsPositive labelrid%, "WorldSetLabel", "labelrid"

  DIM idx AS INTEGER
 
  idx = AtlasIndexOf(aid%)
  IF idx > 0 THEN
    AtlasSetLabel idx, labelrid%
  END IF

END SUB

