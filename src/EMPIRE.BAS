
' Emperor
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

TYPE WinResultType
  action   AS INTEGER
  canceled AS INTEGER
  cmdrsid  AS INTEGER
  selected AS INTEGER
END TYPE

TYPE WinStackItem
  wnid     AS INTEGER
  backpage AS INTEGER
  workpage AS INTEGER
END TYPE

TYPE WinType
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
DECLARE SUB CtBind (ctid%, pid%, expr$)
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
DECLARE SUB CtSetChildList (ctid%, listctid%)
DECLARE SUB CtSetCmdRsid (ctid%, cmdrsid%)
DECLARE SUB CtSetCmdStr (ctid%, cmd$)
DECLARE SUB CtSetKind (ctid%, kind%)
DECLARE SUB CtSetName (ctid%, value$)
DECLARE SUB CtSetOffsetX (ctid%, offsetX%)
DECLARE SUB CtSetOffsetY (ctid%, offsetY%)
DECLARE SUB CtSetParam (ctid%, value%)
DECLARE SUB CtSetParent (ctid%, parentctid%)
DECLARE SUB CtSetPopup (ctid%, popupctid%)
DECLARE SUB CtSetPopupName (ctid%, wname$)
DECLARE SUB CtSetSelected (ctid%, value%)
DECLARE SUB CtSetSizeX (ctid%, sizeX%)
DECLARE SUB CtSetSizeY (ctid%, sizeY%)
DECLARE SUB CtSetStyle (ctid%, stid%)
DECLARE SUB CtSetText (ctid%, value$)
DECLARE SUB CtSetValue (ctid%, value$)
DECLARE FUNCTION CtCreateChild% (wnid%, kind%)
DECLARE FUNCTION CtGetChildList% (ctid%)
DECLARE FUNCTION CtGetCmdRsid% (ctid%)
DECLARE FUNCTION CtGetKind% (ctid%)
DECLARE FUNCTION CtGetName$ (ctid%)
DECLARE FUNCTION CtGetOffsetX% (ctid%)
DECLARE FUNCTION CtGetOffsetY% (ctid%)
DECLARE FUNCTION CtGetParam% (ctid%)
DECLARE FUNCTION CtGetParent% (ctid%)
DECLARE FUNCTION CtGetPopup% (ctid%)
DECLARE FUNCTION CtGetScreenX% (ctid%)
DECLARE FUNCTION CtGetScreenY% (ctid%)
DECLARE FUNCTION CtGetSelected% (ctid%)
DECLARE FUNCTION CtGetSizeX% (ctid%)
DECLARE FUNCTION CtGetSizeY% (ctid%)
DECLARE FUNCTION CtGetStyle% (ctid%)
DECLARE FUNCTION CtGetText$ (ctid%)
DECLARE FUNCTION CtGetValue$ (ctid%)
DECLARE FUNCTION CtRedirected% (ctid%, pid%)
DECLARE FUNCTION CtSelectable% (ctid%)

'
' Dialog API
'
DECLARE SUB DgNext (outpid%, outtext$)
DECLARE SUB DgPrint (pid%, text$)
DECLARE SUB DgStart (hid%)
DECLARE SUB DgStop ()
DECLARE SUB DgTimer ()
DECLARE FUNCTION DgGarble$ (text$, percent!)

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
DECLARE FUNCTION ExecCmd% (text AS STRING)
DECLARE FUNCTION ExecCmdEvid% (ntoken%, stoken$(), evid%)
DECLARE FUNCTION ExecCmdFid% (ntoken%, stoken$(), wnid%, fid%)
DECLARE FUNCTION ExecCmdHid% (ntoken%, stoken$(), hid%)
DECLARE FUNCTION ExecCmdPid% (ntoken%, stoken$(), pid%)
DECLARE FUNCTION ExecCmdRoot% (ntoken%, stoken$(), evid%, hid%, pid%, stid%, tid%, wnid%)
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
DECLARE FUNCTION HbGetBackdrop% (hid%)
DECLARE FUNCTION HbGetLabel% (hid%)
DECLARE FUNCTION HbGetName% (hid%)
DECLARE FUNCTION HbGetStartFile% (hid%)
DECLARE FUNCTION HbGetWindow% (hid%)
DECLARE SUB HbSetBackdrop (hid%, backdrop$)
DECLARE SUB HbSetLabel (hid%, label$)
DECLARE SUB HbSetName (hid%, name$)
DECLARE SUB HbSetStartFile (hid%, startfile$)
DECLARE SUB HbSetWindow (hid%, wnid%)

'
' Inbox
'
DECLARE SUB InboxAdd (subject AS STRING, filename AS STRING)

'
' List API
'
DECLARE FUNCTION LsCreate% ()
DECLARE FUNCTION LsCount% (lsid%)
DECLARE FUNCTION LsMaxIndex% ()

'
' Nebula
'
DECLARE FUNCTION NebulaLabel$ (energy AS INTEGER)
DECLARE FUNCTION NebulaLabelRsid% (energy AS INTEGER)

'
' Object API
'
DECLARE FUNCTION ObCreate% (kind%)
DECLARE FUNCTION ObFindString% (kind%, pid%, value$)
DECLARE FUNCTION ObGet% (oid%, pid%)
DECLARE FUNCTION ObGetKind% (oid%)
DECLARE FUNCTION ObGetString$ (oid%, pid%)
DECLARE SUB ObSet (oid%, pid%, value%)
DECLARE SUB ObSetString (oid%, pid%, value$)

'
' Person API
'
DECLARE SUB PrSetLabel (personid%, label$)
DECLARE SUB PrSetName (personid%, name$)
DECLARE FUNCTION PrCreate% ()
DECLARE FUNCTION PrGetLabel$ (personid%)
DECLARE FUNCTION PrGetName$ (personid%)
DECLARE FUNCTION PrRandomly% ()

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
DECLARE SUB StSetBorderColor (stid%, bordercolor%)
DECLARE SUB StSetBorderType (stid%, bordertype%)
DECLARE SUB StSetName (stid%, name$)
DECLARE SUB StSetSelectedColor (stid%, selectedcolor%)
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
' Windows
'
DECLARE SUB WinClose (wnid%)
DECLARE SUB WinDraw (wnid%)
DECLARE SUB WinOpen (wnid%)
DECLARE SUB WinRefreshField (wnid%, fid%)
DECLARE SUB WinRun (wnid%, result AS WinResultType)
DECLARE SUB WinRunName (idname$)
DECLARE SUB WinSelect (wnid%, fid%)
DECLARE SUB WinSelectNext (wnid%)
DECLARE SUB WinSelectFirst (wnid%)
DECLARE SUB WinSelectLast (wnid%)
DECLARE SUB WinSelectPrevious (wnid%)
DECLARE FUNCTION WinAddButton% (wnid%, offsetX%, offsetY%, sizeX%, text$, value$)
DECLARE FUNCTION WinCreate% ()
DECLARE FUNCTION WinFindStid% (stylename$)
DECLARE FUNCTION WinFindWnid% (wname$)
DECLARE FUNCTION WinMapKey% (wnid%, pressed$)

