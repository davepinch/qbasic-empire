
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
  '
  ' A place that can be visited.
  '
  allocated AS INTEGER
  habitat   AS INTEGER
  level     AS INTEGER
END TYPE

TYPE AtlasItemType
  '
  ' An item shown on the atlas.
  '
  allocated AS INTEGER
  cx        AS INTEGER
  cy        AS INTEGER
  value     AS INTEGER
  label     AS STRING * 20 ' 4 cells + color codes
END TYPE

TYPE FieldType
  '
  ' Information about an input field in a window.
  '
  kind     AS INTEGER
  childWid AS INTEGER
  cid      AS INTEGER
  posX     AS INTEGER
  posY     AS INTEGER
  sizeX    AS INTEGER
END TYPE

TYPE HabitatType
  '
  ' A type of habitat such as an electromagnetic storm.
  '
  backdrop AS STRING * 12
  UI       AS STRING * 3
  label    AS STRING * 20
  title    AS STRING * 20
END TYPE

TYPE MessageType
  '
  ' An inbox message.
  '
  opened  AS INTEGER
  subject AS STRING * 20
END TYPE

TYPE WinStackItem
  wid      AS INTEGER
  backpage AS INTEGER
  workpage AS INTEGER
END TYPE

TYPE WinResultType
  action   AS INTEGER
  canceled AS INTEGER
  cid      AS INTEGER
  selected AS INTEGER
END TYPE

TYPE WindowType
  '
  ' A window on the screen for showing information or collecting input.
  '
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
DECLARE SUB AtlasAddBand (fromValue AS INTEGER, toValue AS INTEGER)
DECLARE SUB AtlasAddCluster (fromValue AS INTEGER, toValue AS INTEGER)
DECLARE SUB AtlasAddItem (cx AS INTEGER, cy AS INTEGER, value AS INTEGER, label AS STRING)
DECLARE SUB AtlasAddRandom (fromValue AS INTEGER, toValue AS INTEGER)
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
DECLARE SUB AtlasSetLabel (idx AS INTEGER, label AS STRING)
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
' in the Execute(cid) function to learn how to implement a command.
'
DECLARE SUB Execute (cid AS INTEGER)
DECLARE SUB ExecuteOptionAlerts ()

'
' Inbox* subroutines
'
DECLARE SUB InboxAdd (subject AS STRING)
DECLARE SUB InboxInit ()

'
' Nebula* subroutines
'
DECLARE SUB NebulaCreate (seq() AS INTEGER)
DECLARE SUB NebulaCreateSeq (seq() AS INTEGER, y!)
DECLARE SUB NebulaDraw (seq() AS INTEGER)
DECLARE SUB NebulaHarvest (seq() AS INTEGER)
DECLARE FUNCTION NebulaLabel$ (level AS INTEGER)

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
DECLARE FUNCTION WinClipText% (wid%, fid%, outposx%, outposy%, outsizeX%, outtext$)
DECLARE FUNCTION WinCreate% ()
DECLARE FUNCTION WinCreateEx% (style%, posX%, posY%, sizeX%, sizeY%)
DECLARE FUNCTION WinCreateField% (wid%)
DECLARE FUNCTION WinDefine% (wid%, f AS FieldType, text$)
DECLARE FUNCTION WinGetOuterSizeX% (wid%)
DECLARE FUNCTION WinGetOuterSizeY% (wid%)
DECLARE FUNCTION WinGetWid% (wname$)
DECLARE FUNCTION WinIsSelectable% (wid%, fid%)
DECLARE FUNCTION WinLoadBoolean% (wid%)
DECLARE FUNCTION WinLoadButton% (wid%)
DECLARE FUNCTION WinLoadField% (wid%, endtag$)
DECLARE FUNCTION WinLoadLabel% (wid%)
DECLARE FUNCTION WinLoadPopup% (wid%)
DECLARE FUNCTION WinMapKey% (wid%, pressed AS STRING)
DECLARE FUNCTION WinParseCommand% (text$)

DECLARE SUB WinAutoSize (wid%)
DECLARE SUB WinClose (wid%)
DECLARE SUB WinDraw (wid%)
DECLARE SUB WinDrawBox (wid%)
DECLARE SUB WinDrawBox0 (wid%, offsetX%, offsetY%, fcolor%, bcolor%)
DECLARE SUB WinDrawBox1 (wid%)
DECLARE SUB WinDrawBox2 (wid%)
DECLARE SUB WinDrawField (wid%, fid%)
DECLARE SUB WinDrawOutline (wid%, sx%, sy%)
DECLARE SUB WinDrawOutline0 (wid%, sx%, sy%)
DECLARE SUB WinDrawOutline1 (wid%, sx%, sy%)
DECLARE SUB WinDrawOutline2 (wid%, sx%, sy%)
DECLARE SUB WinDrawSeparator (wid%, fid%)
DECLARE SUB WinDrawSeparator0 (wid%, fid%, offsetX%, offsetY%, fc%, bc%)
DECLARE SUB WinDrawSeparator1 (wid%, fid%)
DECLARE SUB WinDrawSeparator2 (wid%, fid%)
DECLARE SUB WinDrawText (wid%, fid%)
DECLARE SUB WinDrawText0 (wid%, fid%, offsetX%, offsetY%, fc%, bc%, sfc%, sbc%)
DECLARE SUB WinDrawText1 (wid%, fid%)
DECLARE SUB WinDrawText2 (wid%, fid%)
DECLARE SUB WinKey (wid%, fid%, keypress$)
DECLARE SUB WinKeyBoolean (wid%, fid%, keypress$)
DECLARE SUB WinKeyInteger (wid%, fid%, keypress$)
DECLARE SUB WinLoad ()
DECLARE SUB WinLoadWindow ()
DECLARE SUB WinOpen (wid%)
DECLARE SUB WinRefreshField (wid%, fid%)
DECLARE SUB WinRefreshWindow (wid%)
DECLARE SUB WinRun (wid%, result AS WinResultType)
DECLARE SUB WinRunMove (wid%, bumpX%, bumpY%)
DECLARE SUB WinRunName (idname$)
DECLARE SUB WinSelectNext (wid%)
DECLARE SUB WinSelect (wid%, fid%)
DECLARE SUB WinSelectPrevious (wid%)
DECLARE SUB WinSelectFirst (wid%)
DECLARE SUB WinSelectLast (wid%)
DECLARE SUB WinSetText (wid%, fid%, text$)

'
' World* subroutines
'
DECLARE SUB WorldAddCluster (hid AS INTEGER, size AS INTEGER)
DECLARE SUB WorldAddNebula (size AS INTEGER)
DECLARE SUB WorldInit (areas AS INTEGER)
DECLARE SUB WorldRemove (aid AS INTEGER)
DECLARE SUB WorldSetLabel (aid AS INTEGER, label AS STRING)
DECLARE SUB WorldLoadHabitats ()
DECLARE FUNCTION WorldAdd% (hid AS INTEGER, cx AS INTEGER, cy AS INTEGER)
DECLARE FUNCTION WorldNextId% ()

