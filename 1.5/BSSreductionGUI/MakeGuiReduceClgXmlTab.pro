PRO MakeGuiReduceClgXmlTab, ReduceBase, ReduceClgXmlTabSettings

ReduceClgXmlTab = WIDGET_TAB(ReduceBase,$
                             UNAME     = 'reduce_clg_xml_tab',$
                             LOCATION  = 0,$
                             XOFFSET   = ReduceClgXmlTabSettings.Size[0],$
                             YOFFSET   = ReduceClgXmlTabSettings.Size[1],$
                             SCR_XSIZE = ReduceClgXmlTabSettings.Size[2],$
                             SCR_YSIZE = ReduceClgXmlTabSettings.Size[3])


;Make CLG status
MakeGuiReduceClgXmlTab1, ReduceClgXmlTab, ReduceClgXmlTabSettings

;Make XML
;MakeGuiReduceClgXmlTab2, ReduceClgXmlTab, ReduceClgXmlTabSettings


END
