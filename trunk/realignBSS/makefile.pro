@idl_makefile

resolve_routine, "REVERSE",/either
resolve_routine, "loadct",/either
resolve_routine, "congrid",/either
resolve_routine, "strsplit", /either
resolve_routine, "xdisplayfile",/either
resolve_routine, "read_bmp", /either
resolve_routine, "cw_field", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either

save,/routines,filename = CurrentFolder + '/realignBSS.sav'
exit

