@idl_makefile
spawn, 'pwd', CurrentFolder

resolve_routine, "rebin_nexus_eventcb", /either
resolve_routine, "rebin_nexus", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "REVERSE",/either
resolve_routine, "read_bmp",/either
resolve_routine, "cw_field",/either

save,/routines,filename= CurrentFolder + '/rebin_nexus.sav'
exit
