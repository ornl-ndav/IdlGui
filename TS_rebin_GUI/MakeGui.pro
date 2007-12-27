PRO MakeGui, MAIN_BASE, WidgetInit

;main base (without ok or cancel buttons)
main = WIDGET_BASE(MAIN_BASE,$
                   COLUMN = 1,$
                   FRAME  = 2)

;Runs number, instrument, proposal number
first_base = WIDGET_BASE(main,$
                         ROW = 1,$
                         /BASE_ALIGN_CENTER)

label = WIDGET_LABEL(first_base,$
                     VALUE = 'Runs #:')

text  = WIDGET_TEXT(first_base,$
                    UNAME = 'runs',$
                    /EDITABLE,$
                    XSIZE = 20,$
                    /ALL_EVENTS)

label = WIDGET_LABEL(first_base,$
                     VALUE = '  Instrument:')

text  = WIDGET_TEXT(first_base,$
                    UNAME = 'instrument',$
                    /EDITABLE,$
                    XSIZE = 5,$
                    VALUE = WidgetInit.instrument,$
                    /ALL_EVENTS)

label = WIDGET_LABEL(first_base,$
                     VALUE = ' Proposal number:')

text = WIDGET_TEXT(first_base,$
                   UNAME = 'proposal_number',$
                   /EDITABLE,$
                   XSIZE = 13,$
                   /ALL_EVENTS)

;Bins width and type
second_base = WIDGET_BASE(main,$
                          ROW = 1,$
                          /ALIGN_LEFT)

label = WIDGET_LABEL(second_base,$
                     VALUE = 'Bins:')

label = WIDGET_LABEL(second_base,$
                     VALUE = ' width:')

text = WIDGET_TEXT(second_base,$
                   UNAME = 'bin_width',$
                   /EDITABLE,$
                   XSIZE = 5,$
                   VALUE = strcompress(WidgetInit.bin_width,/remove_all),$
                   /ALL_EVENTS)

type_list = ['linear','log']
group = cw_bgroup(second_base,$
                  type_list,$
                  UNAME = 'bin_type',$
                  /EXCLUSIVE,$
                  /ROW,$
                  SET_VALUE=0)

label = WIDGET_LABEL(second_base,$
                     VALUE = '  Time offset:')

text = WIDGET_TEXT(second_base,$
                   UNAME = 'time_offset',$
                   /EDITABLE,$
                   XSIZE=5,$
                   /ALL_EVENTS)
                   
label = WIDGET_LABEL(second_base,$
                     VALUE = ' Max. time:')

text = WIDGET_TEXT(second_base,$
                   UNAME = 'max_time',$
                   /EDITABLE,$
                   XSIZE=7,$
                   /ALL_EVENTS)
                   
;output path
third_base = WIDGET_BASE(main,$
                         ROW=1)

label = WIDGET_LABEL(third_base,$
                     VALUE = 'Output path:')

text = WIDGET_TEXT(third_base,$
                   UNAME = 'output_path',$
                   /EDITABLE,$
                   XSIZE=55,$
                   VALUE = WidgetInit.staging_area,$
                   /ALL_EVENTS)

button = WIDGET_BUTTON(third_base,$
                       UNAME = 'output_path_button',$
                       SCR_XSIZE = 100,$
                       VALUE = 'Browse...')
                         
;staging area
fourth_base = WIDGET_BASE(main,$
                          ROW=1)

label = WIDGET_LABEL(fourth_base,$
                     VALUE = 'Staging area:')

text = WIDGET_TEXT(fourth_base,$
                   UNAME = 'staging_area',$
                   /EDITABLE,$
                   XSIZE=54,$
                   VALUE = WidgetInit.staging_area,$
                   /ALL_EVENTS)

button = WIDGET_BUTTON(fourth_base,$
                       UNAME = 'staging_area_button',$
                       SCR_XSIZE = 100,$
                       VALUE = 'Browse...')
                         
;REBIN NEXUS FILES
bbase = WIDGET_BASE(MAIN_BASE,$
                    ROW = 1,$
                    /ALIGN_CENTER)

button = WIDGET_BUTTON(bbase,$
                       UNAME = 'go',$
                       SCR_XSIZE = 530,$
                       SCR_YSIZE = 30,$
                       VALUE = '>   >  > > REBIN NEXUS FILES < <  <   <',$
                       SENSITIVE=0)

;MESSAGE BOX
text_base = WIDGET_BASE(MAIN_BASE,$
                        ROW=1,$
                        /ALIGN_CENTER)

text = WIDGET_TEXT(text_base,$
                   UNAME = 'log_book',$
                   XSIZE = 82,$
                   YSIZE = 6,$
                   /SCROLL,$
                   /WRAP)

END
