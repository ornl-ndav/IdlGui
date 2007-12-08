PRO MakeGui, MAIN_BASE, MainBaseSize, InstrumentList, InstrumentIndex

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

base = { size  : [0,0,MainBaseSize[2:3]],$
         uname : 'first_base'} 

XYoff = [10,10]
run_number_base = { size  : [XYoff[0],$
                             XYoff[1],$
                             160,$
                             35],$
                    uname : 'run_number_cw_field',$
                    xsize : 10,$
                    title : 'Run Number:'}

XYOff = [180,0]
instrumentDroplist = { size : [run_number_base.size[0]+XYoff[0],$
                               run_number_base.size[1]+XYoff[1]],$
                       uname : 'instrument_droplist'}

XYoff = [0,45]
output_button = { size  : [run_number_base.size[0]+XYoff[0],$
                           run_number_base.size[1]+XYoff[1],$
                           130,35],$
                  uname : 'output_button',$
                  value : 'Main Output path...'}

XYoff = [130,0]
output_text = { size  : [output_button.size[0]+XYoff[0],$
                         output_button.size[1]+XYoff[1],$
                         255,35],$
                uname : 'output_path_text',$
                value : '~/local/'}

XYoff = [0,40]
shared_base = { size : [output_button.size[0]+XYoff[0],$
                        output_button.size[1]+XYoff[1],$
                        380,35],$
                uname : 'shared_base'}
button_list = { list : ['Instrument Shared Folder   ',$
                        'Proposal Shared Folder     '],$
                uname : 'shared_button'}

XYoff = [0,45]
go_button = { size  : [shared_base.size[0]+XYoff[0],$
                       shared_base.size[1]+XYoff[1],$
                       380,30],$
              uname : 'create_nexus_button',$
              value : 'C R E A T E   N E X U S'}

XYOFF = [0,45]
log_book = { size  : [go_button.size[0]+XYoff[0],$
                      go_button.size[1]+XYoff[1],$
                      380,150],$
             uname : 'log_book'}

XYOFF = [0,log_book.size[3]+5]
my_log_book = { size  : [log_book.size[0]+XYoff[0],$
                         log_book.size[1]+XYoff[1],$
                         780,150],$
                uname : 'my_log_book'}

;***********************************************************************************
;                                Build GUI
;***********************************************************************************
base = WIDGET_BASE(MAIN_BASE,$
                   UNAME     = base.uname,$
                   XOFFSET   = 0,$
                   YOFFSET   = 0,$
                   SCR_XSIZE = base.size[2],$
                   SCR_YSIZE = base.size[3],$
                   map=1)  ;REMOVE 0 and put back 1

run_base = WIDGET_BASE(base,$
                       XOFFSET   = run_number_base.size[0],$
                       YOFFSET   = run_number_base.size[1],$
                       SCR_XSIZE = run_number_base.size[2],$
                       SCR_YSIZE = run_number_base.size[3])

run_number = CW_FIELD(run_base,$
                      XSIZE         = run_number_base.xsize,$
                      UNAME         = run_number_base.uname,$
                      RETURN_EVENTS = 1,$
                      ROW           = 1,$
                      TITLE         = run_number_base.title,$
                      /INTEGER)
                              
Instrument_droplist = WIDGET_DROPLIST(base,$
                                      VALUE   = InstrumentList,$
                                      XOFFSET = instrumentDroplist.size[0],$
                                      YOFFSET = instrumentDroplist.size[1],$
                                      UNAME   = instrumentDroplist.uname)

button = WIDGET_BUTTON(base,$
                       XOFFSET   = output_button.size[0],$
                       YOFFSET   = output_button.size[1],$
                       SCR_XSIZE = output_button.size[2],$
                       SCR_YSIZE = output_button.size[3],$
                       UNAME     = output_button.uname,$
                       VALUE     = output_button.value)

text = WIDGET_TEXT(base,$
                   XOFFSET   = output_text.size[0],$
                   YOFFSET   = output_text.size[1],$
                   SCR_XSIZE = output_text.size[2],$
                   SCR_YSIZE = output_text.size[3],$
                   VALUE     = output_text.value,$
                   UNAME     = output_text.uname,$
                   /EDITABLE)

base_shared = WIDGET_BASE(base,$
                          XOFFSET   = shared_base.size[0],$
                          YOFFSET   = shared_base.size[1],$
                          SCR_XSIZE = shared_base.size[2],$
                          SCR_YSIZE = shared_base.size[3],$
                          UNAME     = shared_base.uname)
                          
group = CW_BGROUP(base_shared,$
                  button_list.list,$
                  UNAME      = button_list.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = [0,0],$
                  ROW        = 1)

button = WIDGET_BUTTON(base,$
                       XOFFSET   = go_button.size[0],$
                       YOFFSET   = go_button.size[1],$
                       SCR_XSIZE = go_button.size[2],$
                       SCR_YSIZE = go_button.size[3],$
                       UNAME     = go_button.uname,$
                       VALUE     = go_button.value,$
                       SENSITIVE = 0)

text = WIDGET_TEXT(base,$
                   XOFFSET   = log_book.size[0],$
                   YOFFSET   = log_book.size[1],$
                   SCR_XSIZE = log_book.size[2],$
                   SCR_YSIZE = log_book.size[3],$
                   VALUE     = '',$
                   /EDITABLE,$
                   UNAME     = log_book.uname,$
                   /WRAP,$
                   /SCROLL)

text = WIDGET_TEXT(base,$
                   XOFFSET   = my_log_book.size[0],$
                   YOFFSET   = my_log_book.size[1],$
                   SCR_XSIZE = my_log_book.size[2],$
                   SCR_YSIZE = my_log_book.size[3],$
                   VALUE     = '',$
                   UNAME     = my_log_book.uname,$
                   /WRAP,$
                   /SCROLL)



END
