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

cw_field_xsize = 35


;Pixel id base
fbase = WIDGET_BASE(SelectionTabBase,$
                    /BASE_ALIGN_CENTER,$
                    ROW          = 1)

text   = CW_FIELD(fbase,$
                  UNAME          = 'pixelid',$
                  RETURN_EVENTS  = 1,$
                  TITLE          = 'Pixel ID:',$
                  ROW            = 1,$
                  XSIZE          = cw_field_xsize)

button = WIDGET_BUTTON(fbase,$
                       VALUE     = 'EXCLUDE',$
                       UNAME     = 'exclude_pixelid',$
                       SCR_XSIZE = 55,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)

button = WIDGET_BUTTON(fbase,$
                       VALUE     = 'INCLUDE',$
                       UNAME     = 'include_pixelid',$
                       SCR_XSIZE = 55,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)


;Row of pixels
abase = WIDGET_BASE(SelectionTabBase,$
                    /BASE_ALIGN_CENTER,$
                    ROW          = 1)

text   = CW_FIELD(abase,$
                  UNAME          = 'pixel_row',$
                  RETURN_EVENTS  = 1,$
                  TITLE          = 'Row (Y): ',$
                  ROW            = 1,$
                  XSIZE          = cw_field_xsize)

button = WIDGET_BUTTON(abase,$
                       VALUE     = 'EXCLUDE',$
                       UNAME     = 'exclude_pixel_row',$
                       SCR_XSIZE = 55,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)

button = WIDGET_BUTTON(abase,$
                       VALUE     = 'INCLUDE',$
                       UNAME     = 'include_pixel_row',$
                       SCR_XSIZE = 55,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)


;Tube base
sbase = WIDGET_BASE(SelectionTabBase,$
                    /BASE_ALIGN_CENTER,$
                    ROW          = 1)

text   = CW_FIELD(sbase,$
                  UNAME          = 'tube',$
                  RETURN_EVENTS  = 1,$
                  TITLE          = 'Tube #:  ',$
                  ROW            = 1,$
                  XSIZE          = cw_field_xsize)

button = WIDGET_BUTTON(sbase,$
                       VALUE     = 'EXCLUDE',$
                       UNAME     = 'exclude_tube',$
                       SCR_XSIZE = 55,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)

button = WIDGET_BUTTON(sbase,$
                       VALUE     = 'INCLUDE',$
                       UNAME     = 'include_tube',$
                       SCR_XSIZE = 55,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)


;Excluded type (full or empty box)
base = WIDGET_BASE(SelectionTabBase,$
                   /BASE_ALIGN_CENTER,$
                   ROW = 1)

EcludedTypeLable = WIDGET_LABEL(base,$
                                VALUE = 'Excluded Pixel Symbol:   ')

excludedTypeList = ['Empty Box  ', 'Full Box  ']
ExcludedType = CW_BGROUP(base, $
                         excludedTypeList, $
                         /EXCLUSIVE, $
                         SET_VALUE = 0, $
                         UNAME = 'excluded_pixel_type', $
                         ROW = 1)


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
