@echo off

if "%1" == ""         goto :config
if "%1" == "h"        goto :configHabitats
if "%1" == "hab"      goto :configHabitats
if "%1" == "habitat"  goto :configHabitats
if "%1" == "habitats" goto :configHabitats
if "%1" == "i"        goto :configInbox
if "%1" == "inbox"    goto :configInbox
if "%1" == "m"        goto :configMenu
if "%1" == "menu"     goto :configMenu
if "%1" == "menus"    goto :configMenu
if "%1" == "p"        goto :configPersonas
if "%1" == "per"      goto :configPersonas
if "%1" == "persona"  goto :configPersonas
if "%1" == "personas" goto :configPersonas

:config
  qbasic /editor empire.cfg
  goto :done

:configHabitats
  qbasic /editor habitats.cfg
  goto :done

:configInbox
  qbasic /editor inbox.cfg
  goto :done

:configMenu
  qbasic /editor menu.cfg
  goto :done

:configPersonas
  qbasic /editor personas.cfg
  goto :done

:done

