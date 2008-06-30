

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

function format, init_str, tag, pos
  pos = pos + STRLEN(tag)
  new_str = STRTRIM(strmid(init_str, pos), 2)
  return, new_str
  
end

Function find_it, init_str, tag
  
  n = N_ELEMENTS(init_str)
  i = 0
  
  pos = STRPOS(init_str, tag)
  ; new_str = ''
  while (i NE n) do begin
    pos = STRPOS(init_str[i], tag)
    ; print, pos
    if pos ne -1 then BEGIN
    
      new_str = init_str[i]
      break
    ENDIF
    i = i+ 1
  endwhile
  ; print, new_str
  new_str = format(new_str, tag, pos)
  return, new_str
;return, 1
end



pro parseDRascii
  location = "/SNS/users/dfp/IDLWorkspace/Default/REF_L_4000_2008y_06m_24d_09h_55mn_08s.txt"
  tag = "#F data:"
  data = READ_DATA(location)
  output = find_it(data, tag)
  print, output
End


