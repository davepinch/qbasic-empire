' Emperor
' By David Pinch, 1991, 2020-2023
'
' MIT License
' https://github.com/davepinch/qbasic-empire
'
' To begin, press Shift + F5.
' To exit QBASIC, press Alt, F, X.
' To view full screen (in DOSBox), press Alt-Enter.

TYPE AreaType
  allocated AS INTEGER
  hbid      AS INTEGER
  energy    AS INTEGER
END TYPE

TYPE AtlasItemType
  allocated AS INTEGER
  cx        AS INTEGER
  cy        AS INTEGER
  labelrsid AS INTEGER
  value     AS INTEGER
END TYPE

TYPE PropType
  flags AS INTEGER
  value AS INTEGER
END TYPE

TYPE TriggerType
  evid     AS INTEGER
  operator AS INTEGER
  operand  AS INTEGER
  cmdrsid  AS INTEGER
END TYPE

TYPE WnResultType
  action   AS INTEGER
  canceled AS INTEGER
  cmdrsid  AS INTEGER
  selected AS INTEGER
END TYPE

TYPE WnStackItem
  wnid     AS INTEGER
  backpage AS INTEGER
  workpage AS INTEGER
END TYPE

TYPE WnType
  arrowexit  AS INTEGER
  fields     AS INTEGER
END TYPE

'
' Assertions
'
DECLARE SUB Assert (truth AS INTEGER, where AS STRING, what AS STRING)
DECLARE SUB AssertExpected (expected%, actual%, where$, what$)
DECLARE SUB AssertFail (where$, what$)
DECLARE SUB AssertIsPositive (value%, where$, what$)
DECLARE SUB AssertIsZero (value%, where$, what$)

'
' Atlas
'
DECLARE SUB AtlasAddItem (cx AS INTEGER, cy AS INTEGER, value AS INTEGER, labelrsid AS INTEGER)
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
DECLARE SUB AtlasSetLabel (idx AS INTEGER, labelrsid AS INTEGER)
DECLARE SUB AtlasSetStatus (text$)
DECLARE SUB AtlasSetStatusEx (text$, attr%)
DECLARE FUNCTION AtlasNextIndex% ()
DECLARE FUNCTION AtlasGetScreenX% (cx AS INTEGER)
DECLARE FUNCTION AtlasGetScreenY% (cy AS INTEGER)
DECLARE FUNCTION AtlasGetValue% (cx AS INTEGER, cy AS INTEGER, default AS INTEGER)
DECLARE FUNCTION AtlasIndexOf% (value AS INTEGER)
DECLARE FUNCTION AtlasPrompt (promptFor AS INTEGER, outcx AS INTEGER, outcy AS INTEGER, outpress AS STRING)

'
' Control API
'
DECLARE FUNCTION CtCreate% (kind%)
DECLARE SUB CtDraw (wnid%, fid%)
DECLARE SUB CtDrawBox (ctid%)
DECLARE SUB CtDrawBox0 (ctid%)
DECLARE SUB CtDrawBox1 (ctid%)
DECLARE SUB CtDrawBox2 (ctid%)
DECLARE SUB CtDrawFile (ctid%)
DECLARE SUB CtDrawNebula (ctid%)
DECLARE SUB CtDrawSeparator (ctid%)
DECLARE SUB CtDrawText (wnid%, fid%)
DECLARE SUB CtKey (ctid%, keypress$)
DECLARE SUB CtKeyBoolean (ctid%, keypress$)
DECLARE SUB CtKeyInteger (ctid%, keypress$)
DECLARE SUB CtSet (ctid%, ctix%, value%)
DECLARE SUB CtSetName (ctid%, value$)
DECLARE SUB CtSetParam (ctid%, value%)
DECLARE SUB CtSetValue (ctid%, value$)
DECLARE FUNCTION CtCreateChild% (wnid%, kind%)
DECLARE FUNCTION CtGet% (ctid%, ctix%)
DECLARE FUNCTION CtGetName$ (ctid%)
DECLARE FUNCTION CtGetOffsetX% (ctid%)
DECLARE FUNCTION CtGetOffsetY% (ctid%)
DECLARE FUNCTION CtGetParam% (ctid%)
DECLARE FUNCTION CtGetScreenX% (ctid%)
DECLARE FUNCTION CtGetScreenY% (ctid%)
DECLARE FUNCTION CtGetSelected% (ctid%)
DECLARE FUNCTION CtGetStyle% (ctid%)
DECLARE FUNCTION CtGetValue$ (ctid%)
DECLARE FUNCTION CtRedirected% (ctid%, pid%)
DECLARE FUNCTION CtSelectable% (ctid%)

'
' Dialog API
'
DECLARE SUB DgNext (outpid%, outtext$)
DECLARE SUB DgPrint (pid%, text$)
DECLARE SUB DgStart (hbid%)
DECLARE SUB DgStop ()
DECLARE SUB DgTimer ()
DECLARE FUNCTION DgGarble$ (text$, percent!)

'
' Drawing
'
DECLARE SUB DrawBackground (sx1%, sy1%, sx2%, sy2%, backcolor%)
DECLARE SUB DrawColor (attr%)
DECLARE SUB DrawFile (filename$)
DECLARE SUB DrawFileAt (filename$, sx%, sy%)
DECLARE SUB DrawText (text$)
DECLARE FUNCTION DrawLength% (text$)

'
' Event API
'
DECLARE SUB EvIncrement (name$)
DECLARE SUB EvFire (evid%)
DECLARE SUB EvSetName (evid%, name$)
DECLARE SUB EvSetValue (evid%, value%)
DECLARE FUNCTION EvCreate% ()
DECLARE FUNCTION EvFind% (name$)
DECLARE FUNCTION EvGetValue% (evid%)
DECLARE FUNCTION EvParseOperator% (opname$)
DECLARE FUNCTION EvTestTrigger% (evid%, tid%)

'
' Execution/commands
'
DECLARE SUB ExecFile (filename AS STRING)
DECLARE FUNCTION ExecCmd% (cmd$)
DECLARE FUNCTION ExecCmdEvid% (ntoken%, stoken$(), evid%)
DECLARE FUNCTION ExecCmdFid% (ntoken%, stoken$(), wnid%, fid%)
DECLARE FUNCTION ExecCmdHbid% (ntoken%, stoken$(), hbid%)
DECLARE FUNCTION ExecCmdPrid% (ntoken%, stoken$(), prid%)
DECLARE FUNCTION ExecCmdRoot% (ntoken%, stoken$(), evid%, hbid%, prid%, stid%, tid%, wnid%)
DECLARE FUNCTION ExecCmdStid% (ntoken%, stoken$(), stid%)
DECLARE FUNCTION ExecCmdTid% (ntoken%, stoken$(), tid%)
DECLARE FUNCTION ExecCmdWnid% (ntoken%, stoken$(), wnid%, fid%)
DECLARE FUNCTION ExecResource% (rsid%)

'
' Game
'
DECLARE SUB GameMoveOffset (offsetX%, offsetY%)

'
' Habitat API
'
DECLARE FUNCTION HbCreate% ()
DECLARE FUNCTION HbFind% (name$)
DECLARE FUNCTION HbGet% (hbid%, hbix%)
DECLARE SUB HbSet (hbid%, hbix%, value%)

'
' Inbox
'
DECLARE SUB InboxAdd (subject AS STRING, filename AS STRING)

'
' List API
'
DECLARE FUNCTION LsAdd% (lsid%, value%)
DECLARE FUNCTION LsCapacity% ()
DECLARE FUNCTION LsCreate% ()
DECLARE FUNCTION LsCount% (lsid%)
DECLARE FUNCTION LsGet% (lsid%, n%)
DECLARE SUB LsSet (lsid%, n%, value%)

'
' Nebula
'
DECLARE FUNCTION NebulaLabel$ (energy AS INTEGER)
DECLARE FUNCTION NebulaLabelRsid% (energy AS INTEGER)

'
' Object API
'
DECLARE FUNCTION ObCreate% (kind%)
DECLARE FUNCTION ObFindString% (kind%, obix%, value$)
DECLARE FUNCTION ObGet% (obid%, obix%)
DECLARE FUNCTION ObGetKind% (obid%)
DECLARE FUNCTION ObGetString$ (obid%, obix%)
DECLARE FUNCTION ObResolveParam% (obid%, value%)
DECLARE FUNCTION ObResolveFocused% (obid%, value%)
DECLARE SUB ObBind (obid%, obix%, expr$)
DECLARE SUB ObSet (obid%, obix%, value%)
DECLARE SUB ObSetString (obid%, obix%, value$)

'
' Person API
'
DECLARE FUNCTION PrCreate% ()
DECLARE FUNCTION PrGet% (prid%, prix%)
DECLARE FUNCTION PrRandomly% ()
DECLARE SUB PrSet (prid%, prix%, value%)

'
' Resource API
'
DECLARE SUB RsSet (outrsid%, value$)
DECLARE FUNCTION RsCreate% (value$)
DECLARE FUNCTION RsGet$ (rsid%)

'
' UI
'
DECLARE SUB UI.Run ()
DECLARE SUB UI.RunAtlas ()
DECLARE SUB UI.RunTerminal ()
DECLARE SUB UI.SetPage (page AS INTEGER)

'
' Style API
'
DECLARE FUNCTION StCreate% ()
DECLARE FUNCTION StGetBorderColor% (stid%)
DECLARE FUNCTION StGetBorderType% (stid%)
DECLARE FUNCTION StGetName$ (stid%)
DECLARE FUNCTION StGetSelectedColor% (stid%)
DECLARE FUNCTION StGetTextColor% (stid%)
DECLARE SUB StSet (stid%, stix%, value%)
DECLARE SUB StSetName (stid%, name$)
DECLARE SUB StSetTextColor (stid%, textcolor%)

'
' Terminal API
'
DECLARE SUB TrBegin ()
DECLARE SUB TrClear ()
DECLARE SUB TrEnd ()
DECLARE SUB TrFile (filename$)
DECLARE SUB TrPrint (text$)

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
' Window API
'
DECLARE SUB WnClose (wnid%)
DECLARE SUB WnDraw (wnid%)
DECLARE SUB WnFocusOn (wnid%, fid%)
DECLARE SUB WnFocusOnFirst (wnid%)
DECLARE SUB WnFocusOnLast (wnid%)
DECLARE SUB WnFocusOnNext (wnid%)
DECLARE SUB WnFocusOnPrevious (wnid%)
DECLARE SUB WnRefreshField (wnid%, fid%)
DECLARE SUB WnRender (wnid%)
DECLARE SUB WnRun (wnid%, result AS WnResultType)
DECLARE SUB WnRunName (idname$)
DECLARE FUNCTION WnAddButton% (wnid%, offsetX%, offsetY%, sizeX%, text$, value$)
DECLARE FUNCTION WnCreate% ()
DECLARE FUNCTION WnFindStid% (stylename$)
DECLARE FUNCTION WnFindWnid% (wname$)
DECLARE FUNCTION WnGet% (wnid%, wnix%)
DECLARE FUNCTION WnMapKey% (wnid%, pressed$)

