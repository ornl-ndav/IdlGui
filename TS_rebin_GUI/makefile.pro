@idl_makefile

;resolve_routine, "ref_reduction", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "LOADCT", /either

save,/routines,filename = CurrentFolder + '/ts_rebin.sav'
exit
