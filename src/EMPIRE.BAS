' Emperor
' By David Pinch, 1991, 2020-2023
'
' MIT License
' https://github.com/davepinch/qbasic-empire
'
' To begin, press Shift + F5.
' To exit QBASIC, press Alt, F, X.
' To view full screen (in DOSBox), press Alt-Enter.
'
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
DECLARE FUNCTION AtlasPrompt% (promptFor AS INTEGER, outcx AS INTEGER, outcy AS INTEGER, outpress AS STRING)

'
' Control API
'
DECLARE SUB CtDraw (ctid%)
DECLARE SUB CtDrawBox (ctid%)
DECLARE SUB CtDrawBox0 (ctid%)
DECLARE SUB CtDrawBox1 (ctid%)
DECLARE SUB CtDrawBox2 (ctid%)
DECLARE SUB CtDrawCheckbox (ctid%)
DECLARE SUB CtDrawContainer (ctid%)
DECLARE SUB CtDrawFile (ctid%)
DECLARE SUB CtDrawLabel (ctid%)
DECLARE SUB CtDrawNebula (ctid%)
DECLARE SUB CtDrawPopup (ctid%)
DECLARE SUB CtDrawSeparator (ctid%)
DECLARE SUB CtUnfocus (ctid%)
DECLARE FUNCTION CtAction% (action%, param%)
DECLARE FUNCTION CtCanFocus% (ctid%)
DECLARE FUNCTION CtFocus% (ctid%)
DECLARE FUNCTION CtFocusBack% (ctid%)
DECLARE FUNCTION CtFocusFirst% (ctid%)
DECLARE FUNCTION CtFocusLast% (ctid%)
DECLARE FUNCTION CtFocusNext% (ctid%)
DECLARE FUNCTION CtGetScreenX% (ctid%)
DECLARE FUNCTION CtGetScreenY% (ctid%)
DECLARE FUNCTION CtKey% (ctid%, keypress$)
DECLARE FUNCTION CtKeyButton% (ctid%, keypress$)
DECLARE FUNCTION CtKeyCheckbox% (ctid%, keypress$)
DECLARE FUNCTION CtKeyContainer% (ctid%, keypress$)
DECLARE FUNCTION CtKeyPopup% (ctid%, keypress$)

'
' Debug API
'
DECLARE SUB DbAssert (truth AS INTEGER, where AS STRING, what AS STRING)
DECLARE SUB DbBeginsWith (text$, prefix$, where$, what$)
DECLARE SUB DbEquals (expected%, actual%, where$, what$)
DECLARE SUB DbFail (where$, what$)
DECLARE SUB DbPositive (value%, where$, what$)
DECLARE SUB DbSet (schema%, obid%, obix%, value%)
DECLARE SUB DbZero (value%, where$, what$)

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
' Drawing API
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
DECLARE SUB EvInc (name$)
DECLARE SUB EvFire (evid%)
DECLARE FUNCTION EvMap% (name$)

'
' Execution/commands
'
DECLARE SUB ExPop ()
DECLARE SUB ExPush (obid%)
DECLARE SUB ExRunFile (filename$)
DECLARE FUNCTION ExCmdListen% (token$(), count%)
DECLARE FUNCTION ExCmdMail% (token$(), count%)
DECLARE FUNCTION ExCmdReplot% (tokens$(), count%)
DECLARE FUNCTION ExCmdSpawn% (tokens$(), count%)
DECLARE FUNCTION ExMap% (schema%, propname$)
DECLARE FUNCTION ExParse% (text$, tokens$(), comment%)
DECLARE FUNCTION ExRun% (cmd$)
DECLARE FUNCTION ExRunResource% (rsid%)
DECLARE FUNCTION ExTop% ()
DECLARE FUNCTION ExTryCmd% (tokens$(), count%)
DECLARE FUNCTION ExTryEndKind% (tag$)
DECLARE FUNCTION ExTryKind% (name$)
DECLARE FUNCTION ExTryProperty% (name$, value$)
DECLARE FUNCTION ExUnquote$ (text$)

'
' Game
'
DECLARE SUB GameMoveOffset (offsetx%, offsety%)


'
' Nebula
'
DECLARE FUNCTION NebulaLabel$ (energy AS INTEGER)
DECLARE FUNCTION NebulaLabelRsid% (energy AS INTEGER)

'
' Object API
'
DECLARE FUNCTION ObCreate% (schema%, parent%)
DECLARE FUNCTION ObFind% (schema%, name$)
DECLARE FUNCTION ObGet% (schema%, obid%, obix%)
DECLARE FUNCTION ObIs% (schema%, obid%)
DECLARE FUNCTION ObRecurse% (schema%, obid%, obix%, nullvalue%)
DECLARE FUNCTION ObResolve% (obid%, expr$)
DECLARE SUB ObDelete (obid%)
DECLARE SUB ObDirtyDown (obid%)
DECLARE SUB ObInc (schema%, obid%, obix%)
DECLARE SUB ObSet (schema%, obid%, obix%, value%)
DECLARE SUB ObSetEx (schema%, obid%, obix%, value%, flags%)
DECLARE SUB ObSetFlags (schema%, obid%, obix%, flags%)

'
' Resource API
'
DECLARE FUNCTION RsCreate% (value$)
DECLARE FUNCTION RsGet$ (rsid%)
DECLARE SUB RsSet (outrsid%, value$)

'
' Shell API
'
DECLARE SUB ShBeginDraw ()
DECLARE SUB ShClear ()
DECLARE SUB ShEndDraw ()
DECLARE SUB ShFile (filename$)
DECLARE SUB ShPause ()
DECLARE SUB ShPrint (text$)
DECLARE SUB ShSerialize (obid%, indent%)

'
' UI
'
DECLARE SUB UI.Run ()
DECLARE SUB UI.RunAtlas ()
DECLARE SUB UI.RunTerminal ()
DECLARE SUB UI.SetPage (page AS INTEGER)

'
' Video API
'
DECLARE SUB VdFree (pagenum%)
DECLARE SUB VdPop ()
DECLARE SUB VdPush (active%, visual%)
DECLARE SUB VdPushActive (active%)
DECLARE SUB VdPushVisual (visual%)
DECLARE SUB VdScreen (activepage%, visualpage%)
DECLARE SUB VdWatch (pagenum%)
DECLARE FUNCTION VdAlloc% ()
DECLARE FUNCTION VdActive% ()
DECLARE FUNCTION VdVisual% ()

'
' Window API
'
DECLARE SUB WnClose (wnid%)
DECLARE SUB WnDirty (wnid%)
DECLARE SUB WnDraw (wnid%)
DECLARE SUB WnOpen (wnid%)
DECLARE SUB WnRun (wnid%)
DECLARE SUB WnRunName (name$)
DECLARE FUNCTION WnCmd% (wnid%, cmd$)
DECLARE FUNCTION WnFocus% (wnid%)
DECLARE FUNCTION WnKey% (wnid%, keypress$)
DECLARE FUNCTION WnUI% (wnid%)

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

'
' Declarations
'
DECLARE SUB SetupGame ()
DECLARE FUNCTION GetKey$ ()

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
' Object bindings
'
CONST ObBinding.None = 0
CONST ObBinding.Expression = 1
CONST ObBinding.Inherit = 3

'
' Object property indexes
'
CONST ObIndex.Invalid = -1
CONST ObIndex.Schema = 0
CONST ObIndex.Dirty = 1
CONST ObIndex.Kind = 2
CONST ObIndex.Label = 3
CONST ObIndex.Name = 4
CONST ObIndex.OffsetX = 5
CONST ObIndex.OffsetY = 6
CONST ObIndex.Parent = 7
CONST ObIndex.SizeX = 8
CONST ObIndex.SizeY = 9
CONST ObIndex.Value = 10
CONST ObIndex.MaxIndex = 10

'
' Object schemas
'
CONST ObSchema.None = 0
CONST ObSchema.Control = 1
CONST ObSchema.Event = 2
CONST ObSchema.Habitat = 3
CONST ObSchema.Location = 4
CONST ObSchema.Style = 5
CONST ObSchema.Thing = 6
CONST ObSchema.Trigger = 7
CONST ObSchema.Window = 8
CONST ObSchemas = 8

'
' Object schema names
'
REDIM SHARED ObKind$(0 TO ObSchemas, 0 TO 15)
ObKind$(0, 0) = "Object"

'
' Object property names
'
REDIM SHARED ObProperty$(0 TO 15, 0 TO 15)
ObProperty$(0, ObIndex.Schema) = "Schema"
ObProperty$(0, ObIndex.Dirty) = "Dirty"
ObProperty$(0, ObIndex.Kind) = "Kind"
ObProperty$(0, ObIndex.Label) = "Label"
ObProperty$(0, ObIndex.Name) = "Name"
ObProperty$(0, ObIndex.OffsetX) = "OffsetX"
ObProperty$(0, ObIndex.OffsetY) = "OffsetY"
ObProperty$(0, ObIndex.Parent) = "Parent"
ObProperty$(0, ObIndex.SizeX) = "SizeX"
ObProperty$(0, ObIndex.SizeY) = "SizeY"
ObProperty$(0, ObIndex.Value) = "Value"

'
' Control actions in response to input
'
CONST CtAction.None = 0
CONST CtAction.Handled = 1
CONST CtAction.Cancel = 2
CONST CtAction.Command = 3
CONST CtAction.Window = 4

'
' Control kinds
'
CONST CtKind.None = 0
CONST CtKind.Box = 1
CONST CtKind.Button = 2
CONST CtKind.Checkbox = 3
CONST CtKind.Container = 4
CONST CtKind.File = 5
CONST CtKind.Label = 6
CONST CtKind.Nebula = 7
CONST CtKind.Popup = 8
CONST CtKind.Separator = 9
CONST CtKinds = 9

'
' Control kind names
'
ObKind$(ObSchema.Control, CtKind.None) = "Control"
ObKind$(ObSchema.Control, CtKind.Box) = "Box"
ObKind$(ObSchema.Control, CtKind.Button) = "Button"
ObKind$(ObSchema.Control, CtKind.Checkbox) = "Checkbox"
ObKind$(ObSchema.Control, CtKind.Container) = "Container"
ObKind$(ObSchema.Control, CtKind.File) = "File"
ObKind$(ObSchema.Control, CtKind.Label) = "Label"
ObKind$(ObSchema.Control, CtKind.Nebula) = "Nebula"
ObKind$(ObSchema.Control, CtKind.Popup) = "Popup"
ObKind$(ObSchema.Control, CtKind.Separator) = "Separator"

'
' Control property indexes
'
CONST CtIndex.Command = 11
CONST CtIndex.Focused = 12
CONST CtIndex.Style = 13

'
' Control property names
'
ObProperty$(ObSchema.Control, CtIndex.Command) = "Command"
ObProperty$(ObSchema.Control, CtIndex.Focused) = "Focused"
ObProperty$(ObSchema.Control, CtIndex.Style) = "Style"

'
' Event kind names
'
ObKind$(ObSchema.Event, 0) = "Event"

'
' Execution token types
'
CONST ExTokenType.None = 0
CONST ExTokenType.Number = 1
CONST ExTokenType.String = 2
CONST ExTokenType.Unknown = 3

'
' Habitat properties
'
CONST HbIndex.Backdrop = 11
CONST HbIndex.StartFile = 12
CONST HbIndex.Window = 13

ObKind$(ObSchema.Habitat, 0) = "Habitat"
ObProperty$(ObSchema.Habitat, HbIndex.Backdrop) = "Backdrop"
ObProperty$(ObSchema.Habitat, HbIndex.StartFile) = "StartFile"
ObProperty$(ObSchema.Habitat, HbIndex.Window) = "Window"

'
' Location properties
'
CONST LcIndex.Energy = 11
CONST LcIndex.Habitat = 12
ObKind$(ObSchema.Location, 0) = "Location"
ObProperty$(ObSchema.Location, LcIndex.Energy) = "Energy"
ObProperty$(ObSchema.Location, LcIndex.Habitat) = "Habitat"

