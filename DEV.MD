
Note: moving comments from source code to reduce size. This file will contain development tips.

## Implemening Commands

Every user action maps to a command defined in the Command.* constants. To create a new command:

1. Review the Command.* global constants and add an entry for the new command. Command values must be unique.
  
2. Define Command.* constants alphabetically and renumber the values whenever a new command is added. This will intentionally cause problems when code improperly uses literal command values instead of their constants. Fix any such cases so the code is immune to future value changes.

3. Optional. If you want reference the command in the DATA window definitions, then update WinParseCommand to translate a string name into its constant value.
  
4. Add an entry to the SELECT statement in the Execute() subroutine. If the implementation is a one-liner, then call the code directly in Execute. Otherwise create a new subroutine named ExecuteXXX where XXX matches the constant command name. For example, Command.About is a one-liner executed directly in Execute() whereas Command.OptionsAlert is implemented in ExecuteOptionsAlert (which is called from Execute).