'
' World
'
DECLARE SUB WorldAddBanded (hbid%, count%)
DECLARE SUB WorldAddCluster (hbid%, count%)
DECLARE SUB WorldAddRandom (hbid%, count%)
DECLARE SUB WorldHarvest (aid%)
DECLARE SUB WorldRemove (aid%)
DECLARE SUB WorldSetLabel (aid%, labelrsid%)
DECLARE FUNCTION WorldAdd% (hbid%, cx%, cy%)
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
' Control kinds
'
CONST CtKind.None = 0
CONST CtKind.Boolean = 1
CONST CtKind.Box = 2
CONST CtKind.Button = 3
CONST CtKind.Container = 4
CONST CtKind.File = 5
CONST CtKind.Integer = 6
CONST CtKind.Label = 7
CONST CtKind.Popup = 8
CONST CtKind.Separator = 9
CONST CtKind.Nebula = 100

'
' Control properties
'
CONST CtIndex.Value = 1
CONST CtIndex.ChildList = 2
CONST CtIndex.Command = 3
CONST CtIndex.Kind = 4
CONST CtIndex.Name = 5
CONST CtIndex.OffsetX = 6
CONST CtIndex.OffsetY = 7
CONST CtIndex.Param = 8
CONST CtIndex.Parent = 9
CONST CtIndex.Popup = 10
CONST CtIndex.Selected = 11
CONST CtIndex.SizeX = 12
CONST CtIndex.SizeY = 13
CONST CtIndex.Style = 14
CONST CtIndex.Text = 15
CONST CtIndex.Window = 16

'
' Event properties
'
CONST EvIndex.Name = 1
CONST EvIndex.Value = 2

'
' Habitat properties
'
CONST HbIndex.Backdrop = 1
CONST HbIndex.Label = 2
CONST HbIndex.Name = 3
CONST HbIndex.StartFile = 4
CONST HbIndex.Window = 5

'
' List properties
'
CONST LsIndex.Count = 1
CONST LsIndex.First = 2

'
' Object bindings
'
CONST ObBinding.None = 0
CONST ObBinding.Focused = 1
CONST ObBinding.Param = 2

'
' Object kinds
'
CONST ObKind.None = 0
CONST ObKind.Control = 1
CONST ObKind.Event = 2
CONST ObKind.Habitat = 3
CONST ObKind.List = 4
CONST ObKind.Person = 5
CONST ObKind.Style = 6
CONST ObKind.Window = 7

'
' Object properties
'
CONST ObIndex.Kind = 0

'
' Operators
'
CONST OpNone = 0
CONST OpEquals = 1

'
' Person properties
'
CONST PrIndex.Name = CtIndex.Name
CONST PrIndex.Label = CtIndex.Text

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
' Style properties
'
CONST StIndex.BorderColor = 1
CONST StIndex.BorderType = 2
CONST StIndex.Name = 3
CONST StIndex.SelectedColor = 4
CONST StIndex.TextColor = 5

'
' UIPage.* constants
'
CONST UIPage.None = 0
CONST UIPage.Atlas = 1
CONST UIPage.Terminal = 2

'
' Window actions
'
CONST WnAction.None = 0
CONST WnAction.Cancel = 1
CONST WnAction.Complete = 2
CONST WnAction.Execute = 3
CONST WnAction.ExitLeft = 4
CONST WnAction.ExitRight = 5
CONST WnAction.OpenPopup = 11
CONST WnAction.SelectFirst = 12
CONST WnAction.SelectLast = 13
CONST WnAction.SelectNext = 14
CONST WnAction.SelectPrevious = 15

'
' Window properties
'
CONST WnIndex.ArrowExit = 1
CONST WnIndex.Container = 2
CONST WnIndex.Name = 3
CONST WnIndex.Focused = 4
CONST WnIndex.Param = 5

'
' Global atlas variables
'
DIM SHARED atlasGrid(1 TO AtlasStyle.GridSizeX, 1 TO AtlasStyle.GridSizeY) AS INTEGER
                 
'
' Globals
'
DIM SHARED gobj(1 TO 200, 0 TO 16) AS PropType
DIM SHARED gwin(1 TO 20, 0 TO 13)  AS INTEGER
DIM SHARED gobids                  AS INTEGER

DIM SHARED area(1 TO 35)         AS AreaType
DIM SHARED atlasitem(1 TO 35)    AS AtlasItemType
DIM SHARED atlaspage             AS INTEGER
DIM SHARED listening             AS INTEGER
DIM SHARED playeraid             AS INTEGER
REDIM SHARED resource(1 TO 200)  AS STRING
DIM SHARED resources             AS INTEGER
DIM SHARED trigger(1 TO 5)       AS TriggerType
DIM SHARED triggers              AS INTEGER
DIM SHARED uiCurrentPage         AS INTEGER
DIM SHARED vallocated            AS INTEGER
DIM SHARED vstack(0 TO 5)        AS INTEGER
DIM SHARED vstacked              AS INTEGER
DIM SHARED win(1 TO 15)          AS WnType
DIM SHARED wincount              AS INTEGER
DIM SHARED winstack(1 TO 3)      AS WnStackItem
DIM SHARED winstacked            AS INTEGER

ON TIMER(1) GOSUB HandleTimer

SetupGame
UI.Run
END

HandleTimer:
  '
  ' Executed when the game needs to perform periodic tasks
  '
  IF listening > 0 THEN
    DgTimer
  END IF
  RETURN

SUB Assert (truth AS INTEGER, where AS STRING, what AS STRING)

  IF NOT truth THEN
   
    DIM message AS STRING
    LET message = where + ": " + what

    AtlasSetStatusEx message, &H4F
    TrPrint "@X4F" + message + "@X07"

    IF GetKey$ <> CHR$(ASCII.Escape) THEN
      END
    END IF
 
  END IF

END SUB

SUB AssertExpected (expected%, actual%, where$, what$)

  IF expected% <> actual% THEN
 
    DIM msg$
    msg$ = what$ + " expected:" + STR$(expected%) + " actually:" + STR$(actual%)

    AssertFail where$, msg$

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

SUB AtlasAddItem (cx AS INTEGER, cy AS INTEGER, value AS INTEGER, labelrsid AS INTEGER)
  '
  ' Adds an item to the atlas at the specified position.
  '
  DIM idx AS INTEGER
  
  '
  ' Get the index of the new item
  '
  idx = AtlasNextIndex%
  IF idx = 0 THEN
    AssertFail "AtlasAddItem", "AtlasNextIndex returned 0"
    EXIT SUB
  END IF

  '
  ' Add the item to the item list
  '
  atlasitem(idx).allocated = -1
  atlasitem(idx).cx = cx
  atlasitem(idx).cy = cy
  atlasitem(idx).labelrsid = labelrsid
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
    LET label = RsGet$(atlasitem(idx).labelrsid)
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

SUB AtlasSetLabel (idx AS INTEGER, labelrsid AS INTEGER)
 
  AssertIsPositive idx, "AtlasSetLabel", "idx"

  atlasitem(idx).labelrsid = labelrsid
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

FUNCTION CtCreate% (kind%)
  '
  ' Creates an empty control
  '
  DIM ctid%
  LET ctid% = ObCreate%(ObKind.Control)
  AssertIsPositive ctid%, "CtCreate%", "ctid%"

  CtSet ctid%, CtIndex.Kind, kind%
  CtCreate% = ctid%

END FUNCTION

FUNCTION CtCreateChild% (wnid%, kind%)

  Assert wnid% > 0, "CtCreateChild%", "wnid cannot be 0"

  '
  ' Get a new field index
  '
  DIM fid%
  LET fid% = win(wnid%).fields + 1
  win(wnid%).fields = fid%

  '
  ' Allocate a control
  '
  DIM ctid%
  LET ctid% = ObCreate%(ObKind.Control)
  gwin(wnid%, fid%) = ctid%

  '
  ' Set the parent to the window control
  '
  CtSet ctid%, CtIndex.Parent, gwin(wnid%, 0)
  CtSet ctid%, CtIndex.Kind, kind%
  CtCreateChild% = fid%

END FUNCTION

SUB CtDraw (wnid%, fid%)

  DIM ctid%
  LET ctid% = gwin(wnid%, fid%)

  SELECT CASE CtGet%(ctid%, CtIndex.Kind)
    '
    ' Check the most common kinds first
    '
    CASE CtKind.Button
      CtDrawText wnid%, fid%

    CASE CtKind.Box
      CtDrawBox ctid%

    CASE CtKind.Label
      CtDrawText wnid%, fid%

    CASE CtKind.File
      CtDrawFile ctid%

    CASE CtKind.Separator
      CtDrawSeparator ctid%

    CASE CtKind.Nebula
      CtDrawNebula ctid%

    CASE ELSE
      CtDrawText wnid%, fid%

  END SELECT

END SUB

SUB CtDrawBox (ctid%)

  DIM stid%
  LET stid% = CtGetStyle(ctid%)

  SELECT CASE StGetBorderType%(stid%)
 
    CASE 0:
      CtDrawBox0 ctid%

    CASE 1:
      CtDrawBox1 ctid%

    CASE 2:
      CtDrawBox2 ctid%

    CASE ELSE
      AssertFail "CtDrawBox", "Unsupported border type"

  END SELECT

END SUB

SUB CtDrawBox0 (ctid%)

  DIM row AS INTEGER
  DIM sx  AS INTEGER
  DIM sy  AS INTEGER

  DIM stid%
  LET stid% = CtGetStyle(ctid%)
  DrawColor StGetTextColor(stid%)
 
  FOR row = 1 TO CtGet%(ctid%, CtIndex.SizeY)
   
    sx = CtGetScreenX%(ctid%)
    sy = CtGetScreenY%(ctid%) + row - 1

    LOCATE sy, sx
    PRINT STRING$(CtGet%(ctid%, CtIndex.SizeX), " ");
 
  NEXT

END SUB

SUB CtDrawBox1 (ctid%)

  CONST lowerFlat = "Ä"   ' CHR$(196)
  CONST lowerLeft = "À"   ' CHR$(192)
  CONST lowerRight = "Ù"  ' CHR$(217)
  CONST sideLeft = "³"    ' CHR$(179)
  CONST sideRight = "³"   ' CHR$(179)
  CONST upperLeft = "Ú"   ' CHR$(218)
  CONST upperFlat = "Ä"   ' CHR$(196)
  CONST upperRight = "¿"  ' CHR$(191)

  DIM r     AS INTEGER
  DIM sizeX AS INTEGER
  DIM sx1   AS INTEGER ' Upper-left x-coord
  DIM sy1   AS INTEGER ' Upper-left y-coord
  DIM sx2   AS INTEGER ' Lower-right x-coord
  DIM sy2   AS INTEGER ' Lower-right y-coord

  '
  ' Calculate screen coordinates
  '
  sizeX = CtGet%(ctid%, CtIndex.SizeX)
  sx1 = CtGetScreenX%(ctid%)
  sy1 = CtGetScreenY%(ctid%)
  sx2 = sx1 + sizeX - 1
  sy2 = sy1 + CtGet%(ctid%, CtIndex.SizeY) - 1

  DIM stid%
  LET stid% = CtGetStyle(ctid%)

  '
  ' Draw the top border
  '
  LOCATE sy1, sx1
  DrawColor StGetBorderColor%(stid%)
  PRINT upperLeft; STRING$(sizeX - 2, upperFlat); upperRight;

  '
  ' Draw each row of the border
  '
  FOR r = sy1 + 1 TO sy2 - 1
    LOCATE r, sx1
    PRINT sideLeft;
  
    DrawColor StGetTextColor%(stid%)
    PRINT STRING$(sizeX - 2, " ");
  
    DrawColor StGetBorderColor%(stid%)
    PRINT sideRight;
  NEXT
 
  '
  ' Draw the lower border
  '
  LOCATE sy2, sx1
  PRINT lowerLeft; STRING$(sizeX - 2, lowerFlat); lowerRight;

