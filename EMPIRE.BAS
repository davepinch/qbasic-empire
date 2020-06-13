
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
  habitat   AS INTEGER
  energy    AS INTEGER
END TYPE

TYPE AtlasItemType
  allocated AS INTEGER
  cx        AS INTEGER
  cy        AS INTEGER
  value     AS INTEGER
  labelrid  AS INTEGER
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
  childwid  AS INTEGER  ' TODO: add nparam and combine these two
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
  sizeX     AS INTEGER
  sizeY     AS INTEGER
  style     AS INTEGER
  wname     AS STRING * 20
END TYPE

'
' Atlas* declarations
'
DECLARE SUB AtlasAddItem (cx AS INTEGER, cy AS INTEGER, value AS INTEGER, labelrid AS INTEGER)
DECLARE SUB AtlasDisplayOff ()
DECLARE SUB AtlasDisplayOn ()
DECLARE SUB AtlasDraw ()
DECLARE SUB AtlasDrawCell (cx AS INTEGER, cy AS INTEGER)
DECLARE SUB AtlasDrawGrid ()
DECLARE SUB AtlasDrawItem (idx AS INTEGER)
DECLARE SUB AtlasDrawItems ()
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
DECLARE FUNCTION AtlasNextIndex% ()
DECLARE FUNCTION AtlasGetScreenX% (cx AS INTEGER)
DECLARE FUNCTION AtlasGetScreenY% (cy AS INTEGER)
DECLARE FUNCTION AtlasGetValue% (cx AS INTEGER, cy AS INTEGER, default AS INTEGER)
DECLARE FUNCTION AtlasIndexOf% (value AS INTEGER)
DECLARE FUNCTION AtlasPrompt (promptFor AS INTEGER, outcx AS INTEGER, outcy AS INTEGER, outpress AS STRING)

'
' Events
'
DECLARE FUNCTION EventFind% (name$)
DECLARE FUNCTION EventParseOperator% (opname$)
DECLARE FUNCTION EventTriggers% (eid%, tid%)
DECLARE SUB EventInc (eid%)
DECLARE SUB EventIncName (ename$)
DECLARE SUB EventFire (eid%)

'
' Execute* subroutines
'
DECLARE FUNCTION ExecCmd% (text AS STRING)
DECLARE FUNCTION ExecCmdEid% (ntoken%, stoken$(), eid%)
DECLARE FUNCTION ExecCmdFid% (ntoken%, stoken$(), wid%, fid%)
DECLARE FUNCTION ExecCmdHid% (ntoken%, stoken$(), hid%)
DECLARE FUNCTION ExecCmdTid% (ntoken%, stoken$(), tid%)
DECLARE FUNCTION ExecCmdWid% (ntoken%, stoken$(), wid%, fid%)
DECLARE FUNCTION ExecCmdRoot% (ntoken%, stoken$(), eid%, hid%, sid%, tid%, wid%)
DECLARE FUNCTION ExecCmdSid% (ntoken%, stoken$(), sid%)
DECLARE FUNCTION ExecResource% (rid AS INTEGER)
DECLARE SUB ExecFile (filename AS STRING)

DECLARE SUB FieldBindText (wid%, fid%, expr$)
DECLARE SUB FieldBindValue (wid%, fid%, expr$)
DECLARE SUB FieldDrawNebula (wid%, fid%)
DECLARE SUB FieldKey (wid%, fid%, keypress$)
DECLARE SUB FieldKeyBoolean (wid%, fid%, keypress$)
DECLARE SUB FieldKeyInteger (wid%, fid%, keypress$)
DECLARE SUB FieldSetBound (wid%, fid%, b AS BindingType, value$)
DECLARE SUB FieldSetChild (wid%, fid%, wname$)
DECLARE SUB FieldSetCommand (wid%, fid%, cmd$)
DECLARE SUB FieldSetStyle (wid%, fid%, sid%)
DECLARE SUB FieldSetText (wid%, fid%, value$)
DECLARE SUB FieldSetValue (wid%, fid%, value$)
DECLARE FUNCTION FieldGetBound$ (wid%, fid%, b AS BindingType)
DECLARE FUNCTION FieldGetStyle% (wid%, fid%)
DECLARE FUNCTION FieldGetText$ (wid%, fid%)
DECLARE FUNCTION FieldGetValue$ (wid%, fid%)
DECLARE FUNCTION FieldIsBound% (wid%, fid%)
DECLARE FUNCTION FieldIsSelectable% (wid%, fid%)

'
' Top-level game methods
'
DECLARE SUB GameHarvest ()
DECLARE FUNCTION GameAreaEnergy% ()
DECLARE FUNCTION GameArea% ()
DECLARE FUNCTION GameHabitat% ()

'
' Habitats
'
DECLARE FUNCTION HabitatCreate% ()
DECLARE FUNCTION HabitatGetBackdrop$ (hid%)
DECLARE FUNCTION HabitatGetName$ (hid%)
DECLARE SUB HabitatSetAction (hid%, cmd$)
DECLARE SUB HabitatSetBackdrop (hid%, backdrop$)
DECLARE SUB HabitatSetLabel (hid%, label$)
DECLARE SUB HabitatSetName (hid%, hname$)

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
' Resources
'
DECLARE FUNCTION ResourceCreate% (value AS STRING)
DECLARE FUNCTION ResourceGet$ (rid AS INTEGER)
DECLARE SUB ResourceSet (rid AS INTEGER, value AS STRING)

'
' Status* subroutines
'
' These subroutines change the status on the bottom of the page.
'
DECLARE SUB StatusClear ()
DECLARE SUB StatusDebug (text AS STRING)
DECLARE SUB StatusUpdate (text AS STRING)
DECLARE SUB StatusUpdateLevel (text AS STRING, level AS INTEGER)

'
' UI subroutines
'
DECLARE SUB UI.Action ()
DECLARE SUB UI.ActionNebula (aid AS INTEGER)
DECLARE SUB UI.Redraw ()
DECLARE SUB UI.RedrawAtlas ()
DECLARE SUB UI.RedrawTable ()
DECLARE SUB UI.Refresh ()
DECLARE SUB UI.Run ()
DECLARE SUB UI.SetPage (page AS INTEGER)
DECLARE FUNCTION UI.RunAtlas% ()

'
' Windows
'
DECLARE FUNCTION WinAddButton% (wid%, posX%, posY%, sizeX%, text$, value%)
DECLARE FUNCTION WinAddSeparator% (wid%, posX%, posY%)
DECLARE FUNCTION WinClipText% (wid%, fid%, outposx%, outposy%, outsizex%, outtext$)
DECLARE FUNCTION WinCreate% ()
DECLARE FUNCTION WinCreateEx% (style%, posX%, posY%, sizeX%, sizeY%)
DECLARE FUNCTION WinCreateField% (wid%, kind%)
DECLARE FUNCTION WinFindSid% (stylename AS STRING)
DECLARE FUNCTION WinFindWid% (wname$)
DECLARE FUNCTION WinGetStyle% (wid%)
DECLARE FUNCTION WinMapKey% (wid%, pressed$)

DECLARE SUB WinAutoSize (wid%)
DECLARE SUB WinClose (wid%)
DECLARE SUB WinDraw (wid%)
DECLARE SUB WinDrawBox (wid%)
DECLARE SUB WinDrawBox0 (wid%)
DECLARE SUB WinDrawBox1 (wid%)
DECLARE SUB WinDrawBox2 (wid%)
DECLARE SUB WinDrawField (wid%, fid%)
DECLARE SUB WinDrawFile (wid%, fid%)
DECLARE SUB WinDrawSeparator (wid%, fid%)
DECLARE SUB WinDrawSeparator0 (wid%, fid%)
DECLARE SUB WinDrawSeparator1 (wid%, fid%)
DECLARE SUB WinDrawSeparator2 (wid%, fid%)
DECLARE SUB WinDrawText (wid%, fid%)
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

