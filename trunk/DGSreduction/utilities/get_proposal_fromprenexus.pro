function get_Proposal_fromPreNeXus, beamtimeinfo_filename

  Catch, theError
  IF theError NE 0 THEN BEGIN
    CATCH, /CANCEL
    ; If we have an error, then just return a sensible default
    return, '0'
  ENDIF
  
  IF (FILE_TEST(beamtimeinfo_filename,/READ, /REGULAR) EQ 1) THEN BEGIN
  
    oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=beamtimeinfo_filename)
    oDocList = oDoc->GetElementsByTagName('Proposal')
    
    obj1 = oDocList->item(0)
    obj2=obj1->GetElementsByTagName('ID')
    obj3=obj2->item(0)
    obj4=obj3->getFirstChild()
    result = STRCOMPRESS(obj4->getdata(), /REMOVE_ALL)
    
    OBJ_DESTROY, oDocList
    
  ENDIF ELSE BEGIN
    result = '0'
  ENDELSE
  
  RETURN, result
  
end