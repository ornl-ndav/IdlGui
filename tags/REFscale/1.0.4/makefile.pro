;Makefile that automatically compile the necessary modules
;and create the VM file.

@idl_makefile

resolve_routine, "strsplit",/either
resolve_routine, "loadct",/either
resolve_routine, "errplot",/either
resolve_routine, "read_bmp",/either
resolve_routine, "poly_fit",/either
resolve_routine, "uniq",/either
resolve_routine, "ref_scale", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either

save,/routines,filename = CurrentFolder + '/ref_scale.sav'
exit