'
' World* subroutines
'
DECLARE SUB WorldAddCluster (hid AS INTEGER, size AS INTEGER)
DECLARE SUB WorldAddNebula (size AS INTEGER)
DECLARE SUB WorldHarvest (aid%)
DECLARE SUB WorldInit (areas AS INTEGER)
DECLARE SUB WorldRemove (aid AS INTEGER)
DECLARE SUB WorldSetLabel (aid AS INTEGER, labelrid AS INTEGER)
DECLARE SUB WorldLoadHabitats ()
DECLARE FUNCTION WorldAdd% (hid AS INTEGER, cx AS INTEGER, cy AS INTEGER)
DECLARE FUNCTION WorldNextId% ()

'
' Declarations
'
DECLARE SUB Assert (truth AS INTEGER, where AS STRING, what AS STRING)
DECLARE SUB AssertFail (where AS STRING, what AS STRING)
DECLARE SUB AssertIsPositive (value%, where$, what$)
DECLARE SUB AssertIsZero (value%, where$, what$)
DECLARE SUB DrawColor (attr%)
DECLARE SUB DrawFile (filename AS STRING)
DECLARE SUB DrawFileAt (filename AS STRING, offsetX AS INTEGER, offsetY AS INTEGER)
DECLARE SUB DrawTable ()
DECLARE SUB DrawTableRow (row AS INTEGER, aid AS INTEGER)
DECLARE SUB DrawTableRows ()
DECLARE SUB DrawText (text AS STRING)
DECLARE SUB PaintBackground (sx1%, sy1%, sx2%, sy2%, backcolor%)
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
CONST AtlasStyle.SelectBackcolor = 4

'
' Boolean constants
'
CONST True = -1
CONST False = NOT True

CONST CmdResult.OK = 0
CONST CmdResult.Malformed = 1

'
' Field Kinds
'
CONST FieldKind.None = 0
CONST FieldKind.Boolean = 1
CONST FieldKind.Button = 2
CONST FieldKind.File = 3
CONST FieldKind.Integer = 4
CONST FieldKind.Label = 5
CONST FieldKind.Popup = 6
CONST FieldKind.Separator = 7
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
' StatusLevel constants
'
CONST StatusLevel.Normal = 0
CONST StatusLevel.Debug = 1

'
' TableStyle.* constants
'
' These constants define the style of the data table.
'
CONST TableStyle.Backcolor = 0
CONST TableStyle.Border = 2
CONST TableStyle.HeaderBackcolor = 0
CONST TableStyle.HeaderForecolor = 7
CONST TableStyle.RowBackcolor = 0
CONST TableStyle.RowForecolor = 7
CONST TableStyle.Forecolor = 1

'
' UIPage.* constants
'
CONST UIPage.None = 0
CONST UIPage.Atlas = 3
CONST UIPage.Table = 5

'
' UIResult.* constants
'
CONST UIResult.Exit = 0
CONST UIResult.Escape = 1

CONST VideoPage.Display = 0
CONST VideoPage.Working = 1

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
DIM SHARED atlasActive        AS INTEGER
DIM SHARED atlasItem(1 TO 30) AS AtlasItemType
DIM SHARED atlasGrid(1 TO AtlasStyle.GridSizeX, 1 TO AtlasStyle.GridSizeY) AS INTEGER

'
' Globals
'
DIM SHARED area(1 TO 30)         AS AreaType
DIM SHARED event(1 TO 5)         AS EventType
DIM SHARED events                AS INTEGER
DIM SHARED fld(1 TO 15, 1 TO 13) AS FieldType
DIM SHARED habitat(1 TO 8)       AS HabitatType
DIM SHARED habitats              AS INTEGER
DIM SHARED resource(1 TO 70)     AS STRING
DIM SHARED resources             AS INTEGER
DIM SHARED trigger(1 TO 5)       AS TriggerType
DIM SHARED triggers              AS INTEGER
DIM SHARED uiCurrentPage         AS INTEGER
DIM SHARED uicx                  AS INTEGER
DIM SHARED uicy                  AS INTEGER
DIM SHARED win(1 TO 15)          AS WinType
DIM SHARED wincount              AS INTEGER
DIM SHARED winstack(1 TO 3)      AS WinStackItem
DIM SHARED winstacked            AS INTEGER
DIM SHARED winstyle(1 TO 10)     AS WinStyleType
DIM SHARED winstyles             AS INTEGER

SetupGame
UI.Run

SUB Assert (truth AS INTEGER, where AS STRING, what AS STRING)

  IF NOT truth THEN
    SCREEN , , 0, 0
    StatusDebug where + ": " + what
    IF GetKey$ <> CHR$(ASCII.Escape) THEN
      END
    END IF
  END IF

END SUB

SUB AssertFail (where AS STRING, what AS STRING)
  Assert 0, where, what
END SUB

SUB AssertIsPositive (value%, where$, what$)

  Assert value% > 0, where$, what$ + " must be > 0 but value =" + STR$(value%)

END SUB

SUB AssertIsZero (value%, where$, what$)
  Assert value% = 0, where$, what$ + " cannot be 0 but value =" + STR$(value%)
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
    StatusDebug "AtlasAddItem: no index available"
    EXIT SUB
  END IF

  '
  ' Add the item to the item list
  '
  atlasItem(idx).allocated = -1
  atlasItem(idx).cx = cx
  atlasItem(idx).cy = cy
  atlasItem(idx).labelrid = labelrid
  atlasItem(idx).value = value

  '
  ' Reference the item in the grid
  '
  atlasGrid(cx, cy) = idx
 
  IF atlasActive THEN
    AtlasDrawCell cx, cy
  END IF

END SUB

SUB AtlasDisplayOff
  '
  ' Turns off active updates to the atlas.
  '
  atlasActive = 0
END SUB

SUB AtlasDisplayOn
  '
  ' Enables synchronizing the atlas display with its data.
  '
  atlasActive = True

END SUB

SUB AtlasDraw
  '
  ' Draws the atlas grid and items
  '
  ' Note: As a design rule, the draw subroutines should not modify
  ' atlas data and should not call subroutines that modify data.
  '
  AtlasDrawGrid
  AtlasDrawItems

END SUB

SUB AtlasDrawCell (cx AS INTEGER, cy AS INTEGER)
  '
  ' Draws the specified atlas cell onto the active video page
  '

  DIM idx   AS INTEGER
  DIM sx    AS INTEGER
  DIM sy    AS INTEGER
  DIM value AS INTEGER

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
    LET label = ResourceGet(atlasItem(idx).labelrid)
    DrawText label
  END IF

END SUB

SUB AtlasDrawGrid
  '
  ' Draws the grid of the atlas onto the active video page
  '
  DrawFileAt "GRID.PCB", 1, 2

END SUB

SUB AtlasDrawItem (idx AS INTEGER)
  '
  ' Draws the specified item
  '
  IF atlasItem(idx).allocated THEN
    AtlasDrawCell atlasItem(idx).cx, atlasItem(idx).cy
  END IF

END SUB

