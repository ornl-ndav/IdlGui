@idl_makefile

resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "strsplit", /either

save,/routines,filename = CurrentFolder + '/need_help.sav'
exit