'
' Declarations
'
DECLARE SUB Assert (truth AS INTEGER, where AS STRING, what AS STRING)
DECLARE SUB AssertFail (where AS STRING, what AS STRING)
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

'
' Command.* constants
'
' These constants assign a unique ID to each type of menu command.
' To add a command, assign a unique value here and then update
' the WinParseCommand function to translate a string to the value.
'
CONST Command.About = 1
CONST Command.EndGame = 2
CONST Command.FilterNone = 3
CONST Command.FilterSelf = 4
CONST Command.NewGame = 5
CONST Command.OptionAlerts = 6
CONST Command.ReplotBand = 7
CONST Command.ReplotCluster = 8
CONST Command.ReplotManual = 9
CONST Command.ReplotRandom = 10
CONST Command.ViewAtlas = 11
CONST Command.ViewInbox = 12
CONST Command.ViewTable = 13

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
CONST FieldKind.Popup = 5
CONST FieldKind.Separator = 6

'
' Habitat UIs
'
CONST HabitatUI.Nebula = "NEB"

CONST InboxStyle.InnerSizeX = 61
CONST InboxStyle.InnerSizeY = 19
CONST InboxStyle.OuterPosX = 10
CONST InboxStyle.OuterPosY = 3
  '
  ' These constants define the position and size of the inbox.
  ' The InnerSize constants define the size of the inner content
  ' section of the inbox (excluding the border). The OuterPos
  ' constants define the position of the inbox in relation to its
  ' upper-left border character.

'
' Maximum UI elements
'
CONST MaxMenus = 5
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
CONST WinAction.MoveDown = 7
CONST WinAction.MoveLeft = 8
CONST WinAction.MoveRight = 9
CONST WinAction.MoveUp = 10
CONST WinAction.OpenPopup = 11
CONST WinAction.SelectFirst = 12
CONST WinAction.SelectLast = 13
CONST WinAction.SelectNext = 14
CONST WinAction.SelectPrevious = 15

'
' WinStyle.* constants
'
' These constants define the colors and other styles of windows.
'
CONST WinStyle0.Backcolor = 7
CONST WinStyle0.Forecolor = 0
CONST WinStyle0.SelectedBackcolor = 1
CONST WinStyle0.SelectedForecolor = 15
CONST WinStyle1.Backcolor = 1
CONST WinStyle1.Forecolor = 7
CONST WinStyle1.SelectedBackcolor = 7
CONST WinStyle1.SelectedForecolor = 0
CONST WinStyle2.Backcolor = 0
CONST WinStyle2.Forecolor = 5
CONST WinStyle2.SelectedBackcolor = 5
CONST WinStyle2.SelectedForecolor = 0

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
' Global messaging variables
'
DIM SHARED msg(1 TO 10) AS MessageType
DIM SHARED msgs AS INTEGER
DIM SHARED mwid AS INTEGER

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
DIM SHARED win(1 TO MaxWindows) AS WindowType
DIM SHARED wins AS INTEGER
DIM SHARED win0 AS INTEGER
DIM SHARED txt(1 TO MaxWindows, 1 TO MaxFields) AS STRING

DIM SHARED winstack(1 TO 3) AS WinStackItem
DIM SHARED winstacked       AS INTEGER

'
' Main
'
SetupGame
UI.Run

'
' Window Definitions
'

DATA "Windows"
 
DATA "Window"
DATA   "Name", "Start"
DATA   "PosY", 10
DATA   "Label"
DATA     "Text", " Select an option to get started... "
DATA   "EndLabel"
DATA   "Button"
DATA     "Command", "NewGame"
DATA     "PosX", 14
DATA     "PosY", 3
DATA     "Text", " New Game "
DATA   "EndButton"
DATA   "Button"
DATA     "Command", "EndGame"
DATA     "PosX", 14
DATA     "PosY", 4
DATA     "Text", " End Game "
DATA   "EndButton"
DATA "EndWindow"

DATA "Window"
DATA   "Name", "FileMenu"
DATA   "ArrowExit", 3
DATA   "PosX", 1
DATA   "PosY", 2
DATA   "Button"
DATA     "Command", "About"
DATA     "PosX", 1
DATA     "PosY", 1
DATA     "SizeX", -1
DATA     "Text", " About... "
DATA   "EndButton"
DATA   "Button"
DATA     "Command", "EndGame"
DATA     "PosX", 1
DATA     "PosY", 2
DATA     "Text", " Exit Game "
DATA   "EndButton"
DATA "EndWindow"

DATA "Window"
DATA   "Name", "ViewMenu"
DATA   "ArrowExit", 3
DATA   "PosX", 7
DATA   "PosY", 2
DATA   "SizeX", 20
DATA   "Button"
DATA     "Command", "ViewAtlas"
DATA     "PosY", 1
DATA     "SizeX", -1
DATA     "Text", " Show atlas "
DATA   "EndButton"
DATA   "Button"
DATA     "Command", "ViewTable"
DATA     "PosY", 2
DATA     "SizeX", -1
DATA     "Text", " Show table"
DATA   "EndButton"
DATA   "Button"
DATA     "Command", "ViewInbox"
DATA     "PosY", 3
DATA     "SizeX", -1
DATA     "Text", " Show inbox"
DATA   "EndButton"
DATA   "-"
DATA   "Button"
DATA     "Command", "ReplotBand"
DATA     "SizeX", -1
DATA     "Text", " Replot banded"
DATA   "EndButton"
DATA   "Button"
DATA     "Command", "ReplotCluster"
DATA     "SizeX", -1
DATA     "Text", " Replot clustered"
DATA   "EndButton"
DATA   "Button"
DATA     "Command", "ReplotManual"
DATA     "SizeX", -1
DATA     "Text", " Replot manually"
DATA   "EndButton"
DATA   "Button"
DATA     "Command", "ReplotRandom"
DATA     "SizeX", -1
DATA     "Text", " Replot randomly"
DATA   "EndButton"
DATA "EndWindow"

DATA "Window"
DATA   "Name", "OptionsMenu"
DATA   "ArrowExit", 3
DATA   "PosX", 13
DATA   "PosY", 2
DATA   "SizeX", 20
DATA   "Button"
DATA     "Command", "OptionAlerts"
DATA     "PosX", 1
DATA     "PosY", 1
DATA     "SizeX", -1
DATA     "Text", " Alerts"
DATA   "EndButton"
DATA "EndWindow"

DATA "Window"
DATA   "Name", "DialogAlerts"
DATA   "PosX", 19
DATA   "PosY", 9
DATA   "Label"
DATA     "Text", "Do you wish to sound alerts?"
DATA   "EndLabel"
DATA   "Boolean"
DATA     "SizeX", -1
DATA     "Text", "Yes"
DATA   "EndBoolean"
DATA "EndWindow"

