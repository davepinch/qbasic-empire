
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
  kind  AS INTEGER
  cid   AS INTEGER
  posX  AS INTEGER
  posY  AS INTEGER
  sizeX AS INTEGER
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
  allocated AS INTEGER
  opened    AS INTEGER
  subject   AS STRING * 40
END TYPE

TYPE MenuType
  '
  ' A menu item on the top of the screen.
  '
  posX  AS INTEGER
  text  AS STRING * 10
  wid   AS INTEGER
END TYPE

TYPE WindowType
  '
  ' A window on the screen for showing information or collecting input.
  '
  canceled AS INTEGER
  fields   AS INTEGER
  helpWid  AS INTEGER
  posX     AS INTEGER
  posY     AS INTEGER
  selected AS INTEGER
  sizeX    AS INTEGER
  sizeY    AS INTEGER
  wname    AS STRING * 20
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
DECLARE SUB AtlasInit ()
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
DECLARE SUB ExecuteAbout ()
DECLARE SUB ExecuteEndGame ()
DECLARE SUB ExecuteFilterNone ()
DECLARE SUB ExecuteFilterSelf ()
DECLARE SUB ExecuteOptionAlerts ()
DECLARE SUB ExecuteViewAtlas ()
DECLARE SUB ExecuteViewTable ()

'
' Inbox* subroutines
'
DECLARE SUB InboxAdd (subject AS STRING)
DECLARE SUB InboxDraw (rows AS INTEGER)
DECLARE SUB InboxDrawRow (row AS INTEGER)
DECLARE SUB InboxReset ()

'
' Menu* subroutines
'
DECLARE SUB MenuHide ()
DECLARE SUB MenuLoad ()
DECLARE SUB MenuDraw ()
DECLARE SUB MenuDrawItem (itemId AS INTEGER, selected AS INTEGER)
DECLARE FUNCTION MenuShow ()

'
' Nebula* subroutines
'
DECLARE SUB NebulaCreate (seq() AS INTEGER)
DECLARE SUB NebulaCreateSeq (seq() AS INTEGER, y!)
DECLARE SUB NebulaDraw (seq() AS INTEGER)
DECLARE SUB NebulaHarvest (seq() AS INTEGER)
DECLARE SUB NebulaShow (aid AS INTEGER)
DECLARE FUNCTION NebulaLabel$ (level AS INTEGER)

'
' SetupGame.* subroutines
'
' These subroutines prepare a game for play.
'
DECLARE SUB SetupGame ()
DECLARE SUB SetupGame.Atlas ()
DECLARE SUB SetupGame.New ()

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
DECLARE SUB UI.RedrawInbox ()
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
DECLARE FUNCTION WinAppend% (wid%, f AS FieldType, text$)
DECLARE FUNCTION WinAppendBoolean% (wid%, text$)
DECLARE FUNCTION WinAppendButton% (wid%, cid%, text$)
DECLARE FUNCTION WinAppendLabel% (wid%, text$)
DECLARE FUNCTION WinAppendSeparator% (wid%)
DECLARE FUNCTION WinDefine% (wid%, f AS FieldType, text$)
DECLARE FUNCTION WinDefineButton% (wid%, posX%, posY%, sizeX%, cid%, text$)
DECLARE FUNCTION WinDefineLabel% (wid%, posX%, posY%, text$)
DECLARE FUNCTION WinDefineInteger% (wid%, posX%, posY%, sizeX%, text$)
DECLARE FUNCTION WinGetWid% (wname$)
DECLARE FUNCTION WinIsSelectable% (wid%, fid%)
DECLARE FUNCTION WinParseCommand% (text$)

DECLARE SUB WinDraw (wid%)
DECLARE SUB WinDrawField (wid%, fid%)
DECLARE SUB WinDrawOutline (wid%, sx%, sy%)
DECLARE SUB WinKey (wid%, fid%, keypress$)
DECLARE SUB WinKeyBoolean (wid%, fid%, keypress$)
DECLARE SUB WinKeyInteger (wid%, fid%, keypress$)
DECLARE SUB WinLoad ()
DECLARE SUB WinMove (wid%)
DECLARE SUB WinSelectNext (wid%)
DECLARE SUB WinSelect (wid%, fid%)
DECLARE SUB WinSelectPrevious (wid%)
DECLARE SUB WinSelectFirst (wid%)
DECLARE SUB WinSelectLast (wid%)
DECLARE SUB WinShow (wid%)
DECLARE SUB WinShowName (idname$)

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
DECLARE SUB DrawFile (filename AS STRING)
DECLARE SUB DrawFileAt (filename AS STRING, offsetX AS INTEGER, offsetY AS INTEGER)
DECLARE SUB DrawTable ()
DECLARE SUB DrawTableRow (row AS INTEGER, aid AS INTEGER)
DECLARE SUB DrawTableRows ()
DECLARE SUB DrawText (text AS STRING)
DECLARE SUB PaintBackground (sx1%, sy1%, sx2%, sy2%, backcolor%)
DECLARE SUB WaitForKeyPress ()
DECLARE FUNCTION GetKey$ ()
DECLARE FUNCTION IsFiltered% (aid AS INTEGER)

'
' ASCII character constants
'
CONST ASCII.Backspace = 8
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
CONST AtlasStyle.DrawFile = "GRID.PCB"
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
CONST Command.NewGame = 8
CONST Command.OptionAlerts = 9
CONST Command.ReplotBand = 11
CONST Command.ReplotCluster = 12
CONST Command.ReplotManual = 13
CONST Command.ReplotRandom = 14
CONST Command.ViewAtlas = 15
CONST Command.ViewInbox = 16
CONST Command.ViewTable = 17

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
CONST FieldKind.Separator = 5

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
CONST MaxFields = 15
CONST MaxWindows = 50

