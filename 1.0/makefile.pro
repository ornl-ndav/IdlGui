@idl_makefile

resolve_routine, "strsplit", /either
resolve_routine, "xdisplayfile",/either
resolve_routine, "cw_field", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either

save,/routines,filename = CurrentFolder + '/sans_reduction.sav'
exit