SUB AtlasDrawItems
  '
  ' Draws the active items of the atlas.
  '
  DIM idx AS INTEGER
  FOR idx = 1 TO UBOUND(atlasItem)
 
    IF atlasItem(idx).allocated THEN
      AtlasDrawCell atlasItem(idx).cx, atlasItem(idx).cy
    END IF

  NEXT

END SUB

SUB AtlasDrawSelect (cx AS INTEGER, cy AS INTEGER, valid AS INTEGER)
  '
  ' Draws the current selection indicator onto the grid
  '

  DIM col AS INTEGER
  DIM sx1 AS INTEGER
  DIM sy1 AS INTEGER

  '
  ' Get the upper-left screen coordinates of the outer cell
  '
  sx1 = AtlasGetScreenX(cx) - 1
  sy1 = AtlasGetScreenY(cy) - 1

  '
  ' Determine the painting color
  '
  IF valid THEN
    col = 2
  ELSE
    col = 4
  END IF

  PaintBackground sx1, sy1, sx1 + AtlasStyle.CellSizeX + 1, sy1 + 2, col

END SUB

SUB AtlasDrawUnselect (cx AS INTEGER, cy AS INTEGER)
  '
  ' Draws the cell to reflect no selection.
  '

  DIM sx1 AS INTEGER
  DIM sy1 AS INTEGER

  '
  ' Get the upper-left screen coordinates of the outer cell
  '
  sx1 = AtlasGetScreenX(cx) - 1
  sy1 = AtlasGetScreenY(cy) - 1

  PaintBackground sx1, sy1, sx1 + AtlasStyle.CellSizeX + 1, sy1 + 2, 0

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
    AtlasGetValue% = atlasItem(idx).value
  END IF

END FUNCTION

FUNCTION AtlasIndexOf% (value AS INTEGER)
  '
  ' Returns the index of the first item with the specified value.
  '

  DIM idx AS INTEGER
  FOR idx = 1 TO UBOUND(atlasItem)
 
    IF atlasItem(idx).value = value THEN
      IF atlasItem(idx).allocated THEN
        AtlasIndexOf% = idx
        EXIT FUNCTION
      END IF
    END IF

  NEXT

  AtlasIndexOf% = 0

END FUNCTION

SUB AtlasMoveItem (idx AS INTEGER, nx AS INTEGER, ny AS INTEGER)
  '
  ' Moves the item with at the specified index.
  '
 
  DIM cx AS INTEGER
  DIM cy AS INTEGER

  '
  ' Get the current x and y coordinates
  '
  cx = atlasItem(idx).cx
  cy = atlasItem(idx).cy

  '
  ' Dereference the item from the grid
  '
  IF cx > 0 AND cy > 0 THEN
    atlasGrid(cx, cy) = 0
    IF atlasActive THEN
      AtlasDrawCell cx, cy
    END IF
  END IF

  '
  ' Update the item location
  '
  atlasItem(idx).cx = nx
  atlasItem(idx).cy = ny

  '
  ' Reference the item in the grid
  '
  atlasGrid(nx, ny) = idx
  IF atlasActive THEN
    AtlasDrawCell nx, ny
  END IF

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
    IF try > UBOUND(atlasItem) THEN
      try = 1
    END IF

    IF NOT atlasItem(try).allocated THEN
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

  FOR idx = 1 TO UBOUND(atlasItem)
   
    IF atlasItem(idx).allocated THEN
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

  FOR idx = 1 TO UBOUND(atlasItem)
  
    IF atlasItem(idx).allocated THEN
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

  FOR idx = 1 TO UBOUND(atlasItem)
 
    IF atlasItem(idx).allocated THEN
  
      '
      ' Get the current position of the item
      '
      cx = atlasItem(idx).cx
      cy = atlasItem(idx).cy

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

  FOR idx = 1 TO UBOUND(atlasItem)
  
    IF atlasItem(idx).allocated THEN
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

  LOOP

END FUNCTION

SUB AtlasRemoveItem (idx AS INTEGER)
  '
  ' Removes the specified item from the atlas.
  '

  DIM cx  AS INTEGER
  DIM cy  AS INTEGER

  IF atlasItem(idx).allocated THEN
 
    '
    ' Remove the item from the list
    '
    atlasItem(idx).allocated = False
 
    '
    ' Remove the item from the grid
    '
    cx = atlasItem(idx).cx
    cy = atlasItem(idx).cy

    atlasGrid(cx, cy) = 0
    IF atlasActive THEN
      AtlasDrawCell cx, cy
    END IF
 
  END IF

END SUB

SUB AtlasRemoveValue (value AS INTEGER)
  '
  ' Removes the item with the specified value from the atlas
  '

  DIM idx AS INTEGER
  LET idx = AtlasIndexOf%(value)

  AtlasRemoveItem idx

END SUB

SUB AtlasSetLabel (idx AS INTEGER, labelrid AS INTEGER)
  '
  ' Sets the label for the specified item
  '
 
  atlasItem(idx).labelrid = labelrid
  IF atlasActive THEN
    AtlasDrawItem idx
  END IF

END SUB

SUB DrawColor (attr%)
  COLOR attr% AND &HF, (attr% AND &HF0) / 16
END SUB

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
  PRINT " Id  Habitat "

  '
  ' Draw the heading separator
  '
  COLOR TableStyle.Forecolor, TableStyle.Backcolor
  PRINT divideLeft; STRING$(77, divideLine); divideRight

  '
  ' Draw each row
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

  DrawTableRows

END SUB

SUB DrawTableRow (row AS INTEGER, aid AS INTEGER)

  '
  ' Move to the first character of the row (inside border)
  '
  ' HACK: supress error caused by too many rows - fix later.
  IF row < 1 OR row > 19 THEN
    StatusDebug "DrawRowTable row=" + STR$(row)
    EXIT SUB
  END IF

  LOCATE row + 4, 3

  COLOR TableStyle.RowForecolor, TableStyle.RowBackcolor
 
  '
  ' Print the area ID
  '
  PRINT USING "##"; aid;
  PRINT "  "; ' HACK

  ' Print the habitat label
  DrawText ResourceGet(habitat(area(aid).habitat).namerid)

END SUB

SUB DrawTableRows
  '
  ' Draws the rows of the table
  '
 
  DIM aid AS INTEGER
  DIM row AS INTEGER

  FOR aid = LBOUND(area) TO UBOUND(area)
  
    IF area(aid).allocated THEN
      row = row + 1
      DrawTableRow row, aid
    END IF

  NEXT

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
      ' Code found; print characters up to the character code.
      '
      PRINT MID$(text, startAt, nextAt - startAt);

      '
      ' Read the color values
      '
      batr = ASC(MID$(text, nextAt + 2, 1)) - 48
      fatr = ASC(MID$(text, nextAt + 3, 1)) - 48
      IF batr > 16 THEN batr = batr - 7
      IF fatr > 16 THEN fatr = fatr - 7
      COLOR fatr, batr

      'backcolor = VAL("&H" + MID$(text, nextAt + 2, 1))
      'forecolor = VAL("&H" + MID$(text, nextAt + 3, 1))
      'COLOR forecolor, backcolor

      '
      ' Continue with the next character in the text
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
    IF EventTriggers%(eid%, tid%) THEN
      result% = ExecResource(trigger(tid%).cmdrid)
    END IF
  NEXT

END SUB

SUB EventInc (eid%)
  AssertIsPositive eid%, "EventIncrement", "eid"
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

