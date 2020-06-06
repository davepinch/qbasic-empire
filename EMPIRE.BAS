
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
  level     AS INTEGER
END TYPE

TYPE AtlasItemType
  allocated AS INTEGER
  cx        AS INTEGER
  cy        AS INTEGER
  value     AS INTEGER
  labelrid  AS INTEGER
END TYPE

TYPE FieldType
  kind     AS INTEGER
  childwid AS INTEGER  ' TODO: add nparam and combine these two
  cmdrid   AS INTEGER
  flags    AS INTEGER
  offsetX  AS INTEGER
  offsetY  AS INTEGER
  sid      AS INTEGER
  sizeX    AS INTEGER
  textrid  AS INTEGER
  value    AS INTEGER
END TYPE

TYPE HabitatType
  backdrop AS INTEGER
  UI       AS STRING * 3
  labelrid AS INTEGER
  titlerid AS INTEGER
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
DECLARE FUNCTION AtlasCellFiltered% (cx AS INTEGER, cy AS INTEGER)
DECLARE FUNCTION AtlasGetScreenX% (cx AS INTEGER)
DECLARE FUNCTION AtlasGetScreenY% (cy AS INTEGER)
DECLARE FUNCTION AtlasGetValue% (cx AS INTEGER, cy AS INTEGER, default AS INTEGER)
DECLARE FUNCTION AtlasIndexOf% (value AS INTEGER)
DECLARE FUNCTION AtlasPrompt (promptFor AS INTEGER, outcx AS INTEGER, outcy AS INTEGER, outpress AS STRING)

'
' Execute* subroutines
'
' Each subroutine executes a different menu command. Review the comments
' in the Execute() function to learn how to implement a command.
'
DECLARE FUNCTION ExecCmd% (text AS STRING)
DECLARE FUNCTION ExecCmdFid% (ntoken%, stoken$(), wid%, fid%)
DECLARE FUNCTION ExecCmdHid% (ntoken%, stoken$(), hid%)
DECLARE FUNCTION ExecCmdWid% (ntoken%, stoken$(), wid%, fid%)
DECLARE FUNCTION ExecCmdRoot% (ntoken%, stoken$(), hid%, sid%, wid%)
DECLARE FUNCTION ExecCmdSid% (ntoken%, stoken$(), sid%)
DECLARE FUNCTION ExecResource% (rid AS INTEGER)
DECLARE SUB ExecFile (filename AS STRING)

'
' Habitats
'
DECLARE FUNCTION HabitatCreate% ()
DECLARE SUB HabitatSetUI (hid%, UI$)
DECLARE SUB HabitatSetLabel (hid%, label$)
DECLARE SUB HabitatSetBackdrop (hid%, filename$)
DECLARE SUB HabitatSetTitle (hid%, title$)

'
' Inbox* subroutines
'
DECLARE SUB InboxAdd (subject AS STRING, value AS INTEGER)
DECLARE SUB InboxInit ()

'
' Nebula* subroutines
'
DECLARE SUB NebulaCreate (seq() AS INTEGER)
DECLARE SUB NebulaCreateSeq (seq() AS INTEGER, y!)
DECLARE SUB NebulaDraw (seq() AS INTEGER)
DECLARE SUB NebulaHarvest (seq() AS INTEGER)
DECLARE FUNCTION NebulaLabel$ (level AS INTEGER)
DECLARE FUNCTION NebulaLabelRid% (level AS INTEGER)

'
' Resource functions for saving general text data.
'
DECLARE FUNCTION ResourceCreate% (value AS STRING)
DECLARE FUNCTION ResourceGet$ (rid AS INTEGER)
DECLARE FUNCTION ResourceLength% (rid AS INTEGER)
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
DECLARE SUB UI.RedrawAbout ()
DECLARE SUB UI.RedrawArea ()
DECLARE SUB UI.RedrawAtlas ()
DECLARE SUB UI.RedrawFile (filename AS STRING)
DECLARE SUB UI.RedrawTable ()
DECLARE SUB UI.Refresh ()
DECLARE SUB UI.Run ()
DECLARE SUB UI.SetFilter (filter AS INTEGER, refreshUI AS INTEGER)
DECLARE SUB UI.SetPage (page AS INTEGER)

DECLARE FUNCTION UI.RunAbout% ()
DECLARE FUNCTION UI.RunArea% ()
DECLARE FUNCTION UI.RunAtlas% ()
DECLARE FUNCTION UI.RunInbox% ()
DECLARE FUNCTION UI.RunNebula% (aid AS INTEGER)

