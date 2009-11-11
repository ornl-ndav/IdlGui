@idl_makefile

resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "XDISPLAYFILE", /either

save,/routines,filename = CurrentFolder + '/cloopes.sav'
exit