FUNCTION EventTriggers% (eid%, tid%)

  AssertIsPositive eid%, "EventTriggers", "eid"
  AssertIsPositive eid%, "EventTriggers", "tid"

  IF trigger(tid%).eid <> eid% THEN
   
    EventTriggers = False

  ELSE

    SELECT CASE trigger(tid%).operator
      CASE OpEquals
        EventTriggers = trigger(tid%).operand = event(eid%).value

      CASE ELSE
        EventTriggers = False
    END SELECT

  END IF

END FUNCTION

FUNCTION ExecCmd% (text AS STRING)

  SHARED eid%
  SHARED fid%
  SHARED hid%
  SHARED sid%
  SHARED tid%
  SHARED wid%

  DIM result         AS INTEGER
 
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
    result = ExecCmdFid%(ntoken%, stoken$(), wid%, fid%)
  ELSEIF wid% > 0 THEN
    result = ExecCmdWid%(ntoken%, stoken$(), wid%, fid%)
  ELSEIF eid% > 0 THEN
    result = ExecCmdEid%(ntoken%, stoken$(), eid%)
  ELSEIF hid% > 0 THEN
    result = ExecCmdHid%(ntoken%, stoken$(), hid%)
  ELSEIF sid% > 0 THEN
    result = ExecCmdSid%(ntoken%, stoken$(), sid%)
  ELSEIF tid% > 0 THEN
    result = ExecCmdTid%(ntoken%, stoken$(), tid%)
  ELSE
    result = ExecCmdRoot%(ntoken%, stoken$(), eid%, hid%, sid%, tid%, wid%)
  END IF

  Assert result = CmdResult.OK, "ExecCmd", "Malformed: " + text

END FUNCTION

FUNCTION ExecCmdEid% (ntoken%, stoken$(), eid%)

  AssertIsPositive eid%, "ExecCmdEid", "eid"

  IF ntoken% = 1 THEN

    IF LCASE$(stoken$(0)) = "endevent" THEN
      eid% = 0
      ExecCmdEid% = CmdResult.OK
    ELSE
      ExecCmdEid% = CmdResult.Malformed
    END IF

  ELSEIF ntoken% <> 2 THEN

    ExecCmdEid% = CmdResult.Malformed

  ELSE

    ExecCmdEid% = CmdResult.OK

    SELECT CASE stoken$(0)
   
      CASE "name"
        event(eid%).namerid = ResourceCreate(stoken$(1))

      CASE "value"
        event(eid%).value = VAL(stoken$(1))

      CASE ELSE
        ExecCmdEid% = CmdResult.Malformed

    END SELECT

  END IF

END FUNCTION

FUNCTION ExecCmdFid% (ntoken%, stoken$(), wid%, fid%)

  AssertIsPositive wid%, "ExecCmdFid", "wid"
  AssertIsPositive fid%, "ExecCmdFid", "fid"

  IF ntoken% = 1 THEN

    '
    ' Exactly one token: only the end* commands are valid
    ' Determine which command ends this field type
    '
    DIM endtag AS STRING
    SELECT CASE fld(wid%, fid%).kind
      CASE FieldKind.Button
        endtag = "endbutton"
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
        AssertFail "ExecCmdFid", "Unknown kind:" + STR$(fld(wid%, fid%).kind)
    END SELECT

    IF stoken$(0) = endtag THEN
      fid% = 0
      ExecCmdFid% = CmdResult.OK
    ELSE
      ExecCmdFid% = CmdResult.Malformed
    END IF

    EXIT FUNCTION

  ELSEIF ntoken% = 3 THEN
    
    '
    ' Possible commands are VALUE BIND <VALUE> or TEXT BIND <VALUE>
    '
    IF LCASE$(stoken$(1)) <> "bind" THEN
      ExecCmdFid% = CmdResult.Malformed
    ELSEIF stoken$(0) = "text" THEN
      FieldBindText wid%, fid%, stoken$(2)
      ExecCmdFid% = CmdResult.OK
    ELSEIF stoken$(0) = "value" THEN
      FieldBindValue wid%, fid%, stoken$(2)
      ExecCmdFid% = CmdResult.OK
    ELSE
      ExecCmdFid% = CmdResult.Malformed
    END IF

    EXIT FUNCTION
  END IF

  '
  ' Remaining commands are NAME VALUE format
  '
  IF ntoken% <> 2 THEN
    ExecCmdFid% = CmdResult.Malformed
    EXIT FUNCTION
  ELSE
    ExecCmdFid% = CmdResult.OK
  END IF

  SELECT CASE stoken$(0)

    CASE endtag
      fid% = 0

    CASE "child"
      FieldSetChild wid%, fid%, stoken$(1)

    CASE "command"
      FieldSetCommand wid%, fid%, stoken$(1)

    CASE "offsetx"
      fld(wid%, fid%).offsetX = VAL(stoken$(1))

    CASE "offsety"
      fld(wid%, fid%).offsetY = VAL(stoken$(1))

    CASE "sizex"
      fld(wid%, fid%).sizeX = VAL(stoken$(1))

    CASE "sizey"
      fld(wid%, fid%).sizeY = VAL(stoken$(1))

    CASE "style"
      FieldSetStyle wid%, fid%, WinFindSid%(stoken$(1))

    CASE "text"
      FieldSetText wid%, fid%, stoken$(1)

    CASE "value"
      FieldSetValue wid%, fid%, stoken$(1)

    CASE ELSE
      ExecCmdFid% = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdHid% (ntoken%, stoken$(), hid%)

  AssertIsPositive hid%, "ExecCmdHid", "hid"

  IF stoken$(0) = "endhabitat" THEN
    IF ntoken% = 1 THEN
      hid% = 0
      ExecCmdHid% = CmdResult.OK
    ELSE
      ExecCmdHid% = CmdResult.Malformed
    END IF
    EXIT FUNCTION
  END IF

  '
  ' All remaining commands are NAME VALUE
  '
  IF ntoken% <> 2 THEN
    ExecCmdHid% = CmdResult.Malformed
    EXIT FUNCTION
  END IF

  ExecCmdHid% = CmdResult.OK

  SELECT CASE stoken$(0)

    CASE "action"
      HabitatSetAction hid%, stoken$(1)
     
    CASE "backdrop"
      HabitatSetBackdrop hid%, stoken$(1)

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

FUNCTION ExecCmdRoot% (ntoken%, stoken$(), eid%, hid%, sid%, tid%, wid%)

  AssertIsZero eid%, "ExecCmdRoot", "eid"
  AssertIsZero hid%, "ExecCmdRoot", "hid"
  AssertIsZero sid%, "ExecCmdRoot", "sid"
  AssertIsZero tid%, "ExecCmdRoot", "tid"
  AssertIsZero wid%, "ExecCmdRoot", "wid"

  ExecCmdRoot% = CmdResult.OK

  IF ntoken% = 1 THEN
    '
    ' Parameterless commands
    '
    SELECT CASE stoken$(0)

      CASE "atlas"
        UI.SetPage UIPage.Atlas
  
      CASE "endgame"
        END

      CASE "event"
        events = events + 1
        eid% = events

      CASE "habitat"
        hid% = HabitatCreate%

      CASE "harvest"
        GameHarvest

      CASE "newgame"
        WorldInit 15

      CASE "style"
        winstyles = winstyles + 1
        sid% = winstyles

      CASE "table"
        UI.SetPage UIPage.Table

      CASE "trigger"
        triggers = triggers + 1
        tid% = triggers

      CASE "window"
        wid% = WinCreate%

      CASE ELSE
        ExecCmdRoot% = CmdResult.Malformed

    END SELECT

  ELSEIF ntoken% = 2 THEN

    SELECT CASE stoken$(0)
      CASE "replot"
        '
        ' Replot <band | cluster | manual | random>
        '
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

      CASE "winrun"
        WinRunName stoken$(1)

      CASE ELSE
        ExecCmdRoot% = CmdResult.Malformed

    END SELECT

  ELSEIF ntoken% = 3 THEN

    SELECT CASE stoken$(0)
      CASE "mail"
        InboxAdd stoken$(1), stoken$(2)
      CASE ELSE
        ExecCmdRoot% = CmdResult.Malformed
    END SELECT

  ELSE

    ExecCmdRoot% = CmdResult.Malformed

  END IF