'
' Style kind names
'
ObKind$(ObSchema.Style, 0) = "Style"

'
' Style property indexes
'
CONST StIndex.BorderColor = 11
CONST StIndex.BorderType = 12
CONST StIndex.SelectedColor = 13
CONST StIndex.TextColor = 14

'
' Style property names
'
ObProperty$(ObSchema.Style, StIndex.BorderColor) = "BorderColor"
ObProperty$(ObSchema.Style, StIndex.BorderType) = "BorderType"
ObProperty$(ObSchema.Style, StIndex.SelectedColor) = "SelectedColor"
ObProperty$(ObSchema.Style, StIndex.TextColor) = "TextColor"

'
' Thing kinds
'
CONST ThKind.None = 0
CONST ThKind.Person = 1
CONST ThKind.Place = 2

'
' Thing kind names
'
ObKind$(ObSchema.Thing, ThKind.None) = "Thing"
ObKind$(ObSchema.Thing, ThKind.Person) = "Person"
ObKind$(ObSchema.Thing, ThKind.Place) = "Place"

'
' Thing property indexes
'
CONST ThIndex.Backdrop = 11
CONST ThIndex.Energy = 12
CONST ThIndex.Greeting = 13
CONST ThIndex.Pin = 14
CONST ThIndex.Window = 15

'
' Thing property names
'
ObProperty$(ObSchema.Thing, ThIndex.Backdrop) = "Backdrop"
ObProperty$(ObSchema.Thing, ThIndex.Energy) = "Energy"
ObProperty$(ObSchema.Thing, ThIndex.Greeting) = "Greeting"
ObProperty$(ObSchema.Thing, ThIndex.Pin) = "Pin"
ObProperty$(ObSchema.Thing, ThIndex.Window) = "Window"

'
' Trigger kind names
'
ObKind$(ObSchema.Trigger, 0) = "Trigger"

'
' Trigger property indexes
'
CONST TrIndex.Event = 11
CONST TrIndex.Equals = 12
CONST TrIndex.Command = 13

'
' Trigger property names
'
ObProperty$(ObSchema.Trigger, TrIndex.Event) = "Event"
ObProperty$(ObSchema.Trigger, TrIndex.Equals) = "Equals"
ObProperty$(ObSchema.Trigger, TrIndex.Command) = "Command"

'
' UIPage.* constants
'
CONST UIPage.None = 0
CONST UIPage.Atlas = 1
CONST UIPage.Terminal = 2

'
' Window kind names
'
ObKind$(ObSchema.Window, 0) = "Window"

'
' Window property indexes
'
CONST WnIndex.Param = 11
CONST WnIndex.Root = 12

'
' Window property names
'
ObProperty$(ObSchema.Window, WnIndex.Param) = "Param"
ObProperty$(ObSchema.Window, WnIndex.Root) = "Root"

CONST MaxChildren = 20
CONST MaxObjects = 200

'
' Keyboard sequences
'
DIM SHARED KeyBackspace$: KeyBackspace$ = CHR$(8)
DIM SHARED KeyDown$:      KeyDown$ = CHR$(0) + CHR$(80)
DIM SHARED KeyEnd$:       KeyEnd$ = CHR$(0) + CHR$(79)
DIM SHARED KeyEnter$:     KeyEnter$ = CHR$(13)
DIM SHARED KeyEscape$:    KeyEscape$ = CHR$(27)
DIM SHARED KeyHome$:      KeyHome$ = CHR$(0) + CHR$(71)
DIM SHARED KeyLeft$:      KeyLeft$ = CHR$(0) + CHR$(75)
DIM SHARED KeyPageDown$:  KeyPageDown$ = CHR$(0) + CHR$(81)
DIM SHARED KeyPageUp$:    KeyPageUp$ = CHR$(0) + CHR$(73)
DIM SHARED KeyRight$:     KeyRight$ = CHR$(0) + CHR$(77)
DIM SHARED KeySpace$:     KeySpace$ = " "
DIM SHARED KeyTab$:       KeyTab$ = CHR$(9)
DIM SHARED KeyUp$:        KeyUp$ = CHR$(0) + CHR$(72)

'
' Global atlas grid
'
DIM SHARED atlasGrid(1 TO AtlasStyle.GridSizeX, 1 TO AtlasStyle.GridSizeY) AS INTEGER
                 
'
' Global object state
'
DIM SHARED obj(1 TO MaxObjects, 0 TO 15) AS PropType

'
' Global runtime state
'
DIM SHARED db.debug            AS INTEGER
DIM SHARED dg.listening        AS INTEGER
DIM SHARED ex.depth            AS INTEGER
DIM SHARED ex.stack(1 TO 10)   AS INTEGER
DIM SHARED ob.count            AS INTEGER
DIM SHARED vd.allocated        AS INTEGER
DIM SHARED vd.stacked          AS INTEGER
DIM SHARED vd.stack(0 TO 5)    AS INTEGER
DIM SHARED wn.backpage(1 TO 3) AS INTEGER
DIM SHARED wn.count            AS INTEGER
DIM SHARED wn.wnid(1 TO 3)     AS INTEGER
DIM SHARED wn.workpage(1 TO 3) AS INTEGER

'
' Views
'
DIM SHARED vwPerParent(1 TO MaxObjects, 0 TO MaxChildren) AS INTEGER
DIM SHARED vwPerSchema(1 TO ObSchemas, 0 TO MaxObjects) AS INTEGER

DIM SHARED atlasitem(1 TO 35)    AS AtlasItemType
DIM SHARED atlaspage             AS INTEGER
DIM SHARED playeraid             AS INTEGER
REDIM SHARED resource(1 TO 200)  AS STRING
DIM SHARED resources             AS INTEGER
DIM SHARED uiCurrentPage         AS INTEGER

ON TIMER(1) GOSUB HandleTimer

SetupGame
UI.Run
END

HandleTimer:
  '
  ' Executed when the game needs to perform periodic tasks
  '
  IF dg.listening > 0 THEN
    DgTimer
  END IF
  RETURN

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
    DbFail "AtlasAddItem", "AtlasNextIndex returned 0"
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
  VdPushActive atlaspage
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
  VdPop
END SUB

SUB AtlasDrawGrid
  AtlasDrawBegin
  DrawFileAt "GRID.PCB", 1, 2
  AtlasDrawEnd
END SUB

SUB AtlasDrawItem (idx AS INTEGER)
 
  DbPositive idx, "AtlasDrawItem", "idx"

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

  DIM Try AS INTEGER
  LET Try = idx

  DO
    '
    ' Try the next index
    '
    Try = Try + 1
    IF Try > UBOUND(atlasitem) THEN
      Try = 1
    END IF

    IF NOT atlasitem(Try).allocated THEN
      idx = Try
      AtlasNextIndex = idx
      EXIT FUNCTION
    END IF

    IF Try = idx THEN
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

FUNCTION AtlasPrompt% (promptFor AS INTEGER, outcx AS INTEGER, outcy AS INTEGER, outpress AS STRING)
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
  
      CASE KeyEscape$
        outpress = keypress
        AtlasPrompt = False
        EXIT FUNCTION

      CASE KeyEnter$, " "
        IF valid THEN
          outcx = mx
          outcy = my
          outpress = keypress
          AtlasPrompt = True
          EXIT FUNCTION
        END IF

      CASE KeyUp$
        '
        ' Up
        '
        my = my - 1
        IF my = 0 THEN my = AtlasStyle.GridSizeY
 
      CASE KeyDown$
        '
        ' Down
        '
        my = my + 1
        IF my > AtlasStyle.GridSizeY THEN my = 1
     
      CASE KeyLeft$
        '
        ' Left
        '
        mx = mx - 1
        IF mx = 0 THEN mx = AtlasStyle.GridSizeX
     
      CASE KeyRight$
        '
        ' Right
        '
        mx = mx + 1
        IF mx > AtlasStyle.GridSizeX THEN mx = 1

      CASE KeyHome$
        mx = 1

      CASE KeyEnd$
        mx = AtlasStyle.GridSizeX

      CASE KeyPageUp$
        my = 1

      CASE KeyPageDown$
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
 
  DbPositive idx, "AtlasSetLabel", "idx"

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

FUNCTION CtAction% (action%, param%)
  DbAssert action% < &H10, "CtAction%", "action% too big"
  DbAssert param% < &H1000, "CtAction%", "param% too big"
  CtAction% = action% OR (param% * 16)
END FUNCTION

FUNCTION CtCanFocus% (ctid%)

  IF ctid% = 0 THEN
    EXIT FUNCTION
  END IF

  IF NOT ObIs%(ObSchema.Control, ctid%) THEN
    EXIT FUNCTION
  END IF

  DIM kind%: kind% = ObGet%(ObSchema.Control, ctid%, ObIndex.Kind)

  SELECT CASE kind%
   
    CASE CtKind.Button, CtKind.Checkbox, CtKind.Container, CtKind.Popup
      CtCanFocus% = True
   
    CASE ELSE
      CtCanFocus% = False
 
  END SELECT

END FUNCTION

SUB CtDraw (ctid%)

  DIM dirty%: dirty% = ObGet%(ObSchema.Control, ctid%, ObIndex.Dirty)
  IF NOT dirty% THEN
    EXIT SUB
  END IF

  DIM kind%: kind% = ObGet%(ObSchema.Control, ctid%, ObIndex.Kind)

  SELECT CASE kind%
   
    CASE CtKind.Button
      CtDrawLabel ctid%

    CASE CtKind.Box
      CtDrawBox ctid%

    CASE CtKind.Checkbox
      CtDrawCheckbox ctid%

    CASE CtKind.Container
      CtDrawContainer ctid%

    CASE CtKind.Label
      CtDrawLabel ctid%

    CASE CtKind.File
      CtDrawFile ctid%

    CASE CtKind.Popup
      CtDrawPopup ctid%

    CASE CtKind.Separator
      CtDrawSeparator ctid%

    CASE CtKind.Nebula
      CtDrawNebula ctid%

     CASE ELSE
      DbFail "CtDraw", "unsupported kind" + STR$(kind%)

  END SELECT

  ObSet ObSchema.Control, ctid%, ObIndex.Dirty, 0

END SUB

SUB CtDrawBox (ctid%)

  DIM stid%: stid% = ObGet%(ObSchema.Control, ctid%, CtIndex.Style)
 
  DIM bordertype%
  IF stid% > 0 THEN
    bordertype% = ObGet%(ObSchema.Style, stid%, StIndex.BorderType)
  END IF

  SELECT CASE bordertype%
 
    CASE 0:
      CtDrawBox0 ctid%

    CASE 1:
      CtDrawBox1 ctid%

    CASE 2:
      CtDrawBox2 ctid%

    CASE ELSE
      DbFail "CtDrawBox", "Unsupported border type"

  END SELECT

END SUB