'
' Win* declarations
'
' These functions are used to create and manipulate windows on the
' screen. Note: due to lengthly parameters in some cases, the
' functions are defined with data type characters instead of "AS".
'
DECLARE FUNCTION WinAddButton% (wid%, posX%, posY%, sizeX%, text$, value%)
DECLARE FUNCTION WinAddSeparator% (wid%, posX%, posY%)
DECLARE FUNCTION WinClipText% (wid%, fid%, outposx%, outposy%, outsizex%, outtext$)
DECLARE FUNCTION WinGetText$ (wid%, fid%)
DECLARE FUNCTION WinCreate% ()
DECLARE FUNCTION WinCreateEx% (style%, posX%, posY%, sizeX%, sizeY%)
DECLARE FUNCTION WinCreateField% (wid%, kind%)
DECLARE FUNCTION WinExpandField$ (wid%, fid%)
DECLARE FUNCTION WinFindSid% (stylename AS STRING)
DECLARE FUNCTION WinGetStyle% (wid%, fid%)
DECLARE FUNCTION WinGetWid% (wname$)
DECLARE FUNCTION WinIsSelectable% (wid%, fid%)
DECLARE FUNCTION WinMapKey% (wid%, pressed$)
DECLARE FUNCTION WinParseMacro% (value$, index1%, outsel$, outval$)
DECLARE FUNCTION WinParseSelector% (wid%, fid%, sel$)

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
DECLARE SUB WinKey (wid%, fid%, keypress$)
DECLARE SUB WinKeyBoolean (wid%, fid%, keypress$)
DECLARE SUB WinKeyInteger (wid%, fid%, keypress$)
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
DECLARE SUB WinSetChild (wid%, fid%, wname$)
DECLARE SUB WinSetCommand (wid%, fid%, cmd$)
DECLARE SUB WinSetStyle (wid%, sid%)
DECLARE SUB WinSetText (wid%, fid%, text$, hasMacros%)
DECLARE SUB WinSetValue (wid%, fid%, value%)

'
' World* subroutines
'
DECLARE SUB WorldAddCluster (hid AS INTEGER, size AS INTEGER)
DECLARE SUB WorldAddNebula (size AS INTEGER)
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
DECLARE FUNCTION IsFiltered% (aid AS INTEGER)
DECLARE FUNCTION Split% (text AS STRING, tokens() AS STRING)
DECLARE FUNCTION StyleCreate% ()

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
CONST AtlasStyle.FilterBackcolor = 7
CONST AtlasStyle.FilterForecolor = 15
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
' Field Flags
'
CONST FieldFlag.None = 0
CONST FieldFlag.Macro = 1

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

'
' Habitat UIs
'
CONST HabitatUI.Nebula = "NEB"

'
' Maximum UI elements
'
CONST MaxFields = 13
CONST MaxWindows = 15

'
' NebulaIndex constants
'
CONST NebulaIndex.X = -2
CONST NebulaIndex.Y = -1
CONST NebulaIndex.Size = 0

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
CONST TableStyle.FilterBackcolor = 7
CONST TableStyle.FilterForecolor = 15
CONST TableStyle.HeaderBackcolor = 0
CONST TableStyle.HeaderForecolor = 7
CONST TableStyle.RowBackcolor = 0
CONST TableStyle.RowForecolor = 7
CONST TableStyle.Forecolor = 1

'
' UIFilter.* constants
'
CONST UIFilter.None = 0
CONST UIFilter.Self = 1

'
' UIPage.* constants
'
CONST UIPage.None = 0
CONST UIPage.About = 1
CONST UIPage.Area = 2
CONST UIPage.Atlas = 3
CONST UIPage.Inbox = 4
CONST UIPage.Table = 5

'
' UIResult.* constants
'
CONST UIResult.Exit = 0
CONST UIResult.Escape = 1

'
' VideoPage.* constants
'
' These constants define how each video page is used.
'
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
' Global world variables
'
DIM SHARED area(1 TO 30)       AS AreaType
DIM SHARED habitat(1 TO 10)    AS HabitatType
DIM SHARED habitats            AS INTEGER

'
' Global atlas variables
'
DIM SHARED atlasActive AS INTEGER
DIM SHARED atlasGrid(1 TO AtlasStyle.GridSizeX, 1 TO AtlasStyle.GridSizeY) AS INTEGER
DIM SHARED atlasItem(1 TO 30) AS AtlasItemType

'
' Global UI variables
'
DIM SHARED uiCurrentFilter AS INTEGER
DIM SHARED uiCurrentPage   AS INTEGER
DIM SHARED uicx AS INTEGER
DIM SHARED uicy AS INTEGER

'
' Global window variables
'
DIM SHARED fld(1 TO MaxWindows, 1 TO MaxFields) AS FieldType
DIM SHARED win(1 TO MaxWindows) AS WinType
DIM SHARED wincount         AS INTEGER
DIM SHARED winstack(1 TO 3) AS WinStackItem
DIM SHARED winstacked       AS INTEGER
DIM SHARED winstyle(1 TO 5) AS WinStyleType
DIM SHARED winstyles        AS INTEGER

DIM SHARED resource(1 TO 80) AS STRING
DIM SHARED resources         AS INTEGER

SetupGame
UI.Run

SUB Assert (truth AS INTEGER, where AS STRING, what AS STRING)

  IF NOT truth THEN
    SCREEN , , 0, 0
    StatusDebug where + ": " + what
    DIM s$: s$ = GetKey$
    END
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

FUNCTION AtlasCellFiltered% (cx AS INTEGER, cy AS INTEGER)
  '
  ' Returns True if the specified atlas cell is filtered.
  '
 
  '
  ' Get the index of the item referenced by the cell
  '
  DIM idx AS INTEGER
  LET idx = atlasGrid(cx, cy)
 
  IF idx = 0 THEN
    '
    ' This cell does not contain anything
    '
    AtlasCellFiltered% = False
 
  ELSE
    AtlasCellFiltered% = IsFiltered(atlasItem(idx).value)
  END IF

