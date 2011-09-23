; Filename: setdefault.pro
; Sprache: IDL 5
; Erzeugt: 2.10.1997 T. Weitkamp
; Zuletzt veraendert: 2.10.1997 T. Weitkamp ; Zweck: Nicht definierte Variable auf Defaultwert setzen ;
PRO setdefault, var, expr
  ; ** Falls keine Argumente: Hilfstext ausgeben
  IF N_PARAMS() EQ 0 THEN BEGIN
    PRINT, 'Usage:  SETDEFAULT, var, expr'
    PRINT, 'Input:  var   Any variable'
    PRINT, '        expr  Any expression'
    PRINT, 'Output: var   If defined before, remains unchanged.'
    PRINT, '              Otherwise, equals expr.'
    RETALL
  ENDIF
  ; ** Wenn kein Defaultwert angegeben, Defaultwert gleich 0 setzen
  IF NOT var_defined(expr) THEN expr = 0
  ; ** Variable mit Defaultwert belegen, falls sie nicht definiert ist
  IF NOT var_defined(var) THEN var = expr
  END
