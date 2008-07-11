function modtag, init_str
  ;remove any spaces on ends
  init_str = STRTRIM(init_str, 2)
  ;locate semicolon
  colon_pos = strpos(init_str, ':')
  ;find size of the array
  arrsize = N_ELEMENTS(init_str)
  ;make sure to return something
  new_str = init_str
  
  ;if input is an array, remove semicolons form ends of each element
  if arrsize ne 1 then begin
  
    for i = 0, arrsize - 1 do begin
    
      colon_pos = strpos(init_str[i], ':')
      length = strlen(init_str[i])
      
      if colon_pos ne -1 then begin
        if colon_pos eq (length-1) then begin
          new_str[i] = strmid(init_str[i], 0, colon_pos)
        endif
        if colon_pos eq 0 then begin
          new_str[i] = strmid(init_str[i], colon_pos + 1)
        endif
      endif
      
    endfor
    
  ;if input is just a string, do the same
  endif else begin
  
    length = strlen(init_str)
    
    if colon_pos ne -1 then begin
      if colon_pos eq (length-1) then begin
        new_str = strmid(init_str, 0, colon_pos)
      endif
      if colon_pos eq 0 then begin
        new_str = strmid(init_str, colon_pos + 1)
      endif
      
    endif
  endelse
  
  ;trim any spaces on ends
  new_str = strtrim(new_str, 2)
  return, new_str
  
  
end

FUNCTION READ_DATA, file, half
  ;Open the data file.
  OPENR, 1, file
  
  print, "READING"
  
  ;Set up variables
  line = strarr(1)
  line2 = strarr(1)
  tmp = ''
  i = 0
  
  ;Read the comments from the file until blank line
  WHILE(~EOF(1)) DO BEGIN
    READF,1,tmp
    ;Check for blank line
    if (tmp EQ '') then begin
      if half eq 2 then begin
        i = 0
        WHILE(~EOF(1)) DO BEGIN
          READF,1,tmp
          if (i eq 0) then begin
            line2[i] = tmp
            i = 1
          endif else begin
            line2 = [line2, tmp]
          endelse
        ENDWHILE
      endif else begin
        break
      endelse
    endif
    ;Put data in a string array
    if (i eq 0) then begin
      line[i] = tmp
      i = 1
    endif else begin
      line = [line, tmp]
    endelse
  ENDWHILE
  
  
  print, "DONE"
  
  
  ;Close file and return the string
  close, 1
  if half eq 1 then return, line
  if half eq 2 then return, line2
END

function format, init_str, tag
  ;find out where tag ends
  pos = STRLEN(tag)
  ;make a string with the comment
  new_str = strmid(init_str, pos)
  ;call modtag to remove semicolons
  new_str = modtag(new_str)
  
  return, new_str
  
end

Function find_it, init_str, tag


  ;get number of elements in array
  n = N_ELEMENTS(init_str)
  i = 0
  flag = 1
  new_str = strarr(1)
  
  ; Go through the array and find all occurances of the tag
  while (i NE n) do begin
    pos = STRPOS(init_str[i], tag)
    if pos ne -1 then BEGIN
      if flag eq 1 then begin
        new_str[0] = init_str[i]
        flag = 0
      endif else begin
        new_str = [new_str,init_str[i]]
      endelse
    endif
    i = i+ 1
  endwhile
  
  ;cut out the tag
  new_str = format(new_str, tag)
  return, new_str
  
end



