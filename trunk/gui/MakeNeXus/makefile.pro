;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/MakeNeXus/"
resolve_routine, "make_nexus_eventcb", /either
.run "make_nexus_eventcb"
resolve_routine, "make_nexus", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
save,/routines,filename="make_nexus.sav"
exit
