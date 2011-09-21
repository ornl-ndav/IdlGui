@idl_makefile

resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either    

save,/routines,filename = CurrentFolder + '/dad.sav'
exit