END FUNCTION

FUNCTION ExecCmdSid% (ntoken%, stoken$(), sid%)

  AssertIsPositive sid%, "ExecCmd", "sid"

  '
  ' The endstyle command ends the context
  '
  IF stoken$(0) = "endstyle" THEN
    IF ntoken% = 1 THEN
      sid% = 0
      ExecuteCommandSid% = CmdResult.OK
    ELSE
      ExecuteCommandSid% = CmdResult.Malformed
    END IF
    
    EXIT FUNCTION
  END IF

  '
  ' All remaining commands are NAME PARAM
  '
  IF ntoken% <> 2 THEN
    ExecuteCommandSid% = CmdResult.Malformed
    EXIT FUNCTION
  END IF

  ExecuteCommandSid% = CmdResult.OK

  SELECT CASE stoken$(0)
    CASE "bordercolor"
      winstyle(sid%).bordercolor = VAL(stoken$(1))

    CASE "bordertype"
      winstyle(sid%).bordertype = VAL(stoken$(1))

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
        WinAutoSize wid%
        wid% = 0
     
      CASE "boolean"
        fid% = WinCreateField(wid%, FieldKind.Boolean)

      CASE "button"
        fid% = WinCreateField(wid%, FieldKind.Button)
   
      CASE "file"
        fid% = WinCreateField(wid%, FieldKind.File)

      CASE "integer"
        fid% = WinCreateField(wid%, FieldKind.Integer)

      CASE "label"
        fid% = WinCreateField(wid%, FieldKind.Label)
   
      CASE "nebula"
        fid% = WinCreateField(wid%, FieldKind.Nebula)

      CASE "popup"
        fid% = WinCreateField(wid%, FieldKind.Popup)

      CASE "separator"
        fid% = WinCreateField(wid%, FieldKind.Separator)

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

    CASE "sizex"
      win(wid%).sizeX = VAL(stoken$(1))

    CASE "sizey"
      win(wid%).sizeY = VAL(stoken$(1))

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

  DO WHILE NOT EOF(1)
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

SUB FieldDrawNebula (wid%, fid%)

  DIM p  AS INTEGER
  DIM sx AS INTEGER
  DIM sy AS INTEGER
  DIM x  AS INTEGER
  DIM y  AS INTEGER

  COLOR 7, 0

  FOR y = 1 TO fld(wid%, fid%).sizeY
 
    p = -1
    x = INT(RND * fld(wid%, fid%).sizeX) + 1

    sx = win(wid%).posX + fld(wid%, fid%).offsetX + x - 1
    sy = win(wid%).posY + fld(wid%, fid%).offsetY + y - 1
    LOCATE sy, sx

    DO
    
      '
      ' Calculate the next p value. -1=stop, 0=space, or 1,2,3
      '
      GOSUB NextP
      IF p = -1 THEN
        EXIT DO
      END IF
     
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

  EXIT SUB

REM ** SUBROUTINES **

NextP:

  SELECT CASE p
   
    CASE -1
      p = 1

    CASE 0
      SELECT CASE INT(RND * 3)
        CASE 0:
          p = 1
        CASE ELSE
          p = -1
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
  RETURN

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

FUNCTION FieldGetStyle% (wid%, fid%)

  AssertIsPositive wid%, "FieldGetStyle", "wid"
  AssertIsPositive fid%, "FieldGetStyle", "fid"

  DIM sid%

  sid% = fld(wid%, fid%).sid
  IF sid% = 0 THEN
    sid% = win(wid%).style
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

    SELECT CASE fld(wid%, fid%).kind
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

    SELECT CASE fld(wid%, fid%).kind
  
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

SUB FieldSetStyle (wid%, fid%, sid%)
  fld(wid%, fid%).sid = sid%
END SUB

SUB FieldSetText (wid%, fid%, value$)
  '
  ' Sets the text of the specified field.
  '

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
    GameHabitat% = area(aid%).habitat
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
    HabitatGetName$ = ResourceGet(habitat(hid%).namerid)
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
  DIM rid%
  DIM wid%
 
  SHARED posY AS INTEGER

  rid% = ResourceCreate(filename)
  wid% = WinFindWid("Inbox")
  fid% = WinAddButton(wid%, 0, posY, 20, " " + subject, rid%)
 
  posY = posY + 1

  StatusUpdate "Mail arrived"

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

SUB PaintBackground (sx1%, sy1%, sx2%, sy2%, backcolor%)
  
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

FUNCTION ResourceCreate% (value AS STRING)

  IF resources = UBOUND(resource) THEN
   
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
  StatusUpdate "Please wait..."
  ExecFile "EMPIRE.CFG"

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
  DIM cresult AS INTEGER
  DIM wresult AS WinResultType
 
  WinRun WinFindWid("Start"), wresult
 
  IF wresult.action = WinAction.Execute THEN
    cresult = ExecResource%(wresult.cmdrid)
  END IF

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

SUB StatusClear
  '
  ' Clears the status
  '
  StatusUpdateLevel "", StatusLevel.Normal

END SUB

SUB StatusDebug (text AS STRING)
  '
  ' Writes a debug message to the status
  '
  StatusUpdateLevel text, StatusLevel.Debug

  ' TODO: set page to ensure debug message is visible to developer
  ' who is on a breakpoint when the active page may not be the
  ' same as the display page.

END SUB

SUB StatusUpdate (text AS STRING)
  '
  ' Writes text to the status
  '
  StatusUpdateLevel text, StatusLevel.Normal

END SUB

SUB StatusUpdateLevel (text AS STRING, level AS INTEGER)

  CONST NormalForecolor = 15
  CONST NormalBackcolor = 0
  CONST DebugBackcolor = 4
  CONST DebugForecolor = 15

  SELECT CASE level
    CASE StatusLevel.Debug:
      COLOR DebugForecolor, DebugBackcolor
    CASE ELSE
      COLOR NormalForecolor, NormalBackcolor
  END SELECT
 
  VIEW PRINT 25 TO 25
  CLS
  DrawText text
  VIEW PRINT
  
END SUB

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
    hid = area(aid).habitat

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

SUB UI.Redraw
  '
  ' Redraws the UI.
  '

  Assert uiCurrentPage <> UIPage.None, "UI.Redraw", "UI page must be set."

  SELECT CASE uiCurrentPage
 
    CASE UIPage.Atlas
      UI.RedrawAtlas

    CASE UIPage.Table
      UI.RedrawTable

  END SELECT

END SUB

SUB UI.RedrawAtlas

  SCREEN , , VideoPage.Working, VideoPage.Display
  CLS
  AtlasDraw
  SCREEN , , VideoPage.Working, VideoPage.Working
  PCOPY VideoPage.Working, VideoPage.Display
  SCREEN , , VideoPage.Display, VideoPage.Display

END SUB

