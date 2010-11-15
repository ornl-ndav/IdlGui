@idl_makefile

resolve_routine, "loadct",/either
resolve_routine, "CONGRID",/either
resolve_routine, "MEAN",/either
resolve_routine, "strsplit", /either
resolve_routine, "cw_field", /either
resolve_routine, "xmanager", /either
resolve_routine, "colorbar", /either
resolve_routine, "uniq", /either
resolve_routine, "plot", /either
resolve_routine, "style_convert", /either
resolve_routine, "graphic", /either
resolve_routine, "graphic__define", /either
resolve_routine, "igetcurrent", /compile_full_file, /either
resolve_routine, "_idlitsys_getsystem", /either
resolve_routine, "reverse", /either
resolve_routine, "cvttobm", /either
resolve_routine, "get_screen_size", /either
resolve_routine, "identity",/either
resolve_routine, "map_proj_init_common", /either

;build all the iProcedures
;itResolve

spawn, 'pwd', current_path

save,/routines,filename =  current_path + '/sos.sav'
exit

