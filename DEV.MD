
This file contains development tips.

## Implemening Commands

ExecCmd(text$) is the top-level subroutine for executing simple text commands such as "Atlas". Commands are used in the following ways:

* A menu item can specify the command to execute when the item is selected.
* The configuration file (EMPIRE.CFG) is implemented as a sequence of commands.

To add a new command:

1. If your command is more complex than a few lines, then create a subroutine with the logic.
2. Determine the context of your command (most likely global):

* ExecCmdGlobal .............. Default 
* ExecCmdHabitat ............. Configuring habitat properties
* ExecCmdWindow .............. Configuring window properties
* ExecCmdField ............... Configuring field properties

3. Add an entry for the new command in the SELECT statement of the applicable subroutine. If the command requires parameters, then examine the token() array that is passed to the subroutine. token(1) contains the command name and token (2+) contains the parameters.



