@mini_idl_makefile

resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "read_bmp",/either
resolve_routine, "loadct",/either
resolve_routine, "xloadct",/either
resolve_routine, "xregistered",/either
resolve_routine, "errplot",/either
resolve_routine, "uniq",/either
resolve_routine, "ZOOM",/either
resolve_routine, "CW_FIELD",/either

save,/routines,filename = CurrentFolder + '/mini_ref_reduction.sav'
exit

