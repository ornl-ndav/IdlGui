;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/utilities/"
resolve_routine, "system_utilities", /either
resolve_routine, "nexus_utilities", /either
resolve_routine, "prenexus_utilities", /either
resolve_routine, "parsing_functions", /either

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/DataReduction/"
resolve_routine, "data_reduction_eventcb", /either
.run "data_reduction_eventcb"
resolve_routine, "data_reduction", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "read_bmp",/either
resolve_routine, "loadct",/either
resolve_routine, "xloadct",/either
resolve_routine, "xregistered",/either
resolve_routine, "errplot",/either
resolve_routine, "uniq",/either
save,/routines,filename="data_reduction.sav"
exit

