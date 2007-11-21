PRO MakeGuiReduceClgXmlTab1, ReduceClgXmlTab, ReduceClgXmlTabSettings

tab1_base = WIDGET_BASE(ReduceClgXmlTab,$
                        XOFFSET   = ReduceClgXmlTabSettings.tab.size[0],$
                        YOFFSET   = ReduceClgXmlTabSettings.tab.size[1],$
                        SCR_XSIZE = ReduceClgXmlTabSettings.tab.size[2],$
                        SCR_YSIZE = ReduceClgXmlTabSettings.tab.size[3],$
                        TITLE     = ReduceClgXmlTabSettings.title[0])

text = WIDGET_TEXT(tab1_base,$
                   UNAME     = ReduceClgXmlTabSettings.text.uname[0],$
                   XOFFSET   = ReduceClgXmlTabSettings.text.size[0],$
                   YOFFSET   = ReduceClgXmlTabSettings.text.size[1],$
                   SCR_XSIZE = ReduceClgXmlTabSettings.text.size[2],$
                   SCR_YSIZE = ReduceClgXmlTabSettings.text.size[3],$
                   /WRAP,$
                   /SCROLL)

END
