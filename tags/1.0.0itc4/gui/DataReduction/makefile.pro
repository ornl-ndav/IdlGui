;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/DataReduction/"
resolve_routine, "data_reduction_eventcb", /either
.run "data_reduction_eventcb"
resolve_routine, "data_reduction", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "read_bmp",/either
resolve_routine, "loadct",/either
save,/routines,filename="data_reduction.sav"
exit
