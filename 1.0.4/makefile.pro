@idl_makefile

resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "LOADCT", /either
resolve_routine, "ERRPLOT", /either
resolve_routine, "CW_FIELD", /either

save,/routines,filename = CurrentFolder + '/plot_ascii.sav'
exit

