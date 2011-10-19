 @idl_makefile

resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "read_bmp",/either
resolve_routine, "loadct",/either
resolve_routine, "xloadct",/either
resolve_routine, "xregistered",/either
resolve_routine, "cw_field",/either
resolve_routine, "colorbar",/either
resolve_routine, "plot",/either
resolve_routine, "style_convert", /either

resolve_all, skip_routines=davegeneratlsettings__define

;build all the iProcedures
;itResolve

save,/routines,filename = CurrentFolder + '/bss_reduction.sav'
exit

