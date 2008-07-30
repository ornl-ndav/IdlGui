pro testXML
  file_name = '/SNS/REF_L/IPTS-225/5/4898/preNeXus/REF_L_4898_runinfo.xml'
  file = OBJ_NEW('idlxmlparser')
  PRINT, file -> getValue(path = file_name, tag = ['DetectorInfo', 'ReportedXDim'])
  
end

