PRO MakeGuiSelectionBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, title

;***********************************************************************************
;                                Build GUI
;***********************************************************************************

SelectionTabBase = WIDGET_BASE(NeXusRoiSelectionTab,$
                               XOFFSET   = 0,$
                               YOFFSET   = 0,$
                               SCR_XSIZE = OpenNeXusSelectionTab[2],$
                               SCR_YSIZE = OpenNeXusSelectionTab[3],$
                               TITLE     = title,$
                               COLUMN    = 1)

;Pixel id base
fbase = WIDGET_BASE(SelectionTabBase,$
                    /BASE_ALIGN_CENTER,$
                    ROW          = 1)

text   = CW_FIELD(fbase,$
                  UNAME          = 'pixelid',$
                  RETURN_EVENTS  = 1,$
                  TITLE          = 'Pixel ID:',$
                  ROW            = 1,$
                  XSIZE          = 40)

button = WIDGET_BUTTON(fbase,$
                       VALUE     = 'ADD',$
                       UNAME     = 'add_pixelid',$
                       SCR_XSIZE = 30,$
                       SCR_YSIZE = 30)

button = WIDGET_BUTTON(fbase,$
                       VALUE     = 'REMOVE',$
                       UNAME     = 'remove_pixelid',$
                       SCR_XSIZE = 50,$
                       SCR_YSIZE = 30)

;Tube base
sbase = WIDGET_BASE(SelectionTabBase,$
                    /BASE_ALIGN_CENTER,$
                    ROW          = 1)

text   = CW_FIELD(sbase,$
                  UNAME          = 'tube',$
                  RETURN_EVENTS  = 1,$
                  TITLE          = 'Tube # : ',$
                  ROW            = 1,$
                  XSIZE          = 40)

button = WIDGET_BUTTON(sbase,$
                       VALUE     = 'ADD',$
                       UNAME     = 'add_tube',$
                       SCR_XSIZE = 30,$
                       SCR_YSIZE = 30)

button = WIDGET_BUTTON(sbase,$
                       VALUE     = 'REMOVE',$
                       UNAME     = 'remove_tube',$
                       SCR_XSIZE = 50,$
                       SCR_YSIZE = 30)


;list of pixel and tubes removed
tbase = WIDGET_BASE(SelectionTabBase,$
                    /BASE_ALIGN_CENTER,$
                    ROW          = 1)

text = WIDGET_TEXT(tbase,$
                   VALUE         = '',$
                   SCR_XSIZE     = 330,$
                   SCR_YSIZE     = 70,$
                   UNAME         = 'pixel_tube_list',$
                   /SCROLL,/WRAP)

button = WIDGET_BUTTON(tbase,$
                       UNAME     = 'reset_button',$
                       VALUE     = 'FULL RESET',$
                       SCR_XSIZE = 80,$
                       SCR_YSIZE = 70)
                       

END
