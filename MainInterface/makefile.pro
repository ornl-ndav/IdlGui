;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/MainInterface/"
resolve_routine, "main_interface_eventcb", /either
.run "main_interface_eventcb"
resolve_routine, "main_interface", /either
resolve_routine, "READ_BMP",/either
resolve_routine, "xmanager",/either
resolve_routine, "strsplit",/either
save,/routines,filename="main_interface.sav"
exit
