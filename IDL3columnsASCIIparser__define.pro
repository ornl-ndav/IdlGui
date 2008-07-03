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

FUNCTION READ_DATA, file

  ;Open the data file.
  OPENR, 1, file
  
  ;Set up variables
  line = strarr(1)
  tmp = ''
  i = 0
  
  ;Read the comments from the file until blank line
  WHILE(~EOF(1)) DO BEGIN
    READF,1,tmp
    ;Check for blank line
    if (tmp EQ '') then break
    ;Put data in a string array
    if (i eq 0) then begin
      line[i] = tmp
      i = 1
    endif else begin
      line = [line, tmp]
    endelse
  ENDWHILE
  
  ;Close file and return the string
  close, 1
  return, line
  
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



function IDL3columnsASCIIparser::get_tag, tag
  ;remove semicolon from tag
  tag = modtag(tag)
  ;read data into array
  data = READ_DATA(self.path)
  ;find and format data
  output = find_it(data, tag)
  return, output
end



function IDL3columnsASCIIparser::init, location
  ;set up the path
  self.path = location
  return, 1
End


pro IDL3columnsASCIIparser__define
  struct = {IDL3columnsASCIIparser,$
    path: ''}
end





