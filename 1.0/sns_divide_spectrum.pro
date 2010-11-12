;///////////////////////////////////////////
;SNS OFF SPECULAR ANALYSIS
;Divide data by a 2 column spectrum
;ERIK WATKINS 9/21/2010
;//////////////////////////////////////////


function SNS_divide_spectrum, data, spectrum

si=size(data.data,/dim)

ndata=data

for loop=0,si[1]-1 do begin
    ndata.data[*,loop]=data.data[*,loop]/spectrum[1,*]
endfor

return, ndata
end