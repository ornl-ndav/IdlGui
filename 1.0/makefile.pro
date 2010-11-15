@idl_makefile

resolve_routine, "loadct",/either
resolve_routine, "CONGRID",/either
resolve_routine, "MEAN",/either
resolve_routine, "strsplit", /either
resolve_routine, "cw_field", /either
resolve_routine, "xmanager", /either
resolve_routine, "colorbar", /either


spawn, 'pwd', current_path

save,/routines,filename =  current_path + '/sos.sav'
exit

