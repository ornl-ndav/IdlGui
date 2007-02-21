;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/REF/"
resolve_routine, "extract_data_eventcb", /either
.run "extract_data_eventcb"
resolve_routine, "extract_data", /either
resolve_routine, "strsplit",/either
resolve_routine, "xmanager",/either
resolve_routine, "cw_bgroup",/either
resolve_routine, "reverse", /either
resolve_routine, "xloadct",/either
resolve_routine, "congrid",/either
resolve_routine, "loadct",/either
resolve_routine, "xregistered",/either
resolve_routine, "errplot",/either
resolve_routine, "uniq",/either
;resolve_all, "isurface",/either
; resolve_routine, "_idlitsys_getsystem",/either
; resolve_routine, "idlitsystem__define",/either
; resolve_routine, "idlitimessaging__define",/either
; resolve_routine, "_idlitobjdescregistry__define",/either
; resolve_routine, "_idlitcontainer__define",/either
; resolve_routine, "idlitcontainer__define",/either
; resolve_routine, "idlitbasename",/either
; resolve_routine, "idlitgetuniquename",/either
; resolve_routine, "idlitdatamanagerfolder__define",/either
; resolve_routine, "idliterror__define",/either
; resolve_routine, "idlitmessage__define",/either
; resolve_routine, "idlituisystem",/either
; resolve_routine, "idlitui__define",/either
; resolve_routine, "idlituiadaptor__define",/either
; resolve_routine, "idlitgetresource",/either
; resolve_routine, "idlitobjdesctool__define",/either
; resolve_routine, "idlitobjdesc__define",/either
; resolve_routine, "idlitpropertybag__define",/either
; resolve_routine, "idlitregroutine__define",/either
; resolve_routine, "idlitobjdescvis__define",/either
; resolve_routine, "idlitobjdescroi__define",/either
; resolve_routine, "idlitsrvlangcat__define",/either
; resolve_routine, "idlitoperation__define",/either
; resolve_routine, "idlfflangcat__define", /either
; resolve_routine, "idlitsrvsystemclipcopy__define",/either
; resolve_routine, "idlitsrvcopywindow__define",/either
; resolve_routine, "idlitsrvprinter__define",/either
; resolve_routine, "idlitsrvrasterbuffer__define",/either
; resolve_routine, "idlitopscale__define",/either
; resolve_routine, "idlitopannotation__define",/either
; resolve_routine, "idlitsrvcreatevisualization__define",/either
;resolve_routine, "idlitsrvcreatedataspace__define",/either
save,/routines,filename="extract_data.sav"
exit
