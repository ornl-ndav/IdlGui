@idl_makefile

resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "read_bmp",/either
resolve_routine, "loadct",/either
resolve_routine, "xloadct",/either
resolve_routine, "xregistered",/either

save,/routines,filename = CurrentFolder + '/bss_selection.sav'
exit

