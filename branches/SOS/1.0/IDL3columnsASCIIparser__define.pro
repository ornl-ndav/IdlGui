; <<<============================================
; NAME:
;   IDL3columsASCIIparser
;
; PURPOSE:
;   Parses a given 3 columns ASCII file.
;
; CATEGORY:
;   ASCII parser
;
; EXAMPLE:
;    Construct an object where loc is the string with the location of the
;    ascii file
;    myobj = obj_new('IDL3columnsASCIIparser', loc)
;
;    Get the comments for a particular tag (e.g. #F data)
;    comment = myobj->get_tag(#F data)
;
;    Parse the rest of the data into a structure
;    struct = myobj ->getData()
;
;    To quickly get a PTRARR of an uncombined ascii file (more than 1
;    set of data
;    data = myobj->getDataQuickly()
;
; OUTPUT
;    help, comment
;    ------------------- returns:
;    COMMENT         STRING    = Array[11]
;    The array contains the comments that follow the tag provided by the user
;
;    help, struct, /structure
;    ------------------- returns
;     ** Structure <af6b98>, 8 tags, length=112, data length=104, refs=1:
;    NBRARRAY           LONG      1                  ; number of datasets
;    XAXIS              STRING    'time_of_flight'   ; title of x-axis
;    XAXIS_UNITS        STRING    'microsecond'      ; x-axis units
;    YAXIS              STRING    'data'             ; title of y-axis
;    YAXIS_UNITS        STRING    ''                 ; y-axis units
;    SIGMA_YAXIS        STRING    'Sigma'            ; title of sigma y-axis
;    SIGMA_YAXIS_UNITS  STRING    ''                 ; sigma y-axis units
;    DATA               POINTER   <PtrHeapVar2225>   ; pointer to an array of structures
;
;    help, (*struct.data)[0], /structure
;    ------------------- returns the first dataset
;     ** Structure SINGLE_DATA_STRUCTURE, 4 tags, length=56, data length=52:
;    BANK            STRING    'bank1'               ; bank number
;    X               STRING    '137'                 ; x value
;    Y               STRING    '127'                 ; y value
;    DATA            POINTER   <PtrHeapVar2462>      ; pointer to a string array of 3
;                                                    ; columns with data
;
;   How To retrieve information
;
; print, (*struct.data[0]).x
; print, (struct.xaxis)
;
; *<=========================================>*
; Author: dfp <prakapenkadv@ornl.gov>
;         j35 <bilheuxjm@ornl.gov>
; ============================================>>>


;------------------------------------------------------------------------------
FUNCTION get_up_to_blank_line, data
  index_blank = WHERE(strcompress(data,/remove_all) EQ '',nbr)
  IF (nbr GT 0) THEN BEGIN
    RETURN, data[0:index_blank[0]-1]
  ENDIF
END

;------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
FUNCTION READ_DATA, file, half
  ;Open the data file.
  OPENR, 1, file
  ;Set up variables
  line = STRARR(1)
  tmp = ''
  i = 0
  
  CASE (half) OF
    1: BEGIN                  ;first half
      ;Read the comments from the file until blank line
      WHILE(~EOF(1)) DO BEGIN
        READF,1,tmp
        ;Check for blank line
        IF (tmp EQ '') THEN BEGIN
          BREAK
        ENDIF ELSE BEGIN
          IF (i EQ 0) THEN BEGIN
            line[i] = tmp
            i = 1
          ENDIF ELSE BEGIN
            line = [line, tmp]
          ENDELSE
        ENDELSE
      ENDWHILE
      close, 1
      RETURN, line
    END
    2: BEGIN
      WHILE (~EOF(1)) DO BEGIN
        nbr_lines = FILE_LINES(file)
        my_array = STRARR(1,nbr_lines)
        READF,1, my_array
      ENDWHILE
      close,1
      free_lun, 1
      RETURN, my_array
    END
  ENDCASE
END

;-------------------------------------------------------------------------------
function format, init_str, tag
  ;find out where tag ends
  pos = STRLEN(tag)
  ;make a string with the comment
  new_str = strmid(init_str, pos)
  ;call modtag to remove semicolons
  new_str = modtag(new_str)
  
  return, new_str
  
end

;-------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------
pro populate_structure, all_data, MyStruct
  ;find where is the first blank line (we do not want anything from the line
  ;below that point
  blk_line_index = WHERE(all_data EQ '', nbr)
  ;get our new interesting array of data
  all_data = all_data[blk_line_index[0]+1:*]
  
  
  ;get how many array we have here
  blk_line_index = WHERE(all_data EQ '', new_nbr)
  num_elnts = N_ELEMENTS(all_data)
  
  ; if new_nbr ne 0 then begin
  ;make sure the last one is not the last element of the array
  ;    IF (blk_line_index[new_nbr-1] EQ (num_elnts-1)) THEN BEGIN
  ;     --new_nbr
  ;   ENDIF
  ; endif else begin
  ;   new_nbr = 1
  ; endelse
  
  ;create the array of structure here
  ;first the structure that will be used for each set of data
  general_data_structure = { single_data_structure,$
    bank: '',$
    X:    '',$
    Y:    '',$
    data: ptr_new()}
    
  ;then create the array of structures according to the number of array (new_nbr)
  data_structure = REPLICATE(general_data_structure,new_nbr)
  
  ;and put this general array of structures inside MyStruct.data
  array_nbr   = 0
  i           = 0L
  array_index = 0
  
  ;  print, 'new_nbr: ' + STRCOMPRESS(new_nbr) ;remov_me
  ;  print, 'array_nbr: ' + STRCOMPRESS(array_nbr) ;remov_me
  
  WHILE (array_nbr NE new_nbr) DO BEGIN
    ;      print, 'array_nbr: ' + STRCOMPRESS(array_nbr) ;remov_me
    ;      print, 'i: ' + STRCOMPRESS(i)
    if i  ne num_elnts then begin
      line = all_data[i]
    endif else begin
      line = ''
    endelse
    
    IF (~STRMATCH(line,'#*')) THEN BEGIN
      IF (line EQ '') THEN BEGIN
        array_index = 0
        data_structure[array_nbr].data = ptr_new(my_data_array)
        data_structure[array_nbr].bank = bank
        data_structure[array_nbr].x = x
        data_structure[array_nbr].y = y
        ++array_nbr
      ENDIF ELSE BEGIN
        array = STRSPLIT(line,' ',/EXTRACT, COUNT=nbr)
        CASE (array_index) OF
          0: BEGIN
            my_data_array = [array[0],array[1],array[2]]
          END
          ELSE: BEGIN
            IF (nbr EQ 1) THEN BEGIN
              my_data_array = [my_data_array,array[0],'','']
            ENDIF ELSE BEGIN
              my_data_array = $
                [my_data_array,array[0],array[1],array[2]]
            ENDELSE
          END
        ENDCASE
        ++array_index
      ENDELSE
      
    ENDIF else begin
      ;populate data_stracture
      IF (STRMATCH(line,'#S*')) THEN BEGIN
        temp = strsplit(line, /PRESERVE_NULL, /extract)
        bank = strsplit(temp[4], " '  ( ) , ", /EXTRACT)
        x = strsplit(temp[5], " '  ( ) , ", /EXTRACT)
        y = strsplit(temp[6], " '  ( ) , ", /EXTRACT)
      endif
      
      ;populate the rest of MyStruct structure
      if array_nbr eq 0 then begin
        IF (STRMATCH(line,'#L*')) THEN BEGIN
          no_error = 0
          CATCH, no_error
          IF (no_error NE 0) THEN BEGIN
            CATCH,/CANCEL
            x_all = ['','']
            y_all = ['','']
            sigma_all = ['','']
          ENDIF ELSE BEGIN
            temp = strsplit(line,'#L',/extract)
            temp1 = strsplit(temp[0],'()', /extract)
            x_all = [temp1[0],temp1[1]]
            y_all = [temp1[2],temp1[3]]
            sigma_all = [temp1[4],temp1[5]]
          ENDELSE
        ENDIF
      ENDIF
      
    ENDELSE
    
    ++i
    
  ENDWHILE
  
  
  ;retrieve the Xaxis, Xaxis_units, Yaxis, Yaxis_units, sigma_axis, sigma_axis_units
  ;and put them in MyStruct.xaxis, Mystruct.xaxis_units ....
  
  MyStruct.NbrArray = new_nbr
  MyStruct.xaxis = x_all[0]
  MyStruct.xaxis_units = x_all[1]
  MyStruct.yaxis = y_all[0]
  MyStruct.yaxis_units = y_all[1]
  MyStruct.sigma_yaxis = sigma_all[0]
  MyStruct.sigma_yaxis_units = sigma_all[1]
  *MyStruct.data = data_structure
  
end

;+
; :Description:
;    This procedures cleanup the data file by removing all the lines that
;    have an intensity of 0 or NaN
;
; :Params:
;    file_name

; :Author: j35
;-
function cleanup_file, file_name
  compile_opt idl2
  
  data = read_data(file_name, 2) ;reads full file
  nLines = file_lines(file_name)
  
  ;by default, we want to keep all the lines
  lines_to_remove = intarr(nLines)
  for i=0,(nLines-1) do begin
    if (strmatch(data[i],'* nan *')) then begin
      lines_to_remove[i] = 1
    endif else begin
      if (strmatch(data[i],'* 0.0 *')) then begin
        lines_to_remove[i] = 1
      endif
    endelse
  endfor
  
  index_to_keep = where(lines_to_remove eq 0, nbr)
  if (nbr lt nLines) then begin
    data_to_keep = data[index_to_keep]
  endif else begin
  data_to_keep = data
  endelse
  
  return, data_to_keep
end

;+
; :Description:
;    Output the data without major formatting
;
; :Author: j35
;-
FUNCTION IDL3columnsASCIIparser::getDataQuickly

  ;remove all the lines where value is 0 or NaN
  data = cleanup_file(self.path)
  
  ;data  = READ_DATA(self.path, 2) ;reads full file
  ;nLines = FILE_LINES(self.path)
  nLines = n_elements(data)
  
  index = WHERE(data EQ '#N 3',nbr) ;retrieves the number of pixels to retrieve
  pARRAY = PTRARR(nbr,/ALLOCATE_HEAP)
  FOR i=1,(nbr-1) DO BEGIN
    *pARRAY[i-1] = data[index[i-1]+2:index[i]-3]  ;???? maybe 4 here
  ENDFOR
  
  if (nbr ge 1) then begin ;retrieve pixel number
    split1 = strsplit(data[index[0]-1],',',/extract,/regex)
    split2 = strsplit(split1[n_elements(split1)-1],')',/regex,/extract)
    self.start_pixel = strcompress(split2[0],/remove_all)
  endif
  
  ;each index of each pArray is
  ; a string of 1 row of the data
  *pARRAY[nbr-1] = data[index[nbr-1]+2:nLines-1]
  ;parse each array into 3 columns
  sz = N_ELEMENTS(pARRAY)
  new_pARRAY = PTRARR(nbr,/ALLOCATE_HEAP)
  FOR i=0,sz-1 DO BEGIN
    n_lines = N_ELEMENTS(*pARRAY[i])
    array = STRARR(3,n_lines)
    FOR j=0,n_lines-2 DO begin
      array[*,j] = STRSPLIT((*pARRAY[i])[j],/EXTRACT)
    ENDFOR
    *new_pARRAY[i] = array
  ENDFOR
  PTR_FREE, pARRAY
  RETURN, new_pARRAY
END


;------------------------------------------------------------------------------
FUNCTION IDL3columnsASCIIparser::getData
  all_data = READ_DATA(self.path, 2)
  
  ;Define the Structure
  MyStruct = { NbrArray:          0L,$
    xaxis:             '', $
    xaxis_units:       '',$
    yaxis:             '', $
    yaxis_units:       '',$
    sigma_yaxis:       '',$
    sigma_yaxis_units: '',$
    Data:              ptr_new(0L)}
    
  ;Populate structure with general information (NbrArray, xaxis....etc)
  populate_structure, all_data, MyStruct
  
  RETURN, MyStruct
END

;------------------------------------------------------------------------------
FUNCTION IDL3columnsASCIIparser::get_tag, tag
  ;remove semicolon from tag
  tag = modtag(tag)
  ;read data into array
  data = READ_DATA(self.path, 1)
  ;find and format data
  output = find_it(data, tag)
  RETURN, output
END

;------------------------------------------------------------------------------
FUNCTION IDL3columnsASCIIparser::getAllTag
  data = READ_DATA(self.path, 2)
  output = get_up_to_blank_line(data)
  RETURN, output
END

;Return the first pixel displayed
function IDL3columnsASCIIparser::getStartPixel
  return, self.start_pixel
end

;------------------------------------------------------------------------------
FUNCTION IDL3columnsASCIIparser::init, location
  ;set up the path
  self.path = location
  RETURN, FILE_TEST(location, /READ)
END

;------------------------------------------------------------------------------
PRO IDL3columnsASCIIparser__define
  struct = {IDL3columnsASCIIparser,$
    data: ptr_new(),$
    start_pixel: '',$
    path: ''}
END

;------------------------------------------------------------------------------




