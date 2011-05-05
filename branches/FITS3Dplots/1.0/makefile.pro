@idl_makefile_application

resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "LOADCT", /either
resolve_routine, "CW_FIELD", /either
resolve_routine, "CONGRID", /either

save,/routines,filename = CurrentFolder + '/fits_tools.sav'
exit

