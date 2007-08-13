;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/utilities/"
.run "system_utilities"
.run "nexus_utilities"
.run "prenexus_utilities"
.run "parsing_functions"

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/REFreduction/"
resolve_routine, "ref_reduction_eventcb", /either
.run "ref_reduction_eventcb"
resolve_routine, "ref_reduction", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "read_bmp",/either
resolve_routine, "loadct",/either
resolve_routine, "xloadct",/either
resolve_routine, "xregistered",/either
resolve_routine, "errplot",/either
resolve_routine, "uniq",/either
resolve_routine, "ZOOM",/either

save,/routines,filename="ref_reduction.sav"
exit