DATA "Window"
DATA   "Name", "About"
DATA   "PosX", 1
DATA   "PosY", 5
DATA   "Style", 2
DATA   "Label"
DATA     "PosY", 1
DATA     "Text", "   The Galactic Empire   "
DATA   "EndLabel"
DATA   "Label"
DATA     "PosY", 2
DATA     "Text", " (C) 1992 David J Pinch "
DATA   "EndLabel"
DATA "EndWindow"

DATA "Window"
DATA   "Name", "Menu"
DATA   "PosX", 1
DATA   "PosY", 1
DATA   "SizeX", 80
DATA   "SizeY", 1
DATA   "Style", 0
DATA   "Popup"
DATA     "Child", "FileMenu"
DATA     "PosX", 1
DATA     "PosY", 1
DATA     "Text", " FILE "
DATA   "EndPopup"
DATA   "Popup"
DATA     "Child", "ViewMenu"
DATA     "PosX", 7
DATA     "PosY", 1
DATA     "Text", " VIEW "
DATA   "EndPopup"
DATA   "Popup"
DATA     "Child", "OptionsMenu"
DATA     "PosX", 13
DATA     "PosY", 1
DATA     "Text", " OPTIONS "
DATA   "EndPopup"
DATA   "Button"
DATA     "PosX", 76
DATA     "PosY", 1
DATA     "Text", " END "
DATA     "Command", "EndGame"
DATA   "EndButton"
DATA "EndWindow"

DATA "EndWindows"

DATA "Habitats"
DATA   "Habitat"
DATA     "Backdrop", "HAB-CAVE.PCB"
DATA     "Label", "@X01°±²±"
DATA     "Title", "Cave"
DATA   "End"
DATA   "Habitat"
DATA     "Backdrop", "HAB-DNEB.PCB"
DATA     "Label", "@X08Ä@X0FÄ@X07Ä@X08Ä"
DATA     "Title", "Dark Nebula"
DATA     "UI", "NEB"
DATA   "End"
DATA   "Habitat"
DATA     "Backdrop", "HAB-STRM.PCB"
DATA     "Label", "@X04°±²±"
DATA     "Title", "Electromagenic"
DATA   "End"
DATA   "Habitat"
DATA     "Backdrop", "HAB-FRGE.PCB"
DATA     "Label", "@X04ùÄ@X4EÅ@X04Ä"
DATA     "Title", "Forge"
DATA   "End"
DATA   "Habitat"
DATA     "Backdrop", "HAB-TOWR.PCB"
DATA     "Label", "@X07ÛÜ@X08ÜÛ"
DATA     "Title", "Tower"
DATA   "End"
DATA   "Habitat"
DATA     "Backdrop", "HAB-RED.PCB"
DATA     "Label", "@X06ùù@X0Eí@X06ù"
DATA     "Title", "Red Ocean"
DATA   "End"
DATA "End"

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

SUB AtlasAddBand (fromValue AS INTEGER, toValue AS INTEGER)
  '
  ' Adds a range of values organized into a horizontal orbital band.
  '

  DIM cx    AS INTEGER
  DIM cy    AS INTEGER
  DIM value AS INTEGER

  '
  ' Get random coordinates to seed the band
  '
  AtlasNextRandom cx, cy

  FOR value = fromValue TO toValue

    '
    ' Find the next open cell in the same band
    '
    AtlasNextBanded cx, cy
   
    '
    ' Save the item
    '
    AtlasAddItem cx, cy, value, STR$(value)

  NEXT

END SUB

SUB AtlasAddCluster (fromValue AS INTEGER, toValue AS INTEGER)
  '
  ' Adds a range of values organized into a cluster.
  '

  DIM cx    AS INTEGER
  DIM cy    AS INTEGER
  DIM value AS INTEGER

  '
  ' Get random coordinates to seed the band
  '
  AtlasNextRandom cx, cy

  FOR value = fromValue TO toValue

    '
    ' Find an open slot near the current one
    '
    AtlasNextClustered cx, cy
  
    '
    ' Save the cell
    '
    AtlasAddItem cx, cy, value, STR$(value)

  NEXT

END SUB

SUB AtlasAddItem (cx AS INTEGER, cy AS INTEGER, value AS INTEGER, label AS STRING)
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
  atlasItem(idx).value = value
  atlasItem(idx).label = label

  '
  ' Reference the item in the grid
  '
  atlasGrid(cx, cy) = idx
 
  IF atlasActive THEN
    AtlasDrawCell cx, cy
  END IF

END SUB

SUB AtlasAddRandom (fromValue AS INTEGER, toValue AS INTEGER)
  '
  ' Adds a range of values placed randomly around the atlas.
  '
 
  DIM cx    AS INTEGER
  DIM cy    AS INTEGER
  DIM value AS INTEGER

  FOR value = fromValue TO toValue

    '
    ' Find an open slot
    '
    AtlasNextRandom cx, cy
   
    '
    ' Save the item
    '
    AtlasAddItem cx, cy, value, STR$(value)

  NEXT

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
    DrawText RTRIM$(atlasItem(idx).label)
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

SUB AtlasSetLabel (idx AS INTEGER, label AS STRING)
  '
  ' Sets the label for the specified item
  '
 
  atlasItem(idx).label = label
  IF atlasActive THEN
    AtlasDrawItem idx
  END IF

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
  DrawText habitat(area(aid).habitat).title

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
      UI.SetPage UIPage.About

    CASE Command.EndGame
      END

    CASE Command.FilterNone
      UI.SetFilter UIFilter.None, True

    CASE Command.FilterSelf
      UI.SetFilter UIFilter.Self, True

    CASE Command.OptionAlerts
      ExecuteOptionAlerts
       
    CASE Command.ReplotBand
      AtlasPlotBanded

    CASE Command.ReplotCluster
      AtlasPlotClustered

    CASE Command.ReplotManual
      AtlasPlotManual

    CASE Command.ReplotRandom
      AtlasPlotRandom

    CASE Command.ViewAtlas
      UI.SetPage UIPage.Atlas
     
    CASE Command.ViewInbox
      UI.SetPage UIPage.Inbox

    CASE Command.ViewTable
      UI.SetPage UIPage.Table

    CASE ELSE
      StatusDebug "Execute(" + LTRIM$(STR$(cid)) + "): unrecognized cid"

  END SELECT

END SUB

SUB ExecuteOptionAlerts

  WinRunName "DialogAlerts"

  'FOR x = 1 TO 3
  '  FOR Y = 300 TO 60 STEP -10
  '    SOUND Y, .2
  '  NEXT
  'NEXT

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