'
' World
'
DECLARE SUB WorldAddBanded (hid AS INTEGER, count AS INTEGER)
DECLARE SUB WorldAddCluster (hid AS INTEGER, size AS INTEGER)
DECLARE SUB WorldAddRandom (hid%, count%)
DECLARE SUB WorldHarvest (aid%)
DECLARE SUB WorldRemove (aid%)
DECLARE SUB WorldSetLabel (aid%, labelrsid%)
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

CONST BindingTarget.None = 0
CONST BindingTarget.Selected = 1
CONST BindingTarget.Param = 2

'
' Command Results
'
CONST CmdResult.OK = 0
CONST CmdResult.Malformed = 1

'
' Control kinds
'
CONST CtKind.None = 0
CONST CtKind.Window = 1
CONST CtKind.Boolean = 2
CONST CtKind.Box = 3
CONST CtKind.Button = 4
CONST CtKind.File = 5
CONST CtKind.Integer = 6
CONST CtKind.Label = 7
CONST CtKind.Popup = 8
CONST CtKind.Separator = 9
CONST CtKind.Nebula = 100

'
' Control properties
'
CONST CtPropId.Value = 1
CONST CtPropId.Parent = 2
CONST CtPropId.Kind = 3
CONST CtPropId.Name = 4
CONST CtPropId.Text = 5
CONST CtPropId.ChildList = 6
CONST CtPropId.Command = 7
CONST CtPropId.OffsetX = 8
CONST CtPropId.OffsetY = 9
CONST CtPropId.Param = 10
CONST CtPropId.Popup = 11
CONST CtPropId.Selected = 12
CONST CtPropId.SizeX = 13
CONST CtPropId.SizeY = 14
CONST CtPropId.Style = 15

'
' Event properties
'
CONST EvPropId.Name = 1
CONST EvPropId.Value = 2

'
' Habitat properties
'
CONST HbPropId.Backdrop = 1
CONST HbPropId.Label = 2
CONST HbPropId.Name = 3
CONST HbPropId.StartFile = 4
CONST HbPropId.Window = 5

'
' List properties
'
CONST LsPropId.Count = 1
CONST LsPropId.First = 2

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
CONST ObPropId.Kind = 0

'
' Operators
'
CONST OpNone = 0
CONST OpEquals = 1

'
' Person properties
'
CONST PrPropId.Name = CtPropId.Name
CONST PrPropId.Label = CtPropId.Text

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
CONST StPropId.BorderColor = 1
CONST StPropId.BorderType = 2
CONST StPropId.Name = 3
CONST StPropId.SelectedColor = 4
CONST StPropId.TextColor = 5

'
' UIPage.* constants
'
CONST UIPage.None = 0
CONST UIPage.Atlas = 1
CONST UIPage.Terminal = 2

'
' Window properties
'
CONST WnPid.ArrowExit = 1
CONST WnPid.Children = 2
CONST WnPid.Name = 3
CONST WnPid.Selected = 4

'
' WinAction* constants
'
CONST WinAction.None = 0
CONST WinAction.Cancel = 1
CONST WinAction.Complete = 2
CONST WinAction.Execute = 3
CONST WinAction.ExitLeft = 4
CONST WinAction.ExitRight = 5
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
DIM SHARED gobj(1 TO 200, 0 TO 15) AS PropType
DIM SHARED gwin(1 TO 20, 0 TO 13)  AS INTEGER
DIM SHARED goids                   AS INTEGER

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
DIM SHARED win(1 TO 15)          AS WinType
DIM SHARED wincount              AS INTEGER
DIM SHARED winstack(1 TO 3)      AS WinStackItem
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

SUB CtBind (ctid%, pid%, expr$)
  '
  ' Binds a property index to a value such as a window parameter
  '
  DIM index%
  LET index% = INSTR(expr$, ".")

  IF index% > 1 THEN
  
    SELECT CASE LCASE$(LEFT$(expr$, index%))

      CASE "param."
        gobj(ctid%, pid%).flags = BindingTarget.Param

      CASE "sel."
        gobj(ctid%, pid%).flags = BindingTarget.Selected

    END SELECT

    RsSet gobj(ctid%, pid%).value, MID$(expr$, index% + 1)

  ELSE

    gobj(ctid%, pid%).flags = BindingTarget.None
    RsSet gobj(ctid%, pid%).value, text$

  END IF
  
END SUB

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
  CtSetParent ctid%, gwin(wnid%, 0)
  CtSetKind ctid%, kind%
  CtCreateChild% = fid%

END FUNCTION

SUB CtDraw (wnid%, fid%)

  DIM ctid%
  LET ctid% = gwin(wnid%, fid%)

  SELECT CASE CtGetKind%(ctid%)
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

  END SELECT

END SUB

