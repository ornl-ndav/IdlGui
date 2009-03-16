@idl_makefile

resolve_routine, "loadct", /either
resolve_routine, "strsplit", /either
resolve_routine, "xdisplayfile",/either
resolve_routine, "read_bmp", /either
resolve_routine, "cw_field", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "CONGRID", /either
resolve_routine, "XDISPLAYFILE", /either
resolve_routine, "ARRAY_INDICES", /either
resolve_routine, "REVERSE", /either
resolve_routine, "POLY_FIT", /either
resolve_routine, "UNIQ", /either
resolve_routine, "MEAN", /either
resolve_routine, "MOMENT", /either
resolve_routine, "ERRPLOT", /either

save,/routines,filename = CurrentFolder + '/ref_off_spec.sav'
exit

