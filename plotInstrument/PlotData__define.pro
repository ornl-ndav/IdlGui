; =============================================================================

;
; Author:
;           dfp <prakapenkadv@ornl.gov>
;           j35 <bilheuxjm@ornl.gov>
;
; =============================================================================


;---------------------------------------------------------------------------
PRO PlotData::cleanup
;free the pointer

END


;---------------------------------------------------------------------------
PRO PlotData::startElement, URI, local, strName, attr, value
  ; PRINT, '+++++++++++++'
  ; print, 'start: ' + local
  ;help, attr, value
  CASE strName OF
  
    'instrument': BEGIN
      self.currCol = 0
      self.currRow = 0
      IF N_ELEMENTS(attr) NE 0 THEN BEGIN
        IF value EQ self.instrument THEN self.flag = 1
      ENDIF
    END
    
    'col': BEGIN
      self.currCol++
      
    END
    
    'row': BEGIN
      self.currRow++
      
    END
    
    
    ELSE:
    
  ENDCASE
  
  self.buffer = ''
  
  
END


;---------------------------------------------------------------------------
PRO PlotData::endElement, URI, local, strName
  IF self.flag EQ 1 THEN BEGIN
    self.buffer = STRCOMPRESS(self.buffer, /REMOVE_ALL)
    IF strName EQ "instrument" THEN BEGIN
      self.flag = 0
    ENDIF ELSE BEGIN
    
      CASE strName OF
      
        'banks': BEGIN
        ; banks = FIX(self.buffer)
        ; self.banksData =  ptr_new(getData(self.pathNexus, dPath, banks, self.rebinBy))
        END
        
        'size': BEGIN
        ;   self.Size = FIX(STRSPLIT(self.buffer,'[,]', /EXTRACT))
        END
        
        'col': BEGIN
        
        END
        
        'row': BEGIN
          bank = self.buffer
          ; IF bank NE '' THEN $
          dPath = '/entry/instrument/bank#/data'
          data = getData(self.pathNexus, dPath, bank, self.rebinBy)
          self.bankDim = SIZE(data, /DIMENSIONS)
          print, self.bankDim
          self.windowDim = self.bankDim * [self.currRow, self.currCol]
          offset = self.bankDim * [self.currRow -1, self.currCol -1]
          WINDOW, 0, XSIZE = self.bankDim[0], YSIZE = self.bankDim[1], $
            TITLE = self.path
          LOADCT, 5
          print, self.currRow, self.currCol
          TVSCL, data
        END
        
        ELSE:
      ENDCASE
      
    ENDELSE
    
    
    self.buffer = ''
    
  ENDIF
  
;  print, 'mode: ' + string(self.mode)
;  print, 'flag: ' + string(self.flag)
;  print, 'end: ' + local
;  print, '-------------'
  
END


;---------------------------------------------------------------------------
PRO graph, data, x, y

  ;
  ;
  ;  ;data = TOTAL(*(*global).data, 1)
  ;  data = TOTAL(data, 1)
  ;  help, data
  ;
  ;  print, n_elements(DATA)
  ;
  ;  T_2d_data = REBIN(TRANSPOSE(data), rY, rX)
  ;  help, t_2d_data
  ;  print, 'graphing'
  ;  LOADCT, 5
  ;  IF ((*global).graphed NE 0) THEN BEGIN
  ;    TVSCL, T_2d_data, 0, ((*global).graphed * rY) + 10
  ;  ENDIF ELSE BEGIN
  ;    print, n
  ;    WINDOW, 0, XSIZE = rY, YSIZE = (rX + 10) * n, TITLE = (*global).path
  ;    TVSCL, T_2d_data
  ;    (*global).graphed++
  ;  ENDELSE

  TVSCL, data
  
END

FUNCTION recalculate, data, rebinBy
  print, "recalculating"
  
  data = TOTAL(data, 1)
  data = TRANSPOSE(data)
  size = SIZE(data, /DIMENSIONS)
  data = REBIN(data, size[0]* rebinBy, size[1] * rebinBy)
  RETURN, data
END


