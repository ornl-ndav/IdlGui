function getEntryIdentifier, nexusfilename

  runNumber_location = '/entry/entry_identifier'
  
  Catch, theError
  IF theError NE 0 THEN BEGIN
    CATCH, /CANCEL
    IF !ERROR_STATE.CODE EQ -1008 THEN runNumber_location = '/entry/run_number'
  ENDIF
  
  fileThere = FILE_TEST(firstString, /READ, /REGULAR)
  
  IF (fileThere) THEN BEGIN
  
    fileID = h5f_open(nexusfilename)
    ; Now lets get the run number
    ;print, 'Getting run number from ', runNumber_location, ' in NeXus file.'
    fieldID = H5D_OPEN(FILEID, runNumber_location)
    runNumber = H5D_READ(FIELDID)
    
  ENDIF
  
  return, runNumber
end
