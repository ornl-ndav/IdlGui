pro testXML
  ;file_name = '/SNS/REF_L/IPTS-225/5/4898/preNeXus/REF_L_4898_runinfo.xml'
  file_name = '/SNS/REF_L/shared/BSS_749_cvinfo.xml'
  file = OBJ_NEW('idlxmlparser', file_name)
  PRINT, file -> getValue(tag = ['cvlog']);, ATTRIBUTE = 'name')
  
end

