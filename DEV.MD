
This file contains development tips.

## Assertions

An *assertion* is a declaration that a variable or parameter is required to conform to some restriction. A failed assertion means the code has a bug. 

    Assert var > 1, "ProcName", "invalid var"

The first parameter is a boolean expression that should result in **True** if the requirement is met. The second parameter is the name of the procedure containing the assertion. The third parameter is a string description.

If the assertion is met, nothing happens. If the assertion fails, the location and description is displayed and the program terminates. By liberally sprinkling assertions around in code, any new bugs are quickly caught, e.g., forgetting to initialize a value.

* **Assert(truth%, where$, what$)** is the core assertion subroutine as described above. All other assertion helpers call this subroutine.
* **AssertIsPositive(value%, where$, varname$)** asserts that a value is greater than zero.
* **AssertFail(where$, what$)** always fails.

The assertion subroutines are designed to be subroutines, never functions. Once code is stable, the assertions can be disabled by globally replacing **Assert** with **'Assert** (converting them to comments).

## Video Page Management

The video API manages the text video pages used by the windowing system and other UI components.

* Call **VideoScreen** to set the current active and visual pages. Always call this method instead of *SCREEN , , active%, visual%* to ensure the current page numbers are tracked.

* Call **VideoPushActive** to temporarily change the active page without changing the visual page. Call **VideoPop** to restore the original active and visual pages.

* Call **VideoAlloc** to reserve the next available video page and call **VideoFree** to release the reservation. These methods are typically used to create a temporary page for background drawing.

## Implemening Commands

ExecCmd(text$) is the top-level subroutine for executing simple text commands such as "Atlas". Commands are used in the following ways:

* A menu item can specify the command to execute when the item is selected.
* The configuration file (EMPIRE.CFG) is implemented as a sequence of commands.

To add a new command:

1. If your command is more complex than a few lines, then create a subroutine with the logic.
2. Determine the context of your command (most likely root):

* ExecCmdRoot ................ Root/global commands
* ExecCmdFid ................. Configuring field properties
* ExecCmdHid ................. Configuring habitat properties
* ExecCmdWid ................. Configuring window properties

3. Add an entry for the new command in the SELECT statement of the applicable subroutine. If the command requires parameters, then examine the token() array that is passed to the subroutine. token(1) contains the command name and token (2+) contains the parameters.



