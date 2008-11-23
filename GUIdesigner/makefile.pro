@idl_makefile

;resolve_routine, "ref_reduction", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "xregistered",/either
resolve_routine, "CW_FIELD",/either

save,/routines,filename = 'guidesigner.sav'
exit

