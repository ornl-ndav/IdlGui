@idl_makefile

resolve_routine, "strsplit", /either
resolve_routine, "cw_field", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "loadct",/either
resolve_routine, "errplot",/either
resolve_routine, "CONGRID",/either
resolve_routine, "MEAN",/either
resolve_routine, "MOMENT", /either

save,/routines,filename = CurrentFolder + '/sans_reduction.sav'
exit

