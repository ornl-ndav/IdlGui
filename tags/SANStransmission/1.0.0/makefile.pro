@idl_makefile

resolve_routine, "strsplit", /either
resolve_routine, "xdisplayfile",/either
resolve_routine, "cw_field", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "loadct",/either
resolve_routine, "errplot",/either
resolve_routine, "poly_fit",/either
resolve_routine, "GET_SCREEN_SIZE",/either

save,/routines,filename = CurrentFolder + '/sans_transmission.sav'
exit

