@idl_makefile

resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either

save,/routines,filename = CurrentFolder + '/gg.sav'
exit