SUB CtDrawBox0 (ctid%)

  DIM row AS INTEGER
  DIM sx  AS INTEGER
  DIM sy  AS INTEGER

  DIM stid%
  LET stid% = CtGetStyle(ctid%)
  DrawColor StGetTextColor(stid%)
 
  FOR row = 1 TO CtGetSizeY%(ctid%)
   
    sx = CtGetScreenX%(ctid%)
    sy = CtGetScreenY%(ctid%) + row - 1

    LOCATE sy, sx
    PRINT STRING$(CtGetSizeX%(ctid%), " ");
 
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
  sizeX = CtGetSizeX%(ctid%)
  sx1 = CtGetScreenX%(ctid%)
  sy1 = CtGetScreenY%(ctid%)
  sx2 = sx1 + sizeX - 1
  sy2 = sy1 + CtGetSizeY%(ctid%) - 1

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
  DIM sizeY AS INTEGER

  sizeX = CtGetSizeX%(ctid%)
  sizeY = CtGetSizeY%(ctid%)
 
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

  FOR row = 1 TO sizeY - 2

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
    idx = sizeY - row - 1
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
  LOCATE sy% + sizeY% - 1, sx%
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

  sizeX = CtGetSizeX%(ctid%)

  COLOR 7, 0

  FOR y = 1 TO CtGetSizeY%(ctid%)
 
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
  DIM sizeY AS INTEGER
  DIM sx    AS INTEGER
  DIM sy    AS INTEGER

  DIM stid%
  LET stid% = CtGetStyle(ctid%)
 
  sizeX = CtGetSizeX%(ctid%)
  sizeY = CtGetSizeY%(ctid%)
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

  ELSEIF sizeY > 0 THEN
   
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

    FOR row = sy + 1 TO sy + sizeY - 2
      LOCATE row, sx
      PRINT CHR$(179);
    NEXT

    '
    ' Bottom edge
    '
    LOCATE sy + sizeY - 1, sx
    SELECT CASE SCREEN(sy + sizeY - 1, sx)
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
  text = CtGetText(fidctid%)
  size = CtGetSizeX%(fidctid%)
  IF size < 1 THEN
    PRINT text;
  ELSE
    PRINT LEFT$(text, size);
    IF LEN(text) < size THEN
      PRINT STRING$(size - LEN(text), " ");
    END IF
  END IF

END SUB

FUNCTION CtGetChildList% (ctid%)
  CtGetChildList% = ObGet%(ctid%, CtPropId.ChildList)
END FUNCTION

FUNCTION CtGetCmdRsid% (ctid%)
  CtGetCmdRsid% = ObGet%(ctid%, CtPropId.Command)
END FUNCTION

FUNCTION CtGetKind% (ctid%)
  CtGetKind% = ObGet%(ctid%, CtPropId.Kind)
END FUNCTION

FUNCTION CtGetName$ (ctid%)
  CtGetName$ = ObGetString$(ctid%, CtPropId.Name)
END FUNCTION

FUNCTION CtGetOffsetX% (ctid%)
  CtGetOffsetX% = ObGet%(ctid%, CtPropId.OffsetX)
END FUNCTION

FUNCTION CtGetOffsetY% (ctid%)
  CtGetOffsetY% = ObGet%(ctid%, CtPropId.OffsetY)
END FUNCTION

FUNCTION CtGetParam% (ctid%)
  CtGetParam = ObGet%(ctid%, CtPropId.Param)
END FUNCTION

FUNCTION CtGetParent% (ctid%)
  CtGetParent% = ObGet%(ctid%, CtPropId.Parent)
END FUNCTION

FUNCTION CtGetPopup% (ctid%)
  CtGetPopup% = ObGet%(ctid%, CtPropId.Popup)
END FUNCTION

FUNCTION CtGetScreenX% (ctid%)

  DIM parentctid%
  LET parentctid% = CtGetParent%(ctid%)

  IF parentctid% = 0 THEN
    CtGetScreenX% = CtGetOffsetX%(ctid%) + 1
  ELSE
    CtGetScreenX% = CtGetOffsetX%(ctid%) + CtGetScreenX%(parentctid%)
  END IF

END FUNCTION

FUNCTION CtGetScreenY% (ctid%)

  DIM parentctid%
  LET parentctid% = CtGetParent%(ctid%)

  IF parentctid% = 0 THEN
    CtGetScreenY% = CtGetOffsetY%(ctid%) + 1
  ELSE
    CtGetScreenY% = CtGetOffsetY%(ctid%) + CtGetScreenY%(parentctid%)
  END IF

END FUNCTION

FUNCTION CtGetSelected% (ctid%)
  CtGetSelected% = ObGet%(ctid%, CtPropId.Selected)
END FUNCTION

FUNCTION CtGetSizeX% (ctid%)
  CtGetSizeX% = ObGet%(ctid%, CtPropId.SizeX)
END FUNCTION

FUNCTION CtGetSizeY% (ctid%)
  CtGetSizeY% = ObGet%(ctid%, CtPropId.SizeY)
END FUNCTION

FUNCTION CtGetStyle% (ctid%)

  AssertIsPositive ctid%, "CtGetStyle%", "ctid%"

  DIM stid%
  LET stid% = ObGet%(ctid%, CtPropId.Style)
 
  IF stid% = 0 THEN
    '
    ' Inherit from the parent control
    '
    DIM parentctid%
    LET parentctid% = CtGetParent(ctid%)

    IF parentctid% > 0 THEN
      stid% = CtGetStyle%(parentctid%)
    END IF

  END IF

  CtGetStyle% = stid%
  
END FUNCTION

FUNCTION CtGetText$ (ctid%)
  CtGetText$ = ObGetString$(ctid%, CtPropId.Text)
END FUNCTION

FUNCTION CtGetValue$ (ctid%)
  CtGetValue$ = ObGetString$(ctid%, CtPropId.Value)
END FUNCTION

SUB CtKey (ctid%, keypress$)
  '
  ' Sends a keystroke to a field
  '
 
  SELECT CASE CtGetKind%(ctid%)
  
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
 
  DIM text AS STRING
  LET text = CtGetText$(ctid%)

  SELECT CASE keypress$

    CASE " "
      SELECT CASE text
        CASE "No"
          CtSetText ctid%, "Yes"
        CASE "Yes"
          CtSetText ctid%, "No"
      END SELECT

    CASE "n", "N"
      CtSetText ctid%, "No"

    CASE "y", "Y"
      CtSetText ctid%, "Yes"

  END SELECT

END SUB

SUB CtKeyInteger (ctid%, keypress$)
  '
  ' Sends a key to an integer field
  '

  DIM buf$
  LET buf$ = CtGetText$(ctid%)

  SELECT CASE keypress$
   
    CASE CHR$(ASCII.Backspace)

      IF LEN(buf$) > 0 THEN
        buf$ = LEFT$(buf$, LEN(buf$) - 1)
      END IF

    CASE "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"

      IF LEN(buf$) < CtGetSizeX%(ctid%) THEN
        buf$ = buf$ + keypress$
      END IF

  END SELECT

  CtSetText ctid%, buf$

END SUB

FUNCTION CtRedirected% (ctid%, pid%)
  CtRedirected% = gobj(ctid%, pid%).flags = BindingTarget.Selected
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

    SELECT CASE CtGetKind%(ctid%)
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

