PRO MakeGuiNeXusRoiBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, title

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
                  TITLE          = 'RUN NUMBER:',$
                  ROW            = 1,$
                  XSIZE          = 30,$
                  /INTEGER)

button = WIDGET_BUTTON(fbase,$
                       VALUE     = 'B R O W S E ...',$
                       UNAME     = 'nexus_run_number_button',$
                       SCR_XSIZE = 120,$
                       SCR_YSIZE = 30)

;full path of nexus file loaded
ffbase = WIDGET_BASE(NeXusRoiTabBase,$
                     ROW         = 1,$
                     /BASE_ALIGN_CENTER)

label = WIDGET_LABEL(ffbase,$
                     VALUE       = 'NeXus full path:',$
                     SCR_XSIZE   = 110,$
                     SCR_YSIZE   = 30)

label = WIDGET_LABEL(ffbase,$
                     VALUE       = '',$
                     UNAME       = 'nexus_full_path_label',$
                     SCR_XSIZE   = 300,$
                     SCR_YSIZE   = 30)

;Create Load roi file
sbase = WIDGET_BASE(NeXusRoiTabBase,$
                    ROW          = 1,$
                    /BASE_ALIGN_CENTER)

button = WIDGET_BUTTON(sbase,$
                       VALUE     = 'LOAD ROI FILE ..',$
                       UNAME     = 'laod_roi_file_button',$
                       SCR_XSIZE = 110,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)

text   = WIDGET_TEXT(sbase,$
                     VALUE       = '',$
                     XSIZE       = 47,$
                     /EDITABLE)

;Save roi file
tbase = WIDGET_BASE(NeXusRoiTabBase,$
                    ROW          = 1,$
                    /BASE_ALIGN_CENTER)

button = WIDGET_BUTTON(tbase,$
                       VALUE     = 'SAVE ROI',$
                       UNAME     = 'save_roi_file_button',$
                       SCR_XSIZE = 74,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)

text   = WIDGET_TEXT(tbase,$
                     UNAME       = 'save_roi_file_text',$
                     VALUE       = '',$
                     XSIZE       = 53,$
                     /EDITABLE)

;ROI path button
fbase = WIDGET_BASE(NeXusRoiTabBase,$
                    ROW = 1,$
                    /BASE_ALIGN_CENTER)

button = WIDGET_BUTTON(fbase,$
                       VALUE     = '~/local/',$
                       UNAME     = 'roi_path_button',$
                       SCR_XSIZE = 335,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)

button = WIDGET_BUTTON(fbase,$
                       VALUE     = 'Auto. Name',$
                       UNAME     = 'roi_file_name_generator',$
                       SCR_XSIZE = 75,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)
END
