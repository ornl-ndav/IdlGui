;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/REF/"
resolve_routine, "extract_data_eventcb", /either
resolve_routine, "extract_data", /either
resolve_routine, "strsplit",/either
resolve_routine, "cw_bgroup",/either
resolve_routine, "reverse",/either
resolve_routine, "xloadct",/either
resolve_routine, "congrid",/either
resolve_routine, "loadct",/either
resolve_routine, "xregistered",/either
resolve_routine, "errplot",/either
resolve_routine, "xmanager",/either
save,/routines,filename="extract_data.sav"
exit