'
' MenuStyle constants
'
CONST MenuStyle.BackColor = 7
CONST MenuStyle.ForeColor = 0
CONST MenuStyle.SelectedBackColor = 0
CONST MenuStyle.SelectedForeColor = 15
                                   
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
' StatusStyle.* constants
'
' These constants define the style of the status bar on the bottom
' of the screen. The status bar is used to display quick updates and
' error/debug information.
'
CONST StatusStyle.NormalForecolor = 15
CONST StatusStyle.NormalBackcolor = 0
CONST StatusStyle.DebugBackcolor = 4
CONST StatusStyle.DebugForecolor = 15

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
CONST VideoPage.Atlas = 2
CONST VideoPage.Table = 3

'
' WinStyle.* constants
'
' These constants define the colors and other styles of windows.
'
CONST WinStyle.Backcolor = 1
CONST WinStyle.Forecolor = 7
CONST WinStyle.Border = 1
CONST WinStyle.OutlineBackcolor = 2
CONST WinStyle.OutlineForecolor = 7
CONST WinStyle.SelectedBackcolor = 7
CONST WinStyle.SelectedForecolor = 0
CONST WinStyle.Shadow = 0
CONST WinStyle.ShadowChar = 176
CONST WinStyle.ShadowForecolor = 8
CONST WinStyle.ShadowBackcolor = 0

'
' Global world variables
'
DIM SHARED area(1 TO 30)       AS AreaType
DIM SHARED habitat(1 TO 20)    AS HabitatType
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
DIM SHARED msg(1 TO 19) AS MessageType
DIM SHARED msgs AS INTEGER
DIM SHARED msgx AS INTEGER

'
' Global menu variables
'
DIM SHARED menuCount AS INTEGER
DIM SHARED menuItem(1 TO MaxMenus) AS MenuType

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
DIM SHARED txt(1 TO MaxWindows, 1 TO MaxFields) AS STRING

'
' Global variables
'
DIM SHARED arrowexit               AS INTEGER
DIM SHARED pressed                 AS STRING

'
' Main
'
SetupGame
UI.Run

'
' Window Definitions
'
' These are loaded by the WinLoad subroutine.
'

REM Window 1
  DATA "Windows"
 
  DATA "Window"
  DATA   "Name", "Start"
  DATA   "PosX", 22
  DATA   "PosY", 10
  DATA   "$", 0, 1, " Select an option to get started: "
  DATA   "@", 12, 3, 10, "NewGame",   " New Game "
  DATA   "@", 12, 4, 10, "<command>", " Exit App "
  DATA "End"

REM Window 2
  DATA "Window"
  DATA   "Name", "DialogAreas"
  DATA   "PosX", 11
  DATA   "PosY", 10
  DATA   "$", 0, 1, "Initialization Mode"
  DATA   "+-"
  DATA   "+$", "How many areas should be in the game?  [Def=15]"
  DATA   "#", 56, 3, 2, 15
  DATA "End"

REM Window 5
  DATA "Window"
  DATA   "Name", "TooManyAreas"
  DATA   "PosX", 20
  DATA   "PosY", 11
  DATA   "+$", " Error: The maximum number of areas is 19 "
  DATA "End"

REM Window 9
  DATA "Window"
  DATA   "Name", "AtlasMaker"
  DATA   "PosX", 3
  DATA   "PosY", 3
  DATA   "+@", "<command>", "Look Behind Window"
  DATA   "+@", "<command>", "Next Step..."
  DATA   "+-"
  DATA   "+@", "ReplotCluster", "Cluster together "
  DATA   "+@", "ReplotBand", "Band together "
  DATA   "+@", "ReplotManual", "Plot Manually"
  DATA   "+@", "ReplotRandom", "Randomly place"
  DATA "End"

  DATA "Window"
  DATA   "Name", "FileMenu"
  DATA   "PosX", 1
  DATA   "PosY", 2
  DATA   "+@", "About", "About..."
  DATA   "+@", "EndGame", "Exit"
  DATA "End"

  DATA "Window"
  DATA   "Name", "ViewMenu"
  DATA   "PosX", 11
  DATA   "PosY", 2
  DATA   "+@", "ViewAtlas", "Show atlas"
  DATA   "+@", "ViewTable", "Show table"
  DATA   "+@", "ViewInbox", "Show inbox"
  DATA   "+-"      
  DATA   "+@", "FilterSelf", "Filter you"
  DATA   "+@", "FilterNone", "Remove Filter"
  DATA   "+-"
  DATA   "+@", "ReplotBand", "Replot banded"
  DATA   "+@", "ReplotCluster", "Replot clustered"
  DATA   "+@", "ReplotManual", "Replot manually"
  DATA   "+@", "ReplotRandom", "Replot randomly"
  DATA "End"

  DATA "Window"
  DATA   "Name", "OptionsMenu"
  DATA   "PosX", 21
  DATA   "PosY", 2
  DATA   "+@", "OptionAlerts", "Alerts"
  DATA "End"

REM Window 27
  DATA "Window"
  DATA   "Name", "DialogAlerts"
  DATA   "PosX", 19
  DATA   "PosY", 9
  DATA   "+$", " Do you wish to sound alert? "
  DATA   "+-"
  DATA   "+&", "Yes"
  DATA "End"

REM Window 30
  DATA "Window"
  DATA   "Name", "About"
  DATA   "PosX", 1
  DATA   "PosY", 5
  DATA   "+$", "   The Galactic Empire   "
  DATA   "+-"
  DATA   "+$", " (C) 1992 David J. Pinch "
  DATA "End"

DATA "EndWindows"

'
' Menu data (loaded by MenuLoad)
'
DATA "Menus"
DATA   "Menu", " File ", "FileMenu"
DATA   "Menu", " View ", "ViewMenu"
DATA   "Menu", " Options ", "OptionsMenu"
DATA "EndMenus"

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
    StatusDebug where + ": " + what
  END IF

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