SUB CtSetChildList (ctid%, listctid%)
  ObSet ctid%, CtPropId.ChildList, listctid%
END SUB

SUB CtSetCmdRsid (ctid%, cmdrsid%)
  ObSet ctid%, CtPropId.Command, cmdrsid%
END SUB

SUB CtSetCmdStr (ctid%, cmd$)

  DIM rsid%
  LET rsid% = CtGetCmdRsid%(ctid%)

  '
  ' rsid% is an output parameter
  '
  RsSet rsid%, cmd$

  CtSetCmdRsid ctid%, rsid%

END SUB

SUB CtSetKind (ctid%, kind%)
  ObSet ctid%, CtPropId.Kind, kind%
END SUB

SUB CtSetName (ctid%, value$)
  ObSetString ctid%, CtPropId.Name, value$
END SUB

SUB CtSetOffsetX (ctid%, offsetX%)
  ObSet ctid%, CtPropId.OffsetX, offsetX%
END SUB

SUB CtSetOffsetY (ctid%, offsetY%)
  ObSet ctid%, CtPropId.OffsetY, offsetY%
END SUB

SUB CtSetParam (ctid%, value%)
  ObSet ctid%, CtPropId.Param, value%
END SUB

SUB CtSetParent (ctid%, parentctid%)
  ObSet ctid%, CtPropId.Parent, parentctid%
END SUB

SUB CtSetPopup (ctid%, popupctid%)
  ObSet ctid%, CtPropId.Popup, popupctid%
END SUB

SUB CtSetPopupName (ctid%, wname$)
  CtSetPopup ctid%, WinFindWnid%(wname$)
END SUB

SUB CtSetSelected (ctid%, value%)
  ObSet ctid%, CtPropId.Selected, value%
END SUB

SUB CtSetSizeX (ctid%, sizeX%)
  ObSet ctid%, CtPropId.SizeX, sizeX%
END SUB

SUB CtSetSizeY (ctid%, sizeY%)
  ObSet ctid%, CtPropId.SizeY, sizeY%
END SUB

SUB CtSetStyle (ctid%, stid%)
  ObSet ctid%, CtPropId.Style, stid%
END SUB

SUB CtSetText (ctid%, value$)
  ObSetString ctid%, CtPropId.Text, value$
END SUB

SUB CtSetValue (ctid%, value$)
  ObSetString ctid%, CtPropId.Value, value$
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

SUB DgNext (outpersonid%, outtext$)

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
  outpersonid% = PrRandomly%

END SUB

SUB DgPrint (personid%, text$)

  DIM name$
  LET name$ = PrGetName$(personid%)
 
  DIM label$
  LET label$ = PrGetLabel$(personid%)
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

SUB DgStart (hid%)
 
  DIM startfile$

  IF hid% <> listening THEN
   
    listening = 0

    startfile$ = RsGet$(HbGetStartFile%(hid%))
    IF LEN(startfile$) > 0 THEN
      TrFile startfile$
    END IF

    listening = hid%

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

FUNCTION EvCreate%
  EvCreate% = ObCreate%(ObKind.Event)
END FUNCTION

FUNCTION EvFind% (name$)
  EvFind% = ObFindString%(ObKind.Event, EvPropId.Name, name$)
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
  EvGetValue% = ObGet%(evid%, EvPropId.Value)
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
  ObSetString evid%, EvPropId.Name, name$
END SUB

SUB EvSetValue (evid%, value%)
  ObSet evid%, EvPropId.Value, value%
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

FUNCTION ExecCmd% (text AS STRING)

  SHARED evid%
  SHARED fid%
  SHARED hid%
  SHARED pid%
  SHARED stid%
  SHARED tid%
  SHARED wnid%

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
    result% = ExecCmdFid%(ntoken%, stoken$(), wnid%, fid%)
  ELSEIF wnid% > 0 THEN
    result% = ExecCmdWnid%(ntoken%, stoken$(), wnid%, fid%)
  ELSEIF evid% > 0 THEN
    result% = ExecCmdEvid%(ntoken%, stoken$(), evid%)
  ELSEIF hid% > 0 THEN
    result% = ExecCmdHid%(ntoken%, stoken$(), hid%)
  ELSEIF pid% > 0 THEN
    result% = ExecCmdPid%(ntoken%, stoken$(), pid%)
  ELSEIF stid% > 0 THEN
    result% = ExecCmdStid%(ntoken%, stoken$(), stid%)
  ELSEIF tid% > 0 THEN
    result% = ExecCmdTid%(ntoken%, stoken$(), tid%)
  ELSE
    result% = ExecCmdRoot%(ntoken%, stoken$(), evid%, hid%, pid%, stid%, tid%, wnid%)
  END IF

  Assert result% = CmdResult.OK, "ExecCmd", "Malformed: " + text

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
  LET kind% = CtGetKind(ctid%)

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

    CASE "child"
      CtSetPopupName ctid%, stoken$(1)

    CASE "command"
      CtSetCmdStr ctid%, stoken$(1)

    CASE "offsetx"
      CtSetOffsetX ctid%, VAL(stoken$(1))

    CASE "offsety"
      CtSetOffsetY ctid%, VAL(stoken$(1))

    CASE "sizex"
      CtSetSizeX ctid%, VAL(stoken$(1))

    CASE "sizey"
      CtSetSizeY ctid%, VAL(stoken$(1))

    CASE "style"
      CtSetStyle ctid%, WinFindStid%(stoken$(1))

    CASE "text"
      IF LCASE$(stoken$(1)) = "bind" THEN
        CtBind ctid%, CtPropId.Text, stoken$(2)
      ELSE
        CtSetText ctid%, stoken$(1)
      END IF

    CASE "value"
      IF LCASE$(stoken$(1)) = "bind" THEN
        CtBind ctid%, CtPropId.Value, stoken$(2)
      ELSE
        CtSetValue ctid%, stoken$(1)
      END IF

    CASE ELSE
      ExecCmdFid% = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdHid% (ntoken%, stoken$(), hid%)

  AssertIsPositive hid%, "ExecCmdHid", "hid"

  ExecCmdHid% = CmdResult.OK

  SELECT CASE stoken$(0)

    CASE "backdrop"
      HbSetBackdrop hid%, stoken$(1)

    CASE "endhabitat"
      hid% = 0

    CASE "label"
      HbSetLabel hid%, stoken$(1)

    CASE "startfile"
      HbSetStartFile hid%, stoken$(1)

    CASE "name"
      HbSetName hid%, stoken$(1)

    CASE "window"
      HbSetWindow hid%, WinFindWnid(stoken$(1))

    CASE ELSE
      ExecCmdHid = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdPid% (ntoken%, stoken$(), pid%)

  AssertIsPositive pid%, "ExecCmdPid", "pid"

  SELECT CASE stoken$(0)
   
    CASE "endperson", "endpersona"
      pid% = 0

    CASE "label"
      PrSetLabel pid%, stoken$(1)

    CASE "name"
      PrSetName pid%, stoken$(1)

  END SELECT
  