SUB UI.RedrawTable

  SCREEN , , VideoPage.Working, VideoPage.Display
 
  CLS
  DrawTable
  DrawTableRows

  '
  ' Restore the display page
  '
  SCREEN , , VideoPage.Working, VideoPage.Working
  PCOPY VideoPage.Working, VideoPage.Display
  SCREEN , , VideoPage.Display, VideoPage.Display

END SUB

SUB UI.Refresh
  '
  ' Refreshes data fields (rather than entire UI)
  '

  SELECT CASE uiCurrentPage
  
    CASE UIPage.Atlas
      AtlasDrawItems

    CASE UIPage.Table
      DrawTableRows

  END SELECT

END SUB

SUB UI.Run
  '
  ' Runs the user interface
  '
 
  DIM menuwid AS INTEGER
  DIM cresult AS INTEGER
  DIM uresult AS INTEGER
  DIM wresult AS WinResultType

  '
  ' Set the atlas (setting the page causes it to redraw)
  '
  UI.SetPage UIPage.Atlas

  '
  ' Find the main menu
  '
  menuwid = WinFindWid("Menu")

  DO
    
    Assert uiCurrentPage <> UIPage.None, "UI.Run", "UI page must be set"

    SELECT CASE uiCurrentPage
    
      CASE UIPage.Atlas
        uresult = UI.RunAtlas%

    END SELECT

    SELECT CASE uresult

      CASE UIResult.Exit
        '
        ' The UI page exited normally.
        '

      CASE UIResult.Escape
        '
        ' The player pressed the escape key to open the menu
        '
       
        WinRun menuwid, wresult
        IF wresult.action = WinAction.Execute THEN
          cresult = ExecResource%(wresult.cmdrid)
        END IF

    END SELECT

  LOOP

END SUB

FUNCTION UI.RunAtlas%
 
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
        hid = area(aid).habitat
       
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
    UI.RunAtlas% = UIResult.Escape

  END IF

END FUNCTION

SUB UI.SetPage (page AS INTEGER)
  '
  ' Sets the current page shown in the UI
  '
 
  Assert page <> UIPage.None, "UI.SetPage", "page cannot be 0"

  '
  ' Switch to the specified page and redraw
  '
  uiCurrentPage = page
  UI.Redraw

  '
  ' Turn on the atlas
  '
  IF page = UIPage.Atlas THEN
    AtlasDisplayOn
  ELSE
    AtlasDisplayOff
  END IF

END SUB

FUNCTION WinAddButton% (wid%, offsetX%, offsetY%, sizeX%, text$, value%)

  AssertIsPositive wid%, "WinAddButton", "wid"

  DIM fid%
  LET fid% = WinCreateField(wid%, FieldKind.Button)

  fld(wid%, fid%).childwid = 0
  fld(wid%, fid%).cmdrid = 0
  fld(wid%, fid%).offsetX = offsetX%
  fld(wid%, fid%).offsetY = offsetY%
  fld(wid%, fid%).sizeX = sizeX%
  fld(wid%, fid%).text.vrid = ResourceCreate(text$)
  fld(wid%, fid%).text.xrid = 0
  fld(wid%, fid%).value.vrid = value%
  fld(wid%, fid%).value.xrid = 0

  WinAddButton% = fid%

END FUNCTION

FUNCTION WinAddSeparator% (wid%, offsetX%, offsetY%)

  AssertIsPositive wid%, "WinAddSeparator", "wid"

  DIM fid%
  LET fid% = WinCreateField(wid%, FieldKind.Separator)

  fld(wid%, fid%).childwid = 0
  fld(wid%, fid%).cmdrid = 0
  fld(wid%, fid%).offsetX = offsetX%
  fld(wid%, fid%).offsetY = offsetY%
  fld(wid%, fid%).sizeX = 0
  fld(wid%, fid%).text.vrid = 0
  fld(wid%, fid%).text.xrid = 0
  fld(wid%, fid%).value.vrid = 0
  fld(wid%, fid%).value.xrid = 0

  WinAddSeparator% = fid%

END FUNCTION

SUB WinAutoSize (wid%)
  '
  ' Expands the size of the window based on field sizes and positions.
  '
 
  AssertIsPositive wid%, "WinAutoSize", "wid"

  DIM fid%
  DIM fieldx2%
  DIM fieldy2%
  DIM fieldSizeX%
  DIM highestx%
  DIM highesty%

  highestx% = win(wid%).sizeX
  highesty% = win(wid%).sizeY

  FOR fid% = 1 TO win(wid%).fields
 
    fieldSizeX% = fld(wid%, fid%).sizeX
    IF fieldSizeX% < 1 THEN
      fieldSizeX% = LEN(FieldGetText(wid%, fid%))
    END IF

    '
    ' Get the coordinates of the lower-right corner
    '
    fieldx2% = fld(wid%, fid%).offsetX + fieldSizeX%
    fieldy2% = fld(wid%, fid%).offsetY + 1

    IF fieldx2% > highestx% THEN highestx% = fieldx2%
    IF fieldy2% > highesty% THEN highesty% = fieldy2%

  NEXT

  IF highestx% > win(wid%).sizeX THEN
    win(wid%).sizeX = highestx%
  END IF

  IF highesty% > win(wid%).sizeY THEN
    win(wid%).sizeY = highesty%
  END IF

END SUB

FUNCTION WinClipText% (wid%, fid%, outoffx%, outoffy%, outsizex%, outtext$)
  '
  ' Returns True if any portion of the field text is visible. If True,
  ' the starting position, clipped size, and clipped text is returned.
  ' The clipped text is filled with spaces to match the clipped size.
  '

  AssertIsPositive wid%, "WinClipText", "wid"
  AssertIsPositive fid%, "WinClipText", "fid"

  DIM text$
  LET text$ = FieldGetText$(wid%, fid%)

  '
  ' Get the size of the field
  '
  outsizex% = fld(wid%, fid%).sizeX
  IF outsizex% = -1 THEN
    '
    ' A size of -1 means the window size
    '
    outsizex% = win(wid%).sizeX

  ELSE

    IF outsizex% = 0 THEN
      '
      ' A size of 0 means to use the size of the text
      '
      outsizex% = LEN(text$)
    END IF

    IF outsizex% > win(wid%).sizeX THEN
      '
      ' The field cannot be larger than the window
      '
      outsideX% = win(wid%).sizeX
    END IF

  END IF

  IF outsizex% < 1 THEN
    '
    ' No visible size
    '
    WinClipText% = False
    EXIT FUNCTION
  END IF

  '
  ' Get the offset of the field.
  '
  outoffx% = fld(wid%, fid%).offsetX
  outoffy% = fld(wid%, fid%).offsetY

  IF outoffx% >= win(wid%).sizeX THEN
    '
    ' No portion visible
    '
    WinClipText% = False
    EXIT FUNCTION
 
  ELSEIF outoffx% >= 0 THEN
    '
    ' The field starts within the window but might be clipped.
    '
    DIM lastCharIndex%
    LET lastCharIndex% = outoffx% + outsizex% - 1

    IF lastCharIndex% > win(wid%).sizeX THEN
      outsizex% = lastCharIndex% - win(wid%).sizeX
    END IF

    '
    ' Get the text value and pad/clip
    '
    outtext$ = text$
    IF LEN(outtext$) < outsizex% THEN
      '
      ' The text value is shorter than the field size
      '
      outtext$ = outtext$ + STRING$(outsizex% - LEN(outtext$), " ")

    ELSEIF LEN(outtext$) > outsizex% THEN
      '
      ' The text value is longer than the field size
      '
      outtext$ = LEFT$(outtext$, outsizex%)
   
    END IF

    WinClipText% = True
    EXIT FUNCTION

  ELSE
    '
    ' The field is to the left of the window (not supported)
    '
    AssertFail "WinClipText", "Negative position not supported."
    WinClipText% = False
    EXIT FUNCTION

  END IF

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
    SCREEN , , winstack(winstacked).backpage, winstack(winstacked).backpage
    winstacked = winstacked - 1

  END IF