;---------------------------------------------------------------------------
FUNCTION getData, path, dPath_template, bank, rebinBy

  print, "GETDATA"
  
  not_hdf5_format = 0
  CATCH, not_hdf5_format
  IF (not_hdf5_format NE 0) THEN BEGIN
    CATCH,/CANCEL
    ;display message about invalid file format
    print, "ERROR **********"
    print, not_hdf5_format
  ENDIF ELSE BEGIN
    print, 'opening file...'
    print, path
    fileID    = H5F_OPEN(path)
    print, 'fileID'
    print, fileID
    
    print, 'opening data path...'
    
    dPath = STRJOIN(STRSPLIT(dPath_template, '#', /EXTRACT), bank)
    print, dpath
    fieldID = H5D_OPEN(fileID,dPath)
    print, 'fieldID'
    print, fieldID
    data = H5D_READ(fieldID)
    print, 'copied data...'
    H5D_CLOSE, fieldID
    
    print, "closing hdf5 file"
    H5F_CLOSE, fileID
  ENDELSE
  
  data = recalculate(data, rebinBy)
  
  RETURN, data
END

;;---------------------------------------------------------------------------
;FUNCTION getData, path, dPath_template, banks, rebinBy
;
;  print, "GETDATA"
;
;  not_hdf5_format = 0
;  CATCH, not_hdf5_format
;  IF (not_hdf5_format NE 0) THEN BEGIN
;    CATCH,/CANCEL
;    ;display message about invalid file format
;    print, "ERROR **********"
;    print, not_hdf5_format
;  ENDIF ELSE BEGIN
;    print, 'opening file...'
;    print, path
;    fileID    = H5F_OPEN(path)
;    print, 'fileID'
;    print, fileID
;
;    print, 'opening data path...'
;
;    banksData = ptrarr(banks)
;
;    FOR i = 1, banks DO BEGIN
;      dPath = STRJOIN(STRSPLIT(dPath_template, '#', /EXTRACT), $
;        STRCOMPRESS(STRING(i), /REMOVE_ALL))
;      print, dpath
;      fieldID = H5D_OPEN(fileID,dPath)
;      print, 'fieldID'
;      print, fieldID
;      data = H5D_READ(fieldID)
;      print, 'copied data...'
;      H5D_CLOSE, fieldID
;      banksData[i-1] = ptr_new(data)
;    ENDFOR
;
;    print, "closing hdf5 file"
;    H5F_CLOSE, fileID
;  ENDELSE
;
;
;  RETURN, banksData
;END

;---------------------------------------------------------------------------
PRO PlotData::startDocument
  self.flag = 0
  self.buffer = ''
END

;---------------------------------------------------------------------------
PRO PlotData::characters, char
  IF STRTRIM(char, 2) NE '' THEN BEGIN
    self.buffer = self.buffer + STRTRIM(char, 2)
  ENDIF
; print, 'buffer: ' + self.buffer
END

;---------------------------------------------------------------------------
FUNCTION PlotData::Graph, pathNexus, instrument, rebinBy
  IF instrument NE '' THEN BEGIN
    self.instrument = instrument
    self.pathNexus = pathNexus
    self.rebinBy = rebinBy
    
    LOADCT, 5
    ;WINDOW, 0, TITLE = self.path
    
    
    self -> IDLffxmlsax::ParseFile, self.path
    
  ENDIF ELSE BEGIN
    PRINT, "ERROR"
  ENDELSE
END

;---------------------------------------------------------------------------
FUNCTION PlotData::setDim, size
  self.bankDim = size
END

;---------------------------------------------------------------------------
FUNCTION PlotData::init, path
  self.path = path
  
  RETURN, self -> IDLffxmlsax::Init()
END

;---------------------------------------------------------------------------
PRO PlotData__define
  void = {PlotData, $
    INHERITS IDLffXMLSAX, $
    
    instrument: '', $
    rebinBy: 1, $
    pathNexus: '', $
    banks: 0, $
    Size: [0,0], $
    bankDim: [0,0], $
    banksData: ptr_new(), $
    
    windowDim: [0,0], $
    
    currCol: 0, $
    currRow: 0, $
    path: '', $
    mode: 0, $
    flag: 0, $
    count: 0, $
    buffer: ''}
END