SUB InboxAdd (subject AS STRING)
  '
  ' Adds a new message to the inbox
  '
 
  msgs = msgs + 1
  msg(msgs).opened = False
  msg(msgs).subject = subject

  '
  ' Make a button for the message
  '
  DIM f AS FieldType

  f.kind = FieldKind.Button
  f.posX = 1
  f.posY = msgs
  f.sizeX = win(mwid).sizeX

  DIM fid AS INTEGER
  LET fid = WinDefine(mwid, f, subject)

END SUB

SUB InboxInit
  '
  ' Initializes the mailbox to its default state
  '
 
  CONST InnerSizeX = 61
  CONST InnerSizeY = 19
  CONST OuterPosX = 10
  CONST OuterPosY = 3

  msgs = 0

  IF msgw = 0 THEN
    mwid = WinCreateEx%(2, OuterPosX, OuterPosY, InnerSizeX, InnerSizeY)
  END IF

  InboxAdd "Welcome 1"
  InboxAdd "Welcome 2"

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

SUB SetupGame

  SCREEN 0, 0, 0, 0: WIDTH 80: COLOR 7, 0: KEY OFF: CLS : RANDOMIZE TIMER
 
  '
  ' Load menus and windows
  '
  StatusUpdate "Please wait..."
  WinLoad
  WorldLoadHabitats

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
  DIM result AS WinResultType
  WinRun WinGetWid("Start"), result
 
  IF result.cid = Command.NewGame THEN
    InboxInit
    WorldInit 15
  ELSE
    END
  END IF

END SUB

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

  Assert aid > 0, "UI.ActionNebula", "aid cannot be 0"

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
    WorldSetLabel aid, NebulaLabel$(level)

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
  IF RTRIM$(habitat(hid).backdrop) <> "" THEN
    UI.RedrawFile habitat(hid).backdrop
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
        IF wresult.cid > 0 THEN
          Execute wresult.cid
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

  WinRun mwid, result
 
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
          WorldSetLabel aid, NebulaLabel$(area(aid).level)
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

SUB WinAutoSize (wid%)
  '
  ' Expands the size of the window based on field sizes and positions.
  '
 
  Assert wid% > 0, "WinAutoSize", "wid cannot be 0"

  DIM fid%
  DIM fieldx2%
  DIM fieldy2%
  DIM highestx%
  DIM highesty%

  highestx% = win(wid%).sizeX
  highesty% = win(wid%).sizeY

  FOR fid% = 1 TO win(wid%).fields
 
    '
    ' Get the field size (default to text size if autosizing).
    ' Size 0 means use text size; size -1 means use window size.
    '
    fieldx2% = fld(wid%, fid%).sizeX
    IF fieldx2% = 0 OR fieldx2% = -1 THEN
      fieldx2% = LEN(txt(wid%, fid%))
    END IF

    '
    ' Get the coordinates of the lower-right corner
    '
    fieldx2% = fld(wid%, fid%).posX + fieldx2% - 1
    fieldy2% = fld(wid%, fid%).posY

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

FUNCTION WinClipText% (wid%, fid%, outposx%, outposy%, outsizeX%, outtext$)
  '
  ' Returns True if any portion of the field text is visible. If True,
  ' the starting position, clipped size, and clipped text is returned.
  ' The clipped text is filled with spaces to match the clipped size.
  '

  Assert wid% > 0, "WinClipText", "wid cannot be 0"

  '
  ' Get the size of the field
  '
  outsizeX% = fld(wid%, fid%).sizeX
  IF outsizeX% = -1 THEN
    '
    ' A size of -1 means the window size
    '
    outsizeX% = win(wid%).sizeX

  ELSE

    IF outsizeX% = 0 THEN
      '
      ' A size of 0 means to use the size of the text
      '
      outsizeX% = LEN(txt(wid%, fid%))
    END IF

    IF outsizeX% > win(wid%).sizeX THEN
      '
      ' The field cannot be larger than the window
      '
      outsideX% = win(wid%).sizeX
    END IF

  END IF

  IF outsizeX% < 1 THEN
    '
    ' No visible size
    '
    WinClipText% = False
    EXIT FUNCTION
  END IF

  '
  ' Get the position of the field.
  '
  outposx% = fld(wid%, fid%).posX
  outposy% = fld(wid%, fid%).posY
  IF outposx% = 0 THEN
    '
    ' Default to the first column
    '
    outposx% = 1
  END IF

  IF outposx% > win(wid%).sizeX THEN
    '
    ' No portion visible
    '
    WinClipText% = False
    EXIT FUNCTION
 
  ELSEIF outposx% > 0 THEN
    '
    ' The field starts within the window but might be clipped.
    ' The value outposX + outsizeX is the index of the first
    ' character after the field.
    '
    DIM last%
    LET last% = outposx% + outsizeX% - 1

    IF last% > win(wid%).sizeX THEN
      outsizeX% = last% - win(wid%).sizeX
    END IF

    '
    ' Get the text value and pad/clip
    '
    outtext$ = txt(wid%, fid%)
    IF LEN(outtext$) < outsizeX% THEN
      '
      ' The text value is shorter than the field size
      '
      outtext$ = outtext$ + STRING$(outsizeX% - LEN(outtext$), " ")

    ELSEIF LEN(outtext$) > outsizeX% THEN
      '
      ' The text value is longer than the field size
      '
      outtext$ = LEFT$(outtext$, outsizeX%)
   
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
  wins = wins + 1
  win(wins).style = 1
  WinCreate% = wins

END FUNCTION

FUNCTION WinCreateEx% (style%, posX%, posY%, sizeX%, sizeY%)
  '
  ' Allocates a new window
  '
 
  DIM wid AS INTEGER
  LET wid = WinCreate%
 
  win(wins).posX = posX%
  win(wins).posY = posY%
  win(wins).style = style%
  win(wins).sizeX = sizeX%
  win(wins).sizeY = sizeY%

  WinCreateEx% = wid

END FUNCTION

FUNCTION WinCreateField% (wid%)

  Assert wid% > 0, "WinCreateField", "wid cannot be 0"

  DIM fid%
  LET fid% = win(wid%).fields + 1

  win(wid%).fields = fid%
  WinCreateField% = fid%

END FUNCTION

FUNCTION WinDefine% (wid%, f AS FieldType, text$)

  Assert wid% > 0, "WinDefine", "wid cannot be 0"

  ' Defines a new field in a window and returns the field ID. Any code
  ' that creates new fields should ultimately call this function
  ' because it applies certain rules such as adjusting the window size.

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

SUB WinDraw (wid%)
  '
  ' Draws the window to the active video page.
  '

  Assert wid% > 0, "WinDraw", "wid cannot be 0"
  Assert win(wid%).posX > 0, "WinDraw", "posX must be > 0"
  Assert win(wid%).posY > 0, "WinDraw", "posY must be > 0"
  Assert win(wid%).sizeX > 0, "WinDraw", "sizeX must be > 0"
  Assert win(wid%).sizeY > 0, "WinDraw", "sizeY must be > 0"

  WinDrawBox wid%
 
  DIM fid AS INTEGER
  FOR fid = 1 TO win(wid%).fields
    WinDrawField wid%, fid
  NEXT

