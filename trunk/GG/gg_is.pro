FUNCTION isGeometryAndCvinfoXmlValide, Event
;get name of geometry XML file
geo_file_name = getGeometryFileName(Event)
IF (geo_file_name EQ '') THEN RETURN, 0
;get name of cvinfo XML file
cvinfo_file_name = getCvinfoFileName(Event)
IF (cvinfo_file_name EQ '') THEN RETURN, 0
;file name ends in .xml
xml_ext = 'xml'
split1 = strsplit(geo_file_name,'.',/extract,count=sz)
IF (split1[sz-1] NE xml_ext) THEN RETURN, 0
split2 = strsplit(cvinfo_file_name,'.',/extract,count=sz)
IF (split2[sz-1] NE xml_ext) THEN RETURN, 0
IF (FILE_TEST(geo_file_name) AND $
    FILE_TEST(cvinfo_file_name)) THEN RETURN, 1
RETURN, 0
END


FUNCTION isOutputGeometryPathValidate, Event
;get path of output geometry file
path_name = getTextFieldValue(Event,'geo_path_text_field')
IF (FILE_TEST(path_name,/DIRECTORY)) THEN RETURN, 1
RETURN, 0
END
