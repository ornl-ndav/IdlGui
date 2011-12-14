;+
; :Description:
;    this procedure will remove the un-necessary tags from the
;    comment part of the file and will add some necessary information
;
; :Params:
;    event
;    reduce_file
;
;
;
; :Author: j35
;-
pro reformatRTOF, event=event, reduce_file=reduce_file
  compile_opt idl2
  
  new_arg = strarr(4)
  if (keyword_set(event)) then begin
    dirpix = getValue(event=event, uname='info_dirpix')
    refpix = getValue(event=event, uname='info_refpix')
    dangle = getValue(event=event, uname='info_dangle_deg')
    dangle0 = getvalue(event=event, uname='info_dangle0_deg')
    new_arg[0] = "#C Ref Dangle (Dangle) (deg): " + dangle
    new_arg[1] = "#C Dir Dangle (Dangle0) (deg): " + dangle0
    new_arg[2] = "#C DirPix: " + dirpix
    new_arg[3] = "#C RefPix: " + refpix
  endif else begin
    new_arg[0] = "#C Ref Dangle (Dangle) (deg): 1.23"
    new_arg[1] = "#C Dir Dangle (Dangle0) (deg): 4.56"
    new_arg[2] = "#C DirPix: 111"
    new_arg[3] = "#C RefPix: 222"
  endelse
  
  ;modify file name
  ;remove ext (.txt) and replace by (.rtof)
  reduce_file_array = strsplit(reduce_file,'.',/extract)
  sz = size(reduce_file_array,/dim)
  if (sz gt 1) then begin
    base_file_name = strjoin(reduce_file_array[0:sz-2],'.')
    rtof_file_name = base_file_name + '.rtof'
  endif else begin
    rtof_file_name = reduce_file_array[0] + '.rtof'
  endelse
  
  ;if the file does not exist, just quit reformatRTOF
  if ~file_test(rtof_file_name) then return
  
  nbr_lines = file_lines(rtof_file_name)
  my_array = strarr(1,nbr_lines)
  openr, 1, rtof_file_name
  readf, 1, my_array
  close, 1
  
  ;locate the first empty line
  index_empty_line = -1
  for i=0, (nbr_lines-1) do begin
    if (strcompress(my_array[i],/remove_all) eq '') then begin
      index_empty_line = i
      break
    endif
  endfor
  
  ;now look for the line to remove
  new_array = !NULL
  for i=0, (index_empty_line-1) do begin
    _line = my_array[i]
    result = strmatch(_line,'#C norm dtheta: *')
    if (result eq 1) then begin
      _firt_found = 0b
      ;add new arguments here
      new_array = [new_array, new_arg]
      i+= 5
    endif else begin
      new_array = [new_array, _line]
    endelse
  endfor
  
end

;+
; :Description:
;    Just for debugging
;
; :Author: j35
;-
pro exec
  compile_opt idl2
  
  reduce_file = '~/results/REF_M.rtof'
  reformatRTOF, reduce_file=reduce_file
  
end