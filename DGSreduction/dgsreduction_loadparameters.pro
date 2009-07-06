;+
; :Description:
;    Loads a configuration from file.
;
; :Params:
;    event
;
; :Author: scu
;-
PRO DGSreduction_LoadParameters, event
  
  ; Just extract the widgetbase from the event and call the load routine
  load_parameters, event.top
  
END