END SUB

SUB WinDrawBox (wid%)

  Assert wid% > 0, "WinDrawBox", "wid cannot be 0"

  SELECT CASE win(wid%).style
  
    CASE 0:
      WinDrawBox0 wid%, 0, 0, WinStyle0.Forecolor, WinStyle0.Backcolor

    CASE 1:
      WinDrawBox1 wid%

    CASE 2:
      WinDrawBox2 wid%

  END SELECT

END SUB

SUB WinDrawBox0 (wid%, offsetX%, offsetY%, fcolor%, bcolor%)
  '
  ' Draws the window box with no styling
  '
 
  COLOR fcolor%, bcolor%

  DIM row AS INTEGER
  FOR row = 1 TO win(wid%).sizeY
    LOCATE win(wid%).posY + row - 1 + offsetY%, win(wid%).posX + offsetX%
    PRINT STRING$(win(wid%).sizeX, " ");
  NEXT

END SUB

SUB WinDrawBox1 (wid%)
  '
  ' Draws the window in a basic (default) style
  '

  Assert wid% > 0, "WinDrawBox1", "wid cannot be 0"

  CONST lowerFlat = "Ä"   ' CHR$(196)
  CONST lowerLeft = "À"   ' CHR$(192)
  CONST lowerRight = "Ù"  ' CHR$(217)
  CONST sideLeft = "³"    ' CHR$(179)
  CONST sideRight = "³"   ' CHR$(179)
  CONST upperLeft = "Ú"   ' CHR$(218)
  CONST upperFlat = "Ä"   ' CHR$(196)
  CONST upperRight = "¿"  ' CHR$(191)

  DIM r AS INTEGER

  '
  ' Set the display color of the window
  '
  COLOR WinStyle1.Forecolor, WinStyle1.Backcolor

  '
  ' Draw the top border
  '
  LOCATE win(wid%).posY, win(wid%).posX
  PRINT upperLeft; STRING$(win(wid%).sizeX, upperFlat); upperRight;

  '
  ' Draw each row of the window
  '
  FOR r = 1 TO win(wid%).sizeY
    LOCATE win(wid%).posY + r, win(wid%).posX
    PRINT sideLeft;
    PRINT STRING$(win(wid%).sizeX, " ");
    PRINT sideRight;
  NEXT
   
  '
  ' Draw the lower border
  '
  LOCATE win(wid%).posY + win(wid%).sizeY + 1, win(wid%).posX
  PRINT lowerLeft; STRING$(win(wid%).sizeX, lowerFlat); lowerRight;

END SUB

SUB WinDrawBox2 (wid%)
  '
  ' Draws the window in a stylized way
  '

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
 
  LOCATE win(wid%).posY, win(wid%).posX
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
    LOCATE win(wid%).posY + row, win(wid%).posX
    COLOR fc(idx), bc(idx)
    PRINT ch(idx);

    '
    ' Inner space
    '
    COLOR fc(0), bc(0)
    PRINT STRING$(win(wid%).sizeX, " ");

    '
    ' Get the index of the right border
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
  ' Bottom border of the inbox
  '
  LOCATE win(wid%).posY + win(wid%).sizeY + 1, win(wid%).posX
  COLOR fc(0), bc(0)
  PRINT CHR$(192);
  PRINT STRING$(win(wid%).sizeX, 196);
  PRINT CHR$(223);

END SUB

SUB WinDrawField (wid%, fid%)

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

    CASE ELSE
      WinDrawText wid%, fid%

  END SELECT

END SUB

SUB WinDrawOutline (wid%, sx%, sy%)

  SELECT CASE win(wid%).style
   
    CASE 0:
      WinDrawOutline0 wid%, sx%, sy%

    CASE 1:
      WinDrawOutline1 wid%, sx%, sy%

    CASE 2:
      WinDrawOutline2 wid%, sx%, sy%
 
  END SELECT

END SUB

SUB WinDrawOutline0 (wid%, sx%, sy%)

  Assert wid% > 0, "WinDrawOutline0", "wid cannot be 0"
  Assert sx% > 0, "WinDrawOutline0", "sx must be positive"
  Assert sy% > 0, "WinDrawOutline0", "sy must be positive"

  IF win(wid%).sizeY = 1 THEN

    LOCATE sy%, sx%
    COLOR 7, 0: PRINT "[";
    COLOR 8, 0: PRINT STRING$(win(wid%).sizeX - 2, "-");
    COLOR 7, 0: PRINT "]";

  ELSE

    AssertFail "WinDrawOutline0", "Not implemented"

  END IF


END SUB

SUB WinDrawOutline1 (wid%, sx%, sy%)

  CONST OutlineBackcolor = 2
  CONST OutlineForecolor = 15

  '
  ' Set the color of the outline
  '
  COLOR OutlineForecolor, OutlineBackcolor

  '
  ' Draw upper-left corner
  '
  LOCATE sy%, sx%
  PRINT CHR$(218);
  PRINT CHR$(196);

  LOCATE sy% + 1, sx%
  PRINT CHR$(179);
 
  '
  ' Draw lower-left corner
  '
  LOCATE sy% + win(wid%).sizeY, sx%
  PRINT CHR$(179);
  LOCATE sy% + win(wid%).sizeY + 1, sx%
  PRINT CHR$(192); CHR$(196);

  '
  ' Draw upper-right corner
  '
  LOCATE sy%, sx% + win(wid%).sizeX
  PRINT CHR$(196); CHR$(191);
  LOCATE sy% + 1, sx% + win(wid%).sizeX + 1
  PRINT CHR$(179);

  '
  ' Draw lower-right corner
  '
  LOCATE sy% + win(wid%).sizeY, sx% + win(wid%).sizeX + 1
  PRINT CHR$(179);
  LOCATE sy% + win(wid%).sizeY + 1, sx% + win(wid%).sizeX
  PRINT CHR$(196); CHR$(217);

END SUB

SUB WinDrawOutline2 (wid%, sx%, sy%)

  WinDrawOutline1 wid%, sx%, sy%
  
END SUB

SUB WinDrawSeparator (wid%, fid%)

  SELECT CASE win(wid%).style
    CASE 0
      WinDrawSeparator0 wid%, fid%, 0, 0, WinStyle0.Forecolor, WinStyle0.Backcolor
    CASE 1
      WinDrawSeparator1 wid%, fid%
    CASE 2
      WinDrawSeparator2 wid%, fid%
  END SELECT

END SUB

