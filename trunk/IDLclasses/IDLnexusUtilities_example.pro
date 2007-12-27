;This module can be used as an instruction on how to use the 
;IDLnexusUtilities class and its various methods
;Requirements: having the following function in the default path
;        - findnexus (version 1.3 or higher)

;check requirements
;findnexus version but be 1.3 or higher
spawn, 'findnexus --version', listening, err_listening
if (err_listening[0] NE '') then begin
    with_findnexus = 0
    print, 'findnexus could not be found in the path'
    print, '--> The methods using findnexus will be unavailable on this system'
endif else begin
    FNversion = float(listening[0])
    print, 'findnexus --version: ' + strcompress(FNversion,/remove_all)
    if (FNversion LT 1.3) then begin
        with_findnexus = 0
        print, '--> The methods using findnexus will be unavailable on this system'
    endif else begin
        with_findnexus = 1
    endelse
endelse

;;IDLnexusUtilities examples
print, '>>Reset IDL session'
print, '.reset'

print, '>>Compile IDLnexusUtilities class'
print, '.compile IDLnexusUtilities__define'

print, '>>Create an instance of the IDLnexusUtilities class'
print, "instance1 = obj_new('IDLnexusUtilities',350,instrument='BSS')"

if (with_findnexus) then begin
    print, '> Get archived nexus path: instance1->getArchivedNeXusPath()'
    print, '> List All NeXus path    : + instance1->getFullListNeXusPath()'
endif

end