SUB CtDrawBox0 (ctid%)

  DIM row AS INTEGER
  DIM sx  AS INTEGER
  DIM sy  AS INTEGER

  DIM stid%: stid% = ObGet%(ObSchema.Control, ctid%, CtIndex.Style)
  IF stid% > 0 THEN
    DrawColor ObGet%(ObSchema.Style, stid%, StIndex.TextColor)
  END IF

  FOR row = 1 TO ObGet%(ObSchema.Control, ctid%, ObIndex.SizeY)
   
    sx = CtGetScreenX%(ctid%)
    sy = CtGetScreenY%(ctid%) + row - 1

    LOCATE sy, sx
    PRINT STRING$(ObGet%(ObSchema.Control, ctid%, ObIndex.SizeX), " ");
 
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
  sizeX = ObGet%(ObSchema.Control, ctid%, ObIndex.SizeX)
  sx1 = CtGetScreenX%(ctid%)
  sy1 = CtGetScreenY%(ctid%)
  sx2 = sx1 + sizeX - 1
  sy2 = sy1 + ObGet%(ObSchema.Control, ctid%, ObIndex.SizeY) - 1

  DIM stid%
  LET stid% = ObGet%(ObSchema.Control, ctid%, CtIndex.Style)

  '
  ' Draw the top border
  '
  LOCATE sy1, sx1
  IF stid% > 0 THEN
    DrawColor ObGet%(ObSchema.Style, stid%, StIndex.BorderColor)
  END IF
  PRINT upperLeft; STRING$(sizeX - 2, upperFlat); upperRight;

  '
  ' Draw each row of the border
  '
  FOR r = sy1 + 1 TO sy2 - 1
    LOCATE r, sx1
    PRINT sideLeft;
  
    IF stid% > 0 THEN
      DrawColor ObGet%(ObSchema.Style, stid%, StIndex.TextColor)
    END IF
    PRINT STRING$(sizeX - 2, " ");
  
    IF stid% > 0 THEN
      DrawColor ObGet%(ObSchema.Style, stid%, StIndex.BorderColor)
    END IF
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

  sizeX = ObGet%(ObSchema.Control, ctid%, ObIndex.SizeX)
  SizeY = ObGet%(ObSchema.Control, ctid%, ObIndex.SizeY)
 
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

SUB CtDrawCheckbox (ctid%)

  DIM bordercolor%
  DIM focused%
  DIM selectedcolor%
  DIM style%
  DIM sx%
  DIM sy%
  DIM textcolor%
  DIM value%

  '
  ' Get the value, 0=false, else=true
  '
  LET value% = ObGet%(ObSchema.Control, ctid%, ObIndex.Value)
  LET focused% = ObGet%(ObSchema.Control, ctid%, CtIndex.Focused)

  '
  ' Get the style to set colors
  '
  LET style% = ObGet%(ObSchema.Control, ctid%, CtIndex.Style)
  IF style% = 0 THEN
    bordercolor% = 7
    selectedcolor% = &H70
    textcolor% = 7
  ELSE
    bordercolor% = ObGet%(ObSchema.Style, style%, StIndex.BorderColor)
    selectedcolor% = ObGet%(ObSchema.Style, style%, StIndex.SelectedColor)
    textcolor% = ObGet%(ObSchema.Style, style%, StIndex.TextColor)
  END IF

  '
  ' Calculate screen coordinates
  '
  LET sx% = CtGetScreenX%(ctid%)
  LET sy% = CtGetScreenY%(ctid%)
  LOCATE sy%, sx%

  '
  ' Left side
  '
  DrawColor bordercolor%
  PRINT "[";
 
  '
  ' Checkmark
  '
  IF focused% THEN DrawColor selectedcolor% ELSE DrawColor textcolor%
  IF value% THEN PRINT "X";  ELSE PRINT " ";
 
  '
  ' Right side
  '
  DrawColor bordercolor%
  PRINT "]";

END SUB

SUB CtDrawContainer (ctid%)

  DIM n%
  FOR n% = 1 TO vwPerParent(ctid%, 0)
    ' *** Optimize by checking dirty state of view
    CtDraw vwPerParent(ctid%, n%)
  NEXT

END SUB

SUB CtDrawFile (ctid%)

  DIM rsid%
  LET rsid% = ObGet%(ObSchema.Control, ctid%, ObIndex.Value)
  IF rsid% = 0 THEN
    EXIT SUB
  END IF

  DIM filename$
  LET filename$ = RsGet$(rsid%)
  IF LEN(filename$) = 0 THEN
    EXIT SUB
  END IF
 
  DIM sx%: sx% = CtGetScreenX%(ctid%)
  DIM sy%: sy% = CtGetScreenY%(ctid%)

  DrawFileAt filename$, sx%, sy%

END SUB

SUB CtDrawLabel (ctid%)
 
  DIM stid%
  DIM sx%
  DIM sy%

  '
  ' Get field position
  '
  LET sx% = CtGetScreenX%(ctid%)
  LET sy% = CtGetScreenY%(ctid%)
  LOCATE sy%, sx%

  '
  ' Set style of text
  '
  LET stid% = ObGet%(ObSchema.Control, ctid%, CtIndex.Style)
  IF stid% = 0 THEN
    IF ObGet%(ObSchema.Control, ctid%, CtIndex.Focused) <> 0 THEN
      ' *** track current color and push/pop
      COLOR 0, 7
    ELSE
      COLOR 7, 0
    END IF
  ELSE
    IF ObGet%(ObSchema.Control, ctid%, CtIndex.Focused) <> 0 THEN
      DrawColor ObGet%(ObSchema.Style, stid%, StIndex.SelectedColor)
    ELSE
      DrawColor ObGet%(ObSchema.Style, stid%, StIndex.TextColor)
    END IF
  END IF

  '
  ' Print text clipped to size
  '
  DIM text$: text$ = RsGet$(ObGet%(ObSchema.Control, ctid%, ObIndex.Label))
  DIM size%: size% = ObGet%(ObSchema.Control, ctid%, ObIndex.SizeX)
 
  IF size% < 1 THEN
    PRINT text$;
  ELSE
    PRINT LEFT$(text$, size%);
    IF LEN(text$) < size% THEN
      PRINT STRING$(size% - LEN(text$), " ");
    END IF
  END IF

END SUB

SUB CtDrawNebula (ctid%)

  DIM p     AS INTEGER
  DIM sizeX AS INTEGER
  DIM sx    AS INTEGER
  DIM sy    AS INTEGER
  DIM x     AS INTEGER
  DIM y     AS INTEGER

  sizeX = ObGet%(ObSchema.Control, ctid%, ObIndex.SizeX)

  COLOR 7, 0

  FOR y = 1 TO ObGet%(ObSchema.Control, ctid%, ObIndex.SizeY)
 
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

SUB CtDrawPopup (ctid%)

  CtDrawLabel ctid%

  DIM focused%
  LET focused% = ObGet%(ObSchema.Control, ctid%, CtIndex.Focused)
 
  IF focused% > 0 THEN
    '
    ' The poppup is opened, so draw child controls
    '
    DIM n%
    FOR n% = 1 TO vwPerParent(ctid%, 0)
     
      DIM child%
      LET child% = vwPerParent(ctid%, n%)

      IF ObIs%(ObSchema.Control, child%) THEN
        CtDraw vwPerParent(ctid%, n%)
      END IF

    NEXT

  END IF

END SUB

SUB CtDrawSeparator (ctid%)

  DIM row   AS INTEGER
  DIM sizeX AS INTEGER
  DIM SizeY AS INTEGER
  DIM sx    AS INTEGER
  DIM sy    AS INTEGER

  DIM stid%
  LET stid% = ObGet%(ObSchema.Control, ctid%, CtIndex.Style)
 
  sizeX = ObGet%(ObSchema.Control, ctid%, ObIndex.SizeX)
  SizeY = ObGet%(ObSchema.Control, ctid%, ObIndex.SizeY)
  sx = CtGetScreenX%(ctid%)
  sy = CtGetScreenY%(ctid%)

  LOCATE sy, sx
  IF stid% > 0 THEN
    DrawColor ObGet%(ObSchema.Style, stid%, StIndex.BorderColor)
  END IF

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

'
' Ensures the control has focused if permitted
'
FUNCTION CtFocus% (ctid%)
 
  DbPositive ctid%, "CtFocus%", "ctid%"
  IF NOT CtCanFocus%(ctid%) THEN
    EXIT FUNCTION
  END IF

  DIM focused%
  LET focused% = ObGet%(ObSchema.Control, ctid%, CtIndex.Focused)

  IF focused% = 0 THEN
    CtFocus% = CtFocusFirst%(ctid%)
  ELSE
    CtFocus% = focused%
  END IF

END FUNCTION

FUNCTION CtFocusBack% (ctid%)

  DbPositive ctid%, "CtFocusBack%", "ctid%"
  IF NOT CtCanFocus%(ctid%) THEN
    EXIT FUNCTION
  END IF

  DIM child%
  DIM first%
  DIM found%
  DIM n%
  DIM new%
  DIM old%

  old% = ObGet%(ObSchema.Control, ctid%, CtIndex.Focused)

  FOR n% = vwPerParent(ctid%, 0) TO 1 STEP -1
     
    child% = vwPerParent(ctid%, n%)
    IF CtCanFocus%(child%) THEN
  
      IF first% = 0 THEN
        '
        ' Keep track of the first control that is focusable
        '
        first% = child%
      END IF

      IF new% > 0 THEN
        '
        ' A new control was selected earlier, this one can be unfocused
        '
        CtUnfocus child%

      ELSEIF found% THEN
        '
        ' The old control was found earlier, so this is the new selection.
        '
        new% = child%

      ELSEIF child% = old% THEN
        '
        ' This is the old control.
        '
        found% = True
    
      ELSE
        '
        ' New control not found, old control not found
        '
        CtUnfocus child%

      END IF

    END IF
   
  NEXT

  IF new% = 0 THEN
    '
    ' A new one was not found, so wrap to the first focusable one
    '
    new% = first%
  END IF

  IF new% <> old% THEN
   
    IF old% > 0 THEN
      CtUnfocus old%
    END IF

    IF new% > 0 THEN
      DIM r%: r% = CtFocus%(new%)
    END IF

    ObSet ObSchema.Control, ctid%, CtIndex.Focused, new%
 
  END IF

  CtFocusBack% = new%

END FUNCTION

'
' Sets focus to the first focusable child control or itself
'
FUNCTION CtFocusFirst% (ctid%)

  DbPositive ctid%, "CtFocusFirst%", "ctid%"
  IF NOT CtCanFocus%(ctid%) THEN
    EXIT FUNCTION
  END IF

  DIM child%
  DIM focused%
  DIM n%

  FOR n% = 1 TO vwPerParent(ctid%, 0)
 
    child% = vwPerParent(ctid%, n%)
    
    IF CtCanFocus%(child%) THEN
   
      IF focused% = 0 THEN
        '
        ' A focusable control has not been found yet
        '
        IF CtFocus%(child%) > 0 THEN
          focused% = child%
        END IF

      ELSE
        '
        ' A focusable control has already been found. Unfocus this one.
        '
        CtUnfocus child%
      END IF

    END IF

  NEXT

  IF focused% = 0 THEN
    '
    ' No child control was focused, so focus on itself
    '
    focused% = ctid%
  END IF
 
  ObSet ObSchema.Control, ctid%, CtIndex.Focused, focused%
  CtFocusFirst% = focused%

END FUNCTION

FUNCTION CtFocusLast% (ctid%)

  DbPositive ctid%, "CtFocusLast%", "ctid%"
  IF NOT CtCanFocus%(ctid%) THEN
    EXIT FUNCTION
  END IF

  DIM child%
  DIM focused%
  DIM n%

  FOR n% = vwPerParent(ctid%, 0) TO 1 STEP -1

    child% = vwPerParent(ctid%, n%)
   
    IF CtCanFocus%(child%) THEN
  
      IF focused% = 0 THEN
        '
        ' A focusable control has not been found yet
        '
        IF CtFocus%(child%) > 0 THEN
          focused% = child%
        END IF

      ELSE
        '
        ' A focusable control has already been found. Unfocus this one.
        '
        CtUnfocus child%
      END IF

    END IF

  NEXT

  IF focused% = 0 THEN
    '
    ' No child control was focused, so focus on itself
    '
    focused% = ctid%
  END IF

  ObSet ObSchema.Control, ctid%, CtIndex.Focused, focused%
  CtFocusLast% = focused%

END FUNCTION

