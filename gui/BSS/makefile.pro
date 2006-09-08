;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/BSS/"
resolve_routine, "plot_data_eventcb", /either
.run "plot_data_eventcb"
resolve_routine, "plot_data", /either
resolve_routine, "loadct",/either
resolve_routine, "strsplit",/either
resolve_routine, "xmanager",/either
save,/routines,filename="plot_data.sav"
exit
