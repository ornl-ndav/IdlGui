PRO MakeGuiReduceClgXmlTab2, ReduceClgXmlTab, ReduceClgXmlTabSettings

tab2_base = WIDGET_BASE(ReduceClgXmlTab,$
                        XOFFSET   = ReduceClgXmlTabSettings.tab.size[0],$
                        YOFFSET   = ReduceClgXmlTabSettings.tab.size[1],$
                        SCR_XSIZE = ReduceClgXmlTabSettings.tab.size[2],$
                        SCR_YSIZE = ReduceClgXmlTabSettings.tab.size[3],$
                        TITLE     = ReduceClgXmlTabSettings.title[1])

text = WIDGET_TEXT(tab2_base,$
                   UNAME     = ReduceClgXmlTabSettings.text.uname[1],$
                   XOFFSET   = ReduceClgXmlTabSettings.text.size[0],$
                   YOFFSET   = ReduceClgXmlTabSettings.text.size[1],$
                   SCR_XSIZE = ReduceClgXmlTabSettings.text.size[2],$
                   SCR_YSIZE = ReduceClgXmlTabSettings.text.size[3],$
                   /WRAP,$
                   /SCROLL)

END