FUNCTION CtFocusNext% (ctid%)

  DbPositive ctid%, "CtFocusNext%", "ctid%"
  IF NOT CtCanFocus%(ctid%) THEN
    EXIT FUNCTION
  END IF

  DIM child%
  DIM first%
  DIM found%
  DIM n%
  DIM new%
  DIM old%

  old% = ObGet%(ObSchema.Control, ctid%, CtIndex.Focused)

  FOR n% = 1 TO vwPerParent(ctid%, 0)
      
    child% = vwPerParent(ctid%, n%)
    IF CtCanFocus%(child%) THEN
   
      IF first% = 0 THEN
        '
        ' Keep track of the first control that is focusable
        '
        first% = child%
      END IF

      IF new% > 0 THEN
        '
        ' A new control has already been focused; this one can be unfocused.
        '
        CtUnfocus child%

      ELSEIF found% THEN
        '
        ' The old control was found earlier, so this is the new selection.
        '
        IF CtFocus%(child%) > 0 THEN
          new% = child%
        END IF

      ELSEIF child% = old% THEN
        '
        ' This is the old control.
        '
        found% = True
     
      ELSE
        '
        ' New control not found, old control not found
        '
        CtUnfocus child%

      END IF

    END IF
    
  NEXT

  IF new% = 0 THEN
    '
    ' A new one was not found, so wrap to the first focusable one
    '
    new% = first%
  END IF

  IF new% <> old% THEN
  
    IF old% > 0 THEN
      CtUnfocus old%
    END IF

    IF new% > 0 THEN
      DIM r%: r% = CtFocus%(new%)
    END IF

    ObSet ObSchema.Control, ctid%, CtIndex.Focused, new%

  END IF

  CtFocusNext% = new%

END FUNCTION

FUNCTION CtGetScreenX% (ctid%)

  DIM offsetx%
  LET offsetx% = ObGet%(ObSchema.Control, ctid%, ObIndex.OffsetX)

  DIM parent%
  LET parent% = ObGet%(ObSchema.Control, ctid%, ObIndex.Parent)

  IF parent% > 0 THEN
    IF ObGet%(0, parent%, ObIndex.Schema) = ObSchema.Control THEN
      CtGetScreenX% = offsetx% + CtGetScreenX%(parent%)
      EXIT FUNCTION
    END IF
  END IF
 
  CtGetScreenX% = offsetx% + 1

END FUNCTION

FUNCTION CtGetScreenY% (ctid%)

  DIM offsety%
  LET offsety% = ObGet%(ObSchema.Control, ctid%, ObIndex.OffsetY)
 
  DIM parent%
  LET parent% = ObGet%(ObSchema.Control, ctid%, ObIndex.Parent)

  IF parent% > 0 THEN
    IF ObGet%(0, parent%, ObIndex.Schema) = ObSchema.Control THEN
      CtGetScreenY% = offsety% + CtGetScreenY%(parent%)
      EXIT FUNCTION
    END IF
  END IF
 
  CtGetScreenY% = offsety% + 1

END FUNCTION

FUNCTION CtKey% (ctid%, keypress$)
  '
  ' The CtKey function sends a keystroke to a control
  '
 
  DbPositive ctid%, "CtKey%", "ctid%"
  DbPositive LEN(keypress$), "CtKey%", "len(keypress$)"
 
  DIM kind%
  LET kind% = ObGet%(ObSchema.Control, ctid%, ObIndex.Kind)
    '
    ' Gets the kind of control, e.g., button, lable, nebula, etc.
    '

  SELECT CASE kind%

    CASE CtKind.Button
      CtKey% = CtKeyButton%(ctid%, keypress$)

    CASE CtKind.Checkbox
      CtKey% = CtKeyCheckbox%(ctid%, keypress$)

    CASE CtKind.Container
      CtKey% = CtKeyContainer%(ctid%, keypress$)

    CASE CtKind.Popup
      CtKey% = CtKeyPopup%(ctid%, keypress$)

  END SELECT

END FUNCTION

FUNCTION CtKeyButton% (ctid%, keypress$)

  IF keypress$ <> KeyEnter$ THEN
    '
    ' A button only recognizes Enter keys
    '
    EXIT FUNCTION
  END IF

  '
  ' Get the resoure ID of the command associated with the button.
  '
  DIM rsid%: rsid% = ObGet%(ObSchema.Control, ctid%, CtIndex.Command)
 
  '
  ' Return an action to execute the command specified by the resource ID.
  '
  CtKeyButton% = CtAction%(CtAction.Command, rsid%)

END FUNCTION

FUNCTION CtKeyCheckbox% (ctid%, keypress$)
 
  DIM new%
  DIM old%
  
  '
  ' Get current value
  '
  LET old% = ObGet%(ObSchema.Control, ctid%, ObIndex.Value)
  LET new% = old%

  DIM action%

  SELECT CASE keypress$

    CASE " "
      new% = NOT new%
      action% = CtAction.Handled

    CASE "n", "N"
      new% = False
      action% = CtAction.Handled

    CASE "y", "Y"
      new% = True
      action% = CtAction.Handled

  END SELECT

  IF new% <> old% THEN
    ObSet ObSchema.Control, ctid%, ObIndex.Value, new%
  END IF

  CtKeyCheckbox% = action%

END FUNCTION

FUNCTION CtKeyContainer% (ctid%, keypress$)

  DbPositive ctid%, "CtKeyContainer%", "ctid%"
 
  '
  ' Get the control with focus, either a child control or this container
  '
  DIM focused%: focused% = ObGet%(ObSchema.Control, ctid%, CtIndex.Focused)
 
  DIM action%
  IF focused% > 0 AND focused% <> ctid% THEN
    '
    ' If a child control has focus, send the key to that control
    '
    action% = CtKey%(focused%, keypress$)
    IF action% THEN
      CtKeyContainer% = action%
      EXIT FUNCTION
    END IF
  END IF

  '
  ' The child control did not handle the key. See if this container can.
  '
  action% = CtAction.Handled
  SELECT CASE keypress$
 
    CASE KeyBackspace$
      focused% = CtFocusBack%(ctid%)

    CASE KeyDown$
      focused% = CtFocusNext%(ctid%)

    CASE KeyEnd$
      focused% = CtFocusLast%(ctid%)

    CASE KeyHome$
      focused% = CtFocusFirst%(ctid%)

    CASE KeyLeft$
      focused% = CtFocusBack%(ctid%)

    CASE KeyPageDown$
      focused% = CtFocusLast%(ctid%)

    CASE KeyPageUp$
      focused% = CtFocusFirst%(ctid%)

    CASE KeyRight$
      focused% = CtFocusNext%(ctid%)

    CASE KeySpace$
      focused% = CtFocusNext%(ctid%)

    CASE KeyTab$
      focused% = CtFocusNext%(ctid%)

    CASE KeyUp$
      focused% = CtFocusBack%(ctid%)

    CASE ELSE
      '
      ' The key is not recognized by the container either.
      '
      action% = CtAction.None

  END SELECT

  CtKeyContainer% = action%

END FUNCTION

FUNCTION CtKeyPopup% (ctid%, keypress$)

  DbPositive ctid%, "CtKeyPopup%", "ctid%"

  SELECT CASE keypress$
 
    CASE KeyDown$, KeyEnter$
      DIM value%: value% = ObGet%(ObSchema.Control, ctid%, ObIndex.Value)
      IF value% > 0 THEN
        CtKeyPopup% = CtAction%(CtAction.Window, value%)
      END IF

  END SELECT

END FUNCTION

SUB CtUnfocus (ctid%)

  DIM child%
  DIM n%

  ObSet ObSchema.Control, ctid%, CtIndex.Focused, 0

  FOR n% = 1 TO vwPerParent(ctid%, 0)
    child% = vwPerParent(ctid%, n%)
    IF CtCanFocus%(child%) THEN
      CtUnfocus child%
    END IF
  NEXT

END SUB

SUB DbAssert (truth AS INTEGER, where AS STRING, what AS STRING)

  IF NOT truth THEN
   
    DIM message$
    LET message$ = where + ": " + what

    VdPush 0, 0
    ShPrint "@X4F" + message$ + "@X07"
    IF GetKey$ <> KeyEscape$ THEN
      STOP
    END IF
    VdPop

  END IF

END SUB

SUB DbBeginsWith (text$, prefix$, where$, what$)
  IF LEFT$(text$, LEN(prefix$)) <> prefix$ THEN
    DbFail where$, what$ + " must begin with " + prefix$
  END IF
END SUB

SUB DbEquals (expected%, actual%, where$, what$)

  IF expected% <> actual% THEN
 
    DIM msg$
    msg$ = what$ + " expected:" + STR$(expected%) + " actually:" + STR$(actual%)

    DbFail where$, msg$

  END IF

END SUB

SUB DbFail (where$, what$)
  DbAssert 0, where$, what$
END SUB

'
' Asserts whether the value is positive.
'
SUB DbPositive (value%, where$, what$)
 
  IF value% <= 0 THEN
    DIM msg$: msg$ = what$ + " must be > 0 but value =" + STR$(value%)
    DbFail where$, msg$
  END IF

END SUB

SUB DbSet (schema%, obid%, obix%, value%)

  DIM text$
  LET text$ = ObKind$(schema%, 0)

  '
  ' obid
  '
  DIM h$: h$ = HEX$(obid%)
  SELECT CASE LEN(h$)
    CASE 1:
      text$ = text$ + ":000" + h$
    CASE 2:
      text$ = text$ + ":00" + h$
    CASE 3:
      text$ = text$ + ":0" + h$
  END SELECT

  '
  ' obix
  '
  h$ = HEX$(obix%)
  SELECT CASE LEN(h$)
    CASE 1:
      text$ = text$ + "[0" + h$ + "]="
    CASE 2:
      text$ = text$ + "[" + h$ + "]="
  END SELECT

  '
  ' value
  '
  h$ = HEX$(value%)
  SELECT CASE LEN(h$)
    CASE 1:
      text$ = text$ + "0" + h$
    CASE 2:
      text$ = text$ + h$
  END SELECT

  ShPrint "@X08" + text$ + "@X07"

END SUB

SUB DbZero (value%, where$, what$)
  DbAssert value% = 0, where$, what$ + " must be 0 but value =" + STR$(value%)
END SUB

FUNCTION DgGarble$ (text$, percent!)

  CONST GarbleCode = 250
  CONST InSpaces = 0
  CONST InWord = 1
  CONST InGarble = 2

  DIM c AS STRING * 1
  DIM g AS STRING
  DIM i AS INTEGER
  DIM S AS INTEGER

  FOR i = 1 TO LEN(text$)

    c = MID$(text$, i, 1)

    SELECT CASE S
      CASE InSpaces
        IF c <> " " THEN
          IF RND <= percent! THEN
            g = g + "@X08" + CHR$(GarbleCode)
            S = InGarble
          ELSE
            g = g + c
            S = InWord
          END IF
        ELSE
          g = g + " "
        END IF
      CASE InWord
        IF c = " " THEN
          g = g + " "
          S = InSpaces
        ELSE
          g = g + c
        END IF
      CASE InGarble
        IF c = " " THEN
          g = g + "@X07 "
          S = InSpaces
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

  '
  ' Select a random person
  ' *** will fail when more than one thing kind is defined
  '
  DIM n%: n% = INT(RND * vwPerSchema(ObSchema.Thing, 0)) + 1
  outprid% = vwPerSchema(ObSchema.Thing, n%)

END SUB

SUB DgPrint (thid%, text$)

  DIM name$
  LET name$ = RsGet$(ObGet%(ObSchema.Thing, thid%, ObIndex.Name))
 
  DIM label$
  LET label$ = RsGet$(ObGet%(ObSchema.Thing, thid%, ObIndex.Label))
  IF label$ = "" THEN
    label$ = "@X1F " + name$ + " @X07"
  END IF

  IF LEFT$(text$, 1) = "(" THEN
    ' *** fails when text too long
    ShPrint STRING$((80 - DrawLength(text$)) / 2, " ") + "@X04" + text$ + "@X07"
    ShPrint ""

  ELSE

    DIM q$
  
    SELECT CASE INT(RND * 2)
      CASE 0:
        '
        ' Left justified
        '
        q$ = DgGarble(text$, .2)

        ShPrint label$
        ShPrint "@X07" + text$ + "@X07"
        ShPrint ""

      CASE 1:
        '
        ' Right justified
        '
        q$ = DgGarble(text$, .7)
      
        ShPrint STRING$(78 - DrawLength(label$), " ") + label$
        ShPrint STRING$(78 - DrawLength(text$), " ") + "@X07" + q$ + "@X07"
        ShPrint ""

    END SELECT

    'AtlasSetStatus "@X1F " + name$ + " @X07 " + CHR$(34) + q$ + CHR$(34)

  END IF