SUB WinDrawSeparator0 (wid%, fid%, offsetX%, offsetY%, fc%, bc%)

  DIM sx AS INTEGER
  DIM sy AS INTEGER

  '
  ' Get screen coordinates
  '
  sx = win(wid%).posX + offsetX%
  sy = win(wid%).posY + fld(wid%, fid%).posY - 1 + offsetY%
  LOCATE sy, sx

  COLOR fc%, bc%
  PRINT STRING$(win(wid%).sizeX, 196);

END SUB

SUB WinDrawSeparator1 (wid%, fid%)
  '
  ' Draws the specified separator field.
  '

  DIM sx AS INTEGER
  DIM sy AS INTEGER

  '
  ' Move the cursor to the left border
  '
  sx = win(wid%).posX
  sy = win(wid%).posY + fld(wid%, fid%).posY
  LOCATE sy, sx

  COLOR WinStyle1.Forecolor, WinStyle1.Backcolor
  PRINT CHR$(195);
  PRINT STRING$(win(wid%).sizeX, 196);
  PRINT CHR$(180);

END SUB

SUB WinDrawSeparator2 (wid%, fid%)
  '
  ' Draws a separator using style #2
  '
  WinDrawSeparator0 wid%, fid%, 0, 0, 5, 0

END SUB

SUB WinDrawText (wid%, fid%)

  SELECT CASE win(wid%).style
  
    CASE 0:
      WinDrawText0 wid%, fid%, 0, 0, WinStyle0.Forecolor, WinStyle0.Backcolor, WinStyle0.SelectedForecolor, WinStyle0.SelectedBackcolor

    CASE 1:
      WinDrawText1 wid%, fid%

    CASE 2:
      WinDrawText2 wid%, fid%

  END SELECT

END SUB

SUB WinDrawText0 (wid%, fid%, offsetX%, offsetY%, fc%, bc%, sfc%, sbc%)
  '
  ' Draws the field text using the specified colors, moved by the offset
  '

  Assert wid% > 0, "WinDrawText0", "wid cannot be 0"
  Assert fid% > 0, "WinDrawText0", "fid cannot be 0"

  '
  ' Get the position of the field
  '
  DIM outposx%
  DIM outposy%
  DIM outsizeX%
  DIM outtext$

  IF NOT WinClipText(wid%, fid%, outposx%, outposy%, outsizeX%, outtext$) THEN
    '
    ' The text is not visible
    '
    EXIT SUB
  END IF

  '
  ' Calculate the screen coordinates of the field
  '
  sx = outposx% + win(wid%).posX - 1 + offsetX%
  sy = outposy% + win(wid%).posY - 1 + offsetY%
  LOCATE sy, sx
 
  IF win(wid%).selected = fid% THEN
    COLOR sfc%, sbc%
  ELSE
    COLOR fc%, bc%
  END IF

  PRINT outtext$;
   
END SUB

SUB WinDrawText1 (wid%, fid%)
  '
  ' Draws the text of the field using style #1
  '
  WinDrawText0 wid%, fid%, 1, 1, WinStyle1.Forecolor, WinStyle1.Backcolor, WinStyle1.SelectedForecolor, WinStyle1.SelectedBackcolor

END SUB

SUB WinDrawText2 (wid%, fid%)
  '
  ' Draws the text of the field using style #2
  '
  WinDrawText0 wid%, fid%, 1, 1, WinStyle2.Forecolor, WinStyle2.Backcolor, WinStyle2.SelectedForecolor, WinStyle2.SelectedBackcolor

END SUB

FUNCTION WinGetOuterSizeX% (wid%)
  '
  ' Returns the outer size of the window (including the border)
  '
  Assert wid% > 0, "WinGetOuterSizeX", "wid cannot be 0"

  SELECT CASE win(wid%).style
    CASE 0:
      WinGetOuterSizeX% = win(wid%).sizeX

    CASE 1, 2:
      WinGetOuterSizeX% = win(wid%).sizeX + 2

  END SELECT

END FUNCTION

FUNCTION WinGetOuterSizeY% (wid%)
  '
  ' Returns the outer size of the window (including the border)
  '
  Assert wid% > 0, "WinGetOuterSizeY", "wid cannot be 0"

  SELECT CASE win(wid%).style
    CASE 0:
      WinGetOuterSizeY% = win(wid%).sizeY

    CASE 1, 2:
      WinGetOuterSizeY% = win(wid%).sizeY + 2

  END SELECT

END FUNCTION

FUNCTION WinGetWid% (wname$)
  '
  ' Returns the ID of the window with the specified name.
  '
 
  DIM wid AS INTEGER

  FOR wid = 1 TO wins
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
 
  SELECT CASE keypress$

    CASE " "
      SELECT CASE txt(wid%, fid%)
        CASE "No"
          WinSetText wid%, fid%, "Yes"
        CASE "Yes"
          WinSetText wid%, fid%, "No"
      END SELECT

    CASE "n", "N"
      WinSetText wid%, fid%, "No"

    CASE "y", "Y"
      WinSetText wid%, fid%, "Yes"

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
 
  DIM block$

  READ block$
  Assert block$ = "Windows", "WinLoad", "Windows block expected"

  DO
    
    READ block$

    SELECT CASE block$
     
      CASE "Window"
        WinLoadWindow

      CASE "EndWindows"
        EXIT DO

      CASE ELSE
        AssertFail "WinLoad", "Expected " + block$

    END SELECT

  LOOP

END SUB

FUNCTION WinLoadBoolean% (wid%)
 
  Assert wid% > 0, "WinLoadBoolean", "wid cannot be 0"

  '
  ' Load the field values
  '
  DIM fid%
  LET fid% = WinLoadField(wid%, "EndBoolean")

  fld(wid%, fid%).kind = FieldKind.Boolean
  WinLoadBoolean% = fid%

END FUNCTION

FUNCTION WinLoadButton% (wid%)

  Assert wid% > 0, "WinLoadButton", "wid cannot be 0"

  '
  ' Load the field values
  '
  DIM fid%
  LET fid% = WinLoadField(wid%, "EndButton")

  fld(wid%, fid%).kind = FieldKind.Button
  WinLoadButton% = fid%

END FUNCTION

FUNCTION WinLoadField% (wid%, endtag$)

  Assert wid% > 0, "WinLoadField", "wid cannot be 0"

  DIM block$
  DIM fid%

  fid% = WinCreateField(wid%)

  DO

    READ block$

    SELECT CASE block$
   
      CASE endtag$
        EXIT DO

      CASE "Child"
        READ block$
        fld(wid%, fid%).childWid = WinGetWid(block$)

      CASE "Command"
        READ block$
        fld(wid%, fid%).cid = WinParseCommand(block$)

      CASE "PosX"
        READ fld(wid%, fid%).posX

      CASE "PosY"
        READ fld(wid%, fid%).posY

      CASE "SizeX"
        READ fld(wid%, fid%).sizeX

      CASE "Text"
        READ txt(wid%, fid%)

      CASE ELSE
        AssertFail "WinLoadField", "Unexpected token " + block$

    END SELECT

  LOOP
 
  IF fld(wid%, fid%).posX = 0 THEN
    '
    ' If no x position is specified, default to 1.
    '
    fld(wid%, fid%).posX = 1
  END IF

  IF fld(wid%, fid%).posY = 0 THEN
    '
    ' If no y position is specified, stack under the last field.
    '
    IF fid% = 1 THEN
      fld(wid%, fid%).posY = 1
    ELSE
      fld(wid%, fid%).posY = fld(wid%, fid% - 1).posY + 1
    END IF
  END IF

  IF fld(wid%, fid%).sizeX = 0 THEN
    '
    ' If no size is specified, use the size of the text
    '
    fld(wid%, fid%).sizeX = LEN(txt(wid%, fid%))

  END IF

  WinLoadField% = fid%