END FUNCTION

FUNCTION ExecCmdRoot% (ntoken%, stoken$(), evid%, hid%, pid%, stid%, tid%, wnid%)

  AssertIsZero evid%, "ExecCmdRoot%", "evid%"
  AssertIsZero hid%, "ExecCmdRoot%", "hid%"
  AssertIsZero pid%, "ExecCmdRoot%", "pid%"
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
      hid% = HbCreate%

    CASE "listen"
      DIM listenhid%: listenhid% = VAL(stoken$(1))
      IF listenhid% = 0 THEN
        DgStop
      ELSE
        UI.SetPage UIPage.Terminal
        DgStart listenhid%
      END IF

    CASE "mail"
      InboxAdd stoken$(1), stoken$(2)
   
    CASE "newgame"
      ExecFile "WORLD.CFG"

    CASE "person", "persona"
      pid% = PrCreate%

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
      DIM shid%
      shid% = HbFind%(stoken$(1))
      IF shid% > 0 THEN
        SELECT CASE LCASE$(stoken$(2))
         
          CASE "at"
            aid% = WorldAdd%(shid%, VAL(stoken$(3)), VAL(stoken$(4)))
         
          CASE "b", "band", "banded"
            WorldAddBanded shid%, VAL(stoken$(3))
         
          CASE "c", "cluster", "clustered"
            WorldAddCluster shid%, VAL(stoken$(3))
         
          CASE "p", "player"
            DIM pcx%: pcx% = VAL(stoken$(3)): IF pcx% = 0 THEN pcx% = 1
            DIM pcy%: pcx% = VAL(stoken$(4)): IF pcy% = 0 THEN pcy% = 1
            IF playeraid = 0 THEN
              playeraid = WorldAdd%(shid%, pcx%, pcy%)
            ELSE
              AtlasMoveItem AtlasIndexOf%(playeraid), pcx%, pcy%
            END IF

          CASE "r", "random"
            WorldAddRandom shid%, VAL(stoken$(3))
        END SELECT
      END IF

    CASE "style"
      stid% = StCreate%

    CASE "trigger"
      triggers = triggers + 1
      tid% = triggers

    CASE "window"
      wnid% = WinCreate%

    CASE "winrun"
      WinRunName stoken$(1)

    CASE ELSE
      ExecCmdRoot% = CmdResult.Malformed

  END SELECT

END FUNCTION

FUNCTION ExecCmdStid% (ntoken%, stoken$(), stid%)

  AssertIsPositive stid%, "ExecCmdStid", "stid%"

  ExecuteCommandStid% = CmdResult.OK

  SELECT CASE stoken$(0)
   
    CASE "bordercolor"
      StSetBorderColor stid%, VAL(stoken$(1))

    CASE "bordertype"
      StSetBorderType stid%, VAL(stoken$(1))

    CASE "endstyle"
      stid% = 0

    CASE "name"
      StSetName stid%, stoken$(1)
  
    CASE "selectedcolor"
      StSetSelectedColor stid%, VAL(stoken$(1))

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

  AssertIsPositive wnid%, "ExecCmdWnid", "wnid"
  AssertIsZero fid%, "ExecCmdWnid", "fid"

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
      CtSetOffsetX wnidctid%, VAL(stoken$(1)) - 1

    CASE "posy"
      CtSetOffsetY wnidctid%, VAL(stoken$(1)) - 1

    CASE "style"
      CtSetStyle wnidctid%, WinFindStid%(stoken$(1))

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

  AssertIsPositive rsid%, "ExecResource", "rsid%"

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
  DIM hid     AS INTEGER
  DIM idx     AS INTEGER
  DIM wresult AS WinResultType

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

    hid = area(aid).hid
      
    '
    ' Run the window name handling this habitat
    '
    DIM hidwnid%
    LET hidwnid% = HbGetWindow%(hid%)

    IF hidwnid% > 0 THEN
     
      AtlasDrawSelect cx, cy, 1

      '
      ' HACK: set window parameter value
      '
      DIM hidwnidctid%
      LET hidwnidctid% = gwin(hidwnid%, 0)
      CtSetParam hidwnidctid%, hid
     
      WinRun hidwnid%, wresult
     
      IF wresult.action = WinAction.Execute THEN
        '
        ' HACK: expand command parameter
        '
        DIM cmd$: cmd$ = RsGet$(wresult.cmdrsid)
        DIM pdx%: pdx% = INSTR(cmd$, "{param.name}")
        IF pdx% > 0 THEN
          MID$(cmd$, pdx%) = STR$(hid)
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
  HbFind% = ObFindString%(ObKind.Habitat, HbPropId.Name, name$)
END FUNCTION

FUNCTION HbGetBackdrop% (hid%)
  IF hid% > 0 THEN
    HbGetBackdrop% = ObGet%(hid%, HbPropId.Backdrop)
  END IF
END FUNCTION

FUNCTION HbGetLabel% (hid%)
  HbGetLabel% = ObGet%(hid%, HbPropId.Label)
END FUNCTION

FUNCTION HbGetName% (hid%)
  IF hid% > 0 THEN
    HbGetName% = ObGet%(hid%, HbPropId.Name)
  END IF
END FUNCTION

FUNCTION HbGetStartFile% (hid%)
  HbGetStartFile% = ObGet%(hid%, HbPropId.StartFile)
END FUNCTION

FUNCTION HbGetWindow% (hid%)
  HbGetWindow% = ObGet%(hid%, HbPropId.Window)
END FUNCTION

SUB HbSetBackdrop (hid%, backdrop$)
  ObSetString hid%, HbPropId.Backdrop, backdrop$
END SUB

SUB HbSetLabel (hid%, label$)
  ObSetString hid%, HbPropId.Label, label$
END SUB

