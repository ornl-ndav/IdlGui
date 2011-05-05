pro read_tif
compile_opt idl2

end_number = 40

base_file = '~/Venus/Jagjit_Nanda/flat2/bat'
ext = '.tif'


for i=0,end_number do begin


digit = string(format='(i03)', i)

_file = base_file + strcompress(digit,/remove_all) + ext
print, _file 
_data = read_tiff(_file)
if (i eq 0) then begin
im1 = image(_data,zvalue=2*i)
endif else begin
im1 = image(_data,zvalue=2*i,/over)
endelse

endfor




end