END SUB

SUB DgStart (hbid%)
 
  IF hbid% <> dg.listening THEN
   
    dg.listening = 0

    DIM startfile$
    LET startfile$ = RsGet$(ObGet%(ObSchema.Habitat, hbid%, HbIndex.StartFile))
    IF LEN(startfile$) > 0 THEN
      ShFile startfile$
    END IF

    dg.listening = hbid%

  END IF

END SUB

SUB DgStop
  dg.listening = 0
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
  DbPositive LEN(filename$), "DrawFile", "LEN(filename$)"

  DIM text$
 
  DIM handle%: handle% = FREEFILE
  OPEN filename$ FOR INPUT ACCESS READ AS #handle%

  DO WHILE NOT EOF(handle%)
    LINE INPUT #handle%, text$
    DrawText text$ + KeyEnter$
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
  DIM startat   AS INTEGER

  DIM batr AS INTEGER
  DIM fatr AS INTEGER

  LET startat = 1

  DO
 
    '
    ' Get the index of the next code
    '
    nextAt = INSTR(startat, text$, "@X")

    IF nextAt = 0 THEN
      '
      ' No further codes found; print remaining characters
      '
      IF startat <= LEN(text$) THEN
        PRINT RIGHT$(text$, LEN(text$) - startat + 1);
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
      PRINT MID$(text$, startat, nextAt - startat);

      '
      ' Read the color values
      '
      DrawColor VAL("&H" + MID$(text$, nextAt + 2, 2))

      '
      ' Continue with the next character after the code
      '
      startat = nextAt + 4
    END IF

  LOOP

END SUB

SUB EvFire (evid%)

  DIM n%
  FOR n% = 1 TO vwPerSchema(ObSchema.Trigger, 0)
   
    DIM trid%: trid% = vwPerSchema(ObSchema.Trigger, n%)

    '
    ' Match the event
    '
    IF ObGet%(ObSchema.Trigger, trid%, TrIndex.Event) = evid% THEN
    
      '
      ' Match the value
      '
      DIM equals%: equals% = ObGet%(ObSchema.Trigger, trid%, TrIndex.Equals)
      IF equals% = ObGet%(ObSchema.Event, evid%, ObIndex.Value) THEN
        DIM rsid%: rsid% = ObGet%(ObSchema.Trigger, trid%, TrIndex.Command)
        DIM result%: result% = ExRunResource(rsid%)
      END IF

    END IF

  NEXT
 
END SUB

SUB EvInc (name$)
 
  DIM evid%: evid% = ObFind%(ObSchema.Event, name$)
  IF evid% > 0 THEN
    ObInc ObSchema.Event, evid%, ObIndex.Value
    EvFire evid%
  END IF

END SUB

FUNCTION ExCmdListen% (token$(), count%)

  DIM hbid%: hbid% = VAL(token$(1))
  IF hbid% = 0 THEN
    DgStop
  ELSE
    UI.SetPage UIPage.Terminal
    DgStart hbid%
  END IF

END FUNCTION

FUNCTION ExCmdMail% (tokens$(), count%)
 
  '
  ' Get the container that holds messages
  '
  DIM msgs%: msgs% = ObFind%(ObSchema.Control, "Messages")
  IF msgs% = 0 THEN
    DbPositive msgs%, "ExCmdMail%", "msgs%"
    EXIT FUNCTION
  END IF

  DIM countmail%: countmail% = vwPerParent(msgs%, 0)

  '
  ' Create a button for the message
  '
  DIM ctid%: ctid% = ObCreate%(ObSchema.Control, msgs%)
  ObSet ObSchema.Control, ctid%, ObIndex.Kind, CtKind.Button
  ObSet ObSchema.Control, ctid%, CtIndex.Command, 0
  ObSet ObSchema.Control, ctid%, ObIndex.Label, RsCreate%(" " + tokens$(1))
  ObSet ObSchema.Control, ctid%, ObIndex.OffsetX, 0
  ObSet ObSchema.Control, ctid%, ObIndex.OffsetY, countmail%
  ObSet ObSchema.Control, ctid%, ObIndex.SizeX, 20
  ObSet ObSchema.Control, ctid%, ObIndex.SizeY, 1
  ObSet ObSchema.Control, ctid%, ObIndex.Value, RsCreate%(tokens$(2))

  DIM f%: f% = CtFocusLast(msgs%)

  AtlasSetStatus "Mail arrived"
  ShFile "NEWMAIL.PCB"
  ExCmdMail% = True

END FUNCTION

FUNCTION ExCmdReplot% (tokens$(), count%)
  '
  ' Replot <band | cluster | manual | random>
  '
  'UI.SetPage UIPage.Atlas
 
  SELECT CASE LCASE$(tokens$(1))
   
    CASE "b", "band", "banded"
      AtlasPlotBanded
      ExCmdReplot% = True

    CASE "c", "cluster", "clustered"
      AtlasPlotClustered
      ExCmdReplot% = True

    CASE "m", "manual"
      AtlasPlotManual
      ExCmdReplot% = True

    CASE "r", "random"
      AtlasPlotRandom
      ExCmdReplot% = True

  END SELECT

END FUNCTION

FUNCTION ExCmdSpawn% (tokens$(), count%)
  '
  ' Spawn <habitat> at <x>, <y>
  ' Spawn <habitat> band <n>
  ' Spawn <habitat> cluster <n>
  ' Spawn <habitat> random <n>
  ' Spawn <habitat> player <x>, <y>
  '

  IF count% < 3 THEN
    EXIT FUNCTION
  END IF

  DIM hbid%: hbid% = ObFind%(ObSchema.Habitat, tokens$(1))
  IF hbid% = 0 THEN
    EXIT FUNCTION
  END IF

  SELECT CASE LCASE$(tokens$(2))
     
    CASE "at"
     
      DIM aid%: aid% = WorldAdd%(hbid%, VAL(tokens$(3)), VAL(tokens$(4)))
      ExCmdSpawn% = aid% > 0

    CASE "b", "band", "banded"
     
      WorldAddBanded hbid%, VAL(tokens$(3))
      ExCmdSpawn% = True

    CASE "c", "cluster", "clustered"
     
      WorldAddCluster hbid%, VAL(tokens$(3))
      ExCmdSpawn% = True

    CASE "p", "player"
     
      DIM cx%: cx% = VAL(tokens$(3)): IF cx% = 0 THEN cx% = 1
      DIM cy%: cy% = VAL(tokens$(4)): IF cy% = 0 THEN cy% = 1
     
      IF playeraid = 0 THEN
        playeraid = WorldAdd%(hbid%, cx%, cy%)
      ELSE
        AtlasMoveItem AtlasIndexOf%(playeraid), cx%, cy%
      END IF
      ExCmdSpawn% = True

    CASE "r", "random"
      WorldAddRandom hbid%, VAL(tokens$(3))
      ExCmdSpawn% = True

  END SELECT

END FUNCTION

FUNCTION ExMap% (schema%, propname$)
 
  DIM fixed$
  DIM n%

  '
  ' Maps a property name to a property index for the specified schema
  '
 
  IF LEFT$(propname$, 1) = "." THEN
    fixed$ = RIGHT$(propname$, LEN(propname$) - 1)
  ELSE
    fixed$ = propname$
  END IF

  FOR n% = ObIndex.Schema TO ObIndex.MaxIndex
    IF fixed$ = ObProperty$(0, n%) THEN
      ExMap% = n%
      EXIT FUNCTION
    END IF
  NEXT

  FOR n% = ObIndex.Parent + 1 TO 15
    IF fixed$ = ObProperty$(schema%, n%) THEN
      ExMap% = n%
      EXIT FUNCTION
    END IF
  NEXT

  ExMap% = -1

END FUNCTION

FUNCTION ExParse% (text$, tokens$(), comment%)
 
  CONST StateNone = 0
  CONST StateToken = 1
  CONST StateComment = 2

  DIM char   AS STRING * 1
  DIM count  AS INTEGER
  DIM index  AS INTEGER
  DIM lower  AS INTEGER
  DIM offset AS INTEGER
  DIM quote  AS STRING
  DIM state  AS INTEGER

  '
  ' Calculate how to convert a count (1,2,3...) to an index element.
  '
  offset = LBOUND(tokens$) - 1

  FOR index = 1 TO LEN(text$)

    char = MID$(text$, index, 1)

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
          tokens$(count + offset) = ""

        ELSEIF char = CHR$(34) THEN
          '
          ' Start quoted token (include quote in token)
          '
          count = count + 1
          quote = char
          tokens$(count + offset) = char
          state = StateToken
      
        ELSEIF char = ";" THEN
          '
          ' Start comment
          '
          comment% = index
          state = StateComment
          EXIT FOR

        ELSEIF char <> " " THEN
          '
          ' Start non-quoted token
          '
          count = count + 1
          quote = ""
          tokens$(count + offset) = char
          state = StateToken
        END IF

      CASE StateToken:
       
        IF char = " " THEN
          '
          ' A space is allowed in a quote, otherwise the token is done.
          '
          IF LEN(quote) = 0 THEN
            state = 0
          ELSE
            '
            ' The token is part of a quote, the space is valid.
            '
            tokens$(count + offset) = tokens$(count + offset) + char
          END IF
       
        ELSEIF char = quote THEN
          '
          ' This is the end of the quoted token
          '
          tokens$(count + offset) = tokens$(count + offset) + char
          state = 0
       
        ELSE
          '
          ' If this token started as a number, ensure it is still a number.
          '
          tokens$(count + offset) = tokens$(count + offset) + char
        END IF

    END SELECT

  NEXT

  ExParse% = count

END FUNCTION

SUB ExPop
 
  IF ex.depth = 0 THEN
   
    DbFail "ExPop", "Stack empty"
 
  ELSE
   
    ex.stack(ex.depth) = 0
    ex.depth = ex.depth - 1
 
  END IF

END SUB

SUB ExPush (obid%)
 
  DbPositive obid%, "ExPush", "obid%"
  ex.depth = ex.depth + 1
  ex.stack(ex.depth) = obid%

END SUB

FUNCTION ExRun% (rawcmd$)

  DIM tokens$(0 TO 5)
  DIM comment%

  DIM cmd$
  IF LEFT$(rawcmd$, 1) = "@" THEN
    cmd$ = RIGHT$(rawcmd$, LEN(rawcmd$) - 1)
  ELSE
    cmd$ = rawcmd$
    ShPrint cmd$
  END IF

  '
  ' Parse the command into tokens
  '
  DIM count%: count% = ExParse%(cmd$, tokens$(), comment%)
 
  IF count% = 0 THEN
    '
    ' Empty commands are OK
    '
    ExRun% = True

  ELSEIF ExTryProperty%(tokens$(0), tokens$(1)) THEN
    '
    ' .Property
    ' .Property #Name
    ' .Property =Bind
    ' .Property "String"
    ' .Property ObSchema | CtKind
    ' .Property number
    '
    ExRun% = True

  ELSEIF ExTryKind%(tokens$(0)) THEN

    ExRun% = True

  ELSEIF ExTryEndKind%(tokens$(0)) THEN

    ExRun% = True

  ELSEIF ExTryCmd%(tokens$(), count%) THEN

    ExRun% = True

  END IF

END FUNCTION

SUB ExRunFile (filename$)

  DIM handle%: handle% = FREEFILE
  OPEN filename$ FOR INPUT ACCESS READ AS #handle%

  DO WHILE NOT EOF(handle%)
   
    DIM text$
    LINE INPUT #handle%, text$
   
    DIM result%: result% = ExRun%(text$)
    IF NOT result% THEN
      DbFail "ExRunFile", text$
    END IF

    '
    ' Pause when a key is pressed
    '
    DIM keypress$: keypress$ = INKEY$
    IF LEN(keypress$) THEN
      ShPause
    END IF

  LOOP

  CLOSE #handle%

