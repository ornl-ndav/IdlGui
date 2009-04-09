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
;    DATA               POINTER   <PtrHeapVar2225>   ; pointer to an array of
;    structures
;
;    help, (*struct.data)[0], /structure
;    ------------------- returns the first dataset
;     ** Structure SINGLE_DATA_STRUCTURE, 4 tags, length=56, data length=52:
;    BANK            STRING    'bank1'               ; bank number
;    X               STRING    '137'                 ; x value
;    Y               STRING    '127'                 ; y value
;    DATA            POINTER   <PtrHeapVar2462>      ; pointer to a string
;                                                    ; array of 3
;                                                    ; columns with data
;
;   How To retrieve information
;
; print, (*struct.data[0]).x
; print, (struct.xaxis)
; print, *(*struct.data)[0].data ;for the data
; *<=========================================>*
; Author: dfp <prakapenkadv@ornl.gov>
; ============================================>>>


;------------------------------------------------------------------------------
FUNCTION get_up_to_blank_line, data
  index_blank = WHERE(data EQ '',nbr)
  IF (nbr GT 0) THEN BEGIN
    RETURN, data[0:index_blank[0]-1]
  ENDIF
END

;------------------------------------------------------------------------------
function modtag, init_str
  ;remove any spaces on ends
  init_str = STRTRIM(init_str, 2)
  ;locate semicolon
  colon_pos = STRPOS(init_str, ':')
  ;find size of the array
  arrsize = N_ELEMENTS(init_str)
  ;make sure to return something
  new_str = init_str
  
  ;if input is an array, remove semicolons form ends of each element
  if arrsize ne 1 then begin
  
    for i = 0, arrsize - 1 do begin
    
      colon_pos = STRPOS(init_str[i], ':')
      length = STRLEN(init_str[i])
      
      if colon_pos ne -1 then begin
        if colon_pos eq (length-1) then begin
          new_str[i] = STRMID(init_str[i], 0, colon_pos)
        endif
        if colon_pos eq 0 then begin
          new_str[i] = STRMID(init_str[i], colon_pos + 1)
        endif
      endif
      
    endfor
    
  ;if input is just a string, do the same
  endif else begin
  
    length = STRLEN(init_str)
    
    if colon_pos ne -1 then begin
      if colon_pos eq (length-1) then begin
        new_str = STRMID(init_str, 0, colon_pos)
      endif
      if colon_pos eq 0 then begin
        new_str = STRMID(init_str, colon_pos + 1)
      endif
      
    endif
  endelse
  
  ;trim any spaces on ends
  new_str = STRTRIM(new_str, 2)
  RETURN, new_str
  
end

;------------------------------------------------------------------------------
FUNCTION READ_DATA, file, half, Event

  text = '--> Entering READ_DATA'
  IDLsendToGeek_addLogBookText, Event, text
  
  text = '---> Opening the data file ... '
  IDLsendToGeek_addLogBookText, Event, text
  
  ;Open the data file
  OPENR, 1, file
  
  IDLsendToGeek_ReplaceLogBookText, Event, ' ... ', ' ... OK'
  IDLsendToGeek_addLogBookText, Event, '---> half: ' + $
    STRCOMPRESS(half,/REMOVE_ALL)
    
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
      CLOSE, 1
      RETURN, line
    END
    2: BEGIN                  ;second half
      WHILE (~EOF(1)) DO BEGIN
        nbr_lines = FILE_LINES(file)
        my_array = STRARR(1,nbr_lines)
        READF,1, my_array
      ENDWHILE
      CLOSE,1
      RETURN, my_array
    END
  ENDCASE
END

;------------------------------------------------------------------------------
function format, init_str, tag
  ;find out where tag ends
  pos = STRLEN(tag)
  ;make a string with the comment
  new_str = STRMID(init_str, pos)
  ;call modtag to remove semicolons
  new_str = modtag(new_str)
  
  RETURN, new_str
  
end

;------------------------------------------------------------------------------
Function find_it, init_str, tag

  ;get number of elements in array
  n = N_ELEMENTS(init_str)
  i = 0
  flag = 1
  new_str = STRARR(1)
  
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
  RETURN, new_str
  
end

