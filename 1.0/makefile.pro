@idl_makefile

resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either    
resolve_routine, "loadct", /either
resolve_routine, "congrid", /either
resolve_routine, "mean", /either
resolve_routine, "xloadct", /either
resolve_routine, "xregistered", /either
resolve_routine, "leefilt", /either
resolve_routine, "rot", /either

;resolve_all

save,/routines,filename = CurrentFolder + '/iMars.sav'
exit