END FUNCTION

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
  IF AtlasCellFiltered(cx, cy) THEN
    COLOR AtlasStyle.FilterForecolor, AtlasStyle.FilterBackcolor
  ELSE
    COLOR AtlasStyle.CellForecolor, AtlasStyle.CellBackcolor
  END IF

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

  ' HACK: filtering conflicts with selection (e.g., different background)
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

  '
  ' Determine whether this area is being filtered
  '
  IF IsFiltered(aid) THEN
    COLOR TableStyle.FilterForecolor, TableStyle.FilterBackcolor
  ELSE
    COLOR TableStyle.RowForecolor, TableStyle.RowBackcolor
  END IF
 
  '
  ' Print the area ID
  '
  PRINT USING "##"; aid;
  PRINT "  "; ' HACK

  ' Print the habitat label
  DrawText ResourceGet(habitat(area(aid).habitat).titlerid)

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

FUNCTION ExecCmd% (text AS STRING)

  SHARED fid%
  SHARED hid%
  SHARED sid%
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
  ELSEIF hid% > 0 THEN
    result = ExecCmdHid%(ntoken%, stoken$(), hid%)
  ELSEIF sid% > 0 THEN
    result = ExecCmdSid%(ntoken%, stoken$(), sid%)
  ELSE
    result = ExecCmdRoot%(ntoken%, stoken$(), hid%, sid%, wid%)
  END IF

  Assert result = CmdResult.OK, "ExecCmd", "Malformed command"

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
    ' Three tokens: only the TEXT MACRO <STRING> command is valid.
    '
    IF LCASE$(stoken$(0)) = "text" THEN
      IF LCASE$(stoken$(1)) = "macro" THEN
        WinSetText wid%, fid%, stoken$(2), True
        ExecCmdFid% = CmdResult.OK
        EXIT FUNCTION
      END IF
    END IF

    ExecCmdFid% = CmdResult.Malformed
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
      WinSetChild wid%, fid%, stoken$(1)

    CASE "command"
      WinSetCommand wid%, fid%, stoken$(1)

    CASE "offsetx"
      fld(wid%, fid%).offsetX = VAL(stoken$(1))

    CASE "offsety"
      fld(wid%, fid%).offsetY = VAL(stoken$(1))

    CASE "sizex"
      fld(wid%, fid%).sizeX = VAL(stoken$(1))

    CASE "style"
      fld(wid%, fid%).sid = WinFindSid%(stoken$(1))

    CASE "text"
      WinSetText wid%, fid%, stoken$(1), False

    CASE "value"
      WinSetValue wid%, fid%, VAL(stoken$(1))

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

    CASE "backdrop"
      HabitatSetBackdrop hid%, stoken$(1)

    CASE "label"
      HabitatSetLabel hid%, stoken$(1)

    CASE "title"
      HabitatSetTitle hid%, stoken$(1)

    CASE "ui"
      HabitatSetUI hid%, stoken$(1)

    CASE ELSE
      ExecCmdHid = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdRoot% (ntoken%, stoken$(), hid%, sid%, wid%)

  Assert hid% = 0, "ExecCmdRoot", "hid context must be 0"
  Assert sid% = 0, "ExecCmdRoot", "sid context must be 0"
  Assert wid% = 0, "ExecCmdRoot", "wid context must be 0"

  ExecCmdRoot% = CmdResult.OK

  IF ntoken% = 1 THEN
    '
    ' Parameterless commands
    '
    SELECT CASE stoken$(0)

      CASE "window"
        wid% = WinCreate%

      CASE "about"
        UI.SetPage UIPage.About

      CASE "atlas"
        UI.SetPage UIPage.Atlas
  
      CASE "endgame"
        END

      CASE "habitat"
        hid% = HabitatCreate%

      CASE "inbox"
        UI.SetPage UIPage.Inbox

      CASE "newgame"
        InboxInit
        WorldInit 15

      CASE "style"
        winstyles = winstyles + 1
        sid% = winstyles

      CASE "table"
        UI.SetPage UIPage.Table

      CASE ELSE
        ExecCmdRoot% = CmdResult.Malformed

    END SELECT

  ELSEIF ntoken% = 2 THEN

    SELECT CASE stoken$(0)
      CASE "filter"
        '
        ' Filder <none | self>
        '
        SELECT CASE LCASE$(stoken$(1))
          CASE "none": UI.SetFilter UIFilter.None, True
          CASE "self": UI.SetFilter UIFilter.Self, True
          CASE ELSE
            ExecCmdRoot% = CmdResult.Malformed
        END SELECT

      CASE "option"
        '
        ' Option <Alerts>
        '
        SELECT CASE LCASE$(stoken$(1))
          CASE "alerts"
            WinRunName "DialogAlerts"
          CASE ELSE
            ExecCmdRoot% = CmdResult.Malformed
        END SELECT

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
            EXIT FUNCTION
        END SELECT

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

SUB HabitatSetBackdrop (hid%, filename$)

  AssertIsPositive hid%, "HabitatSetBackdrop", "hid"

  IF habitat(hid%).backdrop = 0 THEN
    habitat(hid%).backdrop = ResourceCreate%(filename$)
  ELSE
    ResourceSet habitat(hid%).backdrop, filename$
  END IF

END SUB

SUB HabitatSetLabel (hid%, label$)

  AssertIsPositive hid%, "HabitatSetLabel", "hid"

  IF habitat(hid%).labelrid = 0 THEN
    habitat(hid%).labelrid = ResourceCreate%(label$)
  ELSE
    ResourceSet habitat(hid%).labelrid, label$
  END IF

END SUB

SUB HabitatSetTitle (hid%, title$)

  AssertIsPositive hid%, "HabitatSetTitle", "hid"

  IF habitat(hid%).titlerid = 0 THEN
    habitat(hid%).titlerid = ResourceCreate(title$)
  ELSE
    ResourceSet habitat(hid%).titlerid, title$
  END IF

