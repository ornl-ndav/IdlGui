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

    ;slider tube
    Widget_Info(wWidget, FIND_BY_UNAME='draw_tube_pixels_frame'): begin
        plot_tubes_pixels, Event
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

;define parameters
scr_x 	= 1100				;main window width
scr_y 	= 700				;main window height 
ctrl_x	= 1				;width of left box - control
ctrl_y	= scr_y				;height of lect box - control
draw_x 	= 304				;main width of draw area
draw_y 	= 256				;main heigth of draw area
draw_offset_x = 10			;draw x offset within widget
draw_offset_y = 10			;draw y offset within widget
plot_height = 150			;plot box height
plot_length = 304			;plot box length

Resolve_Routine, 'RealignGUI_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup, UNAME='MAIN_BASE'  $
      ,XOFFSET=100 ,YOFFSET=22 ,SCR_XSIZE=scr_x ,SCR_YSIZE=scr_y  $
      ,NOTIFY_REALIZE='MAIN_REALIZE' ,TITLE='Realign BSS tubes'  $
      ,SPACE=3 ,XPAD=3 ,YPAD=3 ,MBAR=WID_BASE_0_MBAR)

;define initial global values - these could be input via external file
;or other means

global = ptr_new({$
		file			:'',$
		file_already_opened	:0,$
		path			:'/SNSlocal/tmp/',$
		working_path		:'',$
		default_path		:'/SNS/users/',$
;		event_file_path		:'/SNS/BSS/2006_1_2_SCI/',$
;		event_filename		:'',$
;		event_filename_only	:'',$
;		histogram_filename	:'',$
;		histogram_filename_only :'',$
;		mapping_filename	:'/SNS/BSS/2006_1_2_CAL/calibrations/BSS_TS_2006_06_09.dat',$
;		filter_event		:'*_event.dat',$
                ucams	                :'',$
		name			:'',$
 		character_id		:'',$
		filter_histo		:'*_histo_mapped.dat',$
		nbytes			:4L,$
		swap_endian		:0,$
; 		pixelids		:9216L,$
 		Nx			:128L,$
                Ny_scat			:64L,$
                Ny_diff                 :8L,$
 		Nt			:1L,$
; 		y_coeff			:0L,$
; 		x_coeff			:0L,$
; 		Nx_tubes		:64L,$
; 		Ny_pixels		:64L,$
; 		minimum_tbin		:0L,$
; 		min_tbin		:0L,$
; 		maximum_tbin		:500L,$
; 		max_tbin		:500L,$
; 		refresh_histo		:0,$
; 		pixel_offset		:4096L,$
; 		xtitle			:'tubes',$
; 		ytitle			:'pixels',$
; 		top_bank		: ptr_new(0L),$
; 		bottom_bank		: ptr_new(0L),$
 		image_2d_1		: ptr_new(0L),$
                i1                      : ptr_new(0L),$
                i2                      : ptr_new(0L),$
                i3                      : ptr_new(0L),$
                i4                      : ptr_new(0L),$
                i5                      : ptr_new(0L),$
                len1                    : ptr_new(0L),$
                len2                    : ptr_new(0L)$
; 		overflow_number		: 500L,$	
;		do_color		:1$ 
})

;attach global data structure with widget ID of widget main base widget ID
widget_control,MAIN_BASE,set_uvalue=global

;  IDENTIFICATION_BASE= widget_base(MAIN_BASE, XOFFSET=300, YOFFSET=300,$
;  	UNAME='IDENTIFICATION_BASE',$
;  	SCR_XSIZE=240, SCR_YSIZE=120, FRAME=10,$
;  	SPACE=4, XPAD=3, YPAD=3)

;  IDENTIFICATION_LABEL = widget_label(IDENTIFICATION_BASE,$
;  		XOFFSET=40, YOFFSET=3, VALUE="ENTER YOUR 3 CHARACTERS ID")

;  IDENTIFICATION_TEXT = widget_text(IDENTIFICATION_BASE,$
;  		XOFFSET=100, YOFFSET=20, VALUE='',$
;  		SCR_XSIZE=37, /editable,$
;  		UNAME='IDENTIFICATION_TEXT',/ALL_EVENTS)

;  ERROR_IDENTIFICATION_left = widget_label(IDENTIFICATION_BASE,$
;  		XOFFSET=5, YOFFSET=25, VALUE='',$
;  		SCR_XSIZE=90, SCR_YSIZE=20, $
;  		UNAME='ERROR_IDENTIFICATION_LEFT')

