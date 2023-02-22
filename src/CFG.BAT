@echo off

if "%1" == ""         goto :config

if "%1" == "d"        goto :configDialog
if "%1" == "dia"      goto :configDialog
if "%1" == "dlg"      goto :configDialog
if "%1" == "dialog"   goto :configDialog
if "%1" == "h"        goto :configHabitats
if "%1" == "hab"      goto :configHabitats
if "%1" == "habitat"  goto :configHabitats
if "%1" == "habitats" goto :configHabitats
if "%1" == "i"        goto :configInbox
if "%1" == "inbox"    goto :configInbox
if "%1" == "m"        goto :configMenu
if "%1" == "menu"     goto :configMenu
if "%1" == "menus"    goto :configMenu
if "%1" == "p"        goto :configPersons
if "%1" == "per"      goto :configPersons
if "%1" == "person"   goto :configPersons
if "%1" == "persons"  goto :configPersons
if "%1" == "people"   goto :configPersons
if "%1" == "*"        goto :dirCFG
if "%1" == "dir"      goto :dirCFG

:config
  qbasic /editor empire.cfg
  goto :done

:configDialog
  qbasic /editor empire.dlg
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

:configPersons
  qbasic /editor persons.cfg
  goto :done

:dirCFG
  dir *.cfg
  goto :done
:done