END FUNCTION

FUNCTION WinLoadLabel% (wid%)

  Assert wid% > 0, "WinLoadLabel", "wid cannot be 0"

  DIM fid%
 
  fid% = WinLoadField(wid%, "EndLabel")
  fld(wid%, fid%).kind = FieldKind.Label
  WinLoadLabel% = fid%

END FUNCTION

FUNCTION WinLoadPopup% (wid%)
 
  Assert wid% > 0, "WinLoadPopup", "wid cannot be 0"

  DIM fid%
 
  fid% = WinLoadField(wid%, "EndPopup")
  fld(wid%, fid%).kind = FieldKind.Popup
  WinLoadPopup = fid%

END FUNCTION

SUB WinLoadWindow

  DIM block$
  DIM fid%
  DIM wid%

  LET wid% = WinCreate%

  DO

    READ block$
  
    SELECT CASE block$
   
      CASE "ArrowExit"
        READ win(wid%).arrowexit

      CASE "Button"
        fid% = WinLoadButton(wid%)

      CASE "EndWindow"
        EXIT DO

      CASE "Label"
        fid% = WinLoadLabel(wid%)

      CASE "Name"
        READ win(wid%).wname

      CASE "Popup"
        fid% = WinLoadPopup(wid%)

      CASE "PosX"
        READ win(wid%).posX

      CASE "PosY"
        READ win(wid%).posY

      CASE "SizeX"
        READ win(wid%).sizeX

      CASE "SizeY"
        READ win(wid%).sizeY

      CASE "Style"
        READ win(wid%).style

      CASE "Boolean"
        fid% = WinLoadBoolean(wid%)
     
      CASE "-"
        fid% = WinCreateField%(wid%)
        fld(wid%, fid%).kind = FieldKind.Separator
        IF fid% = 1 THEN
          fld(wid%, fid%).posY = 1
        ELSE
          fld(wid%, fid%).posY = fld(wid%, fid% - 1).posY + 1
        END IF

      CASE ELSE
        AssertFail "WinLoadWindow", "Unexpected token " + block$

    END SELECT
  LOOP
  
  WinAutoSize wid%

  IF win(wid%).posX = 0 THEN
    '
    ' Center horizontally
    '
    win(wid%).posX = INT((80 - win(wid%).sizeX) / 2) + 1
  END IF

  IF win(wid%).posY = 0 THEN
    '
    ' Center vertically
    '
    win(wid%).posY = INT((25 - win(wid%).sizeY) / 2) + 1
  END IF

END SUB

FUNCTION WinMapKey% (wid%, pressed AS STRING)

  DIM childWid  AS INTEGER
  DIM cid       AS INTEGER
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
    childWid = fld(wid%, selected).childWid
    cid = fld(wid%, selected).cid
  END IF

  SELECT CASE pressed

    CASE CHR$(ASCII.Return)
      IF childWid > 0 THEN
        WinMapKey% = WinAction.OpenPopup
      ELSEIF cid > 0 THEN
        WinMapKey% = WinAction.Execute
      ELSE
        WinMapKey% = WinAction.Complete
      END IF

    CASE CHR$(ASCII.Escape)
      WinMapKey% = WinAction.Cancel

    CASE CHR$(ASCII.Tab)
      WinMapKey% = WinAction.SelectNext

    CASE CHR$(0) + CHR$(ScanCode.Down)
      IF childWid > 0 THEN
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

    CASE CHR$(Control.D)
      WinMapKey% = WinAction.MoveRight

    CASE CHR$(Control.E)
      WinMapKey% = WinAction.MoveUp

    CASE CHR$(Control.S)
      WinMapKey% = WinAction.MoveLeft

    CASE CHR$(Control.X)
      WinMapKey% = WinAction.MoveDown

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

FUNCTION WinParseCommand% (text$)
  '
  ' Translates a command name into a Command.* constant value.
  '
  DIM cid AS INTEGER

  SELECT CASE text$
   
    CASE "About"
      cid = Command.About

    CASE "EndGame":
      cid = Command.EndGame

    CASE "FilterNone":
      cid = Command.FilterNone

    CASE "FilterSelf":
      cid = Command.FilterSelf

    CASE "NewGame":
      cid = Command.NewGame

    CASE "OptionAlerts":
      cid = Command.OptionAlerts

    CASE "ReplotBand":
      cid = Command.ReplotBand

    CASE "ReplotCluster":
      cid = Command.ReplotCluster

    CASE "ReplotManual":
      cid = Command.ReplotManual

    CASE "ReplotRandom":
      cid = Command.ReplotRandom

    CASE "ViewAtlas":
      cid = Command.ViewAtlas

    CASE "ViewInbox":
      cid = Command.ViewInbox

    CASE "ViewTable":
      cid = Command.ViewTable

    CASE ELSE
      StatusDebug "WinParseCommand: " + text$ + " not recognized"
      cid = 0

  END SELECT

  WinParseCommand = cid

END FUNCTION

SUB WinRefreshField (wid%, fid%)

  IF winstacked > 0 THEN
    IF winstack(winstacked).wid = wid% THEN
      WinDrawField wid%, fid%
    END IF
  END IF

END SUB

SUB WinRefreshWindow (wid%)

  Assert wid% > 0, "WinRefreshWindow", "wid cannot be 0"
  Assert winstacked > 0, "WinRefreshWindow", "no windows"
  Assert winstack(winstacked).wid = wid%, "WinRefreshWindow", "top win only"

  SCREEN , , winstack(winstacked).workpage, winstack(winstacked).backpage
  PCOPY winstack(winstacked).backpage, winstack(winstacked).workpage
  WinDraw wid%
  SCREEN , , winstack(winstacked).workpage, winstack(winstacked).workpage

END SUB