SUB AtlasInit
  '
  ' Initializes the atlas data and video page.
  '
  
  '
  ' Mark all items as inactive.
  '
  DIM idx AS INTEGER
  FOR idx = 1 TO UBOUND(atlasItem)
    atlasItem(idx).allocated = 0
  NEXT

  ' For performance, a copy of the empty grid is stored
  ' on a background video page so it can be redrawn quickly.
  '
  SCREEN , , VideoPage.Atlas, VideoPage.Display
  AtlasDrawGrid
  SCREEN , , VideoPage.Display, VideoPage.Display

END SUB

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
      ExecuteAbout

    CASE Command.EndGame
      ExecuteEndGame

    CASE Command.FilterNone
      ExecuteFilterNone

    CASE Command.FilterSelf
      ExecuteFilterSelf

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
      ExecuteViewAtlas
     
    CASE Command.ViewInbox
      UI.SetPage UIPage.Inbox

    CASE Command.ViewTable
      ExecuteViewTable

    CASE ELSE
      StatusDebug "Execute(" + LTRIM$(STR$(cid)) + "): unrecognized cid"

  END SELECT

END SUB

SUB ExecuteAbout
  '
  ' Shows the about page
  '
  UI.SetPage UIPage.About

END SUB

SUB ExecuteEndGame
  '
  ' Ends the game
  '
  END
END SUB

SUB ExecuteFilterNone
  '
  ' Removes the current filter
  '
  UI.SetFilter UIFilter.None, True

END SUB

SUB ExecuteFilterSelf
  '
  ' Filters data to the player
  '
  UI.SetFilter UIFilter.Self, True

END SUB

SUB ExecuteOptionAlerts

  WinShowName "DialogAlerts"

  'FOR x = 1 TO 3
  '  FOR Y = 300 TO 60 STEP -10
  '    SOUND Y, .2
  '  NEXT
  'NEXT

END SUB

SUB ExecuteViewAtlas
  '
  ' Displays the atlas
  '
  UI.SetPage UIPage.Atlas

END SUB

SUB ExecuteViewTable
  '
  ' Displays the data table
  '
  UI.SetPage UIPage.Table

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
 
  '
  ' Get the next message index
  '
  msgs = msgs + 1

  '
  ' Store the message
  '
  msg(msgs).opened = False
  msg(msgs).subject = subject

END SUB

SUB InboxDraw (rows AS INTEGER)

  Assert rows >= 0, "InboxDraw", "rows must be 0 or greater"
  Assert rows <= InboxStyle.InnerSizeY, "InboxDraw", "exceeded max rows"

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
  ' Top border of the inbox
  '
  LOCATE InboxStyle.OuterPosY, InboxStyle.OuterPosX
  COLOR fc(0), bc(0)
  PRINT CHR$(220);
  PRINT STRING$(InboxStyle.InnerSizeX, 196);
  PRINT CHR$(191);

  FOR row = 1 TO rows

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
    LOCATE InboxStyle.OuterPosY + row, InboxStyle.OuterPosX
    COLOR fc(idx), bc(idx)
    PRINT ch(idx);

    InboxDrawRow row

    '
    ' Get the index of the right border
    '
    idx = rows - row + 1
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
  LOCATE InboxStyle.OuterPosY + rows + 1, InboxStyle.OuterPosX
  COLOR fc(0), bc(0)
  PRINT CHR$(192);
  PRINT STRING$(InboxStyle.InnerSizeX, 196);
  PRINT CHR$(223);

END SUB

SUB InboxDrawRow (row AS INTEGER)

  Assert row > 0, "InboxDrawRow", "row cannot be 0 or negative"

  DIM sx   AS INTEGER
  DIM sy   AS INTEGER
  DIM text AS STRING

  '
  ' Calculate the screen coordinates of the row
  '
  sx = InboxStyle.OuterPosX + 1
  sy = InboxStyle.OuterPosY + row
  LOCATE sy, sx

  '
  ' Set the color depending on whether the row is selected
  '
  IF msgx = row THEN
    COLOR 13, 5
  ELSE
    COLOR 5, 0
  END IF

  text = " " + RTRIM$(msg(row).subject)
  text = text + STRING$(InboxStyle.InnerSizeX - LEN(text), " ")

  '
  ' Draw the row
  '
  PRINT text;

END SUB

SUB InboxReset
  '
  ' Initializes the mailbox to its default state
  '
  msgs = 0

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

SUB MenuDraw

  '
  ' Clear the menu space on the top row of the screen
  '
  VIEW PRINT 1 TO 1
  COLOR MenuStyle.ForeColor, MenuStyle.BackColor
  CLS 2
  VIEW PRINT

  '
  ' Draw each menu item
  '
  DIM i AS INTEGER
  FOR i = 1 TO menuCount
    MenuDrawItem i, 0
  NEXT

END SUB

SUB MenuDrawItem (itemId AS INTEGER, selected AS INTEGER)

  '
  ' Move to the screen location of the item
  '
  LOCATE 1, menuItem(itemId).posX

  '
  ' Set the color depending on whether this item is selected
  '
  IF selected THEN
    COLOR MenuStyle.SelectedForeColor, MenuStyle.SelectedBackColor
  ELSE
    COLOR MenuStyle.ForeColor, MenuStyle.BackColor
  END IF

  PRINT menuItem(itemId).text;

END SUB

SUB MenuHide
  '
  ' Hides the menu on the top of the screen.
  '
  VIEW PRINT 1 TO 1
  COLOR 7, 0
  CLS 2
  VIEW PRINT

END SUB

