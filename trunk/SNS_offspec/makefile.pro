@idl_makefile

resolve_routine, "loadct",/either
resolve_routine, "CONGRID",/either
resolve_routine, "MEAN",/either

save,/routines,filename = CurrentFolder + '/sns_offspec.sav'
exit