END SUB

SUB CtDrawBox2 (ctid%)

  DIM idx   AS INTEGER
  DIM row   AS INTEGER
 
  DIM sizeX AS INTEGER
  DIM SizeY AS INTEGER

  sizeX = CtGet%(ctid%, CtIndex.SizeX)
  SizeY = CtGet%(ctid%, CtIndex.SizeY)
 
  '
  ' Calculate screen coordinates
  '
  DIM sx%: sx% = CtGetScreenX%(ctid%)
  DIM sy%: sy% = CtGetScreenY%(ctid%)

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
  LOCATE sy%, sx%
  COLOR fc(0), bc(0)
  PRINT CHR$(220);
  PRINT STRING$(sizeX - 2, 196);
  PRINT CHR$(191);

  FOR row = 1 TO SizeY - 2

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
    LOCATE sy% + row, sx%
    COLOR fc(idx), bc(idx)
    PRINT ch(idx);

    '
    ' Inner space
    '
    COLOR fc(0), bc(0)
    PRINT STRING$(sizeX - 2, " ");

    '
    ' Get the index of the right border char
    '
    idx = SizeY - row - 1
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
  LOCATE sy% + SizeY% - 1, sx%
  COLOR fc(0), bc(0)
  PRINT CHR$(192);
  PRINT STRING$(sizeX - 2, 196);
  PRINT CHR$(223);

END SUB

SUB CtDrawFile (ctid%)

  DIM filename AS STRING
  DIM sx AS INTEGER
  DIM sy AS INTEGER

  filename = CtGetValue$(ctid%)
  IF LEN(filename) = 0 THEN
    EXIT SUB
  END IF

  sx = CtGetScreenX%(ctid%)
  sy = CtGetScreenY%(ctid%)

  DrawFileAt filename, sx, sy

END SUB

SUB CtDrawNebula (ctid%)

  DIM p     AS INTEGER
  DIM sizeX AS INTEGER
  DIM sx    AS INTEGER
  DIM sy    AS INTEGER
  DIM x     AS INTEGER
  DIM y     AS INTEGER

  sizeX = CtGet%(ctid%, CtIndex.SizeX)

  COLOR 7, 0

  FOR y = 1 TO CtGet%(ctid%, CtIndex.SizeY)
 
    x = INT(RND * sizeX) + 1
    p = 1

    sx = CtGetScreenX%(ctid%) + x - 1
    sy = CtGetScreenY%(ctid%) + y - 1
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
      IF x > sizeX THEN
        EXIT DO
      END IF

    LOOP

  NEXT

END SUB

SUB CtDrawSeparator (ctid%)

  DIM row   AS INTEGER
  DIM sizeX AS INTEGER
  DIM SizeY AS INTEGER
  DIM sx    AS INTEGER
  DIM sy    AS INTEGER

  DIM stid%
  LET stid% = CtGetStyle(ctid%)
 
  sizeX = CtGet%(ctid%, CtIndex.SizeX)
  SizeY = CtGet%(ctid%, CtIndex.SizeY)
  sx = CtGetScreenX%(ctid%)
  sy = CtGetScreenY%(ctid%)

  LOCATE sy, sx
  DrawColor StGetBorderColor%(stid%)

  IF sizeX > 0 THEN
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
    PRINT STRING$(sizeX - 2, 196);

    '
    ' Right edge
    '
    SELECT CASE SCREEN(sy, sx + sizeX - 1)
      CASE 179            ' ³
        PRINT CHR$(180);  ' ´
      CASE 186            ' º
        PRINT CHR$(182);  ' ¶
      CASE ELSE           '
        PRINT CHR$(196);  ' Ä
    END SELECT

  ELSEIF SizeY > 0 THEN
   
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

    FOR row = sy + 1 TO sy + SizeY - 2
      LOCATE row, sx
      PRINT CHR$(179);
    NEXT

    '
    ' Bottom edge
    '
    LOCATE sy + SizeY - 1, sx
    SELECT CASE SCREEN(sy + SizeY - 1, sx)
      CASE 196            ' Ä
        PRINT CHR$(193);  ' Á
      CASE 205            ' Í
        PRINT CHR$(207);  ' Ï
      CASE ELSE           '
        PRINT CHR$(179);  ' ³
    END SELECT

  END IF

END SUB

SUB CtDrawText (wnid%, fid%)

  DIM wnidctid%
  LET wnidctid% = gwin(wnid%, 0)

  DIM fidctid%
  LET fidctid% = gwin(wnid%, fid%)

  DIM size AS INTEGER
  DIM sx   AS INTEGER
  DIM sy   AS INTEGER
  DIM text AS STRING

  '
  ' Get field position
  '
  sx = CtGetScreenX%(fidctid%)
  sy = CtGetScreenY%(fidctid%)
  LOCATE sy, sx

  '
  ' Set style of text
  '
  DIM stid%
  LET stid% = CtGetStyle(fidctid%)
  IF CtGetSelected(wnidctid%) = fid% THEN
    DrawColor StGetSelectedColor%(stid%)
  ELSE
    DrawColor StGetTextColor%(stid%)
  END IF

  '
  ' Print text clipped to size
  '
  text = RsGet$(CtGet%(fidctid%, CtIndex.Text))
  size = CtGet%(fidctid%, CtIndex.SizeX)
  IF size < 1 THEN
    PRINT text;
  ELSE
    PRINT LEFT$(text, size);
    IF LEN(text) < size THEN
      PRINT STRING$(size - LEN(text), " ");
    END IF
  END IF

END SUB

FUNCTION CtGet% (ctid%, ctix%)
  AssertExpected ObKind.Control, gobj(ctid%, ObIndex.Kind).value, "CtGet%", "ObKind"
  CtGet% = ObGet%(ctid%, ctix%)
END FUNCTION

FUNCTION CtGetName$ (ctid%)
  CtGetName$ = ObGetString$(ctid%, CtIndex.Name)
END FUNCTION

FUNCTION CtGetOffsetX% (ctid%)
  CtGetOffsetX% = ObGet%(ctid%, CtIndex.OffsetX)
END FUNCTION

FUNCTION CtGetOffsetY% (ctid%)
  CtGetOffsetY% = ObGet%(ctid%, CtIndex.OffsetY)
END FUNCTION

FUNCTION CtGetParam% (ctid%)
  CtGetParam = ObGet%(ctid%, CtIndex.Param)
END FUNCTION

FUNCTION CtGetScreenX% (ctid%)

  DIM parentctid%
  LET parentctid% = CtGet%(ctid%, CtIndex.Parent)

  IF parentctid% = 0 THEN
    CtGetScreenX% = CtGetOffsetX%(ctid%) + 1
  ELSE
    CtGetScreenX% = CtGetOffsetX%(ctid%) + CtGetScreenX%(parentctid%)
  END IF

END FUNCTION

FUNCTION CtGetScreenY% (ctid%)

  DIM parentctid%
  LET parentctid% = CtGet%(ctid%, CtIndex.Parent)

  IF parentctid% = 0 THEN
    CtGetScreenY% = CtGetOffsetY%(ctid%) + 1
  ELSE
    CtGetScreenY% = CtGetOffsetY%(ctid%) + CtGetScreenY%(parentctid%)
  END IF

END FUNCTION

FUNCTION CtGetSelected% (ctid%)
  CtGetSelected% = ObGet%(ctid%, CtIndex.Selected)
END FUNCTION

FUNCTION CtGetStyle% (ctid%)

  AssertIsPositive ctid%, "CtGetStyle%", "ctid%"

  DIM stid%
  LET stid% = ObGet%(ctid%, CtIndex.Style)
 
  IF stid% = 0 THEN
    '
    ' Inherit from the parent control
    '
    DIM parentctid%
    LET parentctid% = CtGet%(ctid%, CtIndex.Parent)

    IF parentctid% > 0 THEN
      stid% = CtGetStyle%(parentctid%)
    END IF

  END IF

  CtGetStyle% = stid%
  
END FUNCTION

FUNCTION CtGetValue$ (ctid%)
  CtGetValue$ = ObGetString$(ctid%, CtIndex.Value)
END FUNCTION

SUB CtKey (ctid%, keypress$)
  '
  ' Sends a keystroke to a field
  '
 
  SELECT CASE CtGet%(ctid%, CtIndex.Kind)
  
    CASE CtKind.Boolean
      CtKeyBoolean ctid%, keypress$

    CASE CtKind.Integer
      CtKeyInteger ctid%, keypress$

  END SELECT

END SUB

SUB CtKeyBoolean (ctid%, keypress$)
  '
  ' Sends a keystroke to a boolean field.
  '
 
  STATIC rsid.y%
  STATIC rsid.n%
  IF rsid.y% = 0 THEN rsid.y% = RsCreate%("Yes")
  IF rsid.n% = 0 THEN rsid.n% = RsCreate%("No")
  AssertIsPositive rsid.y%, "CtKeyBoolean", "rsid.y%"
  AssertIsPositive rsid.n%, "CtKeyBoolean", "rsid.n%"

  DIM boolean%
  LET boolean% = CtGet%(ctid%, CtIndex.Value)
  Assert boolean% = True OR boolean% = False, "CtKeyBoolean", "boolean%"

  SELECT CASE keypress$

    CASE " "
      boolean% = NOT boolean%

    CASE "n", "N"
      boolean% = False

    CASE "y", "Y"
      boolean% = True

  END SELECT

  CtSet ctid%, CtIndex.Value, boolean%
  IF boolean% THEN
    CtSet ctid%, CtIndex.Text, rsid.y%
  ELSE
    CtSet ctid%, CtIndex.Text, rsid.n%
  END IF

END SUB

SUB CtKeyInteger (ctid%, keypress$)
  '
  ' Sends a key to an integer field
  '

  DIM buf$
  LET buf$ = RsGet$(CtGet%(ctid%, CtIndex.Text))

  SELECT CASE keypress$
   
    CASE CHR$(ASCII.Backspace)

      IF LEN(buf$) > 0 THEN
        buf$ = LEFT$(buf$, LEN(buf$) - 1)
      END IF

    CASE "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"

      IF LEN(buf$) < CtGet%(ctid%, CtIndex.SizeX) THEN
        buf$ = buf$ + keypress$
      END IF

  END SELECT

  ObSetString ctid%, CtIndex.Text, buf$

END SUB

FUNCTION CtRedirected% (ctid%, pid%)
  CtRedirected% = gobj(ctid%, pid%).flags = ObBinding.Focused
END FUNCTION

FUNCTION CtSelectable% (ctid%)
  '
  ' Returns True or False depending on whether the specified
  ' field is selectable (i.e., can receive focus for input or
  ' selection).
  '
  IF (ctid% < 0) OR (ctid% > UBOUND(gobj, 1)) THEN

    CtSelectable% = False
 
  ELSE

    SELECT CASE CtGet%(ctid%, CtIndex.Kind)
      CASE CtKind.Button
        CtSelectable% = True

      CASE CtKind.Boolean
        CtSelectable% = True

      CASE CtKind.Integer
        CtSelectable% = True

      CASE CtKind.Popup
        CtSelectable% = True

      CASE ELSE
        CtSelectable% = False

    END SELECT

  END IF