SUB MenuLoad
  '
  ' Loads the menu. This subroutine should be called once
  ' and after the windows are loaded.
  '

  DIM block AS STRING
  DIM posX  AS INTEGER
  DIM wname AS STRING

  READ block
  IF block <> "Menus" THEN
    StatusDebug "MenuLoad: expected 'Menus' but encountered " + block
  END IF

  '
  ' Load each menu definition
  '
  posX = 2
  DO
   
    READ block
   
    SELECT CASE block

      CASE "Menu"
       
        menuCount = menuCount + 1

        READ menuItem(menuCount).text
        READ wname
        menuItem(menuCount).wid = WinGetWid(wname)

        '
        ' Calculate the horizontal position of this menu item
        '
        menuItem(menuCount).posX = posX
        posX = posX + LEN(menuItem(menuCount).text)

      CASE "EndMenus"
        EXIT DO

      CASE ELSE
        StatusDebug "MenuLoad: expected Menu but encountered " + block
   
    END SELECT

  LOOP

END SUB

FUNCTION MenuShow
  '
  ' Returns the command ID of an item selected from the menu.
  '
 
  CONST MenusClosed = 0
  CONST MenusOpen = 1

  DIM keypress AS STRING
  DIM mode     AS INTEGER
 
  '
  ' Keep track of the current menu item
  '
  STATIC selection AS INTEGER
  IF selection = 0 THEN
    selection = 1
  END IF

  MenuDraw

  DO
   
    '
    ' Draw the selected menu item
    '
    MenuDrawItem selection, 1

    IF mode = MenusOpen THEN
      '
      ' The menu is open (a window is displayed)
      '
      arrowexit = 1
      WinShow menuItem(selection).wid
      arrowexit = 0
     
      IF win(menuItem(selection).wid).canceled THEN
       
        mode = MenusClosed
     
      ELSE

        ' HACK: use global pressed variable
        SELECT CASE pressed
          CASE CHR$(ASCII.Return)
           
            DIM wid AS INTEGER
            DIM fid AS INTEGER

            wid = menuItem(selection).wid
            fid = win(wid).selected
            
            MenuShow = fld(wid, fid).cid
            MenuHide
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

        CASE CHR$(0) + CHR$(ScanCode.Down)
          '
          ' Down (open menu)
          '
          mode = MenusOpen

        CASE CHR$(ASCII.Return)
          '
          ' Enter (open menu)
          '
          mode = MenusOpen
       
        CASE CHR$(ASCII.Escape)
          '
          ' Escape (exit menu)
          '
          MenuHide
          MenuShow = 0
          EXIT FUNCTION

      END SELECT

    END IF
   
  LOOP

REM *** Subroutines ***

NavigateLeft:
  '
  ' Moves to the menu item to the left
  '
  MenuDrawItem selection, 0
  selection = selection - 1: IF selection = 0 THEN selection = menuCount
  RETURN

NavigateRight:
  '
  ' Moves to the menu item to the right
  '
  MenuDrawItem selection, 0
  selection = selection + 1: IF selection > menuCount THEN selection = 1
  RETURN

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
  MenuLoad
  WorldLoadHabitats

  '
  ' Draw master screens
  '
  SCREEN , , VideoPage.Table, VideoPage.Display
  DrawTable
  StatusClear

  '
  ' Initialize the atlas
  '
  AtlasInit

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
  WinShowName "Start"
 
  IF fld(1, win(1).selected).cid = Command.NewGame THEN
    InboxReset
    WorldInit 15
  ELSE
    END
  END IF

END SUB

SUB SetupGame.Atlas

  DIM wid AS INTEGER
  LET wid = WinGetWid("AtlasMaker")

  '
  ' Initialize and display the atlas.
  '
  UI.SetPage UIPage.Atlas

  '
  ' Set focus on the option to exit the atlas editor
  '
  WinSelect wid, 2

  DO
   
    '
    ' Show the editor menu
    '
    WinShow wid

    SELECT CASE win(wid).selected
     
      CASE 1
        '
        ' Hide the window in order to see the grid
        '
        StatusUpdate "Press any key to restore the window..."
        WaitForKeyPress
        StatusClear
     
      CASE 2
        '
        ' Exit the atlas maker
        '
        EXIT SUB
     
      CASE 4:
        AtlasPlotClustered

      CASE 5:
        AtlasPlotBanded

      CASE 6:
        AtlasPlotManual

      CASE 7:
        AtlasPlotRandom
    
    END SELECT

  LOOP

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

  '
  ' Set the viewport to the last row of the screen
  '
  VIEW PRINT 25 TO 25
 
  '
  ' Set the color based on the status level
  '
  SELECT CASE level
    CASE StatusLevel.Debug:
      COLOR StatusStyle.DebugForecolor, StatusStyle.DebugBackcolor
    CASE ELSE
      COLOR StatusStyle.NormalForecolor, StatusStyle.NormalBackcolor
  END SELECT

  '
  ' Print the updated status and reset the viewport
  '
  CLS
  'PRINT text;
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

    CASE UIPage.Inbox
      UI.RedrawInbox

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

  '
  ' Copy the blank atlas to the working page and draw items
  '
  SCREEN , , VideoPage.Working, VideoPage.Display
  PCOPY VideoPage.Atlas, VideoPage.Working
  AtlasDrawItems

  '
  ' Restore the display page
  '
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

SUB UI.RedrawInbox

  Assert uiCurrentPage = UIPage.Inbox, "UI.RedrawInbox", "Wrong UI page"

  InboxDraw InboxStyle.InnerSizeY

END SUB

SUB UI.RedrawTable

  SCREEN , , VideoPage.Working, VideoPage.Display
  PCOPY VideoPage.Table, VideoPage.Working
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
 
  DIM cid    AS INTEGER
  DIM result AS INTEGER

  '
  ' Set the atlas (setting the page causes it to redraw)
  '
  UI.SetPage UIPage.Atlas

  DO
    
    Assert uiCurrentPage <> UIPage.None, "UI.Run", "UI page must be set"

    SELECT CASE uiCurrentPage
    
      CASE UIPage.About
        result = UI.RunAbout%

      CASE UIPage.Area
        result = UI.RunArea%

      CASE UIPage.Atlas
        result = UI.RunAtlas%

      CASE UIPage.Inbox
        result = UI.RunInbox%

    END SELECT

    SELECT CASE result

      CASE UIResult.Exit
        '
        ' The UI page exited normally.
        '

      CASE UIResult.Escape
        '
        ' The player pressed the escape key to open the menu
        '
        cid = MenuShow
        IF cid > 0 THEN
          Execute cid
        END IF

    END SELECT

  LOOP