;------------------------------------------------------------------------------
pro populate_structure, all_data, MyStruct, Event

  text = '---> Entering populate_structure'
  IDLsendToGeek_addLogBookText, Event, text
  
  ;find where is the first blank line (we do not want anything from the line
  ;below that point
  blk_line_index = WHERE(all_data EQ '', nbr)
  text = '----> size of blk_line_index: ' + STRCOMPRESS(nbr,/REMOVE_ALL)
  IDLsendToGeek_addLogBookText, Event, text
  
  ;get our new interesting array of data
  text = '----> get our new interesting array of data'
  IDLsendToGeek_addLogBookText, Event, text
  all_data = all_data[blk_line_index[0]+1:*]
  
  ;get how many array we have here
  text = '----> get how many array we have here'
  IDLsendToGeek_addLogBookText, Event, text
  blk_line_index = WHERE(all_data EQ '', new_nbr)
  IDLsendToGeek_addLogBookText, Event, '-----> new_nbr: ' + $
    STRCOMPRESS(new_nbr,/remove_all)
  num_elnts = N_ELEMENTS(all_data)
  IDLsendToGeek_addLogBookText, Event, '-----> num_elnts: ' + $
    STRCOMPRESS(num_elnts,/remove_all)
    
  if new_nbr ne 0 then begin
    ;make sure the last one is not the last element of the array
    IF (blk_line_index[new_nbr-1] EQ (num_elnts-1)) THEN BEGIN
      --new_nbr
    ENDIF
  endif else begin
    new_nbr = 1
  endelse
  
  IDLsendToGeek_addLogBookText, Event, '-----> new_nbr is now: ' + $
    STRCOMPRESS(new_nbr,/remove_all)
    
  ;create the array of structure here
  ;first the structure that will be used for each set of data
  general_data_structure = { single_data_structure,$
    bank: '',$
    X:    '',$
    Y:    '',$
    data: PTR_NEW()}
    
  ;then create the array of structures according to the number of
  ;array (new_nbr)
  data_structure = REPLICATE(general_data_structure,new_nbr)
  
  ;and put this general array of structures inside MyStruct.data
  array_nbr   = 0L
  i           = 0L
  array_index = 0L
  step = num_elnts / 1000
  
  IDLsendToGeek_addLogBookText, Event, '----> about to enter while loop'
  
  WHILE (array_nbr NE new_nbr) DO BEGIN
  
    if i LT num_elnts then begin
      line = all_data[i]
    endif else begin
      line = ''
    endelse
    
    IF (~STRMATCH(line,'#*')) THEN BEGIN
      IF (line EQ '') THEN BEGIN
        array_index = 0
        data_structure[array_nbr].data = PTR_NEW(my_data_array)
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
      
      IF (num_elnts GT 1000) THEN BEGIN
        i =  i + FIX(step)
      ENDIF ELSE BEGIN
        i++
      ENDELSE
      
    ENDIF else begin
      ;populate data_stracture
      IF (STRMATCH(line,'#S*')) THEN BEGIN
        parse_error = 0
        CATCH, parse_error
        IF (parse_error NE 0) THEN BEGIN
          CATCH,/CANCEL
          bank = '?'
          x    = '?'
          y    = '?'
        ENDIF ELSE BEGIN
          temp = STRSPLIT(line, /PRESERVE_NULL, /extract)
          bank = STRSPLIT(temp[4], " '  ( ) , ", /EXTRACT)
          x = STRSPLIT(temp[5], " '  ( ) , ", /EXTRACT)
          y = STRSPLIT(temp[6], " '  ( ) , ", /EXTRACT)
        ENDELSE
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
            temp = STRSPLIT(line,'#L',/extract)
            temp1 = STRSPLIT(temp[0],'()', /extract)
            CASE (N_ELEMENTS(temp1)) OF
              6: BEGIN
                x_all = [temp1[0],temp1[1]]
                y_all = [temp1[2],temp1[3]]
                sigma_all = [temp1[4],temp1[5]]
              END
              5: BEGIN
                x_all = [temp1[0],temp1[1]]
                y_all = [temp1[2],temp1[3]]
                sigma_all = [temp1[4],'']
              END
              4: BEGIN
                x_all = [temp1[0],temp1[1]]
                y_all = [temp1[2],'']
                sigma_all = [temp1[3],'']
              END
              ELSE:  BEGIN
                x_all = [temp1[0],'']
                y_all = [temp1[1],'']
                sigma_all = [temp1[2],'']
              END
            ENDCASE
          ENDELSE
        ENDIF
      ENDIF
  
      i++

    ENDELSE
    
  ENDWHILE
  
  IDLsendToGeek_addLogBookText, Event, '----> leaving the while loop'
  
  ;retrieve the Xaxis, Xaxis_units, Yaxis, Yaxis_units, sigma_axis,
  ;sigma_axis_units
  ;and put them in MyStruct.xaxis, Mystruct.xaxis_units ....
  
  MyStruct.NbrArray = new_nbr
  MyStruct.xaxis = x_all[0]
  MyStruct.xaxis_units = x_all[1]
  MyStruct.yaxis = y_all[0]
  MyStruct.yaxis_units = y_all[1]
  MyStruct.sigma_yaxis = sigma_all[0]
  MyStruct.sigma_yaxis_units = sigma_all[1]
  *MyStruct.data = data_structure
  
END

;------------------------------------------------------------------------------
FUNCTION IDL3columnsASCIIparser::getData, Event

  text = '-> About to read Data in IDL3columnsASCIIparser'
  IDLsendToGeek_addLogBookText, Event, text
  
  all_data = READ_DATA(self.path, 2, Event)
  
  text = '-> Data have been read in IDL3columnsASCIIparser'
  IDLsendToGeek_addLogBookText, Event, text
  
  ;Define the Structure
  MyStruct = { NbrArray:          0L,$
    xaxis:             '', $
    xaxis_units:       '',$
    yaxis:             '', $
    yaxis_units:       '',$
    sigma_yaxis:       '',$
    sigma_yaxis_units: '',$
    Data:              PTR_NEW(0L)}
    
  ;Populate structure with general information (NbrArray, xaxis....etc)
  text = '-> About to Enter populate_structure'
  IDLsendToGeek_addLogBookText, Event, text
  
  populate_structure, all_data, MyStruct, Event
  
  RETURN, MyStruct
END

;------------------------------------------------------------------------------
FUNCTION IDL3columnsASCIIparser::get_tag, tag, event
  ;remove semicolon from tag
  tag = modtag(tag)
  ;read data into array
  data = READ_DATA(self.path, 1, Event)
  ;find and format data
  output = find_it(data, tag)
  RETURN, output
END

;------------------------------------------------------------------------------
FUNCTION IDL3columnsASCIIparser::getAllTag, Event
  data = READ_DATA(self.path, 2, Event)
  output = get_up_to_blank_line(data)
  RETURN, output
END

;------------------------------------------------------------------------------
FUNCTION IDL3columnsASCIIparser::init, location
  ;set up the path
  self.path = location
  test = FILE_TEST(location,/READ)
  RETURN, test
END

;------------------------------------------------------------------------------
PRO IDL3columnsASCIIparser__define
  struct = {IDL3columnsASCIIparser,$
    data: PTR_NEW(),$
    path: ''}
END

;------------------------------------------------------------------------------