END FUNCTION

SUB CtSet (ctid%, ctix%, value%)
  AssertExpected ObKind.Control, gobj(ctid%, ObIndex.Kind).value, "CtSet", "ObKind"
  ObSet ctid%, ctix%, value%
END SUB

SUB CtSetName (ctid%, value$)
  ObSetString ctid%, CtIndex.Name, value$
END SUB

SUB CtSetParam (ctid%, value%)
  ObSet ctid%, CtIndex.Param, value%
END SUB

SUB CtSetValue (ctid%, value$)
  ObSetString ctid%, CtIndex.Value, value$
END SUB

FUNCTION DgGarble$ (text$, percent!)

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

  DgGarble$ = g + "@X07"

END FUNCTION

SUB DgNext (outprid%, outtext$)

  STATIC loaded AS INTEGER
  STATIC lines() AS STRING

  IF loaded = 0 THEN

    REDIM lines(1 TO 100) AS STRING
    handle = FREEFILE
    OPEN "EMPIRE.DLG" FOR INPUT ACCESS READ AS #handle
    DO WHILE (NOT EOF(handle)) AND (loaded < UBOUND(lines))
      loaded = loaded + 1
      LINE INPUT #handle, lines(loaded)
    LOOP
    CLOSE #handle
  END IF
 
  outtext$ = lines(INT(RND * UBOUND(lines)) + 1)
  outprid% = PrRandomly%

END SUB

SUB DgPrint (prid%, text$)

  DIM name$
  LET name$ = RsGet$(PrGet%(prid%, PrIndex.Name))
 
  DIM label$
  LET label$ = RsGet$(PrGet%(prid%, PrIndex.Label))
  IF label$ = "" THEN
    label$ = "@X1F " + name$ + " @X07"
  END IF

  IF LEFT$(text$, 1) = "(" THEN

    TrPrint STRING$((80 - DrawLength(text$)) / 2, " ") + "@X04" + text$ + "@X07"
    TrPrint ""

  ELSE

    DIM q$
  
    SELECT CASE INT(RND * 2)
      CASE 0:
        '
        ' Left justified
        '
        q$ = DgGarble(text$, .2)

        TrPrint label$
        TrPrint "@X07" + text$ + "@X07"
        TrPrint ""

      CASE 1:
        '
        ' Right justified
        '
        q$ = DgGarble(text$, .7)
      
        TrPrint STRING$(78 - DrawLength(label$), " ") + label$
        TrPrint STRING$(78 - DrawLength(text$), " ") + "@X07" + q$ + "@X07"
        TrPrint ""

    END SELECT

    'AtlasSetStatus "@X1F " + name$ + " @X07 " + CHR$(34) + q$ + CHR$(34)

  END IF

END SUB

SUB DgStart (hbid%)
 
  IF hbid% <> listening THEN
   
    listening = 0

    DIM startfile$
    LET startfile$ = RsGet$(HbGet%(hbid%, HbIndex.StartFile))
    IF LEN(startfile$) > 0 THEN
      TrFile startfile$
    END IF

    listening = hbid%

  END IF

END SUB

SUB DgStop
  listening = 0
END SUB

SUB DgTimer
  '
  ' Executed periodically
  '

  IF RND > .4 THEN
    EXIT SUB
  END IF

  DIM aid%
  DIM pid%
  DIM text$

  '
  ' Grab the next dialog
  '
  DgNext pid%, text$
 
  '
  ' Print the dialog to the terminal
  '
  DgPrint pid%, text$

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

SUB DrawFile (filename$)
  '
  ' Draws a PCB file containing embedded color codes
  '

  DIM text$
  DIM handle%
 
  handle% = FREEFILE
  OPEN filename$ FOR INPUT ACCESS READ AS #handle%

  DO WHILE NOT EOF(handle%)
    LINE INPUT #handle%, text$
    DrawText text$ + CHR$(ASCII.Return)
  LOOP

  CLOSE #handle%

END SUB

SUB DrawFileAt (filename$, sx%, sy%)
  '
  ' Draws a PCB file containing embedded color codes
  '

  DIM handle%
  DIM lines%
  DIM text$

  handle% = FREEFILE
  OPEN filename$ FOR INPUT ACCESS READ AS #handle%

  DO WHILE NOT EOF(handle%)
   
    '
    ' Read the next line from the file
    '
    LINE INPUT #handle%, text$

    '
    ' Position the cursor
    '
    LOCATE sy% + lines%, sx%
    lines% = lines% + 1

    '
    ' Draw the text while expanding color codes
    '
    DrawText text$
 
  LOOP

  CLOSE #handle%

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

SUB DrawText (text$)

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
    nextAt = INSTR(startAt, text$, "@X")

    IF nextAt = 0 THEN
      '
      ' No further codes found; print remaining characters
      '
      IF startAt <= LEN(text$) THEN
        PRINT RIGHT$(text$, LEN(text$) - startAt + 1);
      END IF
      EXIT DO

    'ELSEIF nextAt > LEN(text$) - 3 THEN
    '  '
    '  ' Code found, but not enough space for 4 characters
    '  '
    '  PRINT RIGHT$(text, LEN(text$) - startAt + 1);
    '  EXIT DO

    ELSE
      '
      ' Code found; print characters up to the color code.
      '
      PRINT MID$(text$, startAt, nextAt - startAt);

      '
      ' Read the color values
      '
      DrawColor VAL("&H" + MID$(text$, nextAt + 2, 2))

      '
      ' Continue with the next character after the code
      '
      startAt = nextAt + 4
    END IF

  LOOP

END SUB

FUNCTION EvCreate%
  EvCreate% = ObCreate%(ObKind.Event)
END FUNCTION

FUNCTION EvFind% (name$)
  EvFind% = ObFindString%(ObKind.Event, EvIndex.Name, name$)
END FUNCTION

SUB EvFire (evid%)

  DIM result%
  DIM tid%
 
  FOR tid% = 1 TO triggers
    IF EvTestTrigger%(evid%, tid%) THEN
      result% = ExecResource(trigger(tid%).cmdrsid)
    END IF
  NEXT

END SUB

FUNCTION EvGetValue% (evid%)
  EvGetValue% = ObGet%(evid%, EvIndex.Value)
END FUNCTION

SUB EvIncrement (name$)
 
  DIM evid%
  LET evid% = EvFind%(name$)
 
  IF evid% > 0 THEN
    DIM value%
    LET value% = EvGetValue%(evid%) + 1
    EvSetValue evid%, value%
    EvFire evid%
  END IF

END SUB

FUNCTION EvParseOperator% (opname$)

  SELECT CASE opname$
    CASE "="
      EvParseOperator% = OpEquals
    CASE ELSE
      EvParseOperator% = OpNone
  END SELECT

END FUNCTION

SUB EvSetName (evid%, name$)
  ObSetString evid%, EvIndex.Name, name$
END SUB

SUB EvSetValue (evid%, value%)
  ObSet evid%, EvIndex.Value, value%
END SUB

FUNCTION EvTestTrigger% (evid%, tid%)

  AssertIsPositive evid%, "EvTestTrigger%", "evid%"
  AssertIsPositive tid%, "EvTestTrigger%", "tid%"

  IF trigger(tid%).evid <> evid% THEN
   
    EvTestTrigger% = False

  ELSE

    SELECT CASE trigger(tid%).operator
      CASE OpEquals
        EvTestTrigger% = trigger(tid%).operand = EvGetValue%(evid%)
      CASE ELSE
        EvTestTrigger% = False
    END SELECT

  END IF

END FUNCTION

FUNCTION ExecCmd% (cmd$)

  SHARED evid%
  SHARED fid%
  SHARED hbid%
  SHARED prid%
  SHARED stid%
  SHARED tid%
  SHARED wnid%

  DIM result%
 
  '
  ' Parse the command into tokens
  '
  DIM stoken$(0 TO 5)
  DIM ntoken%
  LET ntoken% = Split(cmd$, stoken$())
  IF ntoken% = 0 THEN
    ExecCmd% = CmdResult.OK
    EXIT FUNCTION
  ELSE
    '
    ' Token #0 is the command name
    '
    stoken$(0) = LCASE$(stoken$(0))
  END IF

  IF fid% > 0 THEN
    result% = ExecCmdFid%(ntoken%, stoken$(), wnid%, fid%)
  ELSEIF wnid% > 0 THEN
    result% = ExecCmdWnid%(ntoken%, stoken$(), wnid%, fid%)
  ELSEIF evid% > 0 THEN
    result% = ExecCmdEvid%(ntoken%, stoken$(), evid%)
  ELSEIF hbid% > 0 THEN
    result% = ExecCmdHbid%(ntoken%, stoken$(), hbid%)
  ELSEIF prid% > 0 THEN
    result% = ExecCmdPrid%(ntoken%, stoken$(), prid%)
  ELSEIF stid% > 0 THEN
    result% = ExecCmdStid%(ntoken%, stoken$(), stid%)
  ELSEIF tid% > 0 THEN
    result% = ExecCmdTid%(ntoken%, stoken$(), tid%)
  ELSE
    result% = ExecCmdRoot%(ntoken%, stoken$(), evid%, hbid%, prid%, stid%, tid%, wnid%)
  END IF

  Assert result% = CmdResult.OK, "ExecCmd", "Malformed: " + cmd$

  ExecCmd% = result%

END FUNCTION

