PRO MakeGuiSelectionBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, title

;***********************************************************************************
;                                Build GUI
;***********************************************************************************

SelectionTabBase = WIDGET_BASE(NeXusRoiSelectionTab,$
                               XOFFSET   = 0,$
                               YOFFSET   = 0,$
                               SCR_XSIZE = OpenNeXusSelectionTab[2]-5,$
                               SCR_YSIZE = OpenNeXusSelectionTab[3],$
                               TITLE     = title)

cw_field_xsize = 35
yoffset = 40

;Pixel id base
fbase = WIDGET_BASE(SelectionTabBase,$
                    UNAME        = 'fbase',$
                    XOFFSET      = 0,$
                    YOFFSET      = 0,$
                    /BASE_ALIGN_CENTER,$
                    SENSITIVE    = 0,$
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
                    UNAME        = 'abase',$
                    XOFFSET      = 0,$
                    YOFFSET      = yoffset,$
                    /BASE_ALIGN_CENTER,$
                    SENSITIVE    = 0,$
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
                    XOFFSET      = 0,$
                    YOFFSET      = 2*yoffset,$
                    UNAME        = 'sbase',$
                    SENSITIVE    = 0,$
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
                   XOFFSET   = 0,$
                   YOFFSET   = 3*yoffset,$
                   /BASE_ALIGN_CENTER,$
                   UNAME     = 'symbol_base',$
                   SENSITIVE = 0,$
                   ROW       = 1)
ExcludedTypeLabel = WIDGET_LABEL(base,$
                                VALUE = 'Excluded Pixel Symbol:')

excludedTypeList = ['Empty Box', 'Full Box']
ExcludedType = CW_BGROUP(base, $
                         excludedTypeList, $
                         /EXCLUSIVE, $
                         SET_VALUE = 0, $
                         UNAME     = 'excluded_pixel_type', $
                         ROW       = 1)

button = WIDGET_BUTTON(base,$
                       UNAME     = 'select_everything_button',$
                       SCR_XSIZE = 100,$
                       SCR_YSIZE = 30,$
                       VALUE     = 'SELECT ALL')


;excluded pixel that have value LE than ... and full reset
ExclusionBase = WIDGET_BASE(SelectionTabBase,$
                            UNAME     = 'exclusion_base',$
                            XOFFSET   = 0,$
                            YOFFSET   = 4*yoffset,$
                            SCR_XSIZE = 290,$
                            SCR_YSIZE = 45,$
                            ROW       = 1,$
                            SENSITIVE = 0)

eBase = WIDGET_BASE(ExclusionBase,$
                    /BASE_ALIGN_CENTER,$
                    SENSITIVE = 1,$
                    UNAME     = 'ebase',$
                    ROW       = 1)

text = CW_FIELD(ExclusionBase,$
                UNAME         = 'counts_exclusion',$
                RETURN_EVENTS = 1,$
                TITLE         = 'Exclude pixels with counts <= to',$
                ROW           = 1,$
                XSIZE         = 7,$
                /INTEGER)

button = WIDGET_BUTTON(SelectionTabBase,$
                       XOFFSET   = 305,$
                       YOFFSET   = 4*yoffset+5,$
                       UNAME     = 'reset_button',$
                       VALUE     = 'FULL RESET',$
                       SCR_XSIZE = 100,$
                       SCR_YSIZE = 35,$
                       SENSITIVE = 0)
               

END
