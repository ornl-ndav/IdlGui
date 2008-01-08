PRO gg_Cleanup, Main_base

Widget_Control, Main_Base, get_uvalue=global
tmp_file = (*global).tmp_xml_file

IF (FILE_TEST(tmp_file)) THEN BEGIN
    spawn, 'rm -f ' + tmp_file
ENDIF


END