END SUB

FUNCTION UI.RunAbout%
  '
  ' Displays a screen showing information about the game.
  '

  Assert uiCurrentPage = UIPage.About, "UI.RunAbout", "Wrong UI page"

  '
  ' Lookup the about window
  '
  DIM wid AS INTEGER
  LET wid = WinGetWid("About")
  Assert wid <> 0, "UI.RunAbout", "About window not found"

  WinShow wid
  IF win(wid).canceled THEN
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
  
  DIM keypress AS STRING

  IF msgs = 0 THEN
    '
    ' No messages
    '
    WaitForKeyPress
    UI.SetPage UIPage.Atlas
    UI.RunInbox = UIResult.Exit

  ELSE

    '
    ' Get the current selection
    '
    IF msgx = 0 THEN msgx = 1

    '
    ' Draw the current selection
    '
    InboxDrawRow msgx
   
    keypress = GetKey$
   
    SELECT CASE keypress
     
      CASE CHR$(ASCII.Escape)
        UI.RunInbox% = UIResult.Escape
        EXIT FUNCTION

      CASE CHR$(ASCII.Return)
        UI.SetPage UIPage.Atlas
        UI.RunIndex% = UIResult.Exit
        EXIT FUNCTION

    END SELECT

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

SUB WaitForKeyPress
  '
  ' Waits for any key to be pressed. The key is discarded from input.
  '
  DIM k AS STRING

  DO
    k = INKEY$
  LOOP UNTIL LEN(k)

END SUB

FUNCTION WinAppend% (wid%, f AS FieldType, text$)
  '
  ' Position the field below the bottom of the window
  '
  f.posY = win(wid%).sizeY + 1

  '
  ' Add the field definition to the window (the window will autosize)
  '
  WinAppend% = WinDefine(wid%, f, text$)

END FUNCTION

FUNCTION WinAppendBoolean% (wid%, text$)

  DIM f AS FieldType

  f.kind = FieldKind.Boolean
  f.posX = 0 ' Center

  WinAppendBoolean% = WinAppend(wid%, f, text$)

END FUNCTION

FUNCTION WinAppendButton% (wid%, cid%, text$)

  DIM f AS FieldType

  f.kind = FieldKind.Button
  f.cid = cid%
  f.posX = 1

  WinAppendButton% = WinAppend(wid%, f, text$)

END FUNCTION

FUNCTION WinAppendLabel% (wid%, text$)

  DIM f AS FieldType

  f.kind = FieldKind.Label
  f.posX = 1

  WinAppendLabel% = WinAppend(wid%, f, text$)

END FUNCTION

FUNCTION WinAppendSeparator% (wid%)

  DIM f AS FieldType

  f.kind = FieldKind.Separator

  WinAppendSeparator% = WinAppend(wid%, f, "-")

END FUNCTION

' ===================================================================
' WinDefine
' -------------------------------------------------------------------
' Defines a new field in a window and returns the field ID. Any code
' that creates new fields should ultimately call this function
' because it applies certain rules such as adjusting the window size.
' ===================================================================
FUNCTION WinDefine% (wid%, f AS FieldType, text$)

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

FUNCTION WinDefineButton% (wid%, posX%, posY%, sizeX%, cid%, text$)
  '
  ' Defines a button field in a window.
  '

  DIM f AS FieldType

  f.kind = FieldKind.Button
  f.cid = cid%
  f.posX = posX%
  f.posY = posY%
  f.sizeX = sizeX%

  WinDefineButton = WinDefine(wid%, f, text$)

END FUNCTION

FUNCTION WinDefineInteger% (wid%, posX%, posY%, sizeX%, text$)
  '
  ' Defines an integer field in a window.
  '
 
  DIM f AS FieldType

  f.kind = FieldKind.Integer
  f.posX = posX%
  f.posY = posY%
  f.sizeX = sizeX%

  WinDefineInteger% = WinDefine(wid%, f, text$)

END FUNCTION

FUNCTION WinDefineLabel% (wid%, posX%, posY%, text$)
  '
  ' Defines a label field in a window. A label field is non-editable
  ' text that cannot be selected (receive focus) or edited directly
  ' by the user.
  '

  DIM f AS FieldType

  f.kind = FieldKind.Label
  f.posX = posX%
  f.posY = posY%
  f.sizeX = LEN(text$)

  WinDefineLabel = WinDefine(wid%, f, text$)

END FUNCTION

