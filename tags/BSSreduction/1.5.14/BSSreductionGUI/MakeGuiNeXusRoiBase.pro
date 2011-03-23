PRO MakeGuiNeXusRoiBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, title

;******************************************************************************
;                                Build GUI
;******************************************************************************

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
                  XSIZE          = 10)
;                  /INTEGER)

button = WIDGET_BUTTON(fbase,$
                       VALUE     = 'B R O W S E ...',$
                       UNAME     = 'nexus_run_number_button',$
                       SCR_XSIZE = 123,$
                       SCR_YSIZE = 30)

;Live Data Streaming button ---------------------------------------------------
button = WIDGET_BUTTON(fbase,$
                       SCR_XSIZE = 123,$
                       SCR_YSIZE = 30,$
                       UNAME     = 'live_data_streaming_button',$
                       VALUE     = 'LOAD LIVE DATA')


;full path of nexus file loaded
ffbase = WIDGET_BASE(NeXusRoiTabBase,$
                     ROW         = 1,$
                     /BASE_ALIGN_CENTER)

label = WIDGET_LABEL(ffbase,$
                     VALUE       = 'NeXus File:',$
                     SCR_XSIZE   = 75,$
                     SCR_YSIZE   = 30,$
                     /ALIGN_LEFT)

label = WIDGET_LABEL(ffbase,$
                     VALUE       = '',$
                     UNAME       = 'nexus_full_path_label',$
                     SCR_XSIZE   = 300,$
                     SCR_YSIZE   = 30,$
                     /ALIGN_LEFT,$
                     FRAME       = 0)

;Create Load roi file
sbase = WIDGET_BASE(NeXusRoiTabBase,$
                    ROW          = 1,$
                    /BASE_ALIGN_CENTER)

button = WIDGET_BUTTON(sbase,$
                       VALUE     = 'LOAD ROI FILE ..',$
                       UNAME     = 'load_roi_file_button',$
                       SCR_XSIZE = 110,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)

text   = WIDGET_TEXT(sbase,$
                     UNAME       = 'load_roi_file_text',$
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
                       VALUE     = '~/results/',$
                       UNAME     = 'roi_path_button',$
                       SCR_XSIZE = 320,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)

button = WIDGET_BUTTON(fbase,$
                       VALUE     = 'Refresh Name',$
                       UNAME     = 'roi_file_name_generator',$
                       SCR_XSIZE = 90,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)
END