END SUB

SUB HabitatSetUI (hid%, UI$)
  AssertIsPositive hid%, "HabitatSetUI", "hid"
  habitat(hid%).UI = UI$
END SUB

SUB InboxAdd (subject AS STRING, value AS INTEGER)
  '
  ' Adds a new message to the inbox
  '
 
  DIM wid AS INTEGER
  DIM fid AS INTEGER
 
  SHARED posY AS INTEGER

  wid = WinGetWid("Inbox")
  fid = WinAddButton(wid, 0, posY, 20, " " + subject, value)
  posY = posY + 1

END SUB

SUB InboxInit
  '
  ' Initializes the mailbox to its default state
  '
 
  InboxAdd "Violation", 1
  'InboxAdd "Get out now", 2

END SUB

FUNCTION IsFiltered% (aid AS INTEGER)

  DIM filtering AS INTEGER

  IF aid < 1 OR aid > UBOUND(area) THEN
    '
    ' Invalid area
    '
    IsFiltered% = False
 
  ELSEIF NOT area(aid).allocated THEN

    IsFiltered% = False

  END IF

  IF filtering = UIFilter.None THEN
   
    IsFiltered = False

  ELSEIF filtering = UIFilter.Self THEN
   
    IsFiltered = False ' Not supported yet HACK

  ELSE

    IsFiltered = False

  END IF

END FUNCTION

SUB NebulaCreate (seq() AS INTEGER)

  DIM i AS INTEGER

  '
  ' Initialize y positions of each sequence
  '
  FOR i = LBOUND(seq, 1) TO UBOUND(seq, 1)
    seq(i, NebulaIndex.Y) = i
  NEXT

  FOR i = LBOUND(seq, 1) TO UBOUND(seq, 1)
    '
    ' Get a random index to swap
    '
    j = INT(RND * (UBOUND(seq, 1) - LBOUND(seq, 1) + 1)) + LBOUND(seq, 1)
  
    '
    ' Swap values
    '
    tmp = seq(i, NebulaIndex.Y)
    seq(i, NebulaIndex.Y) = seq(j, NebulaIndex.Y)
    seq(j, NebulaIndex.Y) = tmp

  NEXT

  FOR y = LBOUND(seq, 1) TO UBOUND(seq, 1)
   
    NebulaCreateSeq seq(), y
 
    '
    ' Randomly assign x position
    '
    seq(y, NebulaIndex.X) = INT(RND * (80 - seq(y, NebulaIndex.Size))) + 1

  NEXT
  
END SUB

SUB NebulaCreateSeq (seq() AS INTEGER, y)

  DIM i AS INTEGER
  DIM p AS INTEGER

  seq(y, 1) = 1
  p = 1

  FOR i = 2 TO UBOUND(seq, 2)
    SELECT CASE p
    
      CASE 0:
        SELECT CASE INT(RND * 3)
        
          CASE 0:
            p = 1

          CASE ELSE
            seq(y, NebulaIndex.Size) = i - 1
            EXIT SUB
      
        END SELECT
    
      CASE 1:
        SELECT CASE INT(RND * 4)
          CASE 0
            p = 0
          CASE 1
            p = 2
          CASE ELSE
            p = 1
        END SELECT
      CASE 2:
        SELECT CASE INT(RND * 4)
          CASE 0
            p = 1
          CASE 1
            p = 3
          CASE ELSE
            p = 2
        END SELECT
    
      CASE 3:
      
        SELECT CASE INT(RND * 4)
          CASE 0
            p = 3
          CASE ELSE
            p = 2
        END SELECT

    END SELECT
  
    seq(y, i) = p

  NEXT

  seq(y, NebulaIndex.Size) = UBOUND(seq, 2)

END SUB

SUB NebulaDraw (seq() AS INTEGER)

  DIM i AS INTEGER
  DIM j AS INTEGER

  FOR i = LBOUND(seq, 1) TO UBOUND(seq, 1)
 
    LOCATE seq(i, NebulaIndex.Y), seq(i, NebulaIndex.X)

    FOR j = 1 TO seq(i, NebulaIndex.Size)
     
      SELECT CASE seq(i, j)
        CASE 1:
          COLOR 8
          PRINT "Ä";

        CASE 2:
          COLOR 7
          PRINT "Ä";

        CASE 3:
          COLOR 15
          PRINT "Ä";

        CASE 0:
          PRINT " ";

      END SELECT
   
    NEXT

  NEXT

END SUB

SUB NebulaHarvest (seq() AS INTEGER)

  DIM v AS INTEGER
  DIM y AS INTEGER

  FOR y = LBOUND(seq, 1) TO UBOUND(seq, 1)
 
    FOR x = 1 TO seq(y, NebulaIndex.Size)
       
      v = seq(y, x)
      IF v > 0 THEN
        seq(y, x) = v - 1
      END IF

    NEXT

  NEXT

END SUB

FUNCTION NebulaLabel$ (level AS INTEGER)

  DIM label AS STRING

  SELECT CASE level

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

FUNCTION NebulaLabelRid% (level AS INTEGER)

  Assert level >= 0, "NebulaLabelRid", "level must be 0 or greater"
  Assert level <= 3, "NebulaLabelRid", "level must be 3 or less"

  STATIC created AS INTEGER
  STATIC lrid() AS INTEGER

  IF created = 0 THEN
    REDIM lrid(0 TO 3)
    FOR created = 0 TO 3
      lrid(created) = ResourceCreate(NebulaLabel$(created))
    NEXT
  END IF

  NebulaLabelRid% = lrid(level)

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
  ResourceGet$ = resource(rid)