SUB WinDraw (wid%)
  '
  ' Draws the window to the active video page.
  '

  DIM i          AS INTEGER
  DIM lowerLeft  AS STRING * 1
  DIM lowerFlat  AS STRING * 1
  DIM lowerRight AS STRING * 1
  DIM sideLeft   AS STRING * 1
  DIM sideRight  AS STRING * 1
  DIM upperLeft  AS STRING * 1
  DIM upperFlat  AS STRING * 1
  DIM upperRight AS STRING * 1

  '
  ' Setup border characters
  '
  SELECT CASE WinStyle.Border
    CASE 1
      lowerFlat = CHR$(196)
      lowerLeft = CHR$(192)
      lowerRight = CHR$(217)
      sideLeft = CHR$(179)
      sideRight = CHR$(179)
      upperLeft = CHR$(218)
      upperFlat = CHR$(196)
      upperRight = CHR$(191)
    CASE 2
      lowerFlat = CHR$(205)
      lowerLeft = CHR$(200)
      lowerRight = CHR$(188)
      sideLeft = CHR$(179)
      sideRight = CHR$(179)
      upperLeft = CHR$(201)
      upperFlat = CHR$(205)
      upperRight = CHR$(187)
  END SELECT

  '
  ' Set the display color of the window
  '
  COLOR WinStyle.Forecolor, WinStyle.Backcolor

  '
  ' Draw the top border
  '
  LOCATE win(wid%).posY, win(wid%).posX
  PRINT upperLeft; STRING$(win(wid%).sizeX, upperFlat); upperRight

  '
  ' Draw each row of the window
  '
  FOR r = 1 TO win(wid%).sizeY
   
    LOCATE win(wid%).posY + r, win(wid%).posX
    PRINT sideLeft;
    PRINT STRING$(win(wid%).sizeX, CHR$(ASCII.Space));
    PRINT sideRight;

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
  LOCATE win(wid%).posY + win(wid%).sizeY + 1, win(wid%).posX
  PRINT lowerLeft; STRING$(win(wid%).sizeX, lowerFlat); lowerRight;
 
  '
  ' Draw the shadow (including the shadow of the lower border)
  '
  SELECT CASE WinStyle.Shadow
    CASE 1
      COLOR WinStyle.ShadowForecolor, WinStyle.ShadowBackcolor
      PRINT CHR$(WinStyle.ShadowChar);
      LOCATE win(wid%).posY + win(wid%).sizeY + 2, win(wid%).posX + 1
      PRINT STRING$(win(wid%).sizeX + 2, WinStyle.ShadowChar);
      COLOR WinStyle.Forecolor, WinStyle.Backcolor
  END SELECT

  '
  ' Draw fields
  '
  FOR i = 1 TO win(wid%).fields
    WinDrawField wid%, i
  NEXT

END SUB

SUB WinDrawField (wid%, fid%)

  DIM backcolor AS INTEGER
  DIM forecolor AS INTEGER
  DIM posX      AS INTEGER
  DIM posY      AS INTEGER
  DIM sizeX     AS INTEGER
  DIM sx        AS INTEGER
  DIM sy        AS INTEGER
 
  '
  ' Adjust the field size (if zero, then fill width of window)
  '
  sizeX = fld(wid%, fid%).sizeX
  IF sizeX = 0 THEN
    sizeX = win(wid%).sizeX
  END IF
 
  '
  ' Adjust the position of the field (if zero, center)
  '
  posX = fld(wid%, fid%).posX
  posY = fld(wid%, fid%).posY
  IF posX = 0 THEN
    posX = INT((win(wid%).sizeX - sizeX) / 2) + 1
  END IF

  '
  ' Calculate the screen coordinates of the field
  '
  sx = posX + win(wid%).posX
  sy = posY + win(wid%).posY
  LOCATE sy, sx

  '
  ' Set the color depending on whether the field is selected
  '
  IF win(wid%).selected = fid% THEN
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
  SELECT CASE fld(wid%, fid%).kind
   
    CASE FieldKind.Button, FieldKind.Boolean, FieldKind.Label
      '
      ' Button and Boolean (text)
      '
      PRINT txt(wid%, fid%);
     
      '
      ' Pad remaining spaces
      '
      PRINT STRING$(sizeX - LEN(txt(wid%, fid%)), ASCII.Space);

    CASE FieldKind.Separator
      '
      ' Separator
      '
      PRINT STRING$(win(wid%).sizeX, 196);

    CASE FieldKind.Integer
      '
      ' Integer Input
      '
      DIM format AS STRING
      format = STRING$(fld(wid%, fid%).sizeX, "#")
      PRINT USING format; VAL(txt(wid%, fid%));
 
  END SELECT

END SUB

SUB WinDrawOutline (wid%, sx%, sy%)

  '
  ' Set the color of the outline
  '
  COLOR WinStyle.OutlineForecolor, WinStyle.OutlineBackcolor

  '
  ' Draw upper-left corner
  '
  LOCATE sy%, sx%
  SELECT CASE WinStyle.Border
    CASE 1
      PRINT CHR$(218); CHR$(196);
    CASE 2
      PRINT CHR$(201); CHR$(205);
  END SELECT
  LOCATE sy% + 1, sx%
  SELECT CASE WinStyle.Border
    CASE 1
      PRINT CHR$(179);
    CASE 2
      PRINT CHR$(186);
  END SELECT

  '
  ' Draw lower-left corner
  '
  LOCATE sy% + win(wid%).sizeY, sx%
  IF WinStyle.Border = 2 THEN PRINT CHR$(186);  ELSE PRINT CHR$(179);
  LOCATE sy% + win(wid%).sizeY + 1, sx%
  SELECT CASE WinStyle.Border
    CASE 1
      PRINT CHR$(192); CHR$(196);
    CASE 2
      PRINT CHR$(200); CHR$(205);
  END SELECT

  '
  ' Draw upper-right corner
  '
  LOCATE sy%, sx% + win(wid%).sizeX
  IF WinStyle.Border = 2 THEN
    PRINT CHR$(205); CHR$(187);
  ELSE
    PRINT CHR$(196); CHR$(191);
  END IF
  LOCATE sy% + 1, sx% + win(wid%).sizeX + 1
  IF WinStyle.Border = 2 THEN PRINT CHR$(186);  ELSE PRINT CHR$(179);

  '
  ' Draw lower-right corner
  '
  LOCATE sy% + win(wid%).sizeY, sx% + win(wid%).sizeX + 1
  IF WinStyle.Border = 2 THEN PRINT CHR$(186);  ELSE PRINT CHR$(179);
  LOCATE sy% + win(wid%).sizeY + 1, sx% + win(wid%).sizeX
  IF WinStyle.Border = 2 THEN
    PRINT CHR$(205); CHR$(188);
  ELSE
    PRINT CHR$(196); CHR$(217);
  END IF

END SUB

