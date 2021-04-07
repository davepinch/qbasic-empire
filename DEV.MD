
This file contains development tips.

## Assertions

An *assertion* is a declaration that a variable or parameter is required to conform to some restriction. A failed assertion means the code has a bug. Example:

    Assert var > 1, "ProcName", "invalid var"

This statement is asserting that "var" must be greater than one. The first parameter is a boolean expression that is expected by the code to result in **True**. The second parameter is the name of the procedure containing the assertion. The third parameter is a string description.

If the assertion is met, nothing happens. If the assertion fails, the location and description is displayed and the program terminates. By liberally sprinkling assertions around in code, any new bugs are quickly caught, e.g., forgetting to initialize a value.

* **Assert(truth%, where$, what$)** is the core assertion subroutine as described above. All other assertion helpers call this subroutine.
* **AssertIsPositive(value%, where$, varname$)** asserts that a value is greater than zero.
* **AssertFail(where$, what$)** always fails.

Once code is stable, the assertions can be disabled by globally replacing **Assert** with **'Assert** (converting them to comments). For this reason, assertions are designed to be subroutines, never functions. 

## String Resources

Most strings in the game are referenced as "resources".

* Call **ResourceCreate(text$)** to to save a string as a new resource. The function returns the ID of the resource for later reference.

* Call **ResourceGet(rid%)** to fetch the string using the ID value returned by ResourceCreate.

* Call **ResourceSet(rid%, text$)** to update a resource. If the specified resource ID is zero, then a new resource is created and the rid% parameter will be populated with the new resource ID.

Resource ID #0 is reserved for the empty string. If you fetch resource 0, an empty string is returned. If you set resource 0, an error occurs.

## Video Page Management

The video API manages the text video pages used by the windowing system and other UI components.

* Call **VideoScreen** to set the current active and visual pages. Always call this method instead of *SCREEN , , active%, visual%* to ensure the current page numbers are tracked.

* Call **VideoPushActive** to temporarily change the active page without changing the visual page. Call **VideoPop** to restore the original active and visual pages.

* Call **VideoAlloc** to reserve the next available video page and call **VideoFree** to release the reservation. These methods are typically used to create a temporary page for background drawing.

* Call **VideoGetActive** and **VideoGetVisual** to get the current active and visual video pages.

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



