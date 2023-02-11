
This file contains development tips.

## API Prefixes

The following prefixes are used in function and variable names to distinguish between API areas:

* **Ct** - Controls (visual controls that can take input)
* **Db** - Debug (debugging and assertations)
* **Dg** - Dialog (dialog with persons in the game)
* **Ev** - Events (things that happen such as moving)
* **Ex** - Execution (commands and parsing)
* **Hb** - Habitats (defines environments)
* **Ob** - Objects (core object support, see below)
* **Pr** - Persons (people in the game)
* **Rs** - Resources (strings)
* **St** - Styles (visual appearance of controls)
* **Tr** - Triggers (conditions of an event that cause code to run)
* **Vd** - Video (video page management)
* **Wn** - Windows (manages controls on a video page)

## Objects

The object system is designed to support reactive and object-oriented features not built in the QBASIC language, e.g., inheritance. An object is implemented as an array of properties where each property is an integer. All objects have the following properties:

* (0) - Schema
* (1) - Dirty
* (2) - Name
* (3) - Parent

The **Schema** property at index 0 indicates the type of object.

The **Dirty** property at index 1 indicates whether the object data has changed since the last time it was marked clean. This is used by controls to optimize screen drawing. A clean object does not require a total redraw.

The **Name** property at index 2 contain the resource ID of the string name of the object. The object name is a human-friendly name of the object for reference in scripts. Note that a resource ID is an integer that specifies a string, see Resources below.

The **Parent** property at index 3 specifies the parent object of this object, or 0 if this object is a root object.

Other types of objects have more properties. For example, a Habitat is an object that represents an environment. It has a property to hold its label. By convention, the source code defines constants for each property using the naming convention *Prefix*Index.*PropertyName*. For example, the schema property described above has a constant called *ObIndex.Schema*.

* Call **ObGet** to read a property value.
* Call **ObSet** to write a property value.

## Views

For performance reasons, the system maintains copies of data in "views" which are global arrays for fast lookup. Views are automatically updated whenever an object is modified using *ObSet*.

* The **vwPerSchema** view is a 2D array with a row for each schema and columns of each object of that schema. This view makes it faster to loop through all objects of a particular schema.

* The **vwPerParent** view is a 2D array with a row for each object and columns of each child object ID. This view makes it faster to find the child objects of a parent object.

## Assertions

An *assertion* is a declaration that a variable or parameter is required to conform to some condition. For example:

    DbAssert var > 1, "ProcName", "invalid var"

This statement is asserting that "var" must be greater than one. The first parameter is a boolean expression that is supposed to result in **True**. The second parameter is the name of the procedure containing the assertion. The third parameter is a string description. If the assertion is met, nothing happens. If the assertion fails, the location and description is displayed and the program terminates.

* **DbAssert** fails when the value is false.
* **DbPositive** fails when the value is zero or less.
* **DbFail** always fails.

Assertions can be disabled by globally replacing **Assert** with **'Assert** (converting them to comments). For this reason, assertions are subroutines, never functions. 

## String Resources

Most strings in the game are referenced as "resources".

* Call **RsCreate** to to save a string as a new resource. The function returns the unique ID of the resource.

* Call **RsGet** to fetch the string using by ID value.

* Call **RsSet** to update a resource.

Resource ID #0 is reserved for the empty string. If you fetch resource 0, an empty string is returned. If you set resource 0, an error occurs.

## Video Pages

The video API manages the text video pages used by the windowing system.

* **VdScreen** sets the active and visual pages. Always call this method instead of *SCREEN , , active%, visual%* to ensure the current page numbers are tracked.

* **VdPushActive** temporarily changes the active page without changing the visual page. Call **VideoPop** to restore the original active and visual pages.

* **VdAlloc** reserves the next available video page (0-4).

* **VideoFree** frees a reserved video page.

* Call **VdGetActive** and **VdGetVisual** to get the current active and visual video pages.

## Commands

**ExCmd** is the top-level subroutine for executing text commands. Commands are used in the following ways:

* A menu item can specify the command to execute when the item is selected.
* The configuration file (EMPIRE.CFG) is implemented as a sequence of commands.

To add a new command:

1. If your command is more complex than a few lines, then create a subroutine with the logic.
2. Add your command to the *SELECT* statement in to **ExTryCommand**.
3. If the command requires parameters, then examine the tokens() array that is passed to the subroutine. tokens(0) has the command name.
