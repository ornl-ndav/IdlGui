;$Id$

;Makefile that automatically compile RealignGUI.pro
;and create the VM file

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/utilities/"
resolve_routine, "system_utilities", /either

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/BSS/"
resolve_routine, "xmanager", /either
resolve_routine, "reverse", /either
resolve_routine, "loadct", /either
resolve_routine, "congrid", /either
resolve_routine, "hist_equal",/either
resolve_routine, "xloadct",/either
resolve_routine, "xregistered",/either
resolve_routine, "strsplit", /either
.run "RealignGUI_eventcb.pro"
.run "RealignGUI.pro"
resolve_routine, "CW_BGROUP", /either
save,/routines,filename="RealignGUI.sav"

exit
