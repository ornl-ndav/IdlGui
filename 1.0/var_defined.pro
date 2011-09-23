 ; FUNKTION:    VAR_DEFINED
; SPRACHE:  IDL 4
; ZWECK:    Herausfinden, ob eine Variable definiert ist
;
; ARGUMENT: x   beliebiger Variablenname
; ERGEBNIS: 0   wenn x nicht definiert ist,
;     1    wenn x definiert ist.
;
; AUTOR/DATUM   T. Weitkamp, 30. Mai 1997
;
FUNCTION var_defined, x
  sizeresult=size(x)
  RETURN, sizeresult(1) GT 0
END