FUNCTION WinGetWid% (wname$)
  '
  ' Returns the ID of the window with the specified name.
  '
 
  DIM wid AS INTEGER

  FOR wid = 1 TO UBOUND(win)
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

    CASE "n", "N"
      txt(wid%, fid%) = " No  "

    CASE "y", "Y"
      txt(wid%, fid%) = " Yes "

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
  DIM block   AS STRING
  DIM cid     AS INTEGER
  DIM fid     AS INTEGER
  DIM posX    AS INTEGER
  DIM posY    AS INTEGER
  DIM sizeX   AS INTEGER
  DIM wid     AS INTEGER

  '
  ' This should be a "Windows" block
  '
  READ block
  IF block <> "Windows" THEN
    StatusDebug "WinLoad: Expected 'Windows' but block was " + block
    EXIT SUB
  END IF

  DO
   
    '
    ' This should be the next "Window" block, or the end of the windows
    '
    READ block
    IF block = "EndWindows" THEN
      EXIT SUB
    ELSEIF block <> "Window" THEN
      StatusDebug "WinLoad: Expected 'Window' but block was " + block
      EXIT SUB
    END IF

    wid = wid + 1

    DO

      '
      ' Read the next window attribute
      '
      READ block
   
      SELECT CASE block
     
        CASE "End"
          EXIT DO

        CASE "+$"
          READ block
          fid = WinAppendLabel(wid, block)

        CASE "+-", "-"
          fid = WinAppendSeparator(wid)

        CASE "+@"
          READ block: cid = WinParseCommand(block)
          READ block
          ' HACK: pad the button text for now
          fid = WinAppendButton(wid, cid, " " + block + " ")
     
        CASE "+&"
          READ block
          fid = WinAppendBoolean(wid, block)

        CASE "$"
          READ posX
          READ posY
          READ block
          fid = WinDefineLabel(wid, posX, posY, block)

        CASE "@"
          READ posX
          READ posY
          READ sizeX
          READ block: cid = WinParseCommand(block)
          READ block
          fid = WinDefineButton(wid, posX, posY, sizeX, cid, block)

        CASE "#"
          READ posX
          READ posY
          READ sizeX
          READ block
          fid = WinDefineInteger(wid, posX, posY, sizeX, block)

        CASE "Name"
          READ win(wid).wname

        CASE "PosX"
          READ win(wid).posX

        CASE "PosY"
          READ win(wid).posY

        CASE "SizeX"
          READ win(wid).sizeX

        CASE "SizeY"
          READ win(wid).sizeY

        CASE "Help"
          '
          ' Set Help Window
          '
          READ win(wid).helpWid

        CASE ELSE
          StatusDebug "WinLoad unexpected token: wid=" + STR$(wid) + " block=" + block
          WaitForKeyPress
          END

      END SELECT
    LOOP

  LOOP

END SUB

SUB WinMove (wid%)

  DIM keypress AS STRING
  DIM toX      AS INTEGER
  DIM toY      AS INTEGER

  '
  ' Get the starting location of the window
  '
  toX = win(wid%).posX
  toY = win(wid%).posY

  DO
   
    '
    ' Copy the display page to the working video page
    '
    PCOPY VideoPage.Display, VideoPage.Working

    '
    ' Manipulate the working video page
    '
    SCREEN , , VideoPage.Working, VideoPage.Working

    '
    ' Draw the outline and wait for a keyboard command
    '
    WinDrawOutline wid%, toX, toY
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
        win(wid%).posX = toX
        win(wid%).posY = toY

        '
        ' Restore the display page
        '
        SCREEN , , VideoPage.Display, VideoPage.Display
        EXIT SUB
     
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
        toX = win(wid%).posX
        toY = win(wid%).posY
   
    END SELECT

    GOSUB CheckPlace
 
  LOOP

REM *** Subroutines ***

CheckPlace:
  IF toY < 2 THEN toY = 2
  IF toY > 23 - win(wid%).sizeY THEN toY = 23 - win(wid%).sizeY
  IF toX < 1 THEN toX = 1
  IF toX > 78 - win(wid%).sizeX THEN toX = 78 - win(wid%).sizeX
  RETURN

END SUB

FUNCTION WinParseCommand% (text$)
  '
  ' Translates a command name into an integer value. This is used when
  ' loading window definitions so that the developer can refer to a
  ' command with a human-friendly string instead of an integer.
  ' When creating new commands, add an entry to this function that
  ' maps a human-friendly name to a value in the Command.* constants.

  DIM cid AS INTEGER

  SELECT CASE UCASE$(text$)
   
    CASE "ABOUT"
      cid = Command.About

    CASE "ENDGAME":
      cid = Command.EndGame

    CASE "FILTERNONE":
      cid = Command.FilterNone

    CASE "FILTERSELF":
      cid = Command.FilterSelf

    CASE "NEWGAME":
      cid = Command.NewGame

    CASE "OPTIONALERTS":
      cid = Command.OptionAlerts

    CASE "REPLOTBAND":
      cid = Command.ReplotBand

    CASE "REPLOTCLUSTER":
      cid = Command.ReplotCluster

    CASE "REPLOTMANUAL":
      cid = Command.ReplotManual

    CASE "REPLOTRANDOM":
      cid = Command.ReplotRandom

    CASE "VIEWATLAS":
      cid = Command.ViewAtlas

    CASE "VIEWINBOX":
      cid = Command.ViewInbox

    CASE "VIEWTABLE":
      cid = Command.ViewTable

    CASE "", "<COMMAND>"
      ' HACK: ignore <command> as it is a development placeholder
      cid = 0

    CASE ELSE
      StatusDebug "WinParseCommand: " + text$ + " not recognized"
      cid = 0

  END SELECT

  WinParseCommand = cid

END FUNCTION

SUB WinSelect (wid%, fid%)
  '
  ' Selects the specified field (gives it focus)
  '
 
  IF fid% > 0 THEN

    ' If a non-zero field ID is specified, make sure the field is
    ' actually selectable. Note that fid% can be zero in cases where
    ' the caller wants to unselect all fields.

    IF NOT WinIsSelectable(wid%, fid%) THEN
      StatusDebug "WinSelect(" + STR$(wid%) + "," + STR$(fid%) + "): fid is not selectable"
    END IF

  END IF

  win(wid%).selected = fid%

