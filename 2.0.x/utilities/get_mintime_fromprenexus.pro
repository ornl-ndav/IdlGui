function get_MinTime_fromPreNeXus, runinfo_filename

  Catch, theError
  IF theError NE 0 THEN BEGIN
    CATCH, /CANCEL
    ; If we have an error, then just return a sensible default
    return, '0'
  ENDIF
  
  oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=runinfo_filename)
  oDocList = oDoc->GetElementsByTagName('DetectorInfo')
  
  obj1 = oDocList->item(0)
  obj2=obj1->GetElementsByTagName('Scattering')
  obj3=obj2->item(0)
  obj4=obj3->GetElementsByTagName('NumTimeChannels')
  obj4a=obj4->item(0)
  obj4b=obj4a->getattributes()
  obj4c=obj4b->getnameditem('startbin')
  result = STRCOMPRESS(obj4c->getvalue())
  OBJ_DESTROY, oDocList
  RETURN, result
  
end