;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/utilities/"
.run "nexus_utilities"
.run "system_utilities"

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/"
resolve_routine, "more_nexus_eventcb", /either
.run "more_nexus_eventcb"
resolve_routine, "more_nexus", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "REVERSE",/either
resolve_routine, "read_bmp",/either
save,/routines,filename="more_nexus.sav"
exit
