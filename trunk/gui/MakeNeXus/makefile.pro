;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/MakeNeXus/"
resolve_routine, "rebin_nexus_eventcb", /either
.run "rebin_nexus_eventcb"
resolve_routine, "rebin_nexus", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
save,/routines,filename="rebin_nexus.sav"
exit
