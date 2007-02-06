;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/MakeNeXus/BSSrebinNeXus/"
resolve_routine, "bss_rebin_nexus_eventcb", /either
.run "bss_rebin_nexus_eventcb"
resolve_routine, "bss_rebin_nexus", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "REVERSE",/either
save,/routines,filename="bss_rebin_nexus.sav"
exit
