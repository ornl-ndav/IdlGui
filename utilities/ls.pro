;+
; :Description:
;    List the contents of the current directory.
;
; :Params:
;    name - An optional string specifying the names of the files to
;           be listed.  Wild cards are allowed. For example,
;           ls,'*.pro' will list all files ending in .pro.
;
; :Author: scu
;-
PRO ls, name

on_error,2

if (n_params() eq 0) then begin

    if (!version.os_family eq 'unix') then name='' else name='*'

endif



if !version.os_family eq 'unix' then begin

    command='ls '+name

    spawn,command

endif else begin

    ff=findfile(name)

    more,ff

endelse

end

