;///////////////////////////////////////////
;SNS OFF SPECULAR ANALYSIS
;Divide data by a 2 column spectrum
;ERIK WATKINS 9/21/2010
;//////////////////////////////////////////


function SNS_divide_spectrum, data, spectrum

si=size(data.data,/dim)
ndata=data

_spectrum = reform(spectrum[1,0:-2]) 

for loop=0,si[1]-1 do begin ;loop is the number of pixels for each data file
;  data.data[10,loop] = 45
;  ndata.data[*,loop] = 0.0
  ndata.data[*,loop]=data.data[*,loop]/spectrum[1,*]
  ndata.data[*,loop]=data.data[*,loop]/_spectrum[*]

  ;make sure we do the ratio only where there is a data value and a $
  ;defined spectrum value

  index_nonull = where((data.data[*,loop] ne 0) AND finite(_spectrum[*]), count)
  if (count gt 0) then begin
  ndata.data[index_nonull,loop] = data.data[index_nonull,loop] / $
  _spectrum[index_nonull]
  endif

endfor

return, ndata

end