END FUNCTION

FUNCTION ResourceLength% (rid AS INTEGER)
  IF rid = 0 THEN
    ResourceLength = 0
  ELSE
    ResourceLength = LEN(resource(rid))
  END IF
END FUNCTION

SUB ResourceSet (rid AS INTEGER, value AS STRING)

  resource(rid) = value

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
 
  WinRun WinGetWid("Start"), wresult
 
  IF wresult.action = WinAction.Execute THEN
    cresult = ExecResource%(wresult.cmdrid)
  END IF

END SUB

FUNCTION Split% (text AS STRING, tokens() AS STRING)

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
      CASE 0:
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
          state = 1
       
        ELSEIF char <> " " THEN
          '
          ' Start non-quoted token
          '
          count = count + 1
          quote = ""
          tokens(count + offset) = char
          state = 1

        END IF

      CASE 1:
        
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
    Assert hid <> 0, "UI.RunArea", "hit cannot be 0"

    SELECT CASE habitat(hid).UI
      CASE "NEB"
        UI.ActionNebula aid
    END SELECT

  END IF

END SUB

SUB UI.ActionNebula (aid AS INTEGER)

  AssertIsPositive aid, "UI.ActionNebula", "aid"

  DIM level AS INTEGER
  LET level = area(aid).level

  '
  ' Set the default level
  '
  IF level = 0 THEN
    level = 3
  END IF

  IF level = 1 THEN
   
    '
    ' This is the last extraction
    '
    WorldRemove aid
 
  ELSE
   
    '
    ' Extract one level
    '
    level = level - 1
    area(aid).level = level
    WorldSetLabel aid, NebulaLabelRid(level)

  END IF

END SUB

SUB UI.Redraw
  '
  ' Redraws the UI.
  '

  Assert uiCurrentPage <> UIPage.None, "UI.Redraw", "UI page must be set."

  SELECT CASE uiCurrentPage
 
    CASE UIPage.About
      UI.RedrawAbout

    CASE UIPage.Area
      UI.RedrawArea

    CASE UIPage.Atlas
      UI.RedrawAtlas

    CASE UIPage.Table
      UI.RedrawTable

  END SELECT

END SUB

SUB UI.RedrawAbout
  '
  ' Redraws the About page
  '

  Assert uiCurrentPage = UIPage.About, "UI.RedrawAbout", "Wrong UI page"

  UI.RedrawFile "ABOUT.PCB"

END SUB

SUB UI.RedrawArea
  '
  ' Redraws the current area
  '

  Assert uicx <> 0, "UI.RedrawArea", "uicx cannot be 0"
  Assert uicy <> 0, "UI.RedrawArea", "uicy cannot be 0"

  DIM aid AS INTEGER
  DIM hid AS INTEGER

  '
  ' Get the current area
  '
  aid = AtlasGetValue(uicx, uicy, 0)
  Assert aid <> 0, "UI.RedrawArea", "aid cannot be 0"

  '
  ' Get the habitat of the area
  '
  hid = area(aid).habitat
  Assert hid <> 0, "UI.RedrawArea", "hid cannot be 0"
  
  '
  ' Draw the backdrop file for this habitat
  '
  IF habitat(hid).backdrop > 0 THEN
    UI.RedrawFile ResourceGet(habitat(hid).backdrop)
  END IF

END SUB

SUB UI.RedrawAtlas

  SCREEN , , VideoPage.Working, VideoPage.Display
  CLS
  AtlasDraw
  SCREEN , , VideoPage.Working, VideoPage.Working
  PCOPY VideoPage.Working, VideoPage.Display
  SCREEN , , VideoPage.Display, VideoPage.Display

END SUB

SUB UI.RedrawFile (filename AS STRING)
  '
  ' Loads and redraws the specified file on the display page
  '
 
  SCREEN , , VideoPage.Working, VideoPage.Display
  CLS
 
  '
  ' Draw the file on second row (leaving space for the menu bar)
  '
  DrawFileAt filename, 1, 2
 
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
  menuwid = WinGetWid("Menu")

  DO
    
    Assert uiCurrentPage <> UIPage.None, "UI.Run", "UI page must be set"

    SELECT CASE uiCurrentPage
    
      CASE UIPage.About
        uresult = UI.RunAbout%

      CASE UIPage.Area
        uresult = UI.RunArea%

      CASE UIPage.Atlas
        uresult = UI.RunAtlas%

      CASE UIPage.Inbox
        uresult = UI.RunInbox%

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

FUNCTION UI.RunAbout%
  '
  ' Displays a screen showing information about the game.
  '

  Assert uiCurrentPage = UIPage.About, "UI.RunAbout", "Wrong UI page"

  DIM aboutWid AS INTEGER
  DIM result   AS WinResultType

  '
  ' Lookup the about window
  '
  aboutWid = WinGetWid("About")
  Assert aboutWid <> 0, "UI.RunAbout", "About window not found"

  WinRun aboutWid, result

  IF result.canceled THEN
    UI.RunAbout% = UIResult.Escape
  ELSE
    ' HACK: not sure which page to exit to
    UI.SetPage UIPage.Atlas
    UI.RunAbout% = UIResult.Exit
  END IF

END FUNCTION