FUNCTION ExecCmdEvid% (ntoken%, stoken$(), evid%)

  AssertIsPositive evid%, "ExecCmdEvid%", "evid%"

  ExecCmdEvid% = CmdResult.OK

  SELECT CASE stoken$(0)
   
    CASE "endevent"
      evid% = 0

    CASE "name"
      EvSetName evid%, stoken$(1)

    CASE "value"
      EvSetValue evid%, VAL(stoken$(1))

    CASE ELSE
      ExecCmdEvid% = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdFid% (ntoken%, stoken$(), wnid%, fid%)

  AssertIsPositive wnid%, "ExecCmdFid%", "wnid%"
  AssertIsPositive fid%, "ExecCmdFid%", "fid%"

  DIM ctid%
  LET ctid% = gwin(wnid%, fid%)

  DIM endtag AS STRING
  DIM kind%
  LET kind% = CtGet%(ctid%, CtIndex.Kind)

  SELECT CASE kind%
    CASE CtKind.Button
      endtag = "endbutton"
    CASE CtKind.Box
      endtag = "endbox"
    CASE CtKind.File
      endtag = "endfile"
    CASE CtKind.Label
      endtag = "endlabel"
    CASE CtKind.Popup
      endtag = "endpopup"
    CASE CtKind.Separator
      endtag = "endseparator"
    CASE CtKind.Boolean
      endtag = "endboolean"
    CASE CtKind.Integer
      endtag = "endinteger"
    CASE CtKind.Nebula
      endtag = "endnebula"
    CASE ELSE
      AssertFail "ExecCmdFid", "Unknown kind:" + STR$(kind%)
  END SELECT

  ExecCmdFid% = CmdResult.OK

  SELECT CASE stoken$(0)
    
    CASE endtag
      fid% = 0

    CASE "command"
      CtSet ctid%, CtIndex.Command, RsCreate%(stoken$(1))

    CASE "offsetx"
      CtSet ctid%, CtIndex.OffsetX, VAL(stoken$(1))

    CASE "offsety"
      CtSet ctid%, CtIndex.OffsetY, VAL(stoken$(1))

    CASE "popup", "child"
      CtSet ctid%, CtIndex.Popup, WnFindWnid%(stoken$(1))
   
    CASE "sizex"
      CtSet ctid%, CtIndex.SizeX, VAL(stoken$(1))
      
    CASE "sizey"
      CtSet ctid%, CtIndex.SizeY, VAL(stoken$(1))

    CASE "style"
      CtSet ctid%, CtIndex.Style, WnFindStid%(stoken$(1))

    CASE "text"
      IF LCASE$(stoken$(1)) = "bind" THEN
        ObBind ctid%, CtIndex.Text, stoken$(2)
      ELSE
        CtSet ctid%, CtIndex.Text, RsCreate%(stoken$(1))
      END IF

    CASE "value"
      IF LCASE$(stoken$(1)) = "bind" THEN
        ObBind ctid%, CtIndex.Value, stoken$(2)
      ELSE
        CtSetValue ctid%, stoken$(1)
      END IF

    CASE ELSE
      ExecCmdFid% = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdHbid% (ntoken%, stoken$(), hbid%)

  AssertIsPositive hbid%, "ExecCmdHbid%", "hbid%"

  ExecCmdHbid% = CmdResult.OK

  SELECT CASE stoken$(0)

    CASE "backdrop"
      HbSet hbid%, HbIndex.Backdrop, RsCreate%(stoken$(1))

    CASE "endhabitat"
      hbid% = 0

    CASE "label"
      HbSet hbid%, HbIndex.Label, RsCreate%(stoken$(1))

    CASE "startfile"
      HbSet hbid%, HbIndex.StartFile, RsCreate%(stoken$(1))

    CASE "name"
      HbSet hbid%, HbIndex.Name, RsCreate%(stoken$(1))

    CASE "window"
      HbSet hbid%, HbIndex.Window, WnFindWnid%(stoken$(1))

    CASE ELSE
      ExecCmdHbid = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdPrid% (ntoken%, stoken$(), prid%)

  AssertIsPositive prid%, "ExecCmdPrid%", "prid%"

  SELECT CASE stoken$(0)
   
    CASE "endperson", "endpersona"
      prid% = 0

    CASE "label"
      PrSet prid%, PrIndex.Label, RsCreate%(stoken$(1))

    CASE "name"
      PrSet prid%, PrIndex.Name, RsCreate%(stoken$(1))

  END SELECT
  
END FUNCTION

FUNCTION ExecCmdRoot% (ntoken%, stoken$(), evid%, hbid%, prid%, stid%, tid%, wnid%)

  AssertIsZero evid%, "ExecCmdRoot%", "evid%"
  AssertIsZero hbid%, "ExecCmdRoot%", "hbid%"
  AssertIsZero prid%, "ExecCmdRoot%", "prid%"
  AssertIsZero stid%, "ExecCmdRoot%", "stid%"
  AssertIsZero tid%, "ExecCmdRoot%", "tid%"
  AssertIsZero wnid%, "ExecCmdRoot%", "wnid%"

  ExecCmdRoot% = CmdResult.OK

  SELECT CASE stoken$(0)

    CASE "atlas"
      UI.SetPage UIPage.Atlas
 
    CASE "chain"
      CHAIN stoken$(1)

    CASE "cls"
      TrClear

    CASE "terminal", "console"
      UI.SetPage UIPage.Terminal

    CASE "endgame"
      END

    CASE "event"
      evid% = EvCreate%

    CASE "habitat"
      hbid% = HbCreate%

    CASE "listen"
      DIM listenhbid%
      LET listenhbid% = VAL(stoken$(1))
      IF listenhbid% = 0 THEN
        DgStop
      ELSE
        UI.SetPage UIPage.Terminal
        DgStart listenhbid%
      END IF

    CASE "mail"
      InboxAdd stoken$(1), stoken$(2)
   
    CASE "newgame"
      ExecFile "WORLD.CFG"

    CASE "person", "persona"
      prid% = PrCreate%

    CASE "print"
      TrPrint stoken$(1)

    CASE "printfile"
      TrFile stoken$(1)

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
   
    CASE "spawn"
      DIM aid%
      DIM shbid%
      shbid% = HbFind%(stoken$(1))
      IF shbid% > 0 THEN
        SELECT CASE LCASE$(stoken$(2))
         
          CASE "at"
            aid% = WorldAdd%(shbid%, VAL(stoken$(3)), VAL(stoken$(4)))
         
          CASE "b", "band", "banded"
            WorldAddBanded shbid%, VAL(stoken$(3))
         
          CASE "c", "cluster", "clustered"
            WorldAddCluster shbid%, VAL(stoken$(3))
         
          CASE "p", "player"
            DIM pcx%: pcx% = VAL(stoken$(3)): IF pcx% = 0 THEN pcx% = 1
            DIM pcy%: pcx% = VAL(stoken$(4)): IF pcy% = 0 THEN pcy% = 1
            IF playeraid = 0 THEN
              playeraid = WorldAdd%(shbid%, pcx%, pcy%)
            ELSE
              AtlasMoveItem AtlasIndexOf%(playeraid), pcx%, pcy%
            END IF

          CASE "r", "random"
            WorldAddRandom shbid%, VAL(stoken$(3))
        END SELECT
      END IF

    CASE "style"
      stid% = StCreate%

    CASE "trigger"
      triggers = triggers + 1
      tid% = triggers

    CASE "window"
      wnid% = WnCreate%

    CASE "winrun"
      WnRunName stoken$(1)

    CASE ELSE
      ExecCmdRoot% = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdStid% (ntoken%, stoken$(), stid%)

  AssertIsPositive stid%, "ExecCmdStid%", "stid%"

  ExecuteCommandStid% = CmdResult.OK

  SELECT CASE stoken$(0)
   
    CASE "bordercolor"
      StSet stid%, StIndex.BorderColor, VAL(stoken$(1))

    CASE "bordertype"
      StSet stid%, StIndex.BorderType, VAL(stoken$(1))

    CASE "endstyle"
      stid% = 0

    CASE "name"
      StSetName stid%, stoken$(1)
  
    CASE "selectedcolor"
      StSet stid%, StIndex.SelectedColor, VAL(stoken$(1))

    CASE "textcolor"
      StSetTextColor stid%, VAL(stoken$(1))

    CASE ELSE
      ExecuteCommandStid% = CmdResult.Malformed

  END SELECT
  
END FUNCTION

FUNCTION ExecCmdTid% (ntoken%, stoken$(), tid%)

  AssertIsPositive tid%, "ExecCmdTid", "tid"

  SELECT CASE LCASE$(stoken$(0))

    CASE "command"
      trigger(tid%).cmdrsid = RsCreate(stoken$(1))

    CASE "endtrigger"
      tid% = 0

    CASE "when"
      trigger(tid%).evid = EvFind%(stoken$(1))
      trigger(tid%).operator = EvParseOperator%(stoken$(2))
      trigger(tid%).operand = VAL(stoken$(3))

    CASE ELSE
      ExecCmdTid% = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdWnid% (ntoken%, stoken$(), wnid%, fid%)

  AssertIsPositive wnid%, "ExecCmdWnid%", "wnid%"
  AssertIsZero fid%, "ExecCmdWnid%", "fid%"

  DIM wnidctid%
  LET wnidctid% = gwin(wnid%, 0)

  ExecuteCommandWnid% = CmdResult.OK

  IF ntoken% = 1 THEN

    SELECT CASE stoken$(0)
     
      CASE "endwindow"
        wnid% = 0
        wnidctid% = 0

      CASE "boolean"
        fid% = CtCreateChild%(wnid%, CtKind.Boolean)

      CASE "box"
        fid% = CtCreateChild%(wnid%, CtKind.Box)

      CASE "button"
        fid% = CtCreateChild%(wnid%, CtKind.Button)
   
      CASE "file"
        fid% = CtCreateChild%(wnid%, CtKind.File)

      CASE "integer"
        fid% = CtCreateChild%(wnid%, CtKind.Integer)

      CASE "label"
        fid% = CtCreateChild%(wnid%, CtKind.Label)
   
      CASE "nebula"
        fid% = CtCreateChild%(wnid%, CtKind.Nebula)

      CASE "popup"
        fid% = CtCreateChild%(wnid%, CtKind.Popup)

      CASE "separator"
        fid% = CtCreateChild%(wnid%, CtKind.Separator)

      CASE ELSE
        ExecuteCommandWnid% = CmdResult.Malformed

    END SELECT

    EXIT FUNCTION
  END IF

  IF ntoken% <> 2 THEN
    ExecuteCommandWnid% = CmdResult.Malformed
    EXIT FUNCTION
  END IF

  SELECT CASE stoken$(0)

    CASE "arrowexit"
      win(wnid%).arrowexit = VAL(stoken$(1))

    CASE "name"
      CtSetName wnidctid%, stoken$(1)
 
    CASE "param"
      CtSetParam wnidctid%, VAL(stoken$(2))

    CASE "posx"
      CtSet wnidctid%, CtIndex.OffsetX, VAL(stoken$(1)) - 1

    CASE "posy"
      CtSet wnidctid%, CtIndex.OffsetY, VAL(stoken$(1)) - 1

    CASE "style"
      CtSet wnidctid%, CtIndex.Style, WnFindStid%(stoken$(1))

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

FUNCTION ExecResource% (rsid%)

  AssertIsPositive rsid%, "ExecResource%", "rsid%"

  DIM cmd$
  LET cmd$ = RsGet$(rsid%)

  IF LEN(cmd$) > 0 THEN
    ExecResource% = ExecCmd%(cmd$)
  END IF

END FUNCTION

SUB GameMoveOffset (offsetX%, offsetY%)
 
  DIM aid     AS INTEGER
  DIM cx      AS INTEGER
  DIM cy      AS INTEGER
  DIM idx     AS INTEGER
  DIM wresult AS WnResultType

  '
  ' Get the index of the player avatar
  '
  IF playeraid = 0 THEN EXIT SUB
  idx = AtlasIndexOf%(playeraid)
  IF idx = 0 THEN EXIT SUB
 
  '
  ' Get the coordinates of the player
  '
  cx = atlasitem(idx).cx
  cy = atlasitem(idx).cy

  '
  ' Calculate next coordinates
  '
  cx = cx + offsetX%
  cy = cy + offsetY%
  IF cx < LBOUND(atlasGrid, 1) THEN cx = UBOUND(atlasGrid, 1)
  IF cx > UBOUND(atlasGrid, 1) THEN cx = LBOUND(atlasGrid, 1)
  IF cy < LBOUND(atlasGrid, 2) THEN cy = UBOUND(atlasGrid, 2)
  IF cy > UBOUND(atlasGrid, 2) THEN cy = LBOUND(atlasGrid, 2)

  '
  ' See what is at the next location
  '
  aid = AtlasGetValue(cx, cy, 0)
  IF aid = 0 THEN
    AtlasMoveItem idx, cx, cy
    EvIncrement "AtlasMoves"
  ELSE

    DIM hbid%
    LET hbid% = area(aid).hbid
      
    '
    ' Run the window name handling this habitat
    '
    DIM hbidwnid%
    LET hbidwnid% = HbGet%(hbid%, HbIndex.Window)

    IF hbidwnid% > 0 THEN
     
      AtlasDrawSelect cx, cy, 1

      '
      ' HACK: set window parameter value
      '
      DIM hbidwnidctid%
      LET hbidwnidctid% = gwin(hbidwnid%, 0)
      CtSetParam hbidwnidctid%, hbid%
     
      WnRun hbidwnid%, wresult
     
      IF wresult.action = WnAction.Execute THEN
        '
        ' HACK: expand command parameter
        '
        DIM cmd$: cmd$ = RsGet$(wresult.cmdrsid)
        DIM pdx%: pdx% = INSTR(cmd$, "{param.name}")
        IF pdx% > 0 THEN
          MID$(cmd$, pdx%) = STR$(hbid%) '** numeric habitat strings FYI
        END IF
        cresult = ExecCmd(cmd$)
      END IF
  
      AtlasDrawUnselect cx, cy

    END IF

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

