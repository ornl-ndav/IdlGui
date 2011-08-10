PRO MakeGuiReduceClgXmlTab1, ReduceClgXmlTab, ReduceClgXmlTabSettings

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************
base = { size : [0,0, $
                 ReduceClgXmlTabSettings.size[2],$
                 ReduceClgXmlTabSettings.size[3]]}

XYoff = [-5,-25]
text = { size : [0, $
                 0, $
                 ReduceClgXmlTabSettings.size[2]+XYoff[0],$ $
                 ReduceClgXmlTabSettings.size[3]+XYoff[1]],$
         uname : 'clg_text'}
         
;***********************************************************************************
;                                Build GUI
;***********************************************************************************
tab1_base = WIDGET_BASE(ReduceClgXmlTab,$
                        XOFFSET   = base.size[0],$
                        YOFFSET   = base.size[1],$
                        SCR_XSIZE = base.size[2],$
                        SCR_YSIZE = base.size[3],$
                        TITLE     = ReduceClgXmlTabSettings.title[0])


text = WIDGET_TEXT(tab1_base,$
                   XOFFSET   = text.size[0],$
                   YOFFSET   = text.size[1],$
                   SCR_XSIZE = text.size[2],$
                   SCR_YSIZE = text.size[3],$
                   UNAME     = text.uname,$
                   /scroll,$
                   /wrap)

END
