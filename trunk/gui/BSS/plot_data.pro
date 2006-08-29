pro MAIN_BASE_event, Event

  wWidget =  Event.top  ;widget id

;stop

  case Event.id of

    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end

    ;Open widget in the top toolbar
    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_HISTOGRAM'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_HISTOGRAM, Event
    end

    ;Open widget in the top toolbar
    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_MAPPED_HISTOGRAM'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_MAPPED_HISTOGRAM, Event
    end
    
    ;Exit widget in the top toolbar
    Widget_Info(wWidget, FIND_BY_UNAME='EXIT_MENU'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        EXIT_PROGRAM, Event
    end

    ;Widget to change the color of graph
    Widget_Info(wWidget, FIND_BY_UNAME='ABOUT_MENU'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        ABOUT_MENU, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='IDENTIFICATION_TEXT'): begin
    	IDENTIFICATION_TEXT_CB, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='IDENTIFICATION_GO'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        IDENTIFICATION_GO_cb, Event
    end

    ;output path button
    Widget_Info(wWidget, FIND_BY_UNAME='OUTPUT_PATH'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OUTPUT_PATH_cb, Event
    end

    ;Load Event file
    Widget_Info(wWidget, FIND_BY_UNAME='EVENT_FILE'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        EVENT_FILE_cb, Event
    end

    ;Default path button in identification frame
    Widget_Info(wWidget, FIND_BY_UNAME='DEFAULT_PATH_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        DEFAULT_PATH_BUTTON_cb, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='EVENT_TO_HISTO'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        EVENT_TO_HISTO_cb, Event
    end

    else:
  endcase

end

pro MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;define parameters
scr_x 	= 930				;main window width
scr_y 	= 700				;main window height 
ctrl_x	= 1				;width of left box - control
ctrl_y	= scr_y				;height of lect box - control
draw_x 	= 304				;main width of draw area
draw_y 	= 256				;main heigth of draw area
draw_offset_x = 10			;draw x offset within widget
draw_offset_y = 10			;draw y offset within widget
plot_height = 150			;plot box height
plot_length = 304			;plot box length

Resolve_Routine, 'plot_data_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup, UNAME='MAIN_BASE'  $
      ,XOFFSET=100 ,YOFFSET=22 ,SCR_XSIZE=scr_x ,SCR_YSIZE=scr_y  $
      ,NOTIFY_REALIZE='MAIN_REALIZE' ,TITLE='Plot BSS histogram data'  $
      ,SPACE=3 ,XPAD=3 ,YPAD=3 ,MBAR=WID_BASE_0_MBAR)

;define initial global values - these could be input via external file or other means

global = ptr_new({$
		file			:'',$
		path			:'/SNSlocal/tmp/',$
		working_path		:'',$
		default_path		:'/SNS/users/',$
		event_file_path		:'/SNS/BSS/2006_1_2_SCI/',$
		event_filename		:'',$
		event_filename_only	:'',$
		histogram_filename	:'',$
		histogram_filename_only :'',$
		mapping_filename	:'/SNS/BSS/2006_1_2_CAL/calibrations/BSS_TS_2006_06_09.dat',$
		filter_event		:'*_event.dat',$
		ucams			:'',$
		name			:'',$
		character_id		:'',$
		filter_histo		:'',$
		nbytes			:4L,$
		swap_endian		:0,$
		pixelids		:9216L,$
		Nx			:64L,$
		Ny			:144L,$
		Nx_tubes		:64L,$
		Ny_pixels		:64L,$
		xtitle			:'tubes',$
		ytitle			:'pixels',$
		do_color		:1$ 
})

;attach global data structure with widget ID of widget main base widget ID
widget_control,MAIN_BASE,set_uvalue=global

IDENTIFICATION_BASE= widget_base(MAIN_BASE, XOFFSET=300, YOFFSET=300,$
	UNAME='IDENTIFICATION_BASE',$
	SCR_XSIZE=240, SCR_YSIZE=120, FRAME=10,$
	SPACE=4, XPAD=3, YPAD=3)

IDENTIFICATION_LABEL = widget_label(IDENTIFICATION_BASE,$
		XOFFSET=40, YOFFSET=3, VALUE="ENTER YOUR 3 CHARACTERS ID")

IDENTIFICATION_TEXT = widget_text(IDENTIFICATION_BASE,$
		XOFFSET=100, YOFFSET=20, VALUE='',$
		SCR_XSIZE=37, /editable,$
		UNAME='IDENTIFICATION_TEXT',/ALL_EVENTS)

ERROR_IDENTIFICATION_left = widget_label(IDENTIFICATION_BASE,$
		XOFFSET=5, YOFFSET=25, VALUE='',$
		SCR_XSIZE=90, SCR_YSIZE=20, $
		UNAME='ERROR_IDENTIFICATION_LEFT')

ERROR_IDENTIFICATION_right = widget_label(IDENTIFICATION_BASE,$
		XOFFSET=140, YOFFSET=25, VALUE='',$
		SCR_XSIZE=90, SCR_YSIZE=20, $
		UNAME='ERROR_IDENTIFICATION_RIGHT')

DEFAULT_PATH_BUTTON = widget_button(IDENTIFICATION_BASE,$
		XOFFSET=0, YOFFSET=55, VALUE='Working path',$
		SCR_XSIZE=80, SCR_YSIZE=30,$
		UNAME='DEFAULT_PATH_BUTTON')

DEFAULT_PATH_TEXT = widget_text(IDENTIFICATION_BASE,$
		XOFFSET=83, YOFFSET=55, VALUE=(*global).default_path,$
		UNAME='DEFAULT_PATH_TEXT',/editable,$
		SCR_XSIZE=150)

IDENTIFICATION_GO = widget_button(IDENTIFICATION_BASE,$
		XOFFSET=67, YOFFSET=90,$
		SCR_XSIZE=130, SCR_YSIZE=30,$
		VALUE="E N T E R",$
		UNAME='IDENTIFICATION_GO')		

;draw boxes for plot windows

;TOP_BANK
  VIEW_DRAW_TOP_BANK = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_TOP_BANK',$
	XOFFSET=10,$
        YOFFSET=150,$
	SCR_XSIZE=800,$
	SCR_YSIZE=250 ,RETAIN=2)

;BOTTOM_BANK
  VIEW_DRAW_BOTTOM_BANK = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_BOTTOM_BANK',$
	XOFFSET=10,$
        YOFFSET=405,$
	SCR_XSIZE=800,$
	SCR_YSIZE=250 ,RETAIN=2)

;SCALE_TOP_PLOT
  SCALE_VIEW = Widget_Draw(MAIN_BASE,$
	UNAME='SCALE_TOP_PLOT',$
	XOFFSET=850,$
	YOFFSET=150,$
	SCR_XSIZE=70,$
	SCR_YSIZE=250)

;SCALE_BOTTOM_PLOT
  SCALE_VIEW = Widget_Draw(MAIN_BASE,$
	UNAME='SCALE_BOTTOM_PLOT',$
	XOFFSET=850,$
	YOFFSET=405,$
	SCR_XSIZE=70,$
	SCR_YSIZE=250)

 X_SCALE = Widget_Draw(MAIN_BASE, UNAME='X_SCALE',$
	XOFFSET=4,$
	YOFFSET=660,$
	SCR_XSIZE=812,$
	SCR_YSIZE=30)

 Y_SCALE_TOP_BANK = Widget_Draw(MAIN_BASE, UNAME='Y_SCALE_TOP_BANK',$
	XOFFSET=815,$
	YOFFSET=144,$
	SCR_XSIZE=30,$
	SCR_YSIZE=262)

 Y_SCALE_BOTTOM_BANK = Widget_Draw(MAIN_BASE, UNAME='Y_SCALE_BOTTOM_BANK',$
	XOFFSET=815,$
	YOFFSET=399,$
	SCR_XSIZE=30,$
	SCR_YSIZE=262)

  GENERAL_INFOS = widget_text(MAIN_BASE, $
	UNAME='GENERAL_INFOS', $
	XOFFSET=10,$
	YOFFSET= 20+draw_offset_y, $
	SCR_XSIZE=500, $
	SCR_YSIZE=110,$
	/WRAP,$
	/SCROLL)
	
   GENERAL_INFOS_LABEL = widget_label(MAIN_BASE,$
	XOFFSET=10,$
	YOFFSET= draw_offset_y, $
	value="General Informations")

  EVENT_FILE = widget_button(MAIN_BASE,$
	UNAME="EVENT_FILE",$
	XOFFSET=527,$
	YOFFSET=23,$
	SCR_XSIZE=80,$
	SCR_YSIZE=25,$
	VALUE="Event file")

  EVENT_FILENAME = widget_text(MAIN_BASE,$
	UNAME="EVENT_FILENAME",$
	XOFFSET=610,$
	YOFFSET=20,$
	SCR_XSIZE=300,$
	SCR_YSIZE=30,$
	VALUE="")

  OUTPUT_PATH = widget_button(MAIN_BASE,$
	UNAME="OUTPUT_PATH",$
	XOFFSET=527,$
	YOFFSET=53,$
	SCR_XSIZE=80,$
	SCR_YSIZE=25,$
	VALUE="Output path")

  OUTPUT_PATH_NAME = widget_text(MAIN_BASE,$
	UNAME="OUTPUT_PATH_NAME",$
	XOFFSET=610,$
	YOFFSET=50,$
	SCR_XSIZE=300,$
	SCR_YSIZE=30,$
	VALUE="")
  
  TIME_BIN_LABEL = widget_label(MAIN_BASE,$
	XOFFSET=530,$
	YOFFSET=85,$
	SCR_XSIZE=30,$
	SCR_YSIZE=30,$
	VALUE="Tbin")

  TIME_BIN_VALUE = widget_text(MAIN_BASE,$
	UNAME="TIME_BIN_VALUE",$
	XOFFSET=560,$
	YOFFSET=85,$
	SCR_XSIZE=50,$
	SCR_YSIZE=30,$
	/editable,VALUE='25') 

  TIME_BIN_UNITS = widget_label(MAIN_BASE,$
	XOFFSET=558,$
	YOFFSET=105,$
	SCR_XSIZE=50,$
	SCR_YSIZE=30,$
	VALUE="microS")


  MAX_TIMEBIN_LABEL = widget_label(MAIN_BASE,$
	XOFFSET=630,$
	YOFFSET=85,$
	SCR_XSIZE=50,$
	SCR_YSIZE=30,$
	VALUE="Max Tbin")

  MAX_TIMEBIN_VALUE = widget_text(MAIN_BASE,$
	UNAME="MAX_TIMEBIN_VALUE",$
	XOFFSET=680,$
	YOFFSET=85,$
	SCR_XSIZE=60,$
	SCR_YSIZE=30,$
	/editable,VALUE='200000') 

  MAX_TIMEBIN_UNITS = widget_label(MAIN_BASE,$
	XOFFSET=680,$
	YOFFSET=105,$
	SCR_XSIZE=50,$
	SCR_YSIZE=30,$
	VALUE="microS")

  EVENT_TO_HISTO = widget_button(MAIN_BASE,$
	UNAME="EVENT_TO_HISTO",$
	XOFFSET=750,$
	YOFFSET=85,$
	SCR_XSIZE=150,$
	SCR_YSIZE=50,$
	VALUE="HISTOGRAMMING/MAPPING")


  TRANSLATION_LABEL = Widget_label(MAIN_BASE,$
	XOFFSET=527,$
	YOFFSET=6,$
	VALUE="Event to Histo")

  TRANSLATION_FRAME = Widget_label(MAIN_BASE,$
	XOFFSET=520,$
	YOFFSET=5+draw_offset_y,$
	SCR_XSIZE=395,$
	SCR_YSIZE=120,$
	FRAME=2,VALUE='')

  FILE_MENU = Widget_Button(WID_BASE_0_MBAR, UNAME='FILE_MENU' ,/MENU  $
      ,VALUE='File')

  OPEN_MAPPED_HISTOGRAM = Widget_Button(FILE_MENU, UNAME='OPEN_MAPPED_HISTOGRAM'  $
      ,VALUE='Open Mapped Histogram')

  OPEN_HISTOGRAM = Widget_Button(FILE_MENU, UNAME='OPEN_HISTOGRAM'  $
      ,VALUE='Open Histogram')

  EXIT_MENU = Widget_Button(FILE_MENU, UNAME='EXIT_MENU'  $
      ,VALUE='Exit')

  UTILS_MENU = Widget_Button(WID_BASE_0_MBAR, UNAME='UTILS_MENU'  $
      ,/MENU ,VALUE='plotBSS')

  ABOUT_MENU = Widget_Button(UTILS_MENU, UNAME='ABOUT_MENU'  $
      ,VALUE='about plotBSS')

  Widget_Control, /REALIZE, MAIN_BASE

  ;disabled background buttons/draw/text/labels
  Widget_Control, OPEN_MAPPED_HISTOGRAM, sensitive=0
  Widget_Control, OPEN_HISTOGRAM, sensitive=0
  Widget_Control, OUTPUT_PATH, sensitive=0
  Widget_Control, EVENT_FILE, sensitive=0
  Widget_Control, EVENT_TO_HISTO, sensitive=0
  Widget_Control, MAX_TIMEBIN_VALUE, sensitive=0
  Widget_Control, TIME_BIN_VALUE, sensitive=0
    
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

;
; Empty stub procedure used for autoloading.
;
pro plot_data, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