FUNCTION UI.RunArea%

  Assert uiCurrentPage = UIPage.Area, "UI.RunArea", "Wrong UI page"

  DIM aid AS INTEGER
  DIM hid AS INTEGER

  '
  ' Get the current area
  '
  aid = AtlasGetValue(uicx, uicy, 0)
  Assert aid <> 0, "UI.RunArea", "aid cannot be 0"
  
  '
  ' Get the habitat of the area
  '
  hid = area(aid).habitat
  Assert hid <> 0, "UI.RunArea", "hit cannot be 0"

  SELECT CASE habitat(hid).UI
  
    CASE "NEB":
      UI.RunArea% = UI.RunNebula(aid)

    CASE ELSE
     
      SELECT CASE GetKey$
        CASE CHR$(ASCII.Escape)
          UI.RunArea% = UIResult.Escape
        CASE ELSE
          UI.SetPage UIPage.Atlas
          UI.RunArea% = UIResult.Exit
      END SELECT

  END SELECT

END FUNCTION

FUNCTION UI.RunAtlas%
 
  Assert uiCurrentPage = UIPage.Atlas, "UI.RunAtlas", "Wrong UI page"

  DIM outpress AS STRING

  '
  ' Set the default position if this is the first run
  '
  IF uicx = 0 THEN uicx = 1
  IF uicy = 0 THEN uicy = 1

PromptAgain:

  IF AtlasPrompt(AtlasPromptFor.Item, uicx, uicy, outpress) THEN

    SELECT CASE outpress
     
      CASE CHR$(ASCII.Return)
        UI.SetPage UIPage.Area
        UI.RunAtlas% = UIResult.Exit

      CASE " "
       
        UI.Action
        
        '
        ' Keep one GOTO in this code just to break the rules.
        '
        GOTO PromptAgain

    END SELECT

  ELSE
    '
    ' The player hit escape
    '
    UI.RunAtlas% = UIResult.Escape

  END IF

END FUNCTION

FUNCTION UI.RunInbox%

  Assert uiCurrentPage = UIPage.Inbox, "UI.RunInbox", "Wrong UI page"
  
  DIM result AS WinResultType
  DIM wid    AS INTEGER

  wid = WinGetWid("Inbox")
  WinRun wid, result
 
  IF result.canceled THEN
    UI.RunInbox% = UIResult.Escape
  ELSE
    UI.SetPage UIPage.Atlas
    UI.RunInbox% = UIResult.Exit
  END IF

END FUNCTION

FUNCTION UI.RunNebula% (aid AS INTEGER)

  Assert aid <> 0, "UI.RunNebula", "aid cannot be 0"

  DIM keypress AS STRING
  DIM seq(2 TO 24, -2 TO 30) AS INTEGER

  CLS

  '
  ' Create the nebula data structure
  '
  NebulaCreate seq()
 
  '
  ' HACK for now: update sequence to reflect the level
  '
  SELECT CASE area(aid).level
    CASE 0:
      area(aid).level = 3
    CASE 1:
      NebulaHarvest seq()
      NebulaHarvest seq()
    CASE 2:
      NebulaHarvest seq()
  END SELECT

  DO
   
    NebulaDraw seq()
   
    SELECT CASE area(aid).level
      CASE 3: StatusUpdate "@X07[@X0FSpace@X07] [@X0FESC@X07]"
      CASE 2: StatusUpdate "@X07[@X07Space@X07] [@X0FESC@X07]"
      CASE 1: StatusUpdate "@X07[@X08Space@X07] [@X0FESC@X07]"
      CASE 0: StatusUpdate "@X07[@X04Empty@X07] [@X0FESC@X07]"
    END SELECT

    keypress = GetKey$

    SELECT CASE keypress
     
      CASE CHR$(ASCII.Return), CHR$(ASCII.Backspace)
        UI.SetPage UIPage.Atlas
        UI.RunNebula% = UIResult.Exit
        EXIT FUNCTION

      CASE CHR$(ASCII.Escape)
        UI.RunNebula% = UIResult.Escape
        EXIT FUNCTION
    
      CASE " "
       
        IF area(aid).level = 0 THEN
          UI.RunNebula% = UIResult.Exit
          EXIT FUNCTION
        END IF

        '
        ' Perform the harvest
        '
        area(aid).level = area(aid).level - 1
        NebulaHarvest seq()
       
        '
        ' Update or remove the label
        '
        IF area(aid).level = 0 THEN
          WorldRemove aid
        ELSE
          WorldSetLabel aid, NebulaLabelRid(area(aid).level)
        END IF

    END SELECT

  LOOP

END FUNCTION

SUB UI.SetFilter (filter AS INTEGER, refreshUI AS INTEGER)
  '
  ' Applies a filter to emphasize items and optionally refreshes the screen.
  '

  uiCurrentFilter = filter

  IF refreshUI THEN
    UI.Refresh
  END IF

END SUB

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
  fld(wid%, fid%).textrid = ResourceCreate(text$)
  fld(wid%, fid%).value = value%

  WinAddButton% = fid%

END FUNCTION