SUB HbSetName (hid%, name$)
  ObSetString hid%, HbPropId.Name, name$
END SUB

SUB HbSetStartFile (hid%, startfile$)
  ObSetString hid%, HbPropId.StartFile, startfile$
END SUB

SUB HbSetWindow (hid%, wnid%)
  ObSet hid%, HbPropId.Window, wnid%
END SUB

SUB InboxAdd (subject AS STRING, filename AS STRING)
 
  DIM fid%
  DIM wnid%
 
  SHARED count AS INTEGER

  count = count + 1

  wnid% = WinFindWnid("Inbox")
  fid% = WinAddButton(wnid%, 1, count, 20, " " + subject, filename)

  AtlasSetStatus "Mail arrived"
  TrFile "NEWMAIL.PCB"

END SUB

SUB LsAdd (lsid%, value%)
 
  DIM index%
  LET index% = LsCount%(lsid%) + 1

  IF index% > LsMaxIndex% THEN
    AssertFail "LsAdd", "Maximum items"
    EXIT SUB
  END IF

  ObSet lsid%, LsPropId.Count, count%
  ObSet lsid%, index%, value%

END SUB

FUNCTION LsCount% (lsid%)
  LsCount% = ObGet%(lsid%, LsPropId.Count)
END FUNCTION

FUNCTION LsCreate%
  LsCreate% = ObCreate%(ObKind.List)
END FUNCTION

FUNCTION LsMaxIndex%
  LsMaxItems% = UBOUND(gobj, 1) - LsPropId.First + 1
END FUNCTION

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

FUNCTION ObCreate% (kind%)
 
  Assert goids <= UBOUND(gobj, 1), "ObCreate", "Out of object space"

  goids = goids + 1
 
  ObSet goids, ObPropId.Kind, kind%

  ObCreate% = goids

END FUNCTION

FUNCTION ObFindString% (kind%, pid%, value$)
  '
  ' Finds the first object where a property has the specified string
  '
  FOR oid% = 1 TO UBOUND(gobj, 1)
     
    IF gobj(oid%, ObPropId.Kind).value = kind% THEN
      
      DIM rsid%
      LET rsid% = ObGet%(oid%, pid%)
      
      IF rsid% = 0 THEN
        '
        ' The property on this object does not have a resource.
        ' Treat it as an empty string "".
        '
        IF LEN(value$) = 0 THEN
          ObFindString% = oid%
          EXIT FUNCTION
        END IF

      ELSE

        IF value$ = RsGet$(rsid%) THEN
          ObFindString% = oid%
          EXIT FUNCTION
        END IF

      END IF

    END IF

  NEXT

END FUNCTION

FUNCTION ObGet% (oid%, pid%)

  DIM flags%
  LET flags% = gobj(oid%, pid%).flags

  DIM value%
  LET value% = gobj(oid%, pid%).value

  IF flags% = 0 THEN
    ObGet% = value%
    EXIT FUNCTION
  END IF

  DIM parentctid%
  LET parentctid% = CtGetParent%(oid%)

  SELECT CASE flags%
 
    CASE BindingTarget.Param
      '
      ' Bound to the parent window parameter
      '
      DIM hid%
      LET hid% = CtGetParam%(parentctid%)
      IF hid% > 0 THEN
        SELECT CASE RsGet$(value%)
          CASE "backdrop"
            ObGet% = HbGetBackdrop%(hid%)
          CASE "title"
            ObGet% = HbGetName%(hid%)
        END SELECT
      END IF

    CASE BindingTarget.Selected
      '
      ' Bound to selected control of parent window parameter
      '
      DIM sel%
      LET sel% = CtGetSelected%(parentctid%)
      
      DIM wnid%
      LET wnid% = CtGetChildList%(parentctid%)

      DIM selctid%
      LET selctid% = gwin(wnid%, sel%)

      ObGet% = ObGet%(selctid%, CtPropId.Value)

    CASE ELSE
   
      AssertFail "ObGet%", "Not implemented"
      ObGet% = value%

  END SELECT

END FUNCTION

FUNCTION ObGetKind% (oid%)
  ObGetKind% = ObGet%(oid%, ObPropId.Kind)
END FUNCTION

FUNCTION ObGetString$ (oid%, pid%)

  DIM rsid%
  LET rsid% = ObGet%(oid%, pid%)

  ObGetString$ = RsGet$(rsid%)

END FUNCTION

SUB ObSet (oid%, pid%, value%)
  gobj(oid%, pid%).value = value%
END SUB

SUB ObSetString (oid%, pid%, value$)

  DIM rsid%
  LET rsid% = ObGet%(oid%, pid%)

  RsSet rsid%, value$

  ObSet oid%, pid%, rsid%

END SUB

FUNCTION PrCreate%
  PrCreate% = ObCreate%(ObKind.Person)
END FUNCTION

FUNCTION PrGetLabel$ (personid%)
  PrGetLabel$ = ObGetString$(personid%, PrPropId.Label)
END FUNCTION

FUNCTION PrGetName$ (personid%)
  PrGetName$ = ObGetString$(personid%, PrPropId.Name)
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

  DIM personid%
  LET personid% = items%(INT(RND * count%) + 1)

  PrRandomly% = personid%

END FUNCTION

SUB PrSetLabel (personid%, label$)
  ObSetString personid%, PrPropId.Label, label$
END SUB

SUB PrSetName (personid%, name$)
  ObSetString personid%, PrPropId.Name, name$
END SUB

FUNCTION RsCreate% (value$)

  IF resources = UBOUND(resource) THEN
   
    AssertFail "RsCreate", "Out of resource space"
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
  DIM wresult AS WinResultType
 
  WinRun WinFindWnid("Start"), wresult
 
  IF wresult.action = WinAction.Execute THEN
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
  StGetBorderColor% = ObGet%(stid%, StPropId.BorderColor)
END FUNCTION

FUNCTION StGetBorderType% (stid%)
  StGetBorderType% = ObGet%(stid%, StPropId.BorderType)
END FUNCTION

FUNCTION StGetName$ (stid%)
  StGetName$ = ObGetString$(stid%, StPropId.Name)
END FUNCTION

FUNCTION StGetSelectedColor% (stid%)
  StGetSelectedColor% = ObGet%(stid%, StPropId.SelectedColor)
END FUNCTION

FUNCTION StGetTextColor% (stid%)
  StGetTextColor% = ObGet%(stid%, StPropId.TextColor)