function arrange, data

  ;seperate comments from actual data
  n = N_ELEMENTS(data)
  comments = data[0 : 2]
  just_data = data[3 : n-1]
  
  
  ;put data into a float array
  lines = n_elements(just_data)-1
  array = fltarr(lines, 3)
  for i = 0, lines-1 do begin
    temp = just_data[i]
    limit = n_elements(temp)
    for b = 0, limit- 1 do begin
      array[i,b] = temp[b]
    endfor
  endfor
  
  
  
  
  
  ;parse the comments
  tmp = ptrarr(3, /allocate_heap)
  for i = 0, 2 do begin
    *tmp[i] =  strtrim(STRSPLIT(comments[i], '(,)', /extract, /PRESERVE_NULL), 2)
  endfor
  
  
  ;  *tmp[i] =  strtrim(STRSPLIT(all_data[i], '(,)', /extract), 2)
  ; strtrim(STRSPLIT(all_data[2], '()', /extract), 2)
  
  ; lines = n_elements(comments)-1
  
  ; for i = 3, lines do begin
  ;   temp =  float(STRSPLIT(comments[start], /extract, /PRESERVE_NULL))
  ;   print, temp
  ;   print, double(temp)
  ;   new[i] = temp
  ; endfor
  
  
  ;Put it all into a structure
  Struct = { Value: array,$
    x: (*tmp[0])[3],$
    y: (*tmp[0])[4],$
    bank: (*tmp[0])[1]}
    
    
  return, Struct
end

function break_off, data

  print, "STARTING BREAK_OFF"
  cntblanks = 0
  data_size = n_elements(data)
  
  ;count the blank lines in the file
  for i = 0, data_size-1 do begin
    if data[i] eq '' then begin
      cntblanks++
    endif
  endfor
  
  ;Divide the text into datasets
  pntr = ptrarr(cntblanks, /allocate_heap)
  temp = strarr(1)
  start_at = 1
  b = 0
  i = 0
  While i ne cntblanks do begin
    while b ne data_size do begin
      if data[b] ne '' then begin
        temp = [temp,data[b]]
      endif else begin
        break
      endelse
      b++
    endwhile
    end_at = n_elements(temp) - 1
    *pntr[i] = temp[start_at : end_at]
    start_at = end_at +1
    b++
    i++
  endwhile
  print, "DONE"
  print, "=============================================="
  return, pntr
end


function IDL3columnsASCIIparser::getData
  all_data = READ_DATA(self.path, 2)
  ; for i = 0, n_elements(all_data) - 1 do begin
  ; print, all_data[i]
  ; endfor
  
  ;break off into an array of pointers
  data = break_off(all_data)
  n = n_elements(data)
  
  ; Organize the data into structures instead of arrays
  for i = 0, n-1 do begin
    *data[i] = arrange(*data[i])
  endfor
 
  
  ;value = parseData(all_data)
  ;n_arrays = 10
  ;tmp = ptrarr(3, /allocate_heap)
  ;for i = 0, 2 do begin
  ; *tmp[i] =  strtrim(STRSPLIT(all_data[i], '(,)', /extract), 2)
  ;endfor
  
  ; *tmp[i] =  strtrim(STRSPLIT(all_data[i], '(,)', /extract), 2)
  ;strtrim(STRSPLIT(all_data[2], '()', /extract), 2)
  
  ;print, (*tmp[0])
  ;print, (*tmp[0])[1]
  ;print, (*tmp[1])
  ;print, (*tmp[2])
  ;print, (*tmp[2])[3]
  ;*tmp[1] = STRSPLIT((*tmp[1])[0],/extract)
  ;print, (*tmp[1])[1]
  
  
  ;Put variables in a structure
  MyStruct = { NbrArray:    n,$
    xaxis:       '', $
    xaxis_units: '',$
    yaxis:       '', $
    yaxis_units: '',$
    sigma_yaxis: '',$
    sigma_yaxis_units: '',$
    Data:        data}
    
    
    
    
    
    
  ;title:       (*tmp[0])[0], $
  ;bank:        (*tmp[0])[1], $
    
    
    
   print, (*MyStruct.data[0]).bank
   return, MyStruct
end


function IDL3columnsASCIIparser::get_tag, tag
  ;remove semicolon from tag
  tag = modtag(tag)
  ;read data into array
  data = READ_DATA(self.path, 1)
  ;find and format data
  output = find_it(data, tag)
  return, output
end



function IDL3columnsASCIIparser::init, location
  ;set up the path
  self.path = location
  return, file_test(location, /read)
End


pro IDL3columnsASCIIparser__define
  struct = {IDL3columnsASCIIparser,$
    path: ''}
end