;  ERROR_IDENTIFICATION_right = widget_label(IDENTIFICATION_BASE,$
;  		XOFFSET=140, YOFFSET=25, VALUE='',$
;  		SCR_XSIZE=90, SCR_YSIZE=20, $
;  		UNAME='ERROR_IDENTIFICATION_RIGHT')

;  DEFAULT_PATH_BUTTON = widget_button(IDENTIFICATION_BASE,$
;  		XOFFSET=0, YOFFSET=55, VALUE='Working path',$
;  		SCR_XSIZE=80, SCR_YSIZE=30,$
;  		UNAME='DEFAULT_PATH_BUTTON')

;  DEFAULT_PATH_TEXT = widget_text(IDENTIFICATION_BASE,$
;  		XOFFSET=83, YOFFSET=55, VALUE=(*global).default_path,$
;  		UNAME='DEFAULT_PATH_TEXT',/editable,$
;  		SCR_XSIZE=150)

;  IDENTIFICATION_GO = widget_button(IDENTIFICATION_BASE,$
;  		XOFFSET=67, YOFFSET=90,$
;  		SCR_XSIZE=130, SCR_YSIZE=30,$
;  		VALUE="E N T E R",$
;  		UNAME='IDENTIFICATION_GO')		

;top-left frame (display of counts vs pixelID for each tube
;one at a time
draw_tube_pixels_base = widget_base(MAIN_BASE,$
                                    SCR_XSIZE=550,$
                                    SCR_YSIZE=370,$
                                    XOFFSET=5,$
                                    YOFFSET=10)

draw_tube_pixels_frame_title = widget_label(draw_tube_pixels_base,$
                                            SCR_XSIZE=120,$
                                            SCR_YSIZE=20,$
                                            XOFFSET=5,$
                                            YOFFSET=0,$
                                            VALUE="Tube per tube plot")

draw_tube_pixels_draw = widget_draw(draw_tube_pixels_base,$
                                    UNAME='draw_tube_pixels_draw',$
                                    SCR_XSIZE=536,$
                                    SCR_YSIZE=300,$
                                    XOFFSET=6,$
                                    YOFFSET=20)

draw_tube_pixels_slider = WIDGET_SLIDER(draw_tube_pixels_base,$
                                        UNAME="draw_tube_pixels_slider",$
                                        XOFFSET= 6,$
                                        YOFFSET= 320,$
                                        SCR_XSIZE=536,$
                                        SCR_YSIZE=35,$
                                        MINIMUM=0,$
                                        MAXIMUM=67,$
                                        /DRAG,$
                                        VALUE=0,$
                                        EVENT_PRO="plot_tubes_pixels")

draw_tube_pixels_frame = widget_label(draw_tube_pixels_base,$
                                      UNAME="draw_tube_pixels_frame",$
                                      SCR_XSIZE=550,$
                                      SCR_YSIZE=350,$
                                      XOFFSET=0,$
                                      YOFFSET=10,$
                                      FRAME=1,$
                                      VALUE="")

;Pixels counts vertical window info
pixels_counts_base = widget_base(main_base,$
                                 XOFFSET=920,$
                                 YOFFSET=10,$
                                 SCR_XSIZE=170,$
                                 SCR_YSIZE=690)

pixels_counts_title = widget_label(pixels_counts_base,$
                                   xoffset=8,$
                                   yoffset=0,$
                                   scr_xsize=90,$
                                   scr_ysize=20,$
                                   value="Pixels values")

pixels_counts_values = widget_text(pixels_counts_base,$
                                   XOFFSET=6,$
                                   YOFFSET=20,$
                                   SCR_XSIZE=150,$
                                   SCR_YSIZE=650,$
                                   /wrap,$
                                   /scroll,$
                                   value = '',$
                                   UNAME='pixels_counts_values')

pixels_counts_frame = widget_label(pixels_counts_base,$
                                   XOFFSET=0,$
                                   YOFFSET=10,$
                                   SCR_XSIZE=170,$
                                   SCR_YSIZE=665,$
                                   FRAME=1)
                              

;General infos window
infos_base = widget_base(main_base,$
                          XOFFSET=560,$
                          YOFFSET=10,$
                          SCR_XSIZE=355,$
                          SCR_YSIZE=150)

infos_title = widget_label(infos_base,$
                           xoffset=6,$
                           yoffset=0,$
                           scr_xsize=40,$
                           scr_ysize=20,$
                           value = 'Infos')

general_infos = widget_text(infos_base,$
                             uname = "general_infos",$
                             xoffset=6,$
                             yoffset=20,$
                             scr_xsize=339,$
                             scr_ysize=115,$
                             /wrap,$
                            /scroll,$
                             value="")

infos_frame = widget_label(infos_base,$
                           xoffset=0,$
                           yoffset=10,$
                           scr_xsize=350,$
                           scr_ysize=130,$
                           frame=1)

;pixel, tube and bank info
ptb_info_base = widget_base(main_base,$
                            XOFFSET=560,$
                            YOFFSET=160,$
                            SCR_XSIZE=355,$
                            SCR_YSIZE=80)

pixel_label = widget_label(ptb_info_base,$
                           xoffset=10,$
                           yoffset=5,$
                           scr_xsize=60,$
                           scr_ysize=20,$
                           value="Pixel ID:",$
                           uname='pixel_label')

pixel_value = widget_label(ptb_info_base,$
                           xoffset=70,$
                           yoffset=5,$
                           scr_xsize=35,$
                           scr_ysize=20,$
                           value='8888',$
                          /align_left,$
                          uname='pixel_value')

tube_label = widget_label(ptb_info_base,$
                           xoffset=10+120,$
                           yoffset=5,$
                           scr_xsize=50,$
                           scr_ysize=20,$
                           value="Tube #:",$
                         uname='tube_label')

tube_value = widget_label(ptb_info_base,$
                           xoffset=70+110,$
                           yoffset=5,$
                           scr_xsize=35,$
                           scr_ysize=20,$
                           value='63',$
                          /align_left,$
                            uname='tube_value')

bank_label = widget_label(ptb_info_base,$
                           xoffset=10+230,$
                           yoffset=5,$
                           scr_xsize=50,$
                           scr_ysize=20,$
                           value="Bank #:",$
                         uname='bank_label')

bank_value = widget_label(ptb_info_base,$
                           xoffset=70+220,$
                          yoffset=5,$
                          scr_xsize=10,$
                          scr_ysize=20,$
                          value='2',$
                          /align_left,$
                          uname='bank_value')

pixels_slider = WIDGET_SLIDER(ptb_info_base,$
                              UNAME="pixels_slider",$
                              XOFFSET= 7,$
                              YOFFSET= 25,$
                              SCR_XSIZE=340,$
                              SCR_YSIZE=35,$
                              MINIMUM=0,$
                              MAXIMUM=127,$
                              /DRAG,$
                              VALUE=0,$
                              EVENT_PRO="get_pixels_infos")

infos_frame = widget_label(ptb_info_base,$
                           xoffset=0,$
                           yoffset=0,$
                           scr_xsize=355,$
                           scr_ysize=70,$
                           frame=4,$
                           value='')

;pixelID and tube interaction window
pixel_and_tube_base = widget_base(main_base,$
                                  XOFFSET=560,$
                                  YOFFSET=240,$
                                  SCR_XSIZE=355,$
                                  SCR_YSIZE=180)

pixel_and_tube_title = widget_label(pixel_and_tube_base,$
                                    xoffset=5,$
                                    yoffset=0,$
                                    scr_xsize=180,$
                                    scr_ysize=20,$
                                    value='PixelID and tube interaction')

pixelid_counts_label = widget_label(pixel_and_tube_base,$
                                    xoffset=10,$
                                    yoffset=20,$
                                    scr_xsize=90,$
                                    scr_ysize=20,$
                                    value='PixelID counts:',$
                                   /align_left)

pixelid_counts_value = widget_label(pixel_and_tube_base,$
                                    xoffset=110,$
                                    yoffset=20,$
                                    scr_xsize=150,$
                                    scr_ysize=20,$
                                    value='',$
                                   /align_left)

pixelid_new_counts_label = widget_label(pixel_and_tube_base,$
                                        xoffset=10,$
                                        yoffset=45,$
                                        scr_xsize=114,$
                                        scr_ysize=20,$
                                        value='New PixelID counts:',$
                                       /align_left)

pixelid_new_counts_value = widget_text(pixel_and_tube_base,$
                                       uname='pixelid_new_counts_value',$
                                        xoffset=130,$
                                        yoffset=40,$
                                        scr_xsize=140,$
                                        scr_ysize=30,$
                                        value='1',$
                                        /align_left,$
                                       /editable)

pixelid_new_counts_validation = widget_button(pixel_and_tube_base,$
                                              uname='pixelid_new_counts_validation',$
                                              xoffset=275,$
                                              yoffset=20,$
                                              scr_xsize=70,$
                                              scr_ysize=50,$
                                              value="Validate")

remove_pixelid_label = widget_label(pixel_and_tube_base,$
                                    xoffset=10,$
                                    yoffset=75,$
                                    scr_xsize=120,$
                                    scr_ysize=20,$
                                    value='Remove this pixel:',$
                                   /align_left)

remove_pixelid_group = cw_bgroup(pixel_and_tube_base, $
                                 ['Yes', 'No'], $
                                 /exclusive,$
                                 /row,$
                                 /RETURN_NAME,$
                                 XOFFSET=130, $
                                 YOFFSET=70,$
                                 SET_VALUE=1.0,$
                                 UNAME='remove_pixelid_group')

remove_tube_label = widget_label(pixel_and_tube_base,$
                                 xoffset=10,$
                                 yoffset=100,$
                                 scr_xsize=120,$
                                 scr_ysize=20,$
                                 value='Remove this tube:',$
                                 /align_left)

remove_tube_group = cw_bgroup(pixel_and_tube_base, $
                              ['Yes', 'No'], $
                              /exclusive,$
                              /row,$
                              /RETURN_NAME,$
                              XOFFSET=130, $
                              YOFFSET=95,$
                              SET_VALUE=1.0,$
                              UNAME='remove_tube_group')


pixel_and_tube_frame = widget_label(pixel_and_tube_base,$
                                    xoffset=0,$
                                    yoffset=10,$
                                    scr_xsize=355,$
                                    scr_ysize=160,$
                                    frame=1,$
                                    value='')


y_offset = 375
x_size_tubes = 215
x_size_center =100
y_dim = 90

;tube0_frame
tube0_base = widget_base(main_base,$
                         UNAME="tube0_base",$
                         XOFFSET=5,$
                         YOFFSET=y_offset,$
                         SCR_XSIZE=x_size_tubes,$
                         SCR_YSIZE=y_dim-10)

tube0_title = widget_label(tube0_base,$
                           xoffset=3,$
                           yoffset=0,$
                           scr_xsize=50,$
                           scr_ysize=20,$
                           value='Tube0')

y_off = 25
x_size = 95
y_size = 40

;left
tube0_left_minus = widget_button(tube0_base,$
                                 XOFFSET=10,$
                                 YOFFSET=32,$
                                 SCR_XSIZE=30,$
                                 SCR_YSIZE=30,$
                                 VALUE='-',$
                                 UNAME='tube0_left_minus')

tube0_left_text = widget_text(tube0_base,$
                                XOFFSET=40,$
                                YOFFSET=32,$
                                SCR_XSIZE=30,$
                                SCR_YSIZE=30,$
                                VALUE='99',$
                                /editable,$
                                UNAME='tube0_left_text')

tube0_left_plus = widget_button(tube0_base,$
                                 XOFFSET=69,$
                                 YOFFSET=32,$
                                 SCR_XSIZE=30,$
                                 SCR_YSIZE=30,$
                                 VALUE='+',$
                                 UNAME='tube0_left_plus')

tube0_left_title = widget_label(tube0_base,$
                                XOFFSET=65,$
                                YOFFSET=15,$
                                SCR_XSIZE=25,$
                                SCR_YSIZE=20,$
                                VALUE='Left')

tube0_left_label = widget_label(tube0_base,$
                                 XOFFSET=5,$
                                 YOFFSET=y_off,$
                                 SCR_XSIZE=x_size,$
                                 SCR_YSIZE=y_size,$
                                 FRAME=1,$
                                 VALUE="")

;right
tube0_right_minus = widget_button(tube0_base,$
                                 XOFFSET=115,$
                                 YOFFSET=32,$
                                 SCR_XSIZE=30,$
                                 SCR_YSIZE=30,$
                                 VALUE='-',$
                                 UNAME='tube0_right_minus')

tube0_right_text = widget_text(tube0_base,$
                                XOFFSET=40+105,$
                                YOFFSET=32,$
                                SCR_XSIZE=30,$
                                SCR_YSIZE=30,$
                                VALUE='99',$
                                /editable,$
                                UNAME='tube0_right_text')

tube0_right_plus = widget_button(tube0_base,$
                                 XOFFSET=69+105,$
                                 YOFFSET=32,$
                                 SCR_XSIZE=30,$
                                 SCR_YSIZE=30,$
                                 VALUE='+',$
                                 UNAME='tube0_left_plus')

tube0_right_title = widget_label(tube0_base,$
                                XOFFSET=125,$
                                YOFFSET=15,$
                                SCR_XSIZE=30,$
                                SCR_YSIZE=20,$
                                VALUE='Right')

tube0_right_label = widget_label(tube0_base,$
                                 XOFFSET=110,$
                                 YOFFSET=y_off,$
                                 SCR_XSIZE=x_size,$
                                 SCR_YSIZE=y_size,$
                                 FRAME=1,$
                                 VALUE="")


tube0_label =  widget_label(tube0_base,$
                            UNAME="tube0_label",$
                            XOFFSET=0,$
                            YOFFSET=10,$
                            SCR_XSIZE=x_size_tubes-5,$
                            SCR_YSIZE=y_dim-30,$
                            FRAME=1,$
                            VALUE="")


;center_frame
center_base = widget_base(main_base,$
                         UNAME="center_base",$
                         XOFFSET=228,$
                         YOFFSET=y_offset,$
                         SCR_XSIZE=x_center,$
                         SCR_YSIZE=y_dim-10)

center_minus = widget_button(center_base,$
                                 XOFFSET=6,$
                                 YOFFSET=32,$
                                 SCR_XSIZE=30,$
                                 SCR_YSIZE=30,$
                                 VALUE='-',$
                                 UNAME='center_minus')

center_text = widget_text(center_base,$
                                XOFFSET=37,$
                                YOFFSET=32,$
                                SCR_XSIZE=30,$
                                SCR_YSIZE=30,$
                                VALUE='99',$
                                /editable,$
                                UNAME='center_text')

center_plus = widget_button(center_base,$
                                 XOFFSET=69,$
                                 YOFFSET=32,$
                                 SCR_XSIZE=30,$
                                 SCR_YSIZE=30,$
                                 VALUE='+',$
                                 UNAME='center_plus')

center_title = widget_label(center_base,$
                           xoffset=3,$
                           yoffset=0,$
                           scr_xsize=50,$
                           scr_ysize=20,$
                           value="Center")

center_label =  widget_label(center_base,$
                            UNAME="center_label",$
                            XOFFSET=0,$
                            YOFFSET=10,$
                            SCR_XSIZE=x_size_center,$
                            SCR_YSIZE=y_dim-30,$
                            FRAME=1,$
                            VALUE="")

;tube1_frame
tube1_base = widget_base(main_base,$
                         UNAME="tube1_base",$
                         XOFFSET=340,$
                         YOFFSET=y_offset,$
                         SCR_XSIZE=x_size_tubes_5,$
                         SCR_YSIZE=y_dim-10)

tube1_title = widget_label(tube1_base,$
                           xoffset=3,$
                           yoffset=0,$
                           scr_xsize=50,$
                           scr_ysize=20,$
                           value="Tube1")

y_off = 25
x_size = 95
y_size = 40
;left
tube1_left_minus = widget_button(tube1_base,$
                                 XOFFSET=10,$
                                 YOFFSET=32,$
                                 SCR_XSIZE=30,$
                                 SCR_YSIZE=30,$
                                 VALUE='-',$
                                 UNAME='tube1_left_minus')

tube1_left_text = widget_text(tube1_base,$
                                XOFFSET=40,$
                                YOFFSET=32,$
                                SCR_XSIZE=30,$
                                SCR_YSIZE=30,$
                                VALUE='99',$
                                /editable,$
                                UNAME='tube1_left_text')

tube1_left_plus = widget_button(tube1_base,$
                                 XOFFSET=69,$
                                 YOFFSET=32,$
                                 SCR_XSIZE=30,$
                                 SCR_YSIZE=30,$
                                 VALUE='+',$
                                 UNAME='tube1_left_plus')

tube1_left_title = widget_label(tube1_base,$
                                XOFFSET=65,$
                                YOFFSET=15,$
                                SCR_XSIZE=25,$
                                SCR_YSIZE=20,$
                                VALUE="Left")

tube1_left_label = widget_label(tube1_base,$
                                 XOFFSET=5,$
                                 YOFFSET=y_off,$
                                 SCR_XSIZE=x_size,$
                                 SCR_YSIZE=y_size,$
                                 FRAME=1,$
                                 VALUE='')

;right
tube1_right_minus = widget_button(tube1_base,$
                                 XOFFSET=111,$
                                 YOFFSET=32,$
                                 SCR_XSIZE=30,$
                                 SCR_YSIZE=30,$
                                 VALUE='-',$
                                 UNAME='tube1_right_minus')

tube1_right_text = widget_text(tube1_base,$
                                XOFFSET=36+105,$
                                YOFFSET=32,$
                                SCR_XSIZE=36,$
                                SCR_YSIZE=30,$
                                VALUE='123',$
                                /editable,$
                                UNAME="tube1_right_text")

tube1_right_plus = widget_button(tube1_base,$
                                 XOFFSET=72+105,$
                                 YOFFSET=32,$
                                 SCR_XSIZE=30,$
                                 SCR_YSIZE=30,$
                                 VALUE='+',$
                                 UNAME="tube1_left_plus")

tube1_right_title = widget_label(tube1_base,$
                                XOFFSET=125,$
                                YOFFSET=15,$
                                SCR_XSIZE=30,$
                                SCR_YSIZE=20,$
                                VALUE="Right")

tube1_right_label = widget_label(tube1_base,$
                                 XOFFSET=110,$
                                 YOFFSET=y_off,$
                                 SCR_XSIZE=x_size,$
                                 SCR_YSIZE=y_size,$
                                 FRAME=1,$
                                 VALUE="")

tube1_label =  widget_label(tube1_base,$
                            UNAME="tube1_label",$
                            XOFFSET=0,$
                            YOFFSET=10,$
                            SCR_XSIZE=x_size_tubes-5,$
                            SCR_YSIZE=y_dim-30,$
                            FRAME=1,$
                            VALUE="")
;Rick's way plot
DAS_plot_base = widget_base(MAIN_BASE,$
                            SCR_XSIZE=550,$
                            SCR_YSIZE=250,$
                            XOFFSET=5,$
                            YOFFSET=440)

DAS_plot_title = widget_label(DAS_plot_base,$
                              SCR_XSIZE=70,$
                              SCR_YSIZE=15,$
                              XOFFSET=5,$
                              YOFFSET=12,$
                              VALUE="DAS's plot")


 DAS_plot_draw = widget_draw(DAS_plot_base,$
                             UNAME='DAS_plot_draw',$
                             SCR_XSIZE=536,$
                             SCR_YSIZE=213,$
                             XOFFSET=6,$
                             YOFFSET=30)

DAS_plot_frame = widget_label(DAS_plot_base,$
                            UNAME='DAS_plot_frame',$
                            SCR_XSIZE=547,$
                            SCR_YSIZE=225,$
                            XOFFSET=0,$
                            YOFFSET=20,$
                             FRAME=1)


;draw boxes for plot windows
  FILE_MENU = Widget_Button(WID_BASE_0_MBAR, UNAME='FILE_MENU' ,/MENU  $
      ,VALUE='File')

  OPEN_MAPPED_HISTOGRAM = Widget_Button(FILE_MENU, $
                                        UNAME='OPEN_MAPPED_HISTOGRAM',$
                                        VALUE='Open Mapped Histogram')

;  OPEN_HISTOGRAM = Widget_Button(FILE_MENU, UNAME='OPEN_HISTOGRAM'  $
;      ,VALUE='Open Histogram')

  EXIT_MENU = Widget_Button(FILE_MENU, UNAME='EXIT_MENU'  $
      ,VALUE='Exit')

  UTILS_MENU = Widget_Button(WID_BASE_0_MBAR, UNAME='UTILS_MENU'  $
      ,/MENU ,VALUE='RealignGUI')

  ABOUT_MENU = Widget_Button(UTILS_MENU, UNAME='ABOUT_MENU'  $
      ,VALUE='about RealignGUI')

  Widget_Control, /REALIZE, MAIN_BASE

  ;disabled background buttons/draw/text/labels
;  Widget_Control, OPEN_MAPPED_HISTOGRAM, sensitive=0
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

;
; Empty stub procedure used for autoloading.
;
pro RealignGUI, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
