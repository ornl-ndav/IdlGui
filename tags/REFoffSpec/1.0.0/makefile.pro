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

save,/routines,filename = CurrentFolder + '/ref_off_spec.sav'
exit

