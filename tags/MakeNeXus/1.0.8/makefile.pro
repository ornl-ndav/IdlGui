@idl_makefile

resolve_routine, "STRSPLIT", /either
resolve_routine, "REVERSE", /either
resolve_routine, "CW_FIELD", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either

save,/routines,filename = CurrentFolder + '/makenexus.sav'
exit

