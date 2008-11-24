pro MAIN_BASE_event, Event

  wWidget =  Event.top  ;widget id

;stop

  case Event.id of

    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end

    Widget_Info(wWidget, FIND_BY_UNAME='VIEW_DRAW_TOP_BANK'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_DRAW' )then $
        if( Event.type eq 0 )then $
          VIEW_ONBUTTON_top, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='VIEW_DRAW_BOTTOM_BANK'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_DRAW' )then $
        if( Event.type eq 0 )then $
          VIEW_ONBUTTON_bottom, Event
    end

;if file menu

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
    
    ;Open widget in the top toolbar
    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_NEXUS'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_NEXUS_INTERFACE, Event
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

    ;output path button
    Widget_Info(wWidget, FIND_BY_UNAME='OUTPUT_PATH'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OUTPUT_PATH_cb, Event
    end

;open nexus interface

    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_RUN_NUMBER_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_RUN_NUMBER, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='CANCEL_OPEN_RUN_NUMBER_BUTTON'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          CANCEL_OPEN_RUN_NUMBER, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='IDENTIFICATION_GO'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        IDENTIFICATION_BSS_GO_cb, Event
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

    Widget_Info(wWidget, FIND_BY_UNAME='MIN_TBIN_TEXT'): begin
	min_tbin_text, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='MAX_TBIN_TEXT'): begin
  	max_tbin_text, Event
    end


    else:
  endcase

end

pro MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

APPLICATION = 'plotBSS'
VERSION     = '1.0.1'

;define parameters
scr_x 	      = 930             ;main window width
scr_y 	      = 700             ;main window height 
ctrl_x	      = 1               ;width of left box - control
ctrl_y	      = scr_y           ;height of lect box - control
draw_x 	      = 304             ;main width of draw area
draw_y 	      = 256             ;main heigth of draw area
draw_offset_x = 10              ;draw x offset within widget
draw_offset_y = 10              ;draw y offset within widget
plot_height   = 150             ;plot box height
plot_length   = 304             ;plot box length

Resolve_Routine, $
  'plot_data_eventcb', $
  /COMPILE_FULL_FILE            ; Load event callback routines

title = APPLICATION + ' -' + VERSION
MAIN_BASE = Widget_Base(GROUP_LEADER=wGroup, $
                        UNAME          = 'MAIN_BASE',$
                        XOFFSET        = 100, $
                        YOFFSET        = 22, $
                        SCR_XSIZE      = scr_x, $
                        SCR_YSIZE      = scr_y, $
                        NOTIFY_REALIZE = 'MAIN_REALIZE', $
                        TITLE          = title,$
                        SPACE          = 3, $
                        XPAD           = 3, $
                        YPAD           = 3, $
                        MBAR           = WID_BASE_0_MBAR)

;define initial global values -
;these could be input via external file or other means

global = ptr_new({$
                   image_top : ptr_new(0L),$
                   image_bottom : ptr_new(0L),$
                   file_open : '',$
                   run_number : 0,$
                   find_nexus : 0,$
                   full_nexus_name : '',$
                   full_tmp_nxdir_folder_path: '',$
                   tmp_nxdir_folder : '/plotBSS_tmp/',$
                   file_to_plot_top : '',$
                   file_to_plot_bottom : '',$
                   file			:'',$
                   file_already_opened	:0,$
                   path			:'/SNSlocal/tmp/',$
                   working_path		:'',$
                   default_path		:'/SNSlocal/users/',$
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
                   Ny_scat		:128L,$
                   Ny                   :144L,$
                   Nt			:10L,$
                   y_coeff			:0L,$
                   x_coeff			:0L,$
                   Nx_tubes		:64L,$
                   Ny_pixels		:64L,$
                   minimum_tbin		:0L,$
                   min_tbin		:0L,$
                   maximum_tbin		:500L,$
                   max_tbin		:500L,$
                   refresh_histo		:0,$
                   pixel_offset		:4096L,$
                   xtitle			:'tubes',$
                   ytitle			:'pixels',$
                   top_bank		: ptr_new(0L),$
                   bottom_bank		: ptr_new(0L),$
                   img			: ptr_new(0L),$
                   overflow_number		: 500L,$	
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



;open nexus interface
;open nexus_file window
  OPEN_NEXUS_BASE= widget_base(MAIN_BASE,$
                               XOFFSET=90,$
                               YOFFSET=170,$
                               UNAME='OPEN_NEXUS_BASE',$
                               SCR_XSIZE=300,$
                               SCR_YSIZE=50,$
                               FRAME=10,$
                               SPACE=4,$
                               XPAD=3,$
                               YPAD=3,$
                               MAP=0)    ;REMOVE_ME, PUT 0 INSTEAD
  
  OPEN_RUN_NUMBER_LABEL = widget_label(OPEN_NEXUS_BASE,$
                                       xoffset=5,$
                                       yoffset=8,$
                                       uname='OPEN_RUN_NUMBER_LABEL',$
                                       scr_xsize=65,$
                                       scr_ysize=30,$
                                       value='Run number ')
  
  OPEN_RUN_NUMBER_TEXT = widget_text(OPEN_NEXUS_BASE,$
                                     xoffset=70,$
                                     yoffset=8,$
                                     scr_xsize=80,$
                                     scr_ysize=30,$
                                     value='',$
                                     uname='OPEN_RUN_NUMBER_TEXT',$
                                     /editable,$
                                     /align_left)
  
  OPEN_RUN_NUMBER_BUTTON = widget_button(OPEN_NEXUS_BASE,$
                                         xoffset=160,$
                                         yoffset=8,$
                                         scr_xsize=60,$
                                         scr_ysize=30,$
                                         value='OPEN',$
                                         uname='OPEN_RUN_NUMBER_BUTTON')
  
  CANCEL_OPEN_RUN_NUMBER_BUTTON = widget_button(OPEN_NEXUS_BASE,$
                                                xoffset=230,$
                                                yoffset=8,$
                                                scr_xsize=60,$
                                                scr_ysize=30,$
                                                value='CANCEL',$
                                                uname='CANCEL_OPEN_RUN_NUMBER_BUTTON')


;draw boxes for plot windows

;TOP_BANK
  VIEW_DRAW_TOP_BANK = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_TOP_BANK',$
	XOFFSET=10,$
        YOFFSET=150,$
	SCR_XSIZE=769,$
	SCR_YSIZE=257 ,RETAIN=2,$
	/BUTTON_EVENTS,/MOTION_EVENTS)

;BOTTOM_BANK
  VIEW_DRAW_BOTTOM_BANK = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_BOTTOM_BANK',$
	XOFFSET=10,$
        YOFFSET=410,$
	SCR_XSIZE=769,$
	SCR_YSIZE=257 ,$
	/BUTTON_EVENTS,/MOTION_EVENTS,$
	RETAIN=2)

;SCALE_TOP_PLOT
  SCALE_VIEW = Widget_Draw(MAIN_BASE,$
	UNAME='SCALE_TOP_PLOT',$
	XOFFSET=835,$
	YOFFSET=153,$
	SCR_XSIZE=80,$
	SCR_YSIZE=250)

;SCALE_BOTTOM_PLOT
  SCALE_VIEW = Widget_Draw(MAIN_BASE,$
	UNAME='SCALE_BOTTOM_PLOT',$
	XOFFSET=835,$
	YOFFSET=410,$
	SCR_XSIZE=80,$
	SCR_YSIZE=250)

 X_SCALE = Widget_Draw(MAIN_BASE, UNAME='X_SCALE',$
	XOFFSET=9,$
	YOFFSET=670,$
	SCR_XSIZE=780,$
	SCR_YSIZE=30)

 Y_SCALE_TOP_BANK = Widget_Draw(MAIN_BASE, UNAME='Y_SCALE_TOP_BANK',$
	XOFFSET=781,$
	YOFFSET=149,$
	SCR_XSIZE=20,$
	SCR_YSIZE=260)

 Y_SCALE_BOTTOM_BANK = Widget_Draw(MAIN_BASE, UNAME='Y_SCALE_BOTTOM_BANK',$
	XOFFSET=802,$
	YOFFSET=407,$
	SCR_XSIZE=20,$
	SCR_YSIZE=260)

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


  TRANSLATION_DISPLAY_HISTO_FRAME = WIDGET_TAB(MAIN_BASE,$
	LOCATION=0,$
	XOFFSET=520,$
	YOFFSET=5,$
	SCR_XSIZE=395,$
	SCR_YSIZE=140)



;Frame to play with tbins in display

   y_offset_1 = 10
   y_offset_2 = 45
   y_offset_3 = 70

   TBIN_FRAME = WIDGET_BASE(TRANSLATION_DISPLAY_HISTO_FRAME,$
                            uname='tbin_frame',$
                            TITLE="Time Bin interaction (microS)",$
                            SCR_XSIZE=395,$
                            SCR_YSIZE=140,$
                           sensitive=0)

   MIN_TBIN = WIDGET_LABEL(TBIN_FRAME,$
	VALUE="Min Tbin ",$
	XOFFSET= 5,$
	YOFFSET= y_offset_1,$
	SCR_XSIZE=60,$
	SCR_YSIZE=35)

   MIN_TBIN_SLIDER = WIDGET_SLIDER(TBIN_FRAME,$
	UNAME="MIN_TBIN_SLIDER",$
	XOFFSET= 70,$
	YOFFSET= y_offset_1-5,$
	SCR_XSIZE=250,$
	SCR_YSIZE=35,$
	MINIMUM=(*global).minimum_tbin,$
	MAXIMUM=(*global).maximum_tbin,$
	/DRAG,$
	VALUE=0,$
	EVENT_PRO="min_tbin_slider")

   MIN_TBIN_TEXT = WIDGET_TEXT(TBIN_FRAME,$
	UNAME="MIN_TBIN_TEXT",$
	XOFFSET=325,$
	YOFFSET=y_offset_1+2,$
	SCR_XSIZE=55,$
	SCR_YSIZE=30,$
	VALUE='0',$
	/EDITABLE,$
	/ALL_EVENTS)

   MAX_TBIN = WIDGET_LABEL(TBIN_FRAME,$
	VALUE="Max Tbin ",$
	XOFFSET= 5,$
	YOFFSET= y_offset_2,$
	SCR_XSIZE=60,$
	SCR_YSIZE=35)

   MAX_TBIN_SLIDER = WIDGET_SLIDER(TBIN_FRAME,$
	UNAME="MAX_TBIN_SLIDER",$
	XOFFSET= 70,$
	YOFFSET= y_offset_2-5,$
	SCR_XSIZE=250,$
	SCR_YSIZE=35,$
	MINIMUM=(*global).minimum_tbin,$
	MAXIMUM=(*global).maximum_tbin,$
	VALUE=(*global).Nt,$
	/DRAG,$
	EVENT_PRO="max_tbin_slider")

   MAX_TBIN_TEXT = WIDGET_TEXT(TBIN_FRAME,$
	UNAME="MAX_TBIN_TEXT",$
	XOFFSET=325,$
	YOFFSET=y_offset_2+2,$
	SCR_XSIZE=55,$
	SCR_YSIZE=30,$
	VALUE='0',$
	/EDITABLE,$
	/ALL_EVENTS)

   TBIN_REFRESH_BUTTON = WIDGET_BUTTON(TBIN_FRAME,$
	UNAME="TBIN_REFRESH_BUTTON",$
	XOFFSET=10,$
	YOFFSET=y_offset_3+10,$
	SCR_XSIZE=370,$
	SCR_YSIZE=30,$
	VALUE="R E F R E S H   P L O T",$
	EVENT_PRO="tbin_refresh_button")

  TRANSLATION_FRAME = WIDGET_BASE(TRANSLATION_DISPLAY_HISTO_FRAME,$
                                   TITLE="Event to Histo",$
                                  SCR_XSIZE=395,$
                                  SCR_YSIZE=140,$
                                  sensitive=0,$
                                 uname='TRANSLATION_FRAME')

  x_offset = 524
  y_offset = 20

  EVENT_FILE = widget_button(TRANSLATION_FRAME,$
	UNAME="EVENT_FILE",$
	XOFFSET=527-x_offset,$
	YOFFSET=23-y_offset,$
	SCR_XSIZE=80,$
	SCR_YSIZE=25,$
	VALUE="Event file")

  EVENT_FILENAME = widget_text(TRANSLATION_FRAME,$
	UNAME="EVENT_FILENAME",$
	XOFFSET=610-x_offset,$
	YOFFSET=20-y_offset,$
	SCR_XSIZE=300,$
	SCR_YSIZE=30,$
	VALUE="")

  OUTPUT_PATH = widget_button(TRANSLATION_FRAME,$
	UNAME="OUTPUT_PATH",$
	XOFFSET=527-x_offset,$
	YOFFSET=53-y_offset,$
	SCR_XSIZE=80,$
	SCR_YSIZE=25,$
	VALUE="Output path")

  OUTPUT_PATH_NAME = widget_text(TRANSLATION_FRAME,$
	UNAME="OUTPUT_PATH_NAME",$
	XOFFSET=610-x_offset,$
	YOFFSET=50-y_offset,$
	SCR_XSIZE=300,$
	SCR_YSIZE=30,$
	VALUE="")
  
  TIME_BIN_LABEL = widget_label(TRANSLATION_FRAME,$
	XOFFSET=525-x_offset,$
	YOFFSET=85-y_offset,$
	SCR_XSIZE=30,$
	SCR_YSIZE=30,$
	VALUE="Tbin")

  TIME_BIN_VALUE = widget_text(TRANSLATION_FRAME,$
	UNAME="TIME_BIN_VALUE",$
	XOFFSET=555-x_offset,$
	YOFFSET=85-y_offset,$
	SCR_XSIZE=50,$
	SCR_YSIZE=30,$
	/editable,VALUE='25') 

  TIME_BIN_UNITS = widget_label(TRANSLATION_FRAME,$
	XOFFSET=553-x_offset,$
	YOFFSET=105-y_offset,$
	SCR_XSIZE=50,$
	SCR_YSIZE=30,$
	VALUE="microS")

  MAX_TIMEBIN_LABEL = widget_label(TRANSLATION_FRAME,$
	XOFFSET=610-x_offset,$
	YOFFSET=85-y_offset,$
	SCR_XSIZE=40,$
	SCR_YSIZE=20,$
	VALUE="Max")

  MAX_TIMEBIN_LABEL = widget_label(TRANSLATION_FRAME,$
	XOFFSET=610-x_offset,$
	YOFFSET=95-y_offset,$
	SCR_XSIZE=40,$
	SCR_YSIZE=30,$
	VALUE="Tbin")

  MAX_TIMEBIN_VALUE = widget_text(TRANSLATION_FRAME,$
	UNAME="MAX_TIMEBIN_VALUE",$
	XOFFSET=650-x_offset,$
	YOFFSET=85-y_offset,$
	SCR_XSIZE=60,$
	SCR_YSIZE=30,$
	/editable,VALUE='200000') 

  MAX_TIMEBIN_UNITS = widget_label(TRANSLATION_FRAME,$
	XOFFSET=650-x_offset,$
	YOFFSET=105-y_offset,$
	SCR_XSIZE=50,$
	SCR_YSIZE=30,$
	VALUE="microS")


  MAX_TIMEBIN_LABEL = widget_label(TRANSLATION_FRAME,$
	XOFFSET=710-x_offset,$
	YOFFSET=85-y_offset,$
	SCR_XSIZE=40,$
	SCR_YSIZE=20,$
	VALUE="Min")

  MAX_TIMEBIN_LABEL = widget_label(TRANSLATION_FRAME,$
	XOFFSET=710-x_offset,$
	YOFFSET=95-y_offset,$
	SCR_XSIZE=40,$
	SCR_YSIZE=30,$
	VALUE="Tbin")

  OFFSET_TIMEBIN_VALUE = widget_text(TRANSLATION_FRAME,$
	UNAME="OFFSET_TIMEBIN_VALUE",$
	XOFFSET=750-x_offset,$
	YOFFSET=85-y_offset,$
	SCR_XSIZE=60,$
	SCR_YSIZE=30,$
	/editable,VALUE='0') 

  OFFSET_TIMEBIN_UNITS = widget_label(TRANSLATION_FRAME,$
	XOFFSET=750-x_offset,$
	YOFFSET=105-y_offset,$
	SCR_XSIZE=50,$
	SCR_YSIZE=30,$
	VALUE="microS")

  EVENT_TO_HISTO = widget_button(TRANSLATION_FRAME,$
	UNAME="EVENT_TO_HISTO",$
	XOFFSET=815-x_offset,$
	YOFFSET=85-y_offset,$
	SCR_XSIZE=100,$
	SCR_YSIZE=50,$
	VALUE="HISTO / MAP")

  FILE_MENU = Widget_Button(WID_BASE_0_MBAR, UNAME='FILE_MENU' ,/MENU  $
      ,VALUE='File')

  OPEN_NEXUS = widget_button(FILE_MENU,$
                             uname='OPEN_NEXUS',$
                             value='Open NeXus...',$
                             sensitive=0)

  OPEN_MAPPED_HISTOGRAM = Widget_Button(FILE_MENU,$
                                        UNAME='OPEN_MAPPED_HISTOGRAM'  $
                                        ,VALUE='Open Mapped Histogram...')

  OPEN_HISTOGRAM = Widget_Button(FILE_MENU, UNAME='OPEN_HISTOGRAM'  $
                                 ,VALUE='Open Histogram....')

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
  
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

;logger message
  ucams = get_ucams()
  logger_message  = '/usr/bin/logger -p local5.notice IDLtools '
  logger_message += APPLICATION + '_' + VERSION + ' ' + ucams
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
      CATCH,/CANCEL
  ENDIF ELSE BEGIN
      spawn, logger_message
  ENDELSE

end

;
; Empty stub procedure used for autoloading.
;
pro plot_data, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end

