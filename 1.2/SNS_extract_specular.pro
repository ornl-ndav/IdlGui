;///////////////////////////////////////////
;SNS OFF SPECULAR ANALYSIS
;;extract the specular from a QXQZ data file
;ERIK WATKINS 9/21/2010
;//////////////////////////////////////////


function SNS_extract_specular, datafile, qxvec, qxwidth

si=size(datafile,/dim)
specular=make_array(si[1])
pos2=max(where(Qxvec le qxwidth))
pos1=min(where(Qxvec ge -qxwidth))

for loop=pos1,pos2 do begin
    specular=specular+datafile[loop,*]
endfor

return, specular

end