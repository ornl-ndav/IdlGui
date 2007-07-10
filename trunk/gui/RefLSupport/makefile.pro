;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.

;cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/utilities/"
;.run "nexus_utilities"
;.run "system_utilities"

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/RefLSupport/"
resolve_routine, "ArrayDelete",/either
resolve_routine, "refl_support_fit",/either
resolve_routine, "refl_support_plot_data",/either
resolve_routine, "refl_support_widget",/either
resolve_routine, "refl_support_eventcb", /either
.run "refl_support_eventcb"
resolve_routine, "refl_support", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
save,/routines,filename="refl_support.sav"
exit