FUNCTION HbCreate%
  HbCreate% = ObCreate%(ObKind.Habitat)
END FUNCTION

FUNCTION HbFind% (name$)
  HbFind% = ObFindString%(ObKind.Habitat, HbIndex.Name, name$)
END FUNCTION

FUNCTION HbGet% (hbid%, hbix%)
  AssertExpected ObKind.Habitat, gobj(hbid%, ObIndex.Kind).value, "HbGet%", "ObKind"
  HbGet% = ObGet%(hbid%, hbix%)
END FUNCTION

SUB HbSet (hbid%, hbix%, value%)
  AssertExpected ObKind.Habitat, gobj(hbid%, ObIndex.Kind).value, "HbSet", "ObKind"
  ObSet hbid%, hbix%, value%
END SUB

SUB InboxAdd (subject AS STRING, filename AS STRING)
 
  DIM fid%
  DIM wnid%
 
  SHARED count AS INTEGER

  count = count + 1

  wnid% = WnFindWnid("Inbox")
  fid% = WnAddButton(wnid%, 1, count, 20, " " + subject, filename)

  AtlasSetStatus "Mail arrived"
  TrFile "NEWMAIL.PCB"

END SUB

FUNCTION LsAdd% (lsid%, value%)
  '
  ' Adds a value to a list and returns the 1-based position of the value.
  '
  AssertIsPositive lsid%, "LsAdd%", "lsid%"

  '
  ' Get the 1-based position of the new value
  '
  DIM n%
  LET n% = LsCount%(lsid%) + 1
  Assert n% <= LsCapacity%, "LsAdd%", "n%"

  '
  ' Convert the 1-based position to a property index.
  '
  DIM lsix%
  LET lsix% = n% + LsIndex.First - 1

  '
  ' Update the list count and set the value
  '
  ObSet lsid%, LsIndex.Count, n%
  ObSet lsid%, lsix%, value%

  LsAdd% = n%

END FUNCTION

FUNCTION LsCapacity%
  LsCapacity% = UBOUND(gobj, 1) - LsIndex.First + 1
END FUNCTION

FUNCTION LsCount% (lsid%)
  LsCount% = ObGet%(lsid%, LsIndex.Count)
END FUNCTION

FUNCTION LsCreate%
  LsCreate% = ObCreate%(ObKind.List)
END FUNCTION

FUNCTION LsGet% (lsid%, n%)
  '
  ' Gets the specified 1-based list item
  '
  AssertIsPositive lsid%, "LsGet%", "lsid%"
  AssertIsPositive lsid%, "LsGet%", "n%"

  '
  ' Convert the 1-based position to a property index
  '
  DIM lsix%
  LET lsix% = n% + LsIndex.First - 1
 
  LsGet% = ObGet%(lsid%, lsix%)

END FUNCTION

SUB LsSet (lsid%, n%, value%)
  '
  ' Sets the value at the 1-based position of the list.
  '
  AssertIsPositive lsid%, "LsSet", "lsid%"
  AssertIsPositive fid%, "LsSet", "n%"

  '
  ' Convert the 1-based position to a property index
  '
  DIM lsix%
  LET lsix% = n% + LsIndex.First - 1

  '
  ' Save the value
  '
  ObSet lsid%, lsix%, value%

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

FUNCTION NebulaLabelRsid% (energy AS INTEGER)

  Assert energy >= 0, "NebulaLabelRsid", "energy must be 0 or greater"
  Assert energy <= 3, "NebulaLabelRsid", "energy must be 3 or less"

  STATIC created AS INTEGER
  STATIC lrsid() AS INTEGER

  IF created = 0 THEN
    REDIM lrsid(0 TO 3)
    FOR created = 0 TO 3
      lrsid(created) = RsCreate(NebulaLabel$(created))
    NEXT
  END IF

  NebulaLabelRsid% = lrsid(energy)

END FUNCTION

SUB ObBind (obid%, obix%, expr$)
  '
  ' Binds a property to an expression in the form of ALIAS.PROPERTY,
  ' where ALIAS refers to a control and PROPERTY specifies
  ' a property of that control.
  '
  AssertIsPositive obid%, "ObBind", "obid%"
  AssertIsPositive obix%, "ObBind", "obix%"

  DIM period%
  LET period% = INSTR(expr$, ".")

  IF period% > 1 THEN
 
    SELECT CASE LCASE$(LEFT$(expr$, period%))

      CASE "param."
        gobj(obid%, obix%).flags = ObBinding.Param

      CASE "focused.", "sel."
        gobj(obid%, obix%).flags = ObBinding.Focused

    END SELECT

    RsSet gobj(obid%, obix%).value, MID$(expr$, period% + 1)

  ELSE

    gobj(obid%, obix%).flags = ObBinding.None
    RsSet gobj(obid%, obix%).value, text$

  END IF
 
END SUB

FUNCTION ObCreate% (kind%)
 
  Assert gobids <= UBOUND(gobj, 1), "ObCreate%", "Out of object space"

  gobids = gobids + 1
 
  ObSet gobids, ObIndex.Kind, kind%

  ObCreate% = gobids

END FUNCTION

FUNCTION ObFindString% (kind%, obix%, value$)
  '
  ' Finds the first object where a property has the specified string
  '
  DIM obid%
  FOR obid% = 1 TO UBOUND(gobj, 1)
     
    IF gobj(obid%, ObIndex.Kind).value = kind% THEN
      
      DIM rsid%
      LET rsid% = ObGet%(obid%, obix%)
      
      IF rsid% = 0 THEN
        '
        ' The property on this object does not have a resource.
        ' Treat it as an empty string "".
        '
        IF LEN(value$) = 0 THEN
          ObFindString% = obid%
          EXIT FUNCTION
        END IF

      ELSE

        IF value$ = RsGet$(rsid%) THEN
          ObFindString% = obid%
          EXIT FUNCTION
        END IF

      END IF

    END IF

  NEXT

END FUNCTION

FUNCTION ObGet% (obid%, obix%)

  DIM flags%
  LET flags% = gobj(obid%, obix%).flags

  DIM value%
  LET value% = gobj(obid%, obix%).value

  SELECT CASE flags%

    CASE 0:
      ObGet% = value%

    CASE ObBinding.Focused
      ObGet% = ObResolveFocused%(obid%, value%)

    CASE ObBinding.Param
      ObGet% = ObResolveParam%(obid%, value%)

    CASE ELSE
      AssertFail "ObGet%", "Unsupported binding"

  END SELECT

END FUNCTION

FUNCTION ObGetKind% (obid%)
  ObGetKind% = ObGet%(obid%, ObIndex.Kind)
END FUNCTION

FUNCTION ObGetString$ (obid%, obix%)

  DIM rsid%
  LET rsid% = ObGet%(obid%, obix%)

  ObGetString$ = RsGet$(rsid%)

END FUNCTION

FUNCTION ObResolveFocused% (obid%, value%)

  DIM parentctid%
  LET parentctid% = CtGet%(obid%, CtIndex.Parent)
  AssertIsPositive parentctid%, "ObResolveFocused%", "parentCtid%"

  DIM wnid%
  LET wnid% = CtGet%(parentctid%, CtIndex.ChildList)

  DIM sel%
  LET sel% = CtGetSelected%(parentctid%)
     
  DIM selctid%
  LET selctid% = gwin(wnid%, sel%)

  ObResolveFocused% = CtGet%(selctid%, CtIndex.Value)

END FUNCTION

FUNCTION ObResolveParam% (obid%, value%)

  DIM parentctid%
  LET parentctid% = CtGet%(obid%, CtIndex.Parent)
  AssertIsPositive parentctid%, "ObResolveParam%", "parentCtid%"

  DIM hbid%
  LET hbid% = CtGetParam%(parentctid%)
  AssertIsPositive hbid%, "ObResolveParam", "hbid%"

  IF hbid% > 0 THEN
    SELECT CASE RsGet$(value%)
      CASE "backdrop"
        ObResolveParam% = HbGet%(hbid%, HbIndex.Backdrop)
      CASE "title"
        ObResolveParam% = HbGet%(hbid%, HbIndex.Name)
    END SELECT
  END IF

END FUNCTION

SUB ObSet (obid%, obix%, value%)
  gobj(obid%, obix%).value = value%
END SUB

SUB ObSetString (obid%, obix%, value$)

  DIM rsid%
  LET rsid% = ObGet%(obid%, obix%)

  RsSet rsid%, value$

  ObSet obid%, obix%, rsid%

END SUB

FUNCTION PrCreate%
  PrCreate% = ObCreate%(ObKind.Person)
END FUNCTION

FUNCTION PrGet% (prid%, prix%)
  AssertExpected ObKind.Person, gobj(prid%, ObIndex.Kind).value, "PrGet%", "ObKind"
  PrGet% = ObGet%(prid%, prix%)
END FUNCTION

FUNCTION PrRandomly%
  '
  ' Selects a person randomly
  '
 
  DIM count%
  DIM items%(1 TO 100)

  FOR index% = LBOUND(gobj, 1) TO UBOUND(gobj, 1)
    IF ObGetKind%(index%) = ObKind.Person THEN
      count% = count% + 1
      items%(count%) = index%
    END IF
  NEXT

  DIM prid%
  LET prid% = items%(INT(RND * count%) + 1)

  PrRandomly% = prid%

END FUNCTION

SUB PrSet (prid%, prix%, value%)
  AssertExpected ObKind.Person, gobj(prid%, ObIndex.Kind).value, "PrSet%", "ObKind"
  ObSet prid%, prix%, value%
END SUB

FUNCTION RsCreate% (value$)

  IF resources = UBOUND(resource) THEN
   
    AssertFail "RsCreate%", "Out of resource space"
    RsCreate% = 0

  ELSEIF LEN(value$) = 0 THEN
    '
    ' Resource zero is reserved for the empty string
    '
    RsCreate% = 0

  ELSE

    resources = resources + 1
    resource(resources) = value$
    RsCreate% = resources

  END IF

END FUNCTION

FUNCTION RsGet$ (rsid%)
  IF rsid% = 0 THEN
    '
    ' Resource 0 is always an empty string
    '
    RsGet$ = ""
  ELSE
    RsGet$ = resource(rsid%)
  END IF
END FUNCTION

SUB RsSet (outrsid%, value$)

  IF outrsid% = 0 THEN
    outrsid% = RsCreate%(value$)
  ELSE
    resource(outrsid%) = value$
  END IF

END SUB

