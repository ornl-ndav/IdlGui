PRO ReadXmlFile, Event

;file = '~/SVN/HistoTool/trunk/gui/GG/j35motorlist.xml'
file = '~/SVN/HistoTool/trunk/gui/GG/myXML.xml'

xmlFile = OBJ_NEW('myParser')
xmlFile->ParseFile, file

motors = xmlFile->GetArray()
print, motors
END
