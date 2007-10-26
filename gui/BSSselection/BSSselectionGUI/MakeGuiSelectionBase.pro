PRO MakeGuiSelectionBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, title

;***********************************************************************************
;                                Build GUI
;***********************************************************************************

SelectionTabBase = WIDGET_BASE(NeXusRoiSelectionTab,$
                               XOFFSET   = 0,$
                               YOFFSET   = 0,$
                               SCR_XSIZE = OpenNeXusSelectionTab[2]-5,$
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


;Row of pixels
abase = WIDGET_BASE(SelectionTabBase,$
                    /BASE_ALIGN_CENTER,$
                    ROW          = 1)

text   = CW_FIELD(abase,$
                  UNAME          = 'pixel_row',$
                  RETURN_EVENTS  = 1,$
                  TITLE          = 'Row of x:',$
                  ROW            = 1,$
                  XSIZE          = 40)

button = WIDGET_BUTTON(abase,$
                       VALUE     = 'ADD',$
                       UNAME     = 'add_pixel_row',$
                       SCR_XSIZE = 30,$
                       SCR_YSIZE = 30)

button = WIDGET_BUTTON(abase,$
                       VALUE     = 'REMOVE',$
                       UNAME     = 'remove_pixel_row',$
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


;full reset
fbase = WIDGET_BASE(SelectionTabBase,$
                    /BASE_ALIGN_CENTER,$
                    ROW          = 1)

button = WIDGET_BUTTON(fbase,$
                       UNAME     = 'reset_button',$
                       VALUE     = 'FULL RESET',$
                       SCR_XSIZE = 410,$
                       SCR_YSIZE = 25)                       

END
