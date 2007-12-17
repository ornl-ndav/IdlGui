PRO ReadXmlFile, Event

file = '~/SVN/HistoTool/trunk/gui/GG/j35motorlist.xml'
;file = '~/SVN/HistoTool/trunk/gui/GG/myXML.xml'

xmlFile = OBJ_NEW('xmlParser')
xmlFile->ParseFile, file

motors = xmlFile->GetArray()
sz = (size(motors))(1)

;create table
FinalArray = gg_createTableArray(Event, motors)
;populate Table array
populateTable, Event, FinalArray
END