END FUNCTION

SUB StSetBorderColor (stid%, bordercolor%)
  ObSet stid%, StPropId.BorderColor, bordercolor%
END SUB

SUB StSetBorderType (stid%, bordertype%)
  ObSet stid%, StPropId.BorderType, bordertype%
END SUB

SUB StSetName (stid%, name$)
  ObSetString stid%, StPropId.Name, name$
END SUB

SUB StSetSelectedColor (stid%, selectedcolor%)
  ObSet stid%, StPropId.SelectedColor, selectedcolor%
END SUB

SUB StSetTextColor (stid%, textcolor%)
  ObSet stid%, StPropId.TextColor, textcolor%
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
  DIM cresult AS INTEGER
  DIM wresult AS WinResultType

  UI.SetPage UIPage.Atlas

  menuwnid = WinFindWnid("Menu")

  DO
    
    Assert uiCurrentPage <> UIPage.None, "UI.Run", "UI page must be set"

    SELECT CASE uiCurrentPage
    
      CASE UIPage.Atlas
        UI.RunAtlas

      CASE UIPage.Terminal
        UI.RunTerminal

    END SELECT

    WinRun menuwnid, wresult
    IF wresult.action = WinAction.Execute THEN
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

FUNCTION WinAddButton% (wnid%, offsetX%, offsetY%, sizeX%, text$, value$)

  AssertIsPositive wnid%, "WinAddButton%", "wnid%"

  DIM fid%
  LET fid% = CtCreateChild(wnid%, CtKind.Button)

  DIM ctid%
  LET ctid% = gwin(wnid%, fid%)

  CtSetCmdRsid ctid%, 0
  CtSetOffsetX ctid%, offsetX%
  CtSetOffsetY ctid%, offsetY%
  CtSetPopup ctid%, 0
  CtSetSizeX ctid%, sizeX%
  CtSetSizeY ctid%, 1
  CtSetText ctid%, text$
  CtSetValue ctid%, value$

  WinAddButton% = fid%

END FUNCTION

SUB WinClose (wnid%)

  AssertIsPositive wnid%, "WinClose%", "wnid%"

  IF winstacked = 0 THEN
  
    AssertFail "WinClose", "No windows"

  ELSEIF winstack(winstacked).wnid <> wnid% THEN

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
 
  '
  ' Create a control to represent the window
  '
  DIM ctid%
  LET ctid% = ObCreate%(ObKind.Window)
 
  CtSetKind ctid%, CtKind.Window
  CtSetChildList ctid%, wincount

  '
  ' Track the control as field #0
  '
  gwin(wincount, 0) = ctid%
  WinCreate% = wincount

END FUNCTION

SUB WinDraw (wnid%)

  AssertIsPositive wnid%, "WinDraw", "wnid"

  DIM fid%
  FOR fid% = 1 TO win(wnid%).fields
    CtDraw wnid%, fid%
  NEXT

END SUB

FUNCTION WinFindStid% (stylename$)
  WinFindStid% = ObFindString%(ObKind.Style, StPropId.Name, stylename$)
END FUNCTION

FUNCTION WinFindWnid% (wname$)
 
  DIM wnid%

  FOR wnid% = 1 TO wincount
   
    DIM ctid%
    LET ctid% = gwin(wnid%, 0)
   
    IF CtGetName$(ctid%) = wname$ THEN
      WinFindWnid% = wnid%
      EXIT FUNCTION
    END IF
  NEXT

  WinFindWnid% = 0

END FUNCTION

FUNCTION WinMapKey% (wnid%, pressed$)

  DIM wnidctid%
  LET wnidctid% = gwin(wnid%, 0)

  DIM popupctid    AS INTEGER
  DIM cmdrsid      AS INTEGER
  DIM exitLeft     AS INTEGER
  DIM exitRight    AS INTEGER
  DIM selected     AS INTEGER
  DIM selectedCtid AS INTEGER

  '
  ' Examine the field.
  ' ArrowExit bit 0 means to exit when navigating left
  ' ArrowExit bit 1 means to exit when nagivating right
  '
  exitLeft = win(wnid%).arrowexit AND &H1
  exitRight = win(wnid%).arrowexit AND &H2
  selected = CtGetSelected(wnidctid%)
  IF selected > 0 THEN
    selectedCtid = gwin(wnid%, selected)
    popupctid = CtGetPopup%(selectedCtid)
    cmdrsid = CtGetCmdRsid%(selectedCtid)
  END IF

  SELECT CASE pressed$

    CASE CHR$(ASCII.Return)
      IF popupctid > 0 THEN
        WinMapKey% = WinAction.OpenPopup
      ELSEIF cmdrsid > 0 THEN
        WinMapKey% = WinAction.Execute
      ELSE
        WinMapKey% = WinAction.Complete
      END IF

    CASE CHR$(ASCII.Escape)
      WinMapKey% = WinAction.Cancel

    CASE CHR$(ASCII.Tab)
      WinMapKey% = WinAction.SelectNext

    CASE CHR$(0) + CHR$(ScanCode.Down)
      IF popupctid > 0 THEN
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

    CASE ELSE
      WinMapKey = WinAction.None

  END SELECT

END FUNCTION

SUB WinOpen (wnid%)
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
  WinDraw wnid%
  
  '
  ' Set focus to a field
  '
  IF CtGetSelected(wnidctid%) = 0 THEN
    WinSelectFirst wnid%
  END IF

  '
  ' Set the working page as the visual page
  '
  VideoScreen workpage, workpage

END SUB

SUB WinRefreshField (wnid%, fid%)

  DIM ctid%
  DIM n AS INTEGER

  IF winstacked > 0 THEN
    IF winstack(winstacked).wnid = wnid% THEN
     
      FOR n = 1 TO win(wnid%).fields
       
        ctid% = gwin(wnid%, n)

        IF n = fid% THEN
          CtDraw wnid%, n
        ELSEIF CtRedirected%(ctid%, CtPropId.Text) THEN
          CtDraw wnid%, n
        ELSEIF CtRedirected%(ctid%, CtPropId.Value) THEN
          CtDraw wnid%, n
        END IF
      NEXT

    END IF
  END IF

END SUB