END SUB

FUNCTION ExRunResource% (rsid%)

  DbPositive rsid%, "ExRunResource%", "rsid%"

  DIM cmd$: cmd$ = RsGet$(rsid%)

  IF LEN(cmd$) > 0 THEN
    ExRunResource% = ExRun%(cmd$)
  END IF

END FUNCTION

FUNCTION ExTop%
  IF ex.depth > 0 THEN ExTop% = ex.stack(ex.depth)
END FUNCTION

FUNCTION ExTryCmd% (tokens$(), count%)

  ExTryCmd% = True

  DIM n%
  FOR n% = LBOUND(tokens$) TO UBOUND(tokens$)
    tokens$(n%) = ExUnquote$(tokens$(n%))
  NEXT

  SELECT CASE LCASE$(tokens$(0))

    CASE "atlas"
      UI.SetPage UIPage.Atlas

    CASE "chain"
      CHAIN tokens$(1)

    CASE "cls"
      ShClear

    CASE "endgame"
      END

    CASE "listen"
      ExTryCmd% = ExCmdListen%(tokens$(), count%)

    CASE "mail"
      ExTryCmd% = ExCmdMail%(tokens$(), count%)

    CASE "newgame"
      ExRunFile "WORLD.CFG"

    CASE "pause"
      ShPause

    CASE "print"
      ShPrint tokens$(1)

    CASE "printfile"
      ShFile tokens$(1)

    CASE "replot"
      ExTryCmd% = ExCmdReplot%(tokens$(), count%)

    CASE "run"
      ExRunFile tokens$(1)

    CASE "shell"
      UI.SetPage UIPage.Terminal

    CASE "spawn"
      ExTryCmd% = ExCmdSpawn%(tokens$(), count%)

    CASE "stop"
      STOP

    CASE "wnrun"
      WnRunName tokens$(1)

    CASE ELSE
      ExTryCmd% = False

  END SELECT

END FUNCTION

FUNCTION ExTryEndKind% (tag$)

  DIM obid%: obid% = ExTop%
  IF obid% = 0 THEN
    EXIT FUNCTION
  END IF

  DIM schema%: schema% = ObGet%(0, obid%, ObIndex.Schema)
  IF schema% = 0 THEN
    EXIT FUNCTION
  END IF

  DIM kind%: kind% = ObGet%(schema%, obid%, ObIndex.Kind)

  DIM name$: name$ = ObKind$(schema%, kind%)
  IF LEN(name$) = 0 THEN
    name$ = ObKind$(schema%, 0)
  END IF
  IF LEN(name$) = 0 THEN
    EXIT FUNCTION
  END IF

  IF tag$ = "End" + name$ THEN
    ExPop
    ExTryEndKind% = True
  END IF

END FUNCTION

FUNCTION ExTryKind% (name$)
 
  IF LEN(name$) = 0 THEN
    EXIT FUNCTION
  END IF

  DIM schema%
  DIM kind%
  DIM n$

  FOR i% = 0 TO ObSchemas
    FOR j% = 0 TO UBOUND(ObKind$, 2)
     
      n$ = ObKind$(i%, j%)
      IF LEN(n$) = 0 THEN
        EXIT FOR
      ELSEIF n$ = name$ THEN
        schema% = i%
        kind% = j%
        EXIT FOR
      END IF

    NEXT
 
    IF schema% <> 0 THEN
      EXIT FOR
    END IF

  NEXT

  IF schema% = 0 THEN
    EXIT FUNCTION
  END IF

  DIM obid%: obid% = ObCreate%(schema%, ExTop%)
  IF obid% = 0 THEN
    DbPositive obid%, "ExTryControl%", "obid%"
    EXIT FUNCTION
  ELSE
    ObSet schema%, obid%, ObIndex.Kind, kind%
  END IF

  ExPush obid%
  ExTryKind% = True

END FUNCTION

FUNCTION ExTryProperty% (name$, value$)

  IF LEFT$(name$, 1) <> "." THEN
    '
    ' Syntax requires a . prefix
    '
    EXIT FUNCTION
  END IF

  '
  ' Get the top object in scope
  '
  DIM obid%: obid% = ExTop%
  IF obid% = 0 THEN
    DbPositive obid%, "ExTryProperty%", "obid%"
    EXIT FUNCTION
  END IF

  '
  ' Get the schema of the current object in scope
  '
  DIM schema%: schema% = ObGet%(0, obid%, ObIndex.Schema)
  IF schema% = 0 THEN
    DbPositive schema%, "ExTryProperty%", "schema%"
    EXIT FUNCTION
  END IF

  '
  ' Map the name to a property ID of the schema
  '
  DIM obix%: obix% = ExMap%(schema%, name$)
  IF obix% < 0 THEN
    DbFail "ExTryProperty%", "Invalid property: " + name$
    EXIT FUNCTION
  END IF

  IF LEN(value$) = 0 THEN
    '
    ' .Property (change scope to object value)
    '
    DIM value%: value% = ObGet%(schema%, obid%, obix%)
    IF value% > 0 THEN
      ExPush value%
      ExTryProperty% = True
    END IF
    EXIT FUNCTION
  END IF

  '
  ' A prefix character indicates references and bindings
  '
  DIM prefix$: prefix$ = LEFT$(value$, 1)
  SELECT CASE prefix$
 
    CASE CHR$(34)
      '
      ' "Quoted"
      '
      DIM inner$: inner$ = ExUnquote$(value$)
      DIM rsid%: rsid% = RsCreate%(inner$)
      ObSet schema%, obid%, obix%, rsid%
      ExTryProperty% = True

    CASE "#"
      '
      ' #ObjectName
      '
      DIM find%: find% = ObFind%(0, RIGHT$(value$, LEN(value$) - 1))
      IF find% > 0 THEN
        ObSet schema%, obid%, obix%, find%
        ExTryProperty% = True
      END IF

    CASE "="
      '
      ' =expression
      '
      ObSetEx schema%, obid%, obix%, RsCreate%(value$), ObBinding.Expression
      ExTryProperty% = True

    CASE "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", "&"
      '
      ' Numeric value including &Hxx
      '
      ObSet schema%, obid%, obix%, VAL(value$)
      ExTryProperty% = True

    CASE "^"
      '
      ' Inherit from parent
      '
      ObSetFlags schema%, obid%, obix%, ObBinding.Inherit
      ExTryProperty% = True

    CASE ELSE
      '
      ' If no prefix or quote, this should be a schema or control.
      '
      IF ExTryKind%(value$) THEN
        '
        ' Created object is on top of stack
        '
        ObSet schema%, obid%, obix%, ExTop%
        ExTryProperty% = True
     
      ELSE
        DbFail "ExTryProperty%", "Invalid value: " + value$
      END IF

  END SELECT

END FUNCTION

FUNCTION ExUnquote$ (text$)

  DIM q AS STRING * 1
  DIM u AS STRING

  q = LEFT$(text$, 1)

  IF q = CHR$(34) OR q = "'" THEN
    
    u = RIGHT$(text$, LEN(text$) - 1)
    IF RIGHT$(u, 1) = q THEN
      u = LEFT$(u, LEN(u) - 1)
    END IF

    ExUnquote$ = u

  ELSE

    ExUnquote$ = text$

  END IF

END FUNCTION

SUB GameMoveOffset (offsetx%, offsety%)
 
  DIM cx      AS INTEGER
  DIM cy      AS INTEGER
  DIM idx     AS INTEGER

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
  cx = cx + offsetx%
  cy = cy + offsety%
  IF cx < LBOUND(atlasGrid, 1) THEN cx = UBOUND(atlasGrid, 1)
  IF cx > UBOUND(atlasGrid, 1) THEN cx = LBOUND(atlasGrid, 1)
  IF cy < LBOUND(atlasGrid, 2) THEN cy = UBOUND(atlasGrid, 2)
  IF cy > UBOUND(atlasGrid, 2) THEN cy = LBOUND(atlasGrid, 2)

  '
  ' See what is at the next location
  '
  DIM lcid%: lcid% = AtlasGetValue(cx, cy, 0)
  IF lcid% = 0 THEN
    AtlasMoveItem idx, cx, cy
    EvInc "AtlasMoves"
  ELSE

    DIM hbid%
    LET hbid% = ObGet%(ObSchema.Location, lcid%, LcIndex.Habitat)
      
    '
    ' Run the window handling this habitat
    '
    DIM wnid%
    LET wnid% = ObGet%(ObSchema.Habitat, hbid%, HbIndex.Window)

    IF wnid% > 0 THEN
     
      AtlasDrawSelect cx, cy, 1
      ObSet ObSchema.Window, wnid%, WnIndex.Param, hbid%
      WnRun wnid%
      AtlasDrawUnselect cx, cy

    END IF

  END IF

END SUB

FUNCTION GetKey$
  '
  ' Waits for a key to be pressed.
  '
  DIM k$
  DIM trap%

  DO
   
    k$ = INKEY$
  
    '
    ' Press the ~ key and a second key to set a breakpoint trap.
    '
    IF k$ = "~" AND NOT trap% THEN
      '
      ' Set the trap
      '
      trap% = True

      '
      ' Pretend ~ wasn't pressed
      '
      k$ = ""
    END IF

  LOOP UNTIL LEN(k$)

  IF trap% OR k$ = CHR$(3) THEN
    STOP
    '
    ' If you aren't sure what just happened, press F5 to resume.
    ' Otherwise start pressing F8 to step through the code.
    '
  END IF

  GetKey$ = k$

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

  DbAssert energy >= 0, "NebulaLabelRsid", "energy must be 0 or greater"
  DbAssert energy <= 3, "NebulaLabelRsid", "energy must be 3 or less"

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

FUNCTION ObCreate% (schema%, parent%)
  '
  ' Creates an object of the specified schema and parent.
  '
  DbAssert ob.count <= UBOUND(obj, 1), "ObCreate%", "Out of object space"

  ob.count = ob.count + 1
 
  ObSet 0, ob.count, ObIndex.Schema, schema%
  ObSet 0, ob.count, ObIndex.Parent, parent%
  ObSet 0, ob.count, ObIndex.Dirty, True

  ObCreate% = ob.count

END FUNCTION

SUB ObDelete (obid%)

  '
  ' vwPerParent and children
  '
  FOR n% = 1 TO vwPerParent(obid%, 0)
    ObDelete vwPerParent(obid%, n%)
    vwPerParent(obid%, n%) = 0
  NEXT
  vwPerParent(obid%, 0) = 0

  '
  ' vwPerSchema
  '
  DIM schema%: schema% = ObGet%(0, obid%, ObIndex.Schema)
  DIM count%: count% = vwPerSchema(schema%, count%)
  DIM found%

  FOR n% = 1 TO count%
    IF found% THEN
      vwPerSchema(schema%, n% - 1) = vwPerSchema(schema%, n%)
      vwPerSchema(schema%, n%) = 0
    ELSEIF vwPerSchema(schema%, n%) = obid% THEN
      vwPerSchema(schema%, n%) = 0
      found% = True
    END IF
  NEXT

  '
  ' Delete object
  '
  FOR n% = LBOUND(obj, 2) TO UBOUND(obj, 2)
    obj(obid%, n%).flags = 0
    obj(obid%, n%).value = 0
  NEXT

END SUB

SUB ObDirtyDown (obid%)

  ObSet 0, obid%, ObIndex.Dirty, True

  DIM n%
  FOR n% = 1 TO vwPerParent(obid%, 0)
    ObDirtyDown vwPerParent(obid%, n%)
  NEXT

END SUB

