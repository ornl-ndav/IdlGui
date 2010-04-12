; =============================================================================

;
; Author:
;           dfp <prakapenkadv@ornl.gov>
;           j35 <bilheuxjm@ornl.gov>
;
; =============================================================================


; TO DO:
;   dPath should be set either by user or from xml


;---------------------------------------------------------------------------
PRO PlotData::cleanup
  ;free the pointers
  PTR_FREE, self.data, self.colData
  
END


;---------------------------------------------------------------------------
PRO PlotData::startElement, URI, local, strName, attr, value
  ; PRINT, '+++++++++++++'
  ; print, 'start: ' + local
  ;help, attr, value
  CASE strName OF
  
    'instrument': BEGIN
      ;      self.currCol = 0
      ;      self.currRow = 0
      IF N_ELEMENTS(attr) NE 0 THEN BEGIN
        print, value
        IF value EQ self.instrument THEN self.flag = 1
      ENDIF
    END
    
    'col': BEGIN
    ;self.currCol++
    
    END
    
    'row': BEGIN
    ;self.currRow++
    
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
      
        'col': BEGIN
        
          IF PTR_VALID(SELF.data) THEN BEGIN
            *self.data = [*self.data, *self.colData]
          ENDIF ELSE BEGIN
            self.data = ptr_new(*self.colData)
          ENDELSE
          PTR_FREE, self.colData
          
        END
        
        'row': BEGIN
          IF STRMATCH(self.buffer,'blank*') THEN BEGIN
            size = STRSPLIT(self.buffer, '(,)', /EXTRACT)
            data = fltarr(fix(size[1]),fix(size[2]))  
          ENDIF ELSE BEGIN
            bank = self.buffer
            dPath = '/entry/instrument/bank#/data'
            data = getData(self.pathNexus, dPath, self.rebinBy, bank)
          ENDELSE
          
          help, data
          
          IF PTR_VALID(self.colData) THEN BEGIN
            *self.colData = [[*self.colData], [data]]
          ENDIF ELSE BEGIN
            self.colData = ptr_new(data)
          ENDELSE
          
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

FUNCTION recalculate, data, rebinBy
  print, "recalculating"
  
  data = TOTAL(data, 1)
  data = TRANSPOSE(data)
  size = SIZE(data, /DIMENSIONS)
  data = REBIN(data, size[0]* rebinBy, size[1] * rebinBy)
  RETURN, data
END


;---------------------------------------------------------------------------
FUNCTION getData, path, dPath_template, rebinBy, bank

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
    help, dpath_template
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
    ; ENDELSE
    help, data
    data = recalculate(data, rebinBy)
  END
  RETURN, data
END

;---------------------------------------------------------------------------
PRO PlotData::startDocument
  self.flag = 0
  self.buffer = ''
  PTR_FREE, self.data
END

;---------------------------------------------------------------------------
PRO PlotData::endDocument
  IF PTR_VALID(self.data) THEN BEGIN
    dim = SIZE(*self.data, /DIMENSIONS)
    ;
    print, dim
    help, *self.data
    ; print, *self.data
    print, "drawing"
    WINDOW, 0, XSIZE = dim[0], YSIZE = dim[1], TITLE = self.path
    WSET, 0
    DEVICE, decomposed=0
    LOADCT, 5
    TVSCL, *self.data
  END
END

;---------------------------------------------------------------------------
PRO PlotData::characters, char
  IF STRTRIM(char, 2) NE '' THEN BEGIN
    self.buffer = self.buffer + STRTRIM(char, 2)
  ENDIF
END

;---------------------------------------------------------------------------
FUNCTION PlotData::Graph, pathNexus, instrument, rebinBy
  IF (instrument NE '') && (pathNexus NE '') THEN BEGIN
    self.instrument = instrument
    self.pathNexus = pathNexus
    self.rebinBy = rebinBy
    
    print, self.path
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
    colData: ptr_new(), $
    data: ptr_new(), $
    
    windowDim: [0,0], $
    
    ;    currCol: 0, $
    ;    currRow: 0, $
    path: '', $
    mode: 0, $
    flag: 0, $
    count: 0, $
    buffer: ''}
END