END SUB

SUB WinSelectFirst (wid%)
  '
  ' Selects the first selectable field
  '

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

  DIM fid%
  DIM firstFid%

  IF win(wid%).fields = 0 THEN
    '
    ' No fields are defined
    '
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

    LOOP UNTIL (fid% = firstFid%) OR WinIsSelectable(wid%, fid%)

  END IF

  '
  ' Select the field
  '
  WinSelect wid%, fid%

END SUB

SUB WinSelectPrevious (wid%)
  '
  ' Selects the field before the current one (looping around)
  '

  DIM fid%
  DIM startingFid%

  IF win(wid%).fields = 0 THEN
    '
    ' No fields are defined
    '
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

    LOOP UNTIL (fid% = startingFid%) OR WinIsSelectable(wid%, fid%)

  END IF

  '
  ' Select the field
  '
  WinSelect wid%, fid%

END SUB

SUB WinShow (wid%)
  '
  ' Displays and runs the specified window
  '
 
  DIM oldSelected AS INTEGER

  DO
   
    '
    ' Show the display page but write to the working page
    '
    SCREEN , , VideoPage.Working, VideoPage.Display

    '
    ' Copy the display page to the working page
    '
    PCOPY VideoPage.Display, VideoPage.Working

    '
    ' Draw the window onto the working page
    '
    WinDraw wid%
   
    '
    ' Set the working page as the visual page
    '
    SCREEN , , VideoPage.Working, VideoPage.Working
   
    '
    ' Set focus to a field
    '
    IF win(wid%).selected = 0 THEN
      WinSelectFirst wid%
    END IF

    DO

      '
      ' Get the current field that has focus
      '
      oldSelected = win(wid%).selected
      IF oldSelected <> 0 THEN
        '
        ' If a field is selected, draw it now.
        '
        WinDrawField wid%, oldSelected
      END IF

      '
      ' Wait for a keystroke
      '
      pressed = GetKey$
      SELECT CASE pressed
     
        CASE CHR$(ASCII.Return)
          '
          ' Return/Enter
          '
          win(wid%).canceled = False
        
          '
          ' Restore the display page
          '
          SCREEN , , VideoPage.Display, VideoPage.Display
          EXIT SUB
       
        CASE CHR$(0) + CHR$(ScanCode.Down), CHR$(ASCII.Space)
          '
          ' Down
          '
          WinSelectNext wid%

        CASE CHR$(0) + CHR$(ScanCode.Up)
          '
          ' Up
          '
          WinSelectPrevious wid%

        CASE CHR$(0) + CHR$(ScanCode.Home)
          '
          ' Home (first field)
          '
          WinSelectFirst wid%

        CASE CHR$(0) + CHR$(ScanCode.End)
          '
          ' End (last field)
          '
          WinSelectLast wid%

        CASE "/", "?"
          '
          ' Help
          '
          IF win(wid%).helpWid <> 0 THEN
            WinShow win(wid%).helpWid
          END IF

        CASE CHR$(0) + CHR$(ScanCode.Left), CHR$(0) + CHR$(ScanCode.Right)
          '
          ' Left/right arrow (exit for menu windows)
          '
          IF arrowexit THEN
            ' HACK
            win(wid%).canceled = False
           
            '
            ' Restore the display page and exit
            '
            SCREEN , , VideoPage.Display, VideoPage.Display
            EXIT SUB
          END IF
     
        CASE CHR$(ASCII.Escape)
          '
          ' Escape (cancel)
          '
          win(wid%).canceled = True
         
          '
          ' Restore the display page
          '
          SCREEN , , VideoPage.Display, VideoPage.Display
          EXIT SUB

        CASE CHR$(Control.D), CHR$(Control.E), CHR$(19), CHR$(24)
          WinMove wid%
          '
          ' Exit the input loop to jump up to the window loop.
          ' This will force a refresh of the window.
          '
          EXIT DO

        CASE ELSE
          WinKey wid%, win(wid%).selected, pressed

      END SELECT
   
      '
      ' Redraw the old field if selection changed.
      ' The new field will be redrawn at the start of this DO loop.
      '
      IF oldSelected <> win(wid%).selected THEN
        WinDrawField wid%, oldSelected
      END IF

    LOOP
  LOOP

END SUB

SUB WinShowName (idname$)
  '
  ' Shows the window with the specified name.
  '
 
  DIM wid AS INTEGER
  LET wid = WinGetWid(idname$)
 
  IF wid = 0 THEN
    StatusDebug "WinShowName not found: " + idname$
  ELSE
    WinShow wid
  END IF

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
  IF block <> "Habitats" THEN
    StatusDebug "WorldLoadHabitats: data started with " + block
    EXIT SUB
  END IF

  DO
 
    '
    ' The next block can be "End" (end of data) or "Habitat" (new habitat)
    '
    READ block
    IF block = "End" THEN
      EXIT SUB
    END IF
    IF block <> "Habitat" THEN
      StatusDebug "WorldLoadHabitats: block started with " + block
      EXIT SUB
    END IF

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
          StatusDebug "WorldLoadHabitats: unrecognized " + block

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

  Assert aid <> 0, "WorldRemove", "aid cannot be 0"

  IF area(aid).allocated THEN
    area(aid).allocated = False
    AtlasRemoveValue aid
  END IF

END SUB

SUB WorldSetLabel (aid AS INTEGER, label AS STRING)
  '
  ' Updates the label for the specified area
  '
 
  DIM idx AS INTEGER

  '
  ' Get the index of the item in the atlas data
  '
  idx = AtlasIndexOf(aid)
  IF idx > 0 THEN
    AtlasSetLabel idx, label
  END IF

END SUB

