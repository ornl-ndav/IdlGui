;+
; :Description:
;    Prints out the present working directory.
;
; :Author: scu
;-
PRO pwd
  CD,CURRENT=thisDirectory
  PRINT, thisDirectory
END
