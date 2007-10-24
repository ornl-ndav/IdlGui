PRO MakeGuiNeXusRoiBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, title

;***********************************************************************************
;                             Define size arrays
;***********************************************************************************



;***********************************************************************************
;                                Build GUI
;***********************************************************************************

NeXusRoiTabBase = WIDGET_BASE(NeXusRoiSelectionTab,$
                              XOFFSET   = 0,$
                              YOFFSET   = 0,$
                              SCR_XSIZE = OpenNeXusSelectionTab[2],$
                              SCR_YSIZE = OpenNeXusSelectionTab[3],$
                              TITLE     = title,$
                              COLUMN    = 1)

;Create Open NeXus base
fbase = WIDGET_BASE(NeXusRoiTabBase,$
                    ROW          = 1,$
                    /BASE_ALIGN_CENTER)

text   = CW_FIELD(fbase,$
                  UNAME          = 'nexus_run_number',$
                  RETURN_EVENTS  = 1,$
                  TITLE          = 'RUN #:',$
                  ROW            = 1,$
                  XSIZE          = 43)

button = WIDGET_BUTTON(fbase,$
                       VALUE     = 'BROWSE ...',$
                       UNAME     = 'nexus_run_number_button',$
                       SCR_XSIZE = 80,$
                       SCR_YSIZE = 30)

;Create Load roi file
sbase = WIDGET_BASE(NeXusRoiTabBase,$
                    ROW          = 1,$
                    /BASE_ALIGN_CENTER)

button = WIDGET_BUTTON(sbase,$
                       VALUE     = 'LOAD ROI FILE ..',$
                       UNAME     = 'laod_roi_file_button',$
                       SCR_XSIZE = 110,$
                       SCR_YSIZE = 30)

text   = WIDGET_TEXT(sbase,$
                     VALUE       = '',$
                     XSIZE       = 46,$
                     /EDITABLE)

;Save roi file
tbase = WIDGET_BASE(NeXusRoiTabBase,$
                    ROW          = 1,$
                    /BASE_ALIGN_CENTER)

button = WIDGET_BUTTON(tbase,$
                       VALUE     = 'SAVE ROI FILE',$
                       UNAME     = 'save_roi_file_button',$
                       SCR_XSIZE = 110,$
                       SCR_YSIZE = 30)

text   = WIDGET_TEXT(tbase,$
                     VALUE       = '',$
                     XSIZE       = 46,$
                     /EDITABLE)


END