END SUB

FUNCTION WinCreate%
  '
  ' Creates an empty window
  '
  wincount = wincount + 1
  win(wincount).style = 1
  WinCreate% = wincount

END FUNCTION

FUNCTION WinCreateEx% (style%, posX%, posY%, sizeX%, sizeY%)
  '
  ' Allocates a new window
  '
 
  DIM wid AS INTEGER
  LET wid = WinCreate%
 
  win(wid).posX = posX%
  win(wid).posY = posY%
  win(wid).style = style%
  win(wid).sizeX = sizeX%
  win(wid).sizeY = sizeY%

  WinCreateEx% = wid

END FUNCTION

FUNCTION WinCreateField% (wid%, kind%)

  Assert wid% > 0, "WinCreateField", "wid cannot be 0"

  DIM fid%
  LET fid% = win(wid%).fields + 1

  win(wid%).fields = fid%
  fld(wid%, fid%).kind = kind%
  WinCreateField% = fid%

END FUNCTION

SUB WinDraw (wid%)

  AssertIsPositive wid%, "WinDraw", "wid"
  WinDrawBox wid%

  DIM fid%
  FOR fid% = 1 TO win(wid%).fields
    WinDrawField wid%, fid%
  NEXT

END SUB

SUB WinDrawBox (wid%)

  AssertIsPositive wid%, "WinDrawBorder", "wid"
  AssertIsPositive win(wid%).posX, "WinDraw", "posX"
  AssertIsPositive win(wid%).posY, "WinDraw", "posY"
  AssertIsPositive win(wid%).sizeX, "WinDraw", "sizeX"
  AssertIsPositive win(wid%).sizeY, "WinDraw", "sizeY"

  DIM sid%
  LET sid% = win(wid%).style

  SELECT CASE winstyle(sid%).bordertype
 
    CASE 0:
      WinDrawBox0 wid%

    CASE 1:
      WinDrawBox1 wid%

    CASE 2:
      WinDrawBox2 wid%

  END SELECT

END SUB

SUB WinDrawBox0 (wid%)

  Assert wid% > 0, "WinDrawBox0", "wid cannot be 0"

  DIM row AS INTEGER
  DIM sid AS INTEGER

  sid = WinGetStyle(wid%)
  DrawColor winstyle(sid).textcolor
 
  FOR row = 1 TO win(wid%).sizeY
    LOCATE win(wid%).posY + row - 1, win(wid%).posX
    PRINT STRING$(win(wid%).sizeX, " ");
  NEXT

END SUB

SUB WinDrawBox1 (wid%)

  Assert wid% > 0, "WinDrawBox1", "wid cannot be 0"

  CONST lowerFlat = "Ä"   ' CHR$(196)
  CONST lowerLeft = "À"   ' CHR$(192)
  CONST lowerRight = "Ù"  ' CHR$(217)
  CONST sideLeft = "³"    ' CHR$(179)
  CONST sideRight = "³"   ' CHR$(179)
  CONST upperLeft = "Ú"   ' CHR$(218)
  CONST upperFlat = "Ä"   ' CHR$(196)
  CONST upperRight = "¿"  ' CHR$(191)

  DIM r   AS INTEGER
  DIM sid AS INTEGER
  DIM x1  AS INTEGER ' Upper-left x-coord
  DIM y1  AS INTEGER ' Upper-left y-coord
  DIM x2  AS INTEGER ' Lower-right x-coord
  DIM y2  AS INTEGER ' Lower-right y-coord

  x1 = win(wid%).posX - 1
  y1 = win(wid%).posY - 1
  x2 = x1 + win(wid%).sizeX + 1
  y2 = y1 + win(wid%).sizeY + 1

  sid = WinGetStyle(wid%)

  '
  ' Draw the top border
  '
  LOCATE y1, x1
  DrawColor winstyle(sid).bordercolor
  PRINT upperLeft; STRING$(win(wid%).sizeX, upperFlat); upperRight;

  '
  ' Draw each row of the window
  '
  FOR r = y1 + 1 TO y2 - 1
    LOCATE r, x1
    PRINT sideLeft;
   
    DrawColor winstyle(sid).textcolor
    PRINT STRING$(win(wid%).sizeX, " ");
   
    DrawColor winstyle(sid).bordercolor
    PRINT sideRight;
  NEXT
  
  '
  ' Draw the lower border
  '
  LOCATE y2, x1
  PRINT lowerLeft; STRING$(win(wid%).sizeX, lowerFlat); lowerRight;

END SUB

SUB WinDrawBox2 (wid%)

  Assert wid% > 0, "WinDrawBox2", "wid cannot be 0"

  DIM idx AS INTEGER
  DIM row AS INTEGER

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
  ' Top border of the window
  '
  LOCATE win(wid%).posY - 1, win(wid%).posX - 1
  COLOR fc(0), bc(0)
  PRINT CHR$(220);
  PRINT STRING$(win(wid%).sizeX, 196);
  PRINT CHR$(191);

  FOR row = 1 TO win(wid%).sizeY

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
    LOCATE win(wid%).posY + row - 1, win(wid%).posX - 1
    COLOR fc(idx), bc(idx)
    PRINT ch(idx);

    '
    ' Inner space
    '
    COLOR fc(0), bc(0)
    PRINT STRING$(win(wid%).sizeX, " ");

    '
    ' Get the index of the right border char
    '
    idx = win(wid%).sizeY - row + 1
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
  LOCATE win(wid%).posY + win(wid%).sizeY, win(wid%).posX - 1
  COLOR fc(0), bc(0)
  PRINT CHR$(192);
  PRINT STRING$(win(wid%).sizeX, 196);
  PRINT CHR$(223);

END SUB

SUB WinDrawField (wid%, fid%)

  AssertIsPositive wid%, "WinDrawField", "wid"
  AssertIsPositive wid%, "WinDrawField", "fid"

  SELECT CASE fld(wid%, fid%).kind
    '
    ' Check the most common kinds first
    '
    CASE FieldKind.Button
      WinDrawText wid%, fid%

    CASE FieldKind.Label
      WinDrawText wid%, fid%

    CASE FieldKind.File
      WinDrawFile wid%, fid%

    CASE FieldKind.Separator
      WinDrawSeparator wid%, fid%

    CASE FieldKind.Nebula
      FieldDrawNebula wid%, fid%

    CASE ELSE
      WinDrawText wid%, fid%

  END SELECT

END SUB

SUB WinDrawFile (wid%, fid%)

  AssertIsPositive wid%, "WinDrawFile", "wid"
  AssertIsPositive fid%, "WinDrawFile", "fid"

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

SUB WinDrawSeparator (wid%, fid%)

  SELECT CASE winstyle(win(wid%).style).bordertype
    CASE 0
      WinDrawSeparator0 wid%, fid%
    CASE 1
      WinDrawSeparator1 wid%, fid%
    CASE 2
      WinDrawSeparator2 wid%, fid%
  END SELECT

END SUB