FUNCTION WinAddSeparator% (wid%, offsetX%, offsetY%)

  AssertIsPositive wid%, "WinAddSeparator", "wid"

  DIM fid%
  LET fid% = WinCreateField(wid%, FieldKind.Separator)

  fld(wid%, fid%).childwid = 0
  fld(wid%, fid%).cmdrid = 0
  fld(wid%, fid%).flags = 0
  fld(wid%, fid%).offsetX = offsetX%
  fld(wid%, fid%).offsetY = offsetY%
  fld(wid%, fid%).sizeX = 0
  fld(wid%, fid%).value = 0

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
      fieldSizeX% = ResourceLength(fld(wid%, fid%).textrid)
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
  LET text$ = WinGetText(wid%, fid%)

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

  sid = WinGetStyle(wid%, 0)
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

  sid = WinGetStyle(wid%, 0)

  '
  ' Draw the top border
  '
  LOCATE y1, x1
  DrawColor winstyle(sid).bordercolor
  PRINT upperLeft; STRING$(win(wid%).sizeX, upperFlat); upperRight

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
  PRINT lowerLeft; STRING$(win(wid%).sizeX, lowerFlat); lowerRight

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

    CASE FieldKind.Separator
      WinDrawSeparator wid%, fid%

    CASE FieldKind.File
      WinDrawFile wid%, fid%

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

  filename = WinGetText$(wid%, fid%)
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

  sid% = WinGetStyle(wid%, fid%)
  IF win(wid%).selected = fid% THEN
    DrawColor winstyle(sid%).selectedcolor
  ELSE
    DrawColor winstyle(sid%).textcolor
  END IF

  PRINT outtext$;

END SUB

FUNCTION WinExpandField$ (wid%, fid%)

  AssertIsPositive wid%, "WinExpandText", "wid"
  AssertIsPositive fid%, "WinExpandText", "fid"

  DIM build   AS STRING   ' Built from expanded macros
  DIM nextidx AS INTEGER  ' Index of the next {
  DIM thisidx AS INTEGER  ' Index being checked
  DIM textlen AS INTEGER  ' Source text length
  DIM textval AS STRING   ' Source text

  thisidx = 1
  textval = ResourceGet(fld(wid%, fid%).textrid)
  textlen = LEN(textval)
 
  DO WHILE thisidx < textlen

    '
    ' Find opening bracket
    '
    nextidx = INSTR(thisidx, textval, "{")
    IF nextidx = 0 THEN
      '
      ' Append the rest of the string
      '
      build = build + RIGHT$(textval, textlen - thisidx + 1)
      EXIT DO
    END IF

    '
    ' Append the chars up to the bracket
    '
    build = build + MID$(textval, thisidx, nextidx - thisidx)

    '
    ' Parse the macro
    '
    DIM outsel AS STRING
    DIM outval AS STRING
    thisidx = WinParseMacro(textval, nextidx, outsel, outval)

    IF thisidx = 0 THEN
      '
      ' Not a macro, skip over the {
      '
      build = build + "{"
      thisidx = nextidx + 1

    ELSE
      '
      ' Parse the selector
      '
      DIM selfid AS INTEGER
      LET selfid = WinParseSelector(wid%, fid%, outsel)
      IF selfid > 0 THEN
        SELECT CASE outval
          CASE "Value", "value"
            build = build + LTRIM$(STR$(fld(wid%, selfid).value))
        END SELECT
      END IF

    END IF

  LOOP

  WinExpandField = build

END FUNCTION

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

FUNCTION WinGetStyle% (wid%, fid%)

  AssertIsPositive wid%, "WinGetStyle", "wid"

  DIM sid%

  IF fid% = 0 THEN
    sid% = win(wid%).style
  ELSE
    sid% = fld(wid%, fid%).sid
    IF sid% = 0 THEN
      sid% = win(wid%).style
    END IF
  END IF

  WinGetStyle% = sid%
  
END FUNCTION

FUNCTION WinGetText$ (wid%, fid%)

  IF (fld(wid%, fid%).flags AND FieldFlag.Macro) > 0 THEN
    WinGetText$ = WinExpandField$(wid%, fid%)
  ELSE
    WinGetText$ = ResourceGet(fld(wid%, fid%).textrid)
  END IF

END FUNCTION

FUNCTION WinGetWid% (wname$)
  '
  ' Returns the ID of the window with the specified name.
  '
 
  DIM wid AS INTEGER

  FOR wid = 1 TO wincount
    IF RTRIM$(win(wid).wname) = wname$ THEN
      WinGetWid% = wid
      EXIT FUNCTION
    END IF
  NEXT

  WinGetWid% = 0

END FUNCTION

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

      CASE FieldKind.Popup
        WinIsSelectable = True

      CASE ELSE
        WinIsSelectable = False

    END SELECT

  END IF

END FUNCTION

SUB WinKey (wid%, fid%, keypress$)
  '
  ' Sends a keystroke to a field in the window
  '
 
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
 
  DIM text AS STRING
  LET text = WinGetText(wid%, fid%)

  SELECT CASE keypress$

    CASE " "
      SELECT CASE text
        CASE "No"
          WinSetText wid%, fid%, "Yes", False
        CASE "Yes"
          WinSetText wid%, fid%, "No", False
      END SELECT

    CASE "n", "N"
      WinSetText wid%, fid%, "No", False

    CASE "y", "Y"
      WinSetText wid%, fid%, "Yes", False

  END SELECT

END SUB

SUB WinKeyInteger (wid%, fid%, keypress$)
  '
  ' Sends a key to an integer field
  '

  DIM buf$
  LET buf$ = WinGetText$(wid%, fid%)

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

  WinSetText wid%, fid%, buf$, False

END SUB

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

