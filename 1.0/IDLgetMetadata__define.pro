;***** Class constructor ******
FUNCTION IDLgetMetadata::init, nexus_full_path

;get angle
;get s1
;get s2

RETURN, 1
END





PRO IDLgetMetadata__define
define = {IDLgetMetdata,$
          nexus_full_path : '',$
          angle           : '',$
          S1              : '',$
          S2              : ''}
END
