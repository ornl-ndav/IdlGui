;;*******************************************************************************
;FUNCTION getNumberOfBanks, fileID, path
;banks_path = path
;bank_nbr = 1
;no_more_banks = 0
;WHILE (no_more_banks NE 1) DO BEGIN
;    banks_path = '/entry/bank' + strcompress(bank_nbr,/remove_all) + '/data/'
;    no_more_banks = 0
;    CATCH, no_more_banks
;    IF (no_more_banks NE 0) THEN BEGIN
;        CATCH,/CANCEL
;        RETURN, (bank_nbr-1)
;    ENDIF ELSE BEGIN
;        pathID = h5d_open(fileID, banks_path)
;        h5d_close, pathID
;        ++bank_nbr
;    ENDELSE
;ENDWHILE
;END


PRO test
  file_name = $
  '/SNS/users/dfp/Desktop/ IdlGui/trunk/plotInstrument/InstrumentData.xml'
  file = OBJ_NEW('PlotData', file_name)
  
  
  ;TESTING
  PATH = "/SNS/REF_L/2007_2_4B_SCI/2/3132/NeXus/REF_L_3132.nxs"
  PATH = "/SNS/users/dfp/IdlGui/trunk/plotInstrument/NeXus/BSS_3753.nxs"
  
   text = file -> Graph(path, 'BSS', 4)

 
  
  
  print, 'DONE'
;print, "*" + text + "*"
  
  
  
  
  
  
  
;  path = "/SNS/users/dfp/IdlGui/trunk/plotInstrument/NeXus/BSS_3753.nxs"
;
;
;  not_hdf5_format = 0
;  CATCH, not_hdf5_format
;  IF (not_hdf5_format NE 0) THEN BEGIN
;    CATCH,/CANCEL
;    ;display message about invalid file format
;    RETURN
;  ENDIF ELSE BEGIN
;
;    parsedNX = H5_PARSE(path)
;
;   ; help, parsedNX, /structure
;    HELP, parsednx.entry, /structure
;    help, parsednx.entry.bank1, /structure
;    help, parsednx.entry.bank1.data, /structure
;
;
  
  
;    print, 'opening file...'
;    fileID    = H5F_OPEN(path)
;    print, 'fileID'
;    print, fileID
;
;
;
;;    help, h5d_read(fileID)
;;    print, "type:"
;;    print, h5d_type(fileID)
;;    fileGroup = h5g_open(fileID, '/entry/')
;;;    data_path = '/entry/instrument/bank1/data'
;;    data_path = '/entry/instrument/'
;;    print, 'opening data path...'
;;    fieldID = H5D_OPEN(fileID,data_path)
;;    print, 'fieldID'
;;    print, fieldID
;;    data = H5D_READ(fieldID)
;;    help, data
;;;    print, data
;;    print, 'copied data...'
;;    H5D_CLOSE, fieldID
;    H5D_CLOSE, fileID
;ENDELSE
  
END