SUB SetupGame

  SCREEN 0, 0, 0, 0: WIDTH 80: COLOR 7, 0: KEY OFF: RANDOMIZE TIMER

  '
  ' Load menus and windows
  '
  ExecFile "EMPIRE.CFG"
 
  TrPrint "String Space:" + STR$(FRE(""))
  TrPrint "Unused Stack Space:" + STR$(FRE(-2))
  TrPrint "Array Space:" + STR$(FRE(-1))

  '
  ' Setup atlas
  '
  atlaspage = VideoAlloc%
  AtlasDraw

  '
  ' Show starting window #1
  '
  DIM cresult AS INTEGER
  DIM wresult AS WnResultType
 
  WnRun WnFindWnid("Start"), wresult
 
  IF wresult.action = WnAction.Execute THEN
    cresult = ExecResource%(wresult.cmdrsid)
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

FUNCTION StCreate%
  StCreate% = ObCreate%(ObKind.Style)
END FUNCTION

FUNCTION StGetBorderColor% (stid%)
  StGetBorderColor% = ObGet%(stid%, StIndex.BorderColor)
END FUNCTION

FUNCTION StGetBorderType% (stid%)
  StGetBorderType% = ObGet%(stid%, StIndex.BorderType)
END FUNCTION

FUNCTION StGetName$ (stid%)
  StGetName$ = ObGetString$(stid%, StIndex.Name)
END FUNCTION

FUNCTION StGetSelectedColor% (stid%)
  StGetSelectedColor% = ObGet%(stid%, StIndex.SelectedColor)
END FUNCTION

FUNCTION StGetTextColor% (stid%)
  StGetTextColor% = ObGet%(stid%, StIndex.TextColor)
END FUNCTION

SUB StSet (stid%, stix%, value%)
  AssertExpected ObKind.Style, gobj(stid%, ObIndex.Kind).value, "StSet", "ObKind"
  ObSet stid%, stix%, value%
END SUB

SUB StSetName (stid%, name$)
  ObSetString stid%, StIndex.Name, name$
END SUB

SUB StSetTextColor (stid%, textcolor%)
  ObSet stid%, StIndex.TextColor, textcolor%
END SUB

SUB TrBegin
  VideoPushActive 0
END SUB

SUB TrClear
  TrBegin
  CLS
  TrEnd
END SUB

SUB TrEnd
  VideoPop
END SUB

SUB TrFile (filename$)
  TrBegin
  LOCATE 24, 1
  DrawFile filename$
  PRINT
  TrEnd
END SUB

SUB TrPrint (text$)

  DIM x AS INTEGER
  DIM y AS INTEGER

  TrBegin
  x = POS(0)
  y = CSRLIN
 
  LOCATE 24, 1
  DrawText text$
  PRINT
  LOCATE y, x
  TrEnd

END SUB

SUB UI.Run
 
  DIM menuwnid AS INTEGER
  DIM cresult  AS INTEGER
  DIM wresult  AS WnResultType

  UI.SetPage UIPage.Atlas

  menuwnid = WnFindWnid("Menu")

  DO
    
    Assert uiCurrentPage <> UIPage.None, "UI.Run", "UI page must be set"

    SELECT CASE uiCurrentPage
    
      CASE UIPage.Atlas
        UI.RunAtlas

      CASE UIPage.Terminal
        UI.RunTerminal

    END SELECT

    WnRun menuwnid, wresult
    IF wresult.action = WnAction.Execute THEN
      cresult = ExecResource%(wresult.cmdrsid)
    END IF

  LOOP

END SUB

SUB UI.RunAtlas
 
  Assert uiCurrentPage = UIPage.Atlas, "UI.RunAtlas", "Wrong UI page"

  DIM pressed AS STRING

  DO

    pressed = GetKey$

    SELECT CASE pressed
     
      CASE CHR$(ASCII.Escape)
        EXIT SUB

      CASE CHR$(0) + CHR$(ScanCode.Down)
        GameMoveOffset 0, 1

      CASE CHR$(0) + CHR$(ScanCode.Left)
        GameMoveOffset -1, 0

      CASE CHR$(0) + CHR$(ScanCode.Right)
        GameMoveOffset 1, 0

      CASE CHR$(0) + CHR$(ScanCode.Up)
        GameMoveOffset 0, -1

    END SELECT

  LOOP
 
END SUB

SUB UI.RunTerminal

  Assert uiCurrentPage = UIPage.Terminal, "UI.RunTerminal", "Wrong UI page"

  DIM keypress$: keypress$ = GetKey$

END SUB

SUB UI.SetPage (page AS INTEGER)
 
  Assert page <> UIPage.None, "UI.SetPage", "page cannot be 0"

  SELECT CASE page
   
    CASE UIPage.Atlas
      VideoScreen atlaspage, atlaspage

    CASE UIPage.Terminal
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

FUNCTION WnAddButton% (wnid%, offsetX%, offsetY%, sizeX%, text$, value$)

  AssertIsPositive wnid%, "WnAddButton%", "wnid%"

  DIM fid%
  LET fid% = CtCreateChild(wnid%, CtKind.Button)

  DIM ctid%
  LET ctid% = gwin(wnid%, fid%)

  CtSet ctid%, CtIndex.Command, 0
  CtSet ctid%, CtIndex.OffsetX, offsetX%
  CtSet ctid%, CtIndex.OffsetY, offsetY%
  CtSet ctid%, CtIndex.Popup, 0
  CtSet ctid%, CtIndex.SizeX, sizeX%
  CtSet ctid%, CtIndex.SizeY, 1
  CtSet ctid%, CtIndex.Text, RsCreate%(text$)
  CtSetValue ctid%, value$

  WnAddButton% = fid%

END FUNCTION

SUB WnClose (wnid%)

  AssertIsPositive wnid%, "WnClose", "wnid%"

  IF winstacked = 0 THEN
  
    AssertFail "WnClose", "No windows"

  ELSEIF winstack(winstacked).wnid <> wnid% THEN

    AssertFail "WnClose", "Not supported; specify top window only"

  ELSE

    '
    ' Change active and visual display to the backpage
    '
    VideoScreen winstack(winstacked).backpage, winstack(winstacked).backpage
    VideoFree winstack(winstacked).workpage
    winstacked = winstacked - 1

  END IF

END SUB

FUNCTION WnCreate%
 
  wincount = wincount + 1
 
  '
  ' Create the root window object
  '
  DIM wnid%
  LET wnid% = ObCreate%(ObKind.Window)

  '
  ' Create a container to hold controls
  '
  DIM ctid%
  LET ctid% = CtCreate(CtKind.Container)
 
  CtSet ctid%, CtIndex.Window, wnid%
  CtSet ctid%, CtIndex.ChildList, wincount

  '
  ' Track the control as field #0
  '
  gwin(wincount, 0) = ctid%
  WnCreate% = wincount

END FUNCTION

SUB WnDraw (wnid%)

  AssertIsPositive wnid%, "WnDraw", "wnid"

  DIM fid%
  FOR fid% = 1 TO win(wnid%).fields
    CtDraw wnid%, fid%
  NEXT

END SUB

FUNCTION WnFindStid% (stylename$)
  WnFindStid% = ObFindString%(ObKind.Style, StIndex.Name, stylename$)
END FUNCTION

FUNCTION WnFindWnid% (wname$)
 
  DIM wnid%

  FOR wnid% = 1 TO wincount
   
    DIM ctid%
    LET ctid% = gwin(wnid%, 0)
   
    IF CtGetName$(ctid%) = wname$ THEN
      WnFindWnid% = wnid%
      EXIT FUNCTION
    END IF
  NEXT

  WnFindWnid% = 0

END FUNCTION

SUB WnFocusOn (wnid%, fid%)
  '
  ' Sets focus to a field
  '

  AssertIsPositive wnid%, "WnFocusOn", "wnid%"
  Assert fid% >= 0, "WnFocusOn", "fid cannot be negative"

  DIM fidctid%
  LET fidctid% = gwin(wnid%, fid%)

  DIM wnidctid%
  LET wnidctid% = gwin(wnid%, 0)

  DIM old%
  LET old% = CtGetSelected(wnidctid%)

  IF old% = fid% THEN
    '
    ' Same field
    '
    EXIT SUB
  END IF

  CtSet wnidctid%, CtIndex.Selected, fid%

  IF old% > 0 THEN
    WnRefreshField wnid%, old%
  END IF

  IF fid% > 0 THEN
    WnRefreshField wnid%, fid%
  END IF

END SUB

SUB WnFocusOnFirst (wnid%)
  '
  ' Selects the first selectable field
  '

  AssertIsPositive wnid%, "WnFocusOnFirst", "wnid%"

  IF win(wnid%).fields = 0 THEN
    '
    ' This window has no fields
    '
    WnFocusOn wnid%, 0

  ELSE
 
    DIM fid%
    FOR fid% = 1 TO win(wnid%).fields
     
      DIM ctid%
      LET ctid% = gwin(wnid%, fid%)

      IF CtSelectable%(ctid%) THEN
        WnFocusOn wnid%, fid%
        EXIT SUB
      END IF
    NEXT

    '
    ' None of the fields were selectable
    '
    WnFocusOn wnid%, 0

  END IF

END SUB

SUB WnFocusOnLast (wnid%)
  '
  ' Selects the last selectable field
  '

  AssertIsPositive wnid%, "WnFocusOnLast", "wnid%"

  IF win(wnid%).fields = 0 THEN
    '
    ' This window has no fields
    '
    WnFocusOn wnid%, 0

  ELSE

    DIM fid%
    FOR fid% = win(wnid%).fields TO 1 STEP -1
     
      DIM ctid%
      LET ctid% = gwin(wnid%, fid%)

      IF CtSelectable%(ctid%) THEN
        WnFocusOn wnid%, fid%
        EXIT SUB
      END IF
    NEXT

    '
    ' None of the fields were selectable
    '
    WnFocusOn wnid%, 0

  END IF

END SUB

SUB WnFocusOnNext (wnid%)
  '
  ' Selects the next selectable field
  '

  AssertIsPositive wnid%, "WnFocusOnNext", "wnid%"

  DIM wnidctid%
  LET wnidctid% = gwin(wnid%, 0)

  DIM fid%
  DIM firstFid%

  IF win(wnid%).fields = 0 THEN
   
    fid% = 0
 
  ELSE

    '
    ' Get the starting field
    '
    LET firstFid% = CtGetSelected(wnidctid%)
    IF firstFid% = 0 THEN
      firstFid% = 1
    END IF

    LET fid% = firstFid%

    DO
    
      '
      ' Move to the next field
      '
      fid% = fid% + 1
      IF fid% > win(wnid%).fields THEN
        fid% = 1
      END IF

      DIM fidctid%
      LET fidctid% = gwin(wnid%, fid%)

      IF CtSelectable%(fidctid%) THEN
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

  WnFocusOn wnid%, fid%

END SUB

SUB WnFocusOnPrevious (wnid%)
  '
  ' Selects the field before the current one (looping around)
  '

  AssertIsPositive wnid%, "WnFocusOnPrevious", "wnid%"

  DIM wnidctid%
  LET wnidctid% = gwin(wnid%, 0)

  DIM fid%
  DIM startingFid%

  IF win(wnid%).fields = 0 THEN
   
    fid% = 0

  ELSE

    '
    ' Get the starting field
    '
    LET startingFid% = CtGetSelected(wnidctid%)
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
        fid% = win(wnid%).fields
      END IF

      DIM fidctid%
      LET fidctid% = gwin(wnid%, fid%)

      IF CtSelectable%(fidctid%) THEN
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

  WnFocusOn wnid%, fid%

