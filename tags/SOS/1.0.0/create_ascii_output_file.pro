;+
; :Description:
;   this routine will create an ascii file of the data as follow
;   column1: Qx axis
;   column2: Qz axis
;   column3-n: data with each row is 1 Qx and each column is 1 Qz
;
; :Keywords:
;    data
;    Qx
;    Qz
;
; :Author: j35
;-
pro create_ascii_output_file, data=data, Qx=Qx, Qz=Qz
  compile_opt idl2
  
  output_file_name = '~/results/SNS_offspec_output_ascii.txt'
  
  sz_x = n_elements(Qx)
  sz_z = n_elements(Qz)
  
  ;create ascii array
  output_array = strarr(max([sz_x,sz_z]))
  index = 0
  while (index lt max([sz_x,sz_z])) do begin
  
    if (index ge sz_x) then begin
      x = ''
    endif else begin
      x = strcompress(Qx[index],/remove_all)
    endelse
    
    if (index ge sz_z) then begin
      z = ''
    endif else begin
      z = strcompress(Qz[index],/remove_all)
    endelse
    
    if (index ge sz_x) then begin
      data_part = ''
    endif else begin
      data_part = strjoin(strcompress(reform(data[index,*]),/remove_all),' ')
    endelse
    
    output_array[index] = x + ' ' + z + ' ' + data_part
    
    index++
  endwhile
  
  ;prepare file to write in
  openw, 1, output_file_name
  
  sz = n_elements(output_array)
  _index = 0
  while (_index lt sz) do begin
  
    printf, 1, output_array[_index]
    
    _index++
  endwhile
  
  close, 1
  free_lun, 1
  
end