FUNCTION ObFind% (schema%, name$)
 
  DIM obid%
  FOR obid% = 1 TO UBOUND(obj, 1)
   
    IF schema% = 0 OR obj(obid%, ObIndex.Schema).value = schema% THEN
     
      DIM rsid%: rsid% = ObGet%(0, obid%, ObIndex.Name)
     
      IF rsid% = 0 THEN
        '
        ' The property on this object does not have a resource.
        ' Treat it as an empty string "".
        '
        IF LEN(name$) = 0 THEN
          ObFind% = obid%
          EXIT FUNCTION
        END IF

      ELSE

        IF name$ = RsGet$(rsid%) THEN
          ObFind% = obid%
          EXIT FUNCTION
        END IF

      END IF

    END IF

  NEXT

END FUNCTION

FUNCTION ObGet% (schema%, obid%, obix%)

  DIM flags%
  LET flags% = obj(obid%, obix%).flags

  DIM value%
  LET value% = obj(obid%, obix%).value

  IF schema% > 0 THEN
    IF schema% <> obj(obid%, ObIndex.Schema).value THEN
      DbFail "ObGet%", "schema mismatch"
    END IF
  END IF

  SELECT CASE flags%

    CASE 0:
      ObGet% = value%

    CASE ObBinding.Expression
      ObGet% = ObResolve%(obid%, RsGet$(value%))

    CASE ObBinding.Inherit
      '
      ' This property inherits from the parent.
      '
      DIM parent%: parent% = ObGet%(schema%, obid%, ObIndex.Parent)
      IF parent% > 0 THEN
        '
        ' But inherit only if the parent has same schema
        '
        DIM thisSchema%
        IF schema% = 0 THEN
          thisSchema% = ObGet%(0, obid%, ObIndex.Schema)
        ELSE
          thisSchema% = schema%
        END IF

        IF thisSchema% = ObGet%(0, parent%, ObIndex.Schema) THEN
          value% = ObGet%(schema%, parent%, obix%)
        END IF
     
      END IF
     
      ObGet% = value%

    CASE ELSE
      DbFail "ObGet%", "Unsupported binding"

  END SELECT

END FUNCTION

SUB ObInc (schema%, obid%, obix%)
  ObSet schema%, obid%, obix%, ObGet%(0, obid%, obix%) + 1
END SUB

FUNCTION ObIs% (schema%, obid%)
  ObIs% = obj(obid%, ObIndex.Schema).value = schema%
END FUNCTION

FUNCTION ObResolve% (obid%, expr$)

  CONST SyntaxError = -1
 
  CONST ExpectEqualSign = 0
  CONST ExpectStart = 1
  CONST ExpectNameStart = 2
  CONST ExpectNameBuild = 3
  CONST ExpectPropStart = 4
  CONST ExpectPropBuild = 5

  DIM build$
  DIM char$(1)
  DIM n%
  DIM schema%
  DIM state%
  DIM targetobid%
  DIM targetobix%

  FOR n% = 1 TO LEN(expr$)
 
    char$ = MID$(expr$, n%, 1)
   
    SELECT CASE state%
   
      CASE ExpectEqualSign
        GOSUB ParseEqualSign
      
      CASE ExpectStart
        GOSUB ParseStart

      CASE ExpectNameStart
        GOSUB ParseNameStart
                                 
      CASE ExpectNameBuild
        GOSUB ParseNameBuild

      CASE ExpectPropStart
        GOSUB ParsePropStart

      CASE ExpectPropBuild
        GOSUB ParsePropBuild

      CASE ELSE
        state% = SyntaxError

    END SELECT

    IF state% = SyntaxError THEN
      EXIT FOR
    END IF

  NEXT

  '
  ' Process pending state
  '
  SELECT CASE state%
   
    CASE ExpectNameBuild
      '
      ' Name was being built
      '
      targetobid% = ObFind%(0, build$)
      IF targetobid% = 0 THEN
        state% = SyntaxError
      END IF
     
    CASE ExpectPropBuild
      '
      ' Prop name in progress
      '
      schema% = ObGet%(0, targetobid%, ObIndex.Schema)
      targetobix% = ExMap%(schema%, build$)
      IF targetobix% = 0 THEN
        state% = SyntaxError
      END IF

  END SELECT

  IF state% = SyntaxError THEN
    DIM msg$: msg$ = "Invalid @" + STR$(n%) + " (" + char$ + ") " + expr$
    DbFail "ObResolve%", msg$
  END IF

  IF targetobix% = 0 THEN
    ObResolve% = targetobid%
  ELSE
    ObResolve% = ObGet%(0, targetobid%, targetobix%)
  END IF
  
  EXIT FUNCTION

ParseEqualSign:
 
  SELECT CASE char$
   
    CASE "="
      state% = ExpectStart

    CASE " "
    CASE ELSE
      state% = SyntaxError

  END SELECT
  RETURN

ParseStart:
 
  SELECT CASE char$
 
    CASE "#"
      state% = ExpectNameStart

    CASE "."
      targetobid% = obid%
      state% = ExpectPropStart

    CASE " "
    CASE ELSE
      state% = SyntaxError
     
  END SELECT
  RETURN

ParseNameStart:

  SELECT CASE char$
    CASE "A" TO "Z", "a" TO "z"
      state% = ExpectNameBuild
      build$ = char$

    CASE " "
    CASE ELSE
      state% = ExpectNameBuild
  END SELECT
  RETURN

ParseNameBuild:
 
  SELECT CASE char$
   
    CASE "A" TO "Z", "a" TO "z"
      build$ = build$ + char$

    CASE "."
      targetobid% = ObFind%(0, build$)
      IF targetobid% = 0 THEN
        state% = SyntaxError
      ELSE
        state% = ExpectPropStart
      END IF

    CASE ELSE
      state% = SyntaxError

  END SELECT
  RETURN

ParsePropStart:
 
  SELECT CASE char$
   
    CASE "A" TO "Z", "a" TO "z"
      state% = ExpectPropBuild
      build$ = char$

    CASE " "
    CASE ELSE
      state% = SyntaxError

  END SELECT
  RETURN

ParsePropBuild:
  SELECT CASE char$
    CASE "A" TO "Z", "a" TO "z"
      build$ = build$ + char$
    CASE "."
      schema% = ObGet%(0, targetobid%, ObIndex.Schema)
      targetobix% = ExMap%(schema%, build$)
      IF targetobix% = 0 THEN
        state% = SyntaxError
      ELSE
        targetobid% = ObGet%(0, targetobid%, targetobix%)
        IF targetobid% = 0 THEN
          ObResolve% = 0
          EXIT FUNCTION
        END IF
        targetobix% = 0
        state% = ExpectPropStart
      END IF
    CASE ELSE
      state% = SyntaxError
  END SELECT
  RETURN

END FUNCTION

SUB ObSet (schema%, obid%, obix%, value%)
  DIM flags%: flags% = obj(obid%, obix%).flags
  ObSetEx schema%, obid%, obix%, value%, flags%
END SUB

SUB ObSetEx (schema%, obid%, obix%, value%, flags%)
 
  IF schema% > 0 THEN
    '
    ' Make sure the object has the specified schema
    '
    IF schema% <> obj(obid%, ObIndex.Schema).value THEN
      DbFail "ObSet", "schema mismatch"
    END IF
  END IF

  IF obj(obid%, obix%).value = value% THEN
    IF obj(obid%, obix%).flags = flags% THEN
      '
      ' No change
      '
      EXIT SUB
    END IF
  END IF

  obj(obid%, obix%).value = value%
  obj(obid%, obix%).flags = flags%

  '
  ' Determine whether this object was dirtied.
  '
  DIM dirtied%
  IF obix% = ObIndex.Dirty THEN
    '
    ' Setting Dirty=False does not cause Dirty to become True.
    '
    dirtied% = value% <> 0
  ELSE
    dirtied% = True
  END IF

  IF dirtied% THEN

    '
    ' Mark this and parents as dirty
    '
    DIM obx%: obx% = obid%
    DO
   
      '
      ' If already dirty, no need to recurse further.
      '
      DIM already%: already% = obj(obx%, ObIndex.Dirty).value
      IF already% THEN
        EXIT DO
      END IF

      obj(obx%, ObIndex.Dirty).value = -1
   
      '
      ' Get the parent object
      '
      obx% = obj(obx%, ObIndex.Parent).value
      IF obx% = 0 THEN
        EXIT DO
      END IF
   
    LOOP
   
  END IF

  SELECT CASE obix%
   
    CASE ObIndex.Parent
      '
      ' vwPerParent
      '
      IF value% > 0 THEN
        vwPerParent(value%, 0) = vwPerParent(value%, 0) + 1
        vwPerParent(value%, vwPerParent(value%, 0)) = obid%
      END IF

    CASE ObIndex.Schema
      '
      ' vwPerSchema
      '
      IF value% > 0 THEN
        vwPerSchema(value%, 0) = vwPerSchema(value%, 0) + 1
        vwPerSchema(value%, vwPerSchema(value%, 0)) = obid%
      END IF

  END SELECT

  IF db.debug THEN
    DbSet schema%, obid%, obix%, value%
  END IF

END SUB

SUB ObSetFlags (schema%, obid%, obix%, flags%)
  DIM value%: value% = obj(obid%, obix%).value
  ObSetEx schema%, obid%, obix%, value%, flags%
END SUB

FUNCTION RsCreate% (value$)

  IF resources = UBOUND(resource) THEN
   
    DbFail "RsCreate%", "Out of resource space"
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
  db.debug = False

  '
  ' Setup atlas
  '
  atlaspage = VdAlloc%
  AtlasDraw

  '
  ' Load menus and windows
  '
  ExRunFile "EMPIRE.CFG"
 
  ShPrint "String Space:" + STR$(FRE(""))
  ShPrint "Unused Stack Space:" + STR$(FRE(-2))
  ShPrint "Array Space:" + STR$(FRE(-1))

  '
  ' Show starting window #1
  '
  ' WnRun ObFind%(ObSchema.Window, "Start")
  TIMER ON

END SUB

SUB ShBeginDraw
  VdPushActive 0
END SUB

SUB ShClear
  ShBeginDraw
  CLS
  ShEndDraw
END SUB

SUB ShEndDraw
  VdPop
END SUB

SUB ShFile (filename$)
  ShBeginDraw
  LOCATE 24, 1
  DrawFile filename$
  PRINT
  ShEndDraw
END SUB

SUB ShPause
  
  ShPrint "@X08<@X0Fpaused@X08>@X07"
  DIM d$: d$ = GetKey$

END SUB

SUB ShPrint (text$)

  DIM x AS INTEGER
  DIM y AS INTEGER

  ShBeginDraw
  x = POS(0)
  y = CSRLIN
 
  LOCATE 24, 1
  DrawText text$
  PRINT
  LOCATE y, x
  ShEndDraw

END SUB

SUB ShSerialize (obid%, indent%)

  DbPositive obid%, "ShSerialize", "obid%"
 
  DIM schema%: schema% = ObGet%(0, obid%, ObIndex.Schema)
  DIM title%: title% = ObGet%(schema%, obid%, ObIndex.Name)
 
  IF title% > 0 THEN
    ShPrint SPACE$(indent%) + "#" + RsGet$(title%)
  ELSE
    ShPrint SPACE$(indent%) + "#" + STR$(obid%)
  END IF

  DIM i%
  FOR i% = 0 TO UBOUND(obj, 2)
   
    DIM p$
    LET p$ = ObProperty$(schema%, i%)
    IF LEN(p$) = 0 THEN
      p$ = ObProperty$(0, i%)
    END IF
    IF LEN(p$) = 0 THEN
      EXIT FOR
    END IF

    DIM value%: value% = ObGet%(0, obid%, i%)
    ShPrint SPACE$(indent% + 2) + "." + p$ + " " + STR$(value%)

  NEXT

  ShPrint ";" + STR$(vwPerParent(obid%, 0)) + " children"
  ShPause

  IF vwPerParent(obid%, 0) > 0 THEN
    DIM j%
    FOR j% = 1 TO vwPerParent(obid%, 0)
      ShSerialize vwPerParent(obid%, j%), indent% + 2
    NEXT
  END IF

