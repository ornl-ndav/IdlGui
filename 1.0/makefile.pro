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
resolve_routine, "graphic", /compile_full_file, /either
resolve_routine, "graphic__define", /compile_full_file, /either
resolve_routine, "igetcurrent", /compile_full_file, /either
resolve_routine, "_idlitsys_getsystem", /compile_full_file, /either
resolve_routine, "reverse", /compile_full_file, /either
resolve_routine, "cvttobm", /compile_full_file, /either
resolve_routine, "get_screen_size", /compile_full_file, /either
resolve_routine, "identity", /compile_full_file, /either
resolve_routine, "map_proj_init_common", /compile_full_file, /either

spawn, 'pwd', current_path

save,/routines,filename =  current_path + '/sos.sav'
exit