END SUB

FUNCTION WnGet% (wnid%, wnix%)
  AssertExpected ObKind.Window, gobj(wnid%, ObIndex.Kind).value, "WnGet%", "ObKind"
  WnGet% = ObGet%(wnid%, wnix%)
END FUNCTION

FUNCTION WnMapKey% (wnid%, pressed$)

  DIM wnidctid%
  LET wnidctid% = gwin(wnid%, 0)

  DIM popupctid    AS INTEGER
  DIM cmdrsid      AS INTEGER
  DIM selected     AS INTEGER
  DIM selectedCtid AS INTEGER

  '
  ' Examine the field.
  ' ArrowExit bit 0 means to exit when navigating left
  ' ArrowExit bit 1 means to exit when nagivating right
  '
  DIM exitLeft%
  LET exitLeft% = win(wnid%).arrowexit AND &H1
 
  DIM exitRight%
  LET exitRight% = win(wnid%).arrowexit AND &H2
 
  '
  ' Get the index of the control with focus
  '
  selected = CtGetSelected(wnidctid%)
  IF selected > 0 THEN
    selectedCtid = gwin(wnid%, selected)
    popupctid = CtGet%(selectedCtid, CtIndex.Popup)
    cmdrsid = CtGet%(selectedCtid, CtIndex.Command)
  END IF

  SELECT CASE pressed$

    CASE CHR$(ASCII.Return)
      IF popupctid > 0 THEN
        WnMapKey% = WnAction.OpenPopup
      ELSEIF cmdrsid > 0 THEN
        WnMapKey% = WnAction.Execute
      ELSE
        WnMapKey% = WnAction.Complete
      END IF

    CASE CHR$(ASCII.Escape)
      WnMapKey% = WnAction.Cancel

    CASE CHR$(ASCII.Tab)
      WnMapKey% = WnAction.SelectNext

    CASE CHR$(0) + CHR$(ScanCode.Down)
      IF popupctid > 0 THEN
        WnMapKey% = WnAction.OpenPopup
      ELSE
        WnMapKey% = WnAction.SelectNext
      END IF

    CASE CHR$(0) + CHR$(ScanCode.End)
      WnMapKey% = WnAction.SelectLast

    CASE CHR$(0) + CHR$(ScanCode.Home)
      WnMapKey% = WnAction.SelectFirst

    CASE CHR$(0) + CHR$(ScanCode.Left)
      IF exitLeft% THEN
        WnMapKey% = WnAction.ExitLeft
      ELSE
        WnMapKey% = WnAction.SelectPrevious
      END IF

    CASE CHR$(0) + CHR$(ScanCode.PageDown)
      WnMapKey% = WnAction.SelectLast

    CASE CHR$(0) + CHR$(ScanCode.PageUp)
      WnMapKey% = WnAction.SelectFirst

    CASE CHR$(0) + CHR$(ScanCode.Right)
      IF exitRight% THEN
        WnMapKey% = WnAction.ExitRight
      ELSE
        WnMapKey% = WnAction.SelectNext
      END IF

    CASE CHR$(0) + CHR$(ScanCode.Up)
      WnMapKey% = WnAction.SelectPrevious

    CASE ELSE
      WnMapKey% = WnAction.None

  END SELECT

END FUNCTION

SUB WnRefreshField (wnid%, fid%)

  DIM ctid%
  DIM n AS INTEGER

  IF winstacked > 0 THEN
    IF winstack(winstacked).wnid = wnid% THEN
     
      FOR n = 1 TO win(wnid%).fields
       
        ctid% = gwin(wnid%, n)

        IF n = fid% THEN
          CtDraw wnid%, n
        ELSEIF CtRedirected%(ctid%, CtIndex.Text) THEN
          CtDraw wnid%, n
        ELSEIF CtRedirected%(ctid%, CtIndex.Value) THEN
          CtDraw wnid%, n
        END IF
      NEXT

    END IF
  END IF

END SUB

SUB WnRender (wnid%)
  '
  ' Displays the window and gives it focus
  '
  
  DIM wnidctid%
  LET wnidctid% = gwin(wnid%, 0)

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
 
  winstack(winstacked).wnid = wnid%
  winstack(winstacked).backpage = backpage
  winstack(winstacked).workpage = workpage

  '
  ' Draw the window
  '
  VideoScreen workpage, backpage
  PCOPY backpage, workpage
  WnDraw wnid%
  
  '
  ' Set focus to a field
  '
  IF CtGetSelected(wnidctid%) = 0 THEN
    WnFocusOnFirst wnid%
  END IF

  '
  ' Set the working page as the visual page
  '
  VideoScreen workpage, workpage

END SUB

SUB WnRun (wnid%, result AS WnResultType)

  AssertIsPositive wnid%, "WnRun", "wnid%"

  DIM wnidctid%
  LET wnidctid% = gwin(wnid%, 0)

  DIM nopopups AS INTEGER
  DIM pressed  AS STRING

  WnRender wnid%

  DO

    '
    ' Determine if the selected field is a popup.
    ' If so, that window needs to be displayed now.
    '
    DO

      IF nopopups THEN
        EXIT DO
      ELSEIF CtGetSelected(wnidctid%) = 0 THEN
        EXIT DO
      END IF

      DIM selectedCtid%
      LET selectedCtid% = gwin(wnid%, CtGetSelected(wnidctid%))

      IF CtGet%(selectedCtid%, CtIndex.Kind) <> CtKind.Popup THEN
       
        EXIT DO

      ELSEIF CtGet%(selectedCtid%, CtIndex.Popup) = 0 THEN
       
        EXIT DO

      ELSE
     
        WnRun CtGet%(selectedCtid%, CtIndex.Popup), result
       
        SELECT CASE result.action
         
          CASE WnAction.Cancel
            '
            ' The user canceled the popup, so disable popups until
            ' the user explicitly opens the popup window.
            '
            nopopups = True
            EXIT DO

          CASE WnAction.Execute
            '
            ' The user selected a command from the popup. The result
            ' will be passed up via the output result parameter.
            '
            WnClose wnid%
            EXIT SUB
         
          CASE WnAction.ExitLeft
            WnFocusOnPrevious wnid%
         
          CASE WnAction.ExitRight
            WnFocusOnNext wnid%
         
          CASE ELSE
            EXIT DO

        END SELECT

      END IF

    LOOP

    pressed = GetKey$
   
    SELECT CASE WnMapKey%(wnid%, pressed)
     
      CASE WnAction.Cancel
        result.action = WnAction.Cancel
        result.canceled = True
        result.cmdrsid = 0
        result.selected = CtGetSelected(wnidctid%)
        WnClose wnid%
        EXIT SUB

      CASE WnAction.Complete
        result.action = WnAction.Complete
        result.canceled = False
        result.cmdrsid = 0
        result.selected = CtGetSelected(wnidctid%)
        WnClose wnid%
        EXIT SUB

      CASE WnAction.Execute
        result.action = WnAction.Execute
        result.canceled = False
        result.selected = CtGetSelected(wnidctid%)
        result.cmdrsid = CtGet%(gwin(wnid%, result.selected), CtIndex.Command)
        WnClose wnid%
        EXIT SUB

      CASE WnAction.ExitLeft
        result.action = WnAction.ExitLeft
        result.canceled = True
        result.cmdrsid = 0
        result.selected = CtGetSelected(wnidctid%)
        WnClose wnid%
        EXIT SUB

      CASE WnAction.ExitRight
        result.action = WnAction.ExitRight
        result.canceled = True
        result.cmdrsid = 0
        result.selected = CtGetSelected(wnidctid%)
        WnClose wnid%
        EXIT SUB

      CASE WnAction.OpenPopup
        nopopups = False

      CASE WnAction.SelectFirst
        WnFocusOnFirst wnid%

      CASE WnAction.SelectLast
        WnFocusOnLast wnid%

      CASE WnAction.SelectNext
        WnFocusOnNext wnid%

      CASE WnAction.SelectPrevious
        WnFocusOnPrevious wnid%

      CASE ELSE
        CtKey gwin(wnid%, CtGetSelected(wnidctid%)), pressed
        WnRefreshField wnid%, CtGetSelected(wnidctid%)

    END SELECT

  LOOP

END SUB

SUB WnRunName (name$)
 
  DIM wnid%
  DIM result AS WnResultType

  wnid% = WnFindWnid(name$)
  Assert wnid% <> 0, "WnRunName", "wnid cannot be 0"

  WnRun wnid%, result

END SUB

SUB WnSet (wnid%, wnix%, value%)
  AssertExpected ObKind.Window, gobj(wnid%, ObKind.Window).value, "WnSet", "ObKind"
  ObSet wnid%, wnix%, value%
END SUB

FUNCTION WorldAdd% (hbid%, cx%, cy%)

  DIM aid%

  aid% = WorldNextId%
  area(aid%).allocated = True
  area(aid%).hbid = hbid%
  area(aid%).energy = 3

  AtlasAddItem cx%, cy%, aid%, HbGet%(hbid%, HbIndex.Label)
  WorldAdd% = aid%

END FUNCTION

SUB WorldAddBanded (hbid%, count%)

  DIM aid%
  DIM outcx%
  DIM outcy%

  DIM n%
  FOR n% = 1 TO count%
    AtlasNextBanded outcx%, outcy%
    aid% = WorldAdd%(hbid%, outcx%, outcy%)
  NEXT

END SUB

SUB WorldAddCluster (hbid%, count%)

  DIM aid%
  DIM outcx%
  DIM outcy%
  DIM n%
 
  FOR n% = 1 TO count%
    AtlasNextClustered outcx%, outcy%
    aid% = WorldAdd%(hbid%, outcx%, outcy%)
  NEXT
  
END SUB

SUB WorldAddRandom (hbid%, count%)

  DIM aid%
  DIM outcx%
  DIM outcy%

  DIM n%
  FOR n% = 1 TO count%
    AtlasNextRandom outcx%, outcy%
    aid% = WorldAdd%(hbid%, outcx%, outcy%)
  NEXT

END SUB

SUB WorldHarvest (aid%)

  AssertIsPositive aid%, "WorldHarvest", "aid%"

  DIM energy%
  LET energy% = area(aid%).energy

  IF energy% > 0 THEN
    energy% = energy% - 1
    area(aid%).energy = energy%
  END IF

  IF energy% = 0 THEN
    WorldRemove aid%
    EvIncrement "NebulaDepleted"
  END IF

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

  AssertIsPositive aid%, "WorldRemove", "aid%"

  IF area(aid%).allocated THEN
    area(aid%).allocated = False
    AtlasRemoveValue aid%
  END IF

END SUB

SUB WorldSetLabel (aid%, labelrsid%)
  '
  ' Updates the label for the specified area
  '
  AssertIsPositive aid%, "WorldSetLabel", "aid%"
  AssertIsPositive labelrsid%, "WorldSetLabel", "labelrsid%"

  DIM idx AS INTEGER
 
  idx = AtlasIndexOf(aid%)
  IF idx > 0 THEN
    AtlasSetLabel idx, labelrsid%
  END IF

END SUB