END SUB

SUB UI.Run

  UI.SetPage UIPage.Atlas

  DIM wnid%
  LET wnid% = ObFind%(ObSchema.Window, "Menu")

  DO
    
    DbAssert uiCurrentPage <> UIPage.None, "UI.Run", "UI page must be set"

    SELECT CASE uiCurrentPage
    
      CASE UIPage.Atlas
        UI.RunAtlas

      CASE UIPage.Terminal
        UI.RunTerminal

    END SELECT

    WnRun wnid%

  LOOP

END SUB

SUB UI.RunAtlas
 
  DbAssert uiCurrentPage = UIPage.Atlas, "UI.RunAtlas", "Wrong UI page"

  DIM pressed AS STRING

  DO

    pressed = GetKey$

    SELECT CASE pressed
     
      CASE KeyEscape$
        EXIT SUB

      CASE KeyDown$
        GameMoveOffset 0, 1

      CASE KeyLeft$
        GameMoveOffset -1, 0

      CASE KeyRight$
        GameMoveOffset 1, 0

      CASE KeyUp$
        GameMoveOffset 0, -1

    END SELECT

  LOOP
 
END SUB

SUB UI.RunTerminal

  DbAssert uiCurrentPage = UIPage.Terminal, "UI.RunTerminal", "Wrong UI page"

  DIM keypress$: keypress$ = GetKey$

END SUB

SUB UI.SetPage (page AS INTEGER)
 
  DbAssert page <> UIPage.None, "UI.SetPage", "page cannot be 0"

  SELECT CASE page
   
    CASE UIPage.Atlas
      VdScreen atlaspage, atlaspage

    CASE UIPage.Terminal
      VdScreen 0, 0

    CASE ELSE
      VdScreen 0, 0

  END SELECT

  uiCurrentPage = page
 
END SUB

FUNCTION VdActive%
  VdActive = (vd.stack(vd.stacked) AND &HF0) / 16
END FUNCTION

FUNCTION VdAlloc%
 
  DIM bit  AS INTEGER
  DIM mask AS INTEGER

  FOR bit = 1 TO 7
   
    mask = 2 ^ bit

    IF (vd.allocated AND mask) = 0 THEN
      vd.allocated = vd.allocated OR mask
      VdAlloc% = bit
      EXIT FUNCTION
    END IF

  NEXT

  VdAlloc% = 0

END FUNCTION

SUB VdFree (pagenum%)
  DIM mask%: mask% = NOT (2 ^ pagenum%)
  vd.allocated = vd.allocated AND mask%
END SUB

SUB VdPop

  IF vd.stacked = 0 THEN
   
    DbFail "VdPop", "No page stack to pop"

  ELSE

    vd.stacked = vd.stacked - 1
   
    DIM p%: p% = vd.stack(vd.stacked)

    SCREEN , , (p% AND &HF0) / 16, (p% AND &HF)

  END IF

END SUB

SUB VdPush (active%, visual%)
 
  DIM newpages%
  LET newpages% = (visual% AND &HF) + (active% * 16)

  vd.stacked = vd.stacked + 1
  vd.stack(vd.stacked) = newpages%

  SCREEN , , active%, visual%

END SUB

SUB VdPushActive (active%)
  VdPush active%, vd.stack(vd.stacked) AND &HF
  EXIT SUB
  '
  ' Use this to temporarily write to a specific video
  ' page and then call VdPop to restore the current
  ' active and display pages.
  '
  DIM newpages%
  LET newpages% = (vd.stack(vd.stacked) AND &HF) + (active% * 16)
 
  vd.stacked = vd.stacked + 1
  vd.stack(vd.stacked) = newpages%

  SCREEN , , active%, vd.stack(vd.stacked) AND &HF

END SUB

SUB VdPushVisual (visual%)
  DIM active%: active% = vd.stack(vd.stacked) AND &HF0
  VdPush active% / 16, visual%
END SUB

SUB VdScreen (activepage%, visualpage%)
  vd.stack(vd.stacked) = (activepage% * 16) + visualpage%
  SCREEN , , activepage%, visualpage%
END SUB

FUNCTION VdVisual%
  VdVisual% = vd.stack(vd.stacked) AND &HF
END FUNCTION

SUB VdWatch (pagenum%)
  VdPushVisual pagenum%
  DIM k$: k$ = GetKey$
  VdPop
END SUB

SUB WnClose (wnid%)
 
  DbPositive wnid%, "WnClose", "wnid%"

  IF wn.count = 0 THEN
  
    DbFail "WnClose", "No windows"

  ELSEIF wn.wnid(wn.count) <> wnid% THEN

    DbFail "WnClose", "Not supported; specify top window only"

  ELSE

    '
    ' Change active and visual display to the backpage
    '
    VdScreen wn.backpage(wn.count), wn.backpage(wn.count)
    VdFree wn.workpage(wn.count)
    wn.count = wn.count - 1

  END IF

END SUB

'
' Executes a command in the context of a window.
'
FUNCTION WnCmd% (wnid%, cmd$)

  DbPositive wnid%, "WnEx%", "wnid%"

  '
  ' HACK: expand command parameter ***
  '
  DIM index%: index% = INSTR(cmd$, "[Window][Param]")
  IF index% > 0 THEN
    DIM param%: param% = ObGet%(ObSchema.Window, wnid%, WnIndex.Param)
    MID$(cmd$, index%) = STR$(param%)
  END IF

  WnEx% = ExRun%(cmd$)

END FUNCTION

SUB WnDirty (wnid%)
  DIM root%: root% = ObGet%(ObSchema.Window, wnid%, WnIndex.Root)
  IF root% > 0 THEN ObDirtyDown root%
END SUB

SUB WnDraw (wnid%)
  DIM root%: root% = ObGet%(ObSchema.Window, wnid%, WnIndex.Root)
  IF root% > 0 THEN CtDraw root%
END SUB

FUNCTION WnFocus% (wnid%)
  
  DbPositive wnid%, "WnFocus%", "wnid%"

  DIM root%: root% = ObGet%(ObSchema.Window, wnid%, WnIndex.Root)
  IF root% > 0 THEN
    root% = CtFocus%(root%)
  END IF

END FUNCTION

FUNCTION WnKey% (wnid%, keypress$)
 
  DbPositive wnid%, "WnKey%", "wnid%"

  DIM action%
  DIM focused%
  DIM root%

  '
  ' Get the focused control and dispatch the key
  '
  root% = ObGet%(ObSchema.Window, wnid%, WnIndex.Root)
  IF root% > 0 THEN
    action% = CtKey%(root%, keypress$)
  END IF

  IF action% = CtAction.None THEN
   
    SELECT CASE keypress$
   
      CASE KeyEscape$
        action% = CtAction.Cancel

      CASE "!"
        '
        ' Show the console page and wait for a key to be pressed
        '
        VdWatch 0
        action% = CtAction.Handled
   
      CASE "?"
        '
        ' Show debug information about the window
        '
        VdPushVisual 0
        ShSerialize wnid%, 0
        VdPop
        action% = CtAction.Handled

    END SELECT
  END IF

  WnKey% = action%

END FUNCTION

SUB WnOpen (wnid%)
  '
  ' Displays the window and gives it focus
  '
  DbPositive wnid%, "WnOpen", "wnid%"

  '
  ' Allocate working video page for drawing
  '
  DIM workpage%: workpage% = VdAlloc%
  DbPositive workpage%, "WnOpen", "workpage%"

  DIM backpage%
  IF wn.count = 0 THEN
    backpage% = VdActive%
  ELSE
    backpage% = wn.workpage(wn.count)
  END IF

  wn.count = wn.count + 1
  wn.wnid(wn.count) = wnid%
  wn.backpage(wn.count) = backpage%
  wn.workpage(wn.count) = workpage%

  '
  ' Mark the controls dirty
  '
  WnDirty wnid%

  '
  ' Draw the window
  '
  VdScreen workpage%, backpage%
  PCOPY backpage%, workpage%
  WnDraw wnid%
  
  '
  ' Set the working page as the visual page
  '
  VdScreen workpage%, workpage%

END SUB

SUB WnRun (wnid%)

  DbPositive wnid%, "WnRun", "wnid%"
 
  '
  ' Run the window UI and get the action to execute
  '
  DIM result%: result% = WnUI%(wnid%)
  DIM action%: action% = result% AND &HF
  DIM param%: param% = result% \ 16

  SELECT CASE action%

    CASE CtAction.Cancel
      '
      ' The window was canceled
      '

    CASE CtAction.Command
      result% = WnCmd%(wnid%, RsGet$(param%))

  END SELECT

END SUB

SUB WnRunName (name$)
  DIM wnid%: wnid% = ObFind%(ObSchema.Window, name$)
  WnRun wnid%
END SUB

FUNCTION WnUI% (wnid%)

  DbPositive wnid%, "WnUI%", "wnid%"
  WnOpen wnid%

  DO

    '
    ' Set focus, draw updates, wait for the next key.
    '
    DIM focused%: focused% = WnFocus%(wnid%)
    WnDraw wnid%
    DIM keypress$: keypress$ = GetKey$
 
    '
    ' Dispatch the key
    '
    DIM result%: result% = WnKey%(wnid%, keypress$)
   
    '
    ' The action is lower 4 bits, the param is upper bits
    '
    DIM action%: action% = result% AND &HF
    DIM param%: param% = result% \ 16

    SELECT CASE action%
     
      CASE CtAction.None, CtAction.Handled
        '
        ' Remain open
        '
     
      CASE CtAction.Cancel, CtAction.Command
        '
        ' Close and let caller handle
        '
        WnClose wnid%
        WnUI% = result%
        EXIT FUNCTION

      CASE CtAction.Window
        '
        ' Stack another window
        '
        result% = WnUI%(param%)
        SELECT CASE result% AND &HF
          CASE CtAction.Cancel
            '
            ' Stacked window was canceled, but keep this one alive.
            '

          CASE CtAction.Command
            '
            ' Command selected, pass back to caller
            '
            WnUI% = result%
            WnClose wnid%
            EXIT FUNCTION
            
        END SELECT

      CASE ELSE
        DbFail "WnUI%", "Unsupported action:" + STR$(action%)

    END SELECT

  LOOP
  
END FUNCTION

FUNCTION WorldAdd% (hbid%, cx%, cy%)

  DIM lcid%: lcid% = ObCreate%(ObSchema.Location, 0)

  ObSet ObSchema.Location, lcid%, LcIndex.Habitat, hbid%
  ObSet ObSchema.Location, lcid%, LcIndex.Energy, 3

  AtlasAddItem cx%, cy%, lcid%, ObGet%(ObSchema.Habitat, hbid%, ObIndex.Label)
  WorldAdd% = lcid%

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

SUB WorldHarvest (lcid%)

  DbPositive lcid%, "WorldHarvest", "lcid%"

  DIM energy%: energy% = ObGet%(ObSchema.Location, lcid%, LcIndex.Energy)

  IF energy% > 0 THEN
    energy% = energy% - 1
    ObSet ObSchema.Location, lcid%, LcIndex.Energy, energy%
  END IF

  IF energy% = 0 THEN
    WorldRemove lcid%
    EvInc "NebulaDepleted"
  END IF

END SUB

SUB WorldRemove (lcid%)

  DbPositive lcid%, "WorldRemove", "lcid%"

  ObDelete lcid%
  AtlasRemoveValue lcid%

END SUB

SUB WorldSetLabel (aid%, labelrsid%)
  '
  ' Updates the label for the specified area
  '
  DbPositive aid%, "WorldSetLabel", "aid%"
  DbPositive labelrsid%, "WorldSetLabel", "labelrsid%"

  DIM idx AS INTEGER
 
  idx = AtlasIndexOf(aid%)
  IF idx > 0 THEN
    AtlasSetLabel idx, labelrsid%
  END IF

END SUB

