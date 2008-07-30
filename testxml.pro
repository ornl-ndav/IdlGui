pro testXML
  file_name = '/SNS/REF_L/IPTS-225/5/4898/preNeXus/REF_L_4898_runinfo.xml'
  file = OBJ_NEW('idlxmlparser')
  print, OBJ_VALID(file)
  PRINT, file->getValue(tag = ['DateTime', 'StartTime'])
  
end