SUB WinRun (wid%, result AS WinResultType)

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

      ELSEIF fld(wid%, win(wid%).selected).childWid = 0 THEN
       
        EXIT DO

      ELSE
     
        WinRun fld(wid%, win(wid%).selected).childWid, result
       
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
        result.cid = 0
        result.selected = win(wid%).selected
        WinClose wid%
        EXIT SUB

      CASE WinAction.Complete
        result.action = WinAction.Complete
        result.canceled = False
        result.cid = 0
        result.selected = win(wid%).selected
        WinClose wid%
        EXIT SUB

      CASE WinAction.Execute
        result.action = WinAction.Execute
        result.canceled = False
        result.selected = win(wid%).selected
        result.cid = fld(wid%, result.selected).cid
        WinClose wid%
        EXIT SUB

      CASE WinAction.ExitLeft
        result.action = WinAction.ExitLeft
        result.canceled = True
        result.cid = 0
        result.selected = win(wid%).selected
        WinClose wid%
        EXIT SUB

      CASE WinAction.ExitRight
        result.action = WinAction.ExitRight
        result.canceled = True
        result.cid = 0
        result.selected = win(wid%).selected
        WinClose wid%
        EXIT SUB

      CASE WinAction.Help
        IF win(wid%).helpWid <> 0 THEN
          WinRun win(wid%).helpWid, result
        END IF

      CASE WinAction.MoveDown
        WinRunMove wid%, 0, 1

      CASE WinAction.MoveLeft
        WinRunMove wid%, -1, 0

      CASE WinAction.MoveRight
        WinRunMove wid%, 1, 0

      CASE WinAction.MoveUp
        WinRunMove wid%, 0, -1

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

SUB WinRunMove (wid%, bumpX%, bumpY%)

  Assert wid% > 0, "WinMove", "wid cannot be 0"
  Assert winstacked > 0, "WinMove", "no windows"
  Assert winstack(winstacked).wid = wid%, "WinMove", "Top window only"

  DIM minX    AS INTEGER
  DIM minY    AS INTEGER
  DIM maxX    AS INTEGER
  DIM maxY    AS INTEGER
  DIM pressed AS STRING
  DIM toX     AS INTEGER
  DIM toY     AS INTEGER

  minX = 1
  minY = 1
  maxX = 80 - WinGetOuterSizeX(wid%) + 1
  maxY = 24 - WinGetOuterSizeY(wid%) + 1

  '
  ' Get the starting location of the window
  '
  toX = win(wid%).posX + bumpX%
  toY = win(wid%).posY + bumpY%

  IF toX < minX THEN toX = minX
  IF toX > maxX THEN toX = maxX
  IF toY < minY THEN toY = minY
  IF toY > maxY THEN toY = maxY

  DO
   
    '
    ' Reset the page
    '
    PCOPY winstack(winstacked).backpage, winstack(winstacked).workpage

    '
    ' Draw the outline and wait for a keyboard command
    '
    WinDrawOutline wid%, toX, toY
    pressed = GetKey$

    SELECT CASE pressed

      CASE CHR$(ASCII.Return)
        '
        ' Enter (final position selected)
        '
        win(wid%).posX = toX
        win(wid%).posY = toY

        '
        ' Restore the display page
        '
        WinRefreshWindow wid%
        EXIT SUB
     
      CASE CHR$(Control.D), CHR$(0) + CHR$(ScanCode.Right)
        '
        ' Move right
        '
        toX = toX + 1
        IF toX > maxX THEN toX = maxX

      CASE CHR$(Control.E), CHR$(0) + CHR$(ScanCode.Up)
        '
        ' Move Up
        '
        toY = toY - 1
        IF toY < minY THEN toY = minY
     
      CASE CHR$(Control.S), CHR$(0) + CHR$(ScanCode.Left)
        '
        ' Move Left
        '
        toX = toX - 1
        IF toX < minX THEN toX = minX

      CASE CHR$(Control.X), CHR$(0) + CHR$(ScanCode.Down)
        '
        ' Move Down
        '
        toY = toY + 1
        IF toY > maxY THEN toY = maxY

      CASE CHR$(ASCII.Escape)
        '
        ' Escape (restore original location)
        '
        toX = win(wid%).posX
        toY = win(wid%).posY
   
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

  Assert wid% > 0, "WinSelect", "wid cannot be 0"
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

  Assert wid% > 0, "WinSelectFirst", "wid cannot be 0"

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

  Assert wid% > 0, "WinSelectLast", "wid cannot be 0"

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

  Assert wid% > 0, "WinSelectNext", "wid cannot be 0"

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

  Assert wid% > 0, "WinSelectPrevious", "wid cannot be 0"

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

SUB WinSetText (wid%, fid%, text$)
  '
  ' Sets the text of the specified field.
  '

  Assert wid% > 0, "WinSetText", "wid cannot be 0"
  Assert fid% > 0, "WinSetText", "fid cannot be 0"

  txt(wid%, fid%) = text$
  WinRefreshField wid%, fid%

END SUB

SUB WinUpdateBegin (wid%)
  '
  ' Indicates a window is being updated
  '

  win0 = wid%


END SUB

FUNCTION WorldAdd% (hid AS INTEGER, cx AS INTEGER, cy AS INTEGER)

  DIM aid AS INTEGER

  '
  ' Allocate the area
  '
  LET aid = WorldNextId%
  area(aid).allocated = True
  area(aid).habitat = hid

  '
  ' Position on the atlas
  '
  AtlasAddItem cx, cy, aid, habitat(hid).label

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

SUB WorldLoadHabitats
  '
  ' Loads habitat information from DATA
  '
 
  DIM block AS STRING

  '
  ' Verify this is the start of a data block
  '
  READ block
  Assert block = "Habitats", "WorldLoadHabitats", "unexpected " + block

  DO
 
    '
    ' The next block can be "End" (end of data) or "Habitat" (new habitat)
    '
    READ block
    IF block = "End" THEN
      EXIT SUB
    END IF
   
    Assert block = "Habitat", "WorldLoadHabitats", "unexpected " + block
    habitats = habitats + 1
    
    DO
   
      READ block

      SELECT CASE block
       
        CASE "End"
          EXIT DO
       
        CASE "Backdrop"
          READ block
          habitat(habitats).backdrop = block

        CASE "Label"
          READ block
          habitat(habitats).label = block

        CASE "Title"
          READ block
          habitat(habitats).title = block

        CASE "UI"
          READ block
          habitat(habitats).UI = block

        CASE ELSE
          AssertFail "WorldLoadHabitats", "unexpected " + block

      END SELECT

    LOOP

  LOOP

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

  Assert aid > 0, "WorldRemove", "aid cannot be 0"

  IF area(aid).allocated THEN
    area(aid).allocated = False
    AtlasRemoveValue aid
  END IF

END SUB

SUB WorldSetLabel (aid AS INTEGER, label AS STRING)
  '
  ' Updates the label for the specified area
  '
  Assert aid > 0, "WorldSetLabel", "aid cannot be 0"

  DIM idx AS INTEGER
  LET idx = AtlasIndexOf(aid)
  IF idx > 0 THEN
    AtlasSetLabel idx, label
  END IF

END SUB