SUB WinRun (wnid%, result AS WinResultType)

  AssertIsPositive wnid%, "WinRun%", "wnid%"

  DIM wnidctid%
  LET wnidctid% = gwin(wnid%, 0)

  DIM nopopups AS INTEGER
  DIM pressed  AS STRING

  WinOpen wnid%

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

      IF CtGetKind%(selectedCtid%) <> CtKind.Popup THEN
       
        EXIT DO

      ELSEIF CtGetPopup%(selectedCtid%) = 0 THEN
       
        EXIT DO

      ELSE
     
        WinRun CtGetPopup%(selectedCtid%), result
       
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
            WinClose wnid%
            EXIT SUB
         
          CASE WinAction.ExitLeft
            WinSelectPrevious wnid%
         
          CASE WinAction.ExitRight
            WinSelectNext wnid%
         
          CASE ELSE
            EXIT DO

        END SELECT

      END IF

    LOOP

    pressed = GetKey$
   
    SELECT CASE WinMapKey%(wnid%, pressed)
     
      CASE WinAction.Cancel
        result.action = WinAction.Cancel
        result.canceled = True
        result.cmdrsid = 0
        result.selected = CtGetSelected(wnidctid%)
        WinClose wnid%
        EXIT SUB

      CASE WinAction.Complete
        result.action = WinAction.Complete
        result.canceled = False
        result.cmdrsid = 0
        result.selected = CtGetSelected(wnidctid%)
        WinClose wnid%
        EXIT SUB

      CASE WinAction.Execute
        result.action = WinAction.Execute
        result.canceled = False
        result.selected = CtGetSelected(wnidctid%)
        result.cmdrsid = CtGetCmdRsid%(gwin(wnid%, result.selected))
        WinClose wnid%
        EXIT SUB

      CASE WinAction.ExitLeft
        result.action = WinAction.ExitLeft
        result.canceled = True
        result.cmdrsid = 0
        result.selected = CtGetSelected(wnidctid%)
        WinClose wnid%
        EXIT SUB

      CASE WinAction.ExitRight
        result.action = WinAction.ExitRight
        result.canceled = True
        result.cmdrsid = 0
        result.selected = CtGetSelected(wnidctid%)
        WinClose wnid%
        EXIT SUB

      CASE WinAction.OpenPopup
        nopopups = False

      CASE WinAction.SelectFirst
        WinSelectFirst wnid%

      CASE WinAction.SelectLast
        WinSelectLast wnid%

      CASE WinAction.SelectNext
        WinSelectNext wnid%

      CASE WinAction.SelectPrevious
        WinSelectPrevious wnid%

      CASE ELSE
        CtKey gwin(wnid%, CtGetSelected(wnidctid%)), pressed
        WinRefreshField wnid%, CtGetSelected(wnidctid%)

    END SELECT

  LOOP

END SUB

SUB WinRunName (idname$)
 
  DIM wnid%
  DIM result AS WinResultType

  wnid% = WinFindWnid(idname$)
  Assert wnid% <> 0, "WinRunName", "wnid cannot be 0"

  WinRun wnid%, result

END SUB

SUB WinSelect (wnid%, fid%)
  '
  ' Sets focus to a field
  '

  AssertIsPositive wnid%, "WinSelect", "wnid%"
  Assert fid% >= 0, "WinSelect", "fid cannot be negative"

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

  CtSetSelected wnidctid%, fid%

  IF old% > 0 THEN
    WinRefreshField wnid%, old%
  END IF

  IF fid% > 0 THEN
    WinRefreshField wnid%, fid%
  END IF

END SUB

SUB WinSelectFirst (wnid%)
  '
  ' Selects the first selectable field
  '

  AssertIsPositive wnid%, "WinSelectFirst", "wnid%"

  IF win(wnid%).fields = 0 THEN
    '
    ' This window has no fields
    '
    WinSelect wnid%, 0

  ELSE
 
    DIM fid%
    FOR fid% = 1 TO win(wnid%).fields
     
      DIM ctid%
      LET ctid% = gwin(wnid%, fid%)

      IF CtSelectable%(ctid%) THEN
        WinSelect wnid%, fid%
        EXIT SUB
      END IF
    NEXT

    '
    ' None of the fields were selectable
    '
    WinSelect wnid%, 0

  END IF

END SUB

SUB WinSelectLast (wnid%)
  '
  ' Selects the last selectable field
  '

  AssertIsPositive wnid%, "WinSelectLast", "wnid%"

  IF win(wnid%).fields = 0 THEN
    '
    ' This window has no fields
    '
    WinSelect wnid%, 0

  ELSE

    DIM fid%
    FOR fid% = win(wnid%).fields TO 1 STEP -1
     
      DIM ctid%
      LET ctid% = gwin(wnid%, fid%)

      IF CtSelectable%(ctid%) THEN
        WinSelect wnid%, fid%
        EXIT SUB
      END IF
    NEXT

    '
    ' None of the fields were selectable
    '
    WinSelect wnid%, 0

  END IF

END SUB

SUB WinSelectNext (wnid%)
  '
  ' Selects the next selectable field
  '

  AssertIsPositive wnid%, "WinSelectNext", "wnid%"

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

  WinSelect wnid%, fid%

END SUB

SUB WinSelectPrevious (wnid%)
  '
  ' Selects the field before the current one (looping around)
  '

  AssertIsPositive wnid%, "WinSelectPrevious", "wnid%"

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

  WinSelect wnid%, fid%

END SUB

FUNCTION WorldAdd% (hid%, cx%, cy%)

  DIM aid%

  aid% = WorldNextId%
  area(aid%).allocated = True
  area(aid%).hid = hid%
  area(aid%).energy = 3

  AtlasAddItem cx%, cy%, aid%, HbGetLabel%(hid%)
  WorldAdd% = aid%

END FUNCTION

SUB WorldAddBanded (hid AS INTEGER, count AS INTEGER)

  DIM aid   AS INTEGER
  DIM outcx AS INTEGER
  DIM outcy AS INTEGER
  DIM n     AS INTEGER

  FOR n = 1 TO count
    AtlasNextBanded outcx, outcy
    aid = WorldAdd%(hid, outcx, outcy)
  NEXT

END SUB

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

SUB WorldAddRandom (hid%, count%)

  DIM aid   AS INTEGER
  DIM outcx AS INTEGER
  DIM outcy AS INTEGER
  DIM n     AS INTEGER

  FOR n = 1 TO count%
    AtlasNextRandom outcx, outcy
    aid = WorldAdd%(hid%, outcx, outcy)
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

  AssertIsPositive aid%, "WorldRemove", "aid"

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

