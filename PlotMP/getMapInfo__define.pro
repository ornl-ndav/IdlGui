FUNCTION getMapInfo::getInfo, x, y
  command = '/SNS/software/sbin/mapinfo'
  command = command + ' -x ' + string(x) + ' -y ' + string(y)
  command = command + ' ' + self.path + ' --xml'
  
  SPAWN,  command, listen, erlisten
  listen = STRCOMPRESS(listen, /REMOVE_ALL)
  
  if erlisten eq '' then begin
    numbanks = listen[WHERE(STRMATCH(listen, '<numbank>*', /FOLD_CASE) EQ 1)]
    numbanks = STRSPLIT(numbanks, '<>', /EXTRACT)
    numbanks = fix(numbanks[1])
    
    
    gen_struct = {number: 0, $
      type: '', $
      offset: 0}
      
    all_struct = REPLICATE(gen_struct, numbanks)
    index_num = WHERE(STRMATCH(listen, '<number>*', /FOLD_CASE) EQ 1, count)
    index_type = WHERE(STRMATCH(listen, '<type>*', /FOLD_CASE) EQ 1, count)
    index_offset = WHERE(STRMATCH(listen, '<offset>*', /FOLD_CASE) EQ 1, count)
    for i = 0, numbanks - 1 do begin
      tmp = STRSPLIT(listen[index_num[i]], '<>', /EXTRACT)
      all_struct[i].number = fix(tmp[1])
      ;      tmp = STRSPLIT(listen[index_type[i]], '<>', /EXTRACT)
      ;      all_struct[i].type = tmp[1]
      tmp = STRSPLIT(listen[index_offset[i]], '<>', /EXTRACT)
      all_struct[i].offset = fix(tmp[1])
    endfor
  endif else begin
    print, '[' + erlisten + ']'
    return, "error"
  endelse
  
  file_struct = {path: self.path,$
    size_map: 0L, $
    size_bank: 0L, $
    numbanks: numbanks,$
    data: ptr_new(/allocate_heap), $
    banks: all_struct}
    
  RETURN, file_struct
END

;------------------------------------------------------------------------------
FUNCTION getMapInfo::init, location
  ;set up the path
  self.path = location
  RETURN, FILE_TEST(location, /READ)
END

;------------------------------------------------------------------------------
PRO getMapInfo__define
  struct = {getMapInfo,$
    path: ''}
END

;------------------------------------------------------------------------------