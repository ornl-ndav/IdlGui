
PRO parse_xml

  xml_filename = 'REF_L_21288_cvinfo.xml'

  iXML = OBJ_NEW('myXMLparser')
  iXML->parseFile, xml_filename
    
  CDATA_array = iXML->getArray()  
  print, CDATA_array
    
  OBJ_DESTROY, iXML  

END    