FUNCTION WinParseMacro% (value$, index1%, outsel$, outval$)

  '
  ' Validate starting index
  '
  IF index1% < 1 OR index1% > LEN(value$) THEN
    WinParseMacro% = 0
    EXIT FUNCTION
  ELSEIF MID$(value$, index1%, 1) <> "{" THEN
    WinParseMacro% = 0
    EXIT FUNCTION
  END IF

  '
  ' Get index of :
  '
  DIM index2%
  LET index2% = INSTR(index1% + 1, value$, ":")
  IF index2% = 0 THEN
    WinParseMacro% = 0
    EXIT FUNCTION
  END IF

  '
  ' Get index of }
  '
  DIM index3%
  index3% = INSTR(index2% + 1, value$, "}")
  IF index3% = 0 THEN
    WinParseMacro% = 0
    EXIT FUNCTION
  END IF

  ' Value: AB{C:D}E
  ' Index: 12345678

  outsel$ = MID$(value$, index1% + 1, index2% - index1% - 1)
  outval$ = MID$(value$, index2% + 1, index3% - index2% - 1)
 
  '
  ' Return index of next character to start parsing
  '
  WinParseMacro = index3% + 1

END FUNCTION

FUNCTION WinParseSelector% (wid%, fid%, sel$)
 
  DIM selected AS INTEGER

  IF sel$ = "sel" THEN
    selected = win(wid%).selected
  ELSEIF LEN(sel$) = 0 THEN
    selected = fid%
  ELSE
    selected = VAL(sel$)
  END IF

  WinParseSelector% = selected%

END FUNCTION

SUB WinRefreshField (wid%, fid%)

  DIM n AS INTEGER

  IF winstacked > 0 THEN
    IF winstack(winstacked).wid = wid% THEN
     
      WinDrawField wid%, fid%
   
      FOR n = 1 TO win(wid%).fields
        IF (fld(wid%, n).flags AND FieldFlag.Macro) > 0 THEN
          WinDrawField wid%, n
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
        WinKey wid%, (win(wid%).selected), pressed

    END SELECT

  LOOP

END SUB

SUB WinRunName (idname$)
 
  DIM wid AS INTEGER
  DIM result AS WinResultType

  wid = WinGetWid(idname$)
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

  AssertIsPositive wid%, "WinSelectLast", "wid"

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

      IF WinIsSelectable(wid%, fid%) THEN
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

      IF WinIsSelectable(wid%, fid%) THEN
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

SUB WinSetChild (wid%, fid%, wname$)

  AssertIsPositive wid%, "WinSetChild", "wid"
  AssertIsPositive fid%, "WinSetChild", "fid"

  fld(wid%, fid%).childwid = WinGetWid%(wname$)

END SUB

SUB WinSetCommand (wid%, fid%, cmd$)

  AssertIsPositive wid%, "WinSetCommand", "wid"
  AssertIsPositive fid%, "WinSetCommand", "fid"

  IF fld(wid%, fid%).cmdrid = 0 THEN
    fld(wid%, fid%).cmdrid = ResourceCreate(cmd$)
  ELSE
    ResourceSet fld(wid%, fid%).cmdrid, cmd$
  END IF

END SUB

SUB WinSetStyle (wid%, sid%)
  
  AssertIsPositive wid%, "WinSetStyle", "wid"

  win(wid%).style = sid%

END SUB

SUB WinSetText (wid%, fid%, text$, hasMacros%)
  '
  ' Sets the text of the specified field.
  '

  AssertIsPositive wid%, "WinSetText", "wid"
  AssertIsPositive fid%, "WinSetText", "fid"

  '
  ' Create or update the resource
  '
  DIM rid%
  LET rid% = fld(wid%, fid%).textrid
  IF rid% = 0 THEN
    fld(wid%, fid%).textrid = ResourceCreate(text$)
  ELSE
    ResourceSet rid%, text$
  END IF

  IF hasMacros% THEN
    fld(wid%, fid%).flags = fld(wid%, fid%).flags OR FieldFlag.Macro
  ELSE
    fld(wid%, fid%).flags = fld(wid%, fid%).flags AND (NOT FieldFlag.Macro)
  END IF

  WinRefreshField wid%, fid%

END SUB

SUB WinSetValue (wid%, fid%, value%)

  AssertIsPositive wid%, "WinSetValue", "wid"
  AssertIsPositive fid%, "WinSetValue", "fid"

  fld(wid%, fid%).value = value%

END SUB

FUNCTION WorldAdd% (hid AS INTEGER, cx AS INTEGER, cy AS INTEGER)

  DIM aid AS INTEGER

  '
  ' Allocate the area
  '
  LET aid = WorldNextId%
  area(aid).allocated = True
  area(aid).habitat = hid

  AtlasAddItem cx, cy, aid, habitat(hid).labelrid

  WorldAdd% = aid

END FUNCTION

SUB WorldAddCluster (hid AS INTEGER, size AS INTEGER)

  DIM aid AS INTEGER
  DIM cx  AS INTEGER
  DIM cy  AS INTEGER
  DIM i   AS INTEGER
 
  FOR i = 1 TO size
    AtlasNextClustered cx, cy
    aid = WorldAdd%(hid, cx, cy)
  NEXT
  
END SUB

SUB WorldAddNebula (size AS INTEGER)

  DIM hid AS INTEGER
  DIM i   AS INTEGER

  '
  ' Find the nebula habitat
  '
  FOR i = 1 TO habitats
    IF habitat(i).UI = HabitatUI.Nebula THEN
      hid = i
      EXIT FOR
    END IF
  NEXT
  IF hid = 0 THEN
    StatusDebug "WorldAddNebula: unable to find nebula habitat"
    EXIT SUB
  END IF

  WorldAddCluster hid, size

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