SUB WinDrawSeparator0 (wid%, fid%)

  AssertIsPositive wid%, "WinDrawSeparator0", "wid"
  AssertIsPositive fid%, "WinDrawSeparator0", "fid"

  DIM sx AS INTEGER
  DIM sy AS INTEGER

  DrawColor winstyle(win(wid%).style).bordercolor
 
  IF fld(wid%, fid%).offsetY > 0 THEN
    '
    ' Horizontal separator
    '
    sx = win(wid%).posX
    sy = win(wid%).posY + fld(wid%, fid%).offsetY
    LOCATE sy, sx
    PRINT STRING$(win(wid%).sizeX, 196);

  END IF

  IF fld(wid%, fid%).offsetX > 0 THEN
    '
    ' Vertical separator
    '
   
    sx = win(wid%).posX + fld(wid%, fid%).offsetX

    FOR sy = 1 TO win(wid%).sizeY
      LOCATE sy + win(wid%).posY - 1, sx
      PRINT CHR$(179);
    NEXT

  END IF

  IF fld(wid%, fid%).offsetX > 0 AND fld(wid%, fid%).offsetY > 0 THEN
    '
    ' Intersection
    '
    sx = win(wid%).posX + fld(wid%, fid%).offsetX
    sy = win(wid%).posY + fld(wid%, fid%).offsetY

    LOCATE sy, sx
    PRINT CHR$(197);

  END IF

END SUB

SUB WinDrawSeparator1 (wid%, fid%)
  '
  ' Draws the specified separator field based on a single-line border.
  '

  DIM sx AS INTEGER
  DIM sy AS INTEGER

  WinDrawSeparator0 wid%, fid%

  IF fld(wid%, fid%).offsetX > 0 THEN
    '
    ' Top border
    '
    sx = win(wid%).posX + fld(wid%, fid%).offsetX
    sy = win(wid%).posY - 1

    LOCATE sy, sx
    PRINT CHR$(194);

    '
    ' Bottom border
    '
    sy = win(wid%).posY + win(wid%).sizeY
    LOCATE sy, sx
    PRINT CHR$(193);

  END IF

  IF fld(wid%, fid%).offsetY > 0 THEN
    '
    ' Left border
    '
    sx = win(wid%).posX - 1
    sy = win(wid%).posY + fld(wid%, fid%).offsetY

    LOCATE sy, sx
    PRINT CHR$(195);
   
    '
    ' Right border
    '
    sx = win(wid%).posX + win(wid%).sizeX
    LOCATE sy, sx
    PRINT CHR$(180);

  END IF

END SUB

SUB WinDrawSeparator2 (wid%, fid%)
  WinDrawSeparator1 wid%, fid%
END SUB

SUB WinDrawText (wid%, fid%)
 
  AssertIsPositive wid%, "WinDrawText", "wid"
  AssertIsPositive fid%, "WinDrawText", "fid"

  DIM outoffx%
  DIM outoffy%
  DIM outsizex%
  DIM outtext$
  DIM sid%

  IF NOT WinClipText(wid%, fid%, outoffx%, outoffy%, outsizex%, outtext$) THEN
    '
    ' The text is not visible
    '
    EXIT SUB
  END IF

  '
  ' Calculate the screen coordinates of the field
  '
  sx = win(wid%).posX + outoffx%
  sy = win(wid%).posY + outoffy%
  LOCATE sy, sx

  sid% = FieldGetStyle(wid%, fid%)
  IF win(wid%).selected = fid% THEN
    DrawColor winstyle(sid%).selectedcolor
  ELSE
    DrawColor winstyle(sid%).textcolor
  END IF

  PRINT outtext$;

END SUB

FUNCTION WinFindSid% (stylename AS STRING)

  DIM sid%
 
  sid% = VAL(stylename)
  IF sid% > 0 THEN

    IF sid% >= LBOUND(winstyle) AND sid% <= UBOUND(winstyle) THEN
      WinFindSid% = sid%
      EXIT FUNCTION
    END IF

  ELSE

    FOR sid% = LBOUND(winstyle) TO UBOUND(winstyle)
      IF RTRIM$(winstyle(sid%).stylename) = stylename THEN
        WinFindSid% = sid%
        EXIT FUNCTION
      END IF
    NEXT

    WinFindSid% = 0

  END IF

END FUNCTION

FUNCTION WinFindWid% (wname$)
  '
  ' Returns the ID of the window with the specified name.
  '
 
  DIM wid AS INTEGER

  FOR wid = 1 TO wincount
    IF RTRIM$(win(wid).wname) = wname$ THEN
      WinFindWid% = wid
      EXIT FUNCTION
    END IF
  NEXT

  WinFindWid% = 0

END FUNCTION

FUNCTION WinGetStyle% (wid%)

  AssertIsPositive wid%, "WinGetStyle", "wid"

  WinGetStyle% = win(wid%).style

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

  winstacked = winstacked + 1
 
  '
  ' Assign video pages and update stack
  '
  backpage = winstacked - 1
  workpage = winstacked
  winstack(winstacked).wid = wid%
  winstack(winstacked).backpage = backpage
  winstack(winstacked).workpage = workpage

  '
  ' Draw the window
  '
  SCREEN , , workpage, backpage
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
  SCREEN , , workpage, workpage

END SUB

SUB WinRefreshField (wid%, fid%)

  DIM n AS INTEGER

  IF winstacked > 0 THEN
    IF winstack(winstacked).wid = wid% THEN
     
      WinDrawField wid%, fid%
   
      FOR n = 1 TO win(wid%).fields
        '
        ' Look for bound fields, but don't redraw the same field
        '
        IF n <> fid% THEN
          IF FieldIsBound%(wid%, n) THEN
            WinDrawField wid%, n
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

  SCREEN , , winstack(winstacked).workpage, winstack(winstacked).backpage
  PCOPY winstack(winstacked).backpage, winstack(winstacked).workpage
  WinDraw wid%
  SCREEN , , winstack(winstacked).workpage, winstack(winstacked).workpage

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

      ELSEIF fld(wid%, win(wid%).selected).kind <> FieldKind.Popup THEN
       
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
  win(wid%).style = sid%
END SUB

FUNCTION WorldAdd% (hid AS INTEGER, cx AS INTEGER, cy AS INTEGER)

  DIM aid AS INTEGER

  '
  ' Allocate the area
  '
  LET aid = WorldNextId%
  area(aid).allocated = True
  area(aid).habitat = hid
  area(aid).energy = 3

  AtlasAddItem cx, cy, aid, habitat(hid).labelrid

  WorldAdd% = aid

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
  END IF

END SUB

SUB WorldInit (areas AS INTEGER)
  '
  ' Initializes the world
  '
 
  DIM aid AS INTEGER
  DIM cx  AS INTEGER
  DIM cy  AS INTEGER
  DIM hid AS INTEGER
  DIM i   AS INTEGER

  WorldAddNebula 15

  FOR i = 1 TO areas

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

SUB WorldRemove (aid AS INTEGER)
  '
  ' Removes an area from the world
  '

  AssertIsPositive aid, "WorldRemove", "aid"

  IF area(aid).allocated THEN
    area(aid).allocated = False
    AtlasRemoveValue aid
  END IF

END SUB

SUB WorldSetLabel (aid AS INTEGER, labelrid AS INTEGER)
  '
  ' Updates the label for the specified area
  '
  AssertIsPositive aid, "WorldSetLabel", "aid"
  AssertIsPositive labelrid, "WorldSetLabel", "labelrid"

  DIM idx AS INTEGER
  LET idx = AtlasIndexOf(aid)
  IF idx > 0 THEN
    AtlasSetLabel idx, labelrid
  END IF

END SUB

