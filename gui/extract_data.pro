pro MAIN_BASE_event, Event

  wWidget =  Event.top  ;widget id

;stop

  case Event.id of

    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end

;;    Widget_Info(wWidget, FIND_BY_UNAME='TBIN_TXT'): begin
;;      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'widget_text' )then $
;;        if( Event.type eq 0 )then $
;;	   print, "CA marche"
;;          ;TEST_TEST, Event
;;    end

    Widget_Info(wWidget, FIND_BY_UNAME='VIEW_DRAW'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_DRAW' )then $
        if( Event.type eq 0 )then $
          VIEW_ONBUTTON, Event
    end

    ;Open widget in the top toolbar
    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_MENU'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_FILE, Event
    end

    ;Open widget in the top toolbar
    Widget_Info(wWidget, FIND_BY_UNAME='START_CALCULATION'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        DATA_REDUCTION, Event
    end
    
;!!!!!!!open window only if we switch on (not when we switch off)
    ;Open normalization widget in the top toolbar
    Widget_Info(wWidget, FIND_BY_UNAME='NORMALIZATION_SWITCH'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_NORMALIZATION, Event
    end

    ;Exit widget in the top toolbar
    Widget_Info(wWidget, FIND_BY_UNAME='EXIT_MENU'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        EXIT_PROGRAM, Event
    end

    ;Widget to change the color of graph
    Widget_Info(wWidget, FIND_BY_UNAME='CTOOL_MENU'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        CTOOL, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='REFRESH_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        REFRESH, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='SAVE_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        SAVE_REGION, Event
    end

    else:
  endcase

end

pro MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;define parameters
scr_x 	= 880				;main window width
scr_y 	= 750				;main window height 
ctrl_x	= 1				;width of left box - control
ctrl_y	= scr_y				;height of lect box - control
draw_x 	= 304				;main width of draw area
draw_y 	= 256				;main heigth of draw area
draw_offset_x = 10			;draw x offset within widget
draw_offset_y = 10			;draw y offset within widget
plot_height = 150			;plot box height
plot_length = 304			;plot box length

Resolve_Routine, 'extract_data_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup, UNAME='MAIN_BASE'  $
      ,XOFFSET=100 ,YOFFSET=22 ,SCR_XSIZE=scr_x ,SCR_YSIZE=scr_y  $
      ,NOTIFY_REALIZE='MAIN_REALIZE' ,TITLE='Extract Data Tool'  $
      ,SPACE=3 ,XPAD=3 ,YPAD=3 ,MBAR=WID_BASE_0_MBAR)

;define initial global values - these could be input via external file or other means

global = ptr_new({ $
	idl_path		: '/',$
	filename		: '',$
	norm_filename		: '',$
	filename_only		: '',$
	nexus_filename		: '',$
	filename_index		: 0, $
	path			: '/SNS/users/j35/data/REF_M/REF_M_7/',$
	scr_x			: scr_x,$
	scr_y			: scr_y,$
	ctrl_x			: ctrl_x,$
	ctrl_y			: ctrl_y,$
	draw_x			: draw_x,$
	draw_y			: draw_y,$
	draw_offset_x		: draw_offset_x,$
	draw_offset_y		: draw_offset_y,$
	plot_height		: plot_height,$
	plot_length		: plot_length,$
	filter_histo		: '*mapped.dat',$
	filter_normalization	: '*.nxs',$
	filter_nexus		: '*.nxs',$
	with_background		: 0, $
	with_normalization	: 0, $
	wavelength_min		: 0L,$
	wavelength_max		: 0L,$
	wavelength_width	: 0L,$
	detector_angle		: 0L,$
	detector_angle_err	: 0L,$
	detector_angle_units	: '',$
	time_bin		: 0L,$
	Nx			: 256L,$
	Ny			: 304L,$
	Ntof			: 0L,$
	starting_id_x		: 0L,$
	starting_id_y		: 0L,$
	ending_id_x		: 0L,$
	ending_id_y		: 0L,$
	data_ptr		: ptr_new(0L),$
	data_assoc		: ptr_new(0L),$
	img_ptr			: ptr_new(0L),$
	selection_ptr		: ptr_new(OL),$
	x			: 0L,$
	y			: 0L,$
	tof			: 0L,$
	ct			: 5,$
	pass			: 0,$
	have_indicies		: 0,$
	indicies		: ptr_new(0L),$
	tlb			: 0, $
	window_counter		: 0L $
	})

;attach global data structure with widget ID of widget main base widget ID
widget_control,MAIN_BASE,set_uvalue=global

VIEW_DRAW = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW' ,XOFFSET=draw_offset_x+ctrl_x  $
      ,YOFFSET=2*draw_offset_y+plot_height ,SCR_XSIZE=draw_x ,SCR_YSIZE=draw_y ,RETAIN=2 ,$
      /BUTTON_EVENTS,/MOTION_EVENTS)

;draw boxes for plot windows
;TOF
  VIEW_DRAW_TOF = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_TOF' ,XOFFSET=draw_offset_x+ctrl_x  $
      ,YOFFSET=draw_offset_y ,SCR_XSIZE=plot_length ,SCR_YSIZE=plot_height ,RETAIN=2)
;X
  VIEW_DRAW_X = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_X' ,XOFFSET=draw_offset_x+ctrl_x  $
      ,YOFFSET=3*draw_offset_y+draw_y+plot_height ,SCR_XSIZE=plot_length ,SCR_YSIZE=plot_height ,RETAIN=2)
;Y
  VIEW_DRAW_Y = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_Y' ,XOFFSET=2*draw_offset_x+draw_x+ctrl_x  $
      ,YOFFSET=2*draw_offset_y+plot_height ,SCR_XSIZE=plot_height ,SCR_YSIZE=draw_y,RETAIN=2)

  VIEW_DRAW_REDUCTION = Widget_Draw(MAIN_BASE,$
	UNAME='VIEW_DRAW_REDUCTION',$
	XOFFSET=2*draw_offset_x+draw_x+ctrl_x, $
	YOFFSET=3*draw_offset_y+draw_y+plot_height, $
	SCR_XSIZE= 540, SCR_YSIZE= 2*plot_height, RETAIN=2)

  GENERAL_INFOS = widget_text(MAIN_BASE, $
	UNAME='GENERAL_INFOS', $
	XOFFSET=3*draw_offset_x+ctrl_x+plot_height+plot_length, $
	YOFFSET= 20+draw_offset_y, $
	SCR_XSIZE=2.5*plot_height, $
	SCR_YSIZE=plot_height,$
	/WRAP,$
	/SCROLL)
	
   GENERAL_INFOS_LABEL = widget_label(MAIN_BASE, $
	XOFFSET=3*draw_offset_x+ctrl_x+plot_height+plot_length,$
	YOFFSET= draw_offset_y, $
	value="General Informations")

;  VIEW_DRAW_SELECTION = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_SELECTION', $
;	XOFFSET=3*draw_offset_x+ctrl_x+plot_height+plot_length, $
;	YOFFSET=2*draw_offset_y+1.3*plot_height+60, SCR_XSIZE=2.5*plot_height, $
;	SCR_YSIZE=plot_height, RETAIN=2)

  TBIN_UNITS_LABEL = widget_label(MAIN_BASE, UNAME='TBIN_UNITS_LABEL',XOFFSET=draw_offset_x+plot_length+100, $
	YOFFSET=draw_offset_y+10, VALUE="microS")

  TBIN_LABEL = widget_label(MAIN_BASE, UNAME='TBIN_LABEL',XOFFSET=draw_offset_x+plot_length+15, YOFFSET=draw_offset_y+10, $
	VALUE="Tbin:")

  TBIN_TXT = widget_text(MAIN_BASE, UNAME='TBIN_TXT', XOFFSET=draw_offset_x+plot_length+50, YOFFSET=draw_offset_y+5,$
	SCR_XSIZE=50, SCR_YSIZE=30, /editable, VALUE='25')

  REFRESH_BUTTON = Widget_Button(MAIN_BASE, UNAME='REFRESH_BUTTON', XOFFSET=draw_offset_x+plot_length+15,$
      YOFFSET=45,VALUE='Refresh Selection',SCR_XSIZE=134)

  SAVE_BUTTON = Widget_Button(MAIN_BASE, UNAME='SAVE_BUTTON', XOFFSET=draw_offset_x+plot_length+15,$
      YOFFSET=70,VALUE='Save Region',SCR_XSIZE=134)

   MODE_INFOS = widget_text(MAIN_BASE, UNAME='MODE_INFOS', $
	XOFFSET= draw_offset_x+plot_length+15, $
	YOFFSET= 95, SCR_XSIZE= 134, SCR_YSIZE= 30, value= 'MODE: INFOS') 

  FRAME1 = widget_label(MAIN_BASE, XOFFSET=2*draw_offset_x+plot_length,$
	YOFFSET=draw_offset_y,SCR_XSIZE=plot_height-5, SCR_YSIZE=plot_height-35,FRAME=3, value="")
	
   ;x position of cursor in Infos mode	
   CURSOR_X_LABEL = Widget_label(MAIN_BASE, UNAME='CURSOR_X_LABEL',$
	XOFFSET=2*draw_offset_x+plot_length+5,$
	YOFFSET=draw_offset_y+130,$
	value="x= ")

   CURSOR_X_POSITION = Widget_label(MAIN_BASE,UNAME='CURSOR_X_POSITION',$
	XOFFSET=2*draw_offset_x+plot_length+15,$
	YOFFSET=draw_offset_y+125,$
	VALUE="N/A",$
	SCR_XSIZE=45,$
	SCR_YSIZE=28)
	
   ;y position of cursor in Infos mode	
   CURSOR_Y_LABEL= Widget_label(MAIN_BASE, UNAME='CURSOR_Y_LABEL',$
	XOFFSET=2*draw_offset_x+plot_length+75,$
	YOFFSET=draw_offset_y+130,$
	value="y= ")

   CURSOR_Y_POSITION = Widget_label(MAIN_BASE,UNAME='CURSOR_Y_POSITION',$
	XOFFSET=2*draw_offset_x+plot_length+85,$
	YOFFSET=draw_offset_y+125,$
	VALUE="N/A",$
	SCR_XSIZE=45,$
	SCR_YSIZE=28)

  ;frame3 of x= and y= for infos mode
  FRAME3 = widget_label(MAIN_BASE, UNAME='FRAME3', $
	XOFFSET=2*draw_offset_x+plot_length,$
	YOFFSET=draw_offset_y+123,$
	SCR_XSIZE=plot_height-5,$
	SCR_YSIZE=27,FRAME=3, value="")

   SELECTION_INFOS = widget_label(MAIN_BASE,$
	XOFFSET=draw_offset_x+ctrl_x,$
	YOFFSET = 2*plot_height+draw_y+33, $
	value="Information about selection")  

  PIXELID_INFOS = widget_text(MAIN_BASE, UNAME='PIXELID_INFOS', $
	XOFFSET= draw_offset_x + ctrl_x, $
	YOFFSET= 2*plot_height+draw_y+50, $
	SCR_XSIZE=300, $
	SCR_YSIZE=130,$
	/SCROLL)

  ;Data reduction space
  MICHAEL_SPACE_LABEL = widget_label(MAIN_BASE,$
	XOFFSET=490,$
	YOFFSET=187,$
	VALUE="Data Reduction Interface")
	
  ;Wavelength part (min, max, width)
   WAVELENGTH_LABEL = widget_label(MAIN_BASE,$
 	XOFFSET=500,$
	YOFFSET=205,$
	VALUE="Wavelength")

   wavelength_frame_y_offset = 230
   wavelength_frame_x_offset = 510
   
   ;min
   min_y_offset = wavelength_frame_y_offset
   min_x_offset = wavelength_frame_x_offset
   WAVELENGTH_MIN_LABEL= widget_label(MAIN_BASE,$
 	XOFFSET=min_x_offset,$
	YOFFSET=min_y_offset,$
	VALUE="min")

   WAVELENGTH_MIN_TEXT = widget_text(MAIN_BASE,$
	UNAME='WAVELENGTH_MIN_TEXT',$
 	XOFFSET=min_x_offset+30,$
	YOFFSET=min_y_offset-5,$
	SCR_XSIZE=50,$
	VALUE='0', /editable)

   WAVELENGTH_MIN_A_LABEL= widget_label(MAIN_BASE,$
 	XOFFSET=min_x_offset+80,$
	YOFFSET=min_y_offset,$
	VALUE="Angstroms")

   ;max
   max_y_offset = wavelength_frame_y_offset+30
   max_x_offset = wavelength_frame_x_offset   
   WAVELENGTH_MAX_LABEL= widget_label(MAIN_BASE,$
 	XOFFSET=max_x_offset,$
	YOFFSET=max_y_offset,$
	VALUE="max")

   WAVELENGTH_MAX_TEXT = widget_text(MAIN_BASE,$
	UNAME='WAVELENGTH_MAX_TEXT',$
 	XOFFSET=max_x_offset+30,$
	YOFFSET=max_y_offset-5,$
	SCR_XSIZE=50,$
	VALUE='10', /editable)

   WAVELENGTH_MAX_A_LABEL= widget_label(MAIN_BASE,$
 	XOFFSET=max_x_offset+80,$
	YOFFSET=max_y_offset,$
	VALUE="Angstroms")

   ;width
   width_y_offset =  wavelength_frame_y_offset +60
   width_x_offset = wavelength_frame_x_offset - 10
   WAVELENGTH_WIDTH_LABEL= widget_label(MAIN_BASE,$
 	XOFFSET=width_x_offset,$
	YOFFSET=width_y_offset,$
	VALUE="width")

   WAVELENGTH_WIDTH_TEXT = widget_text(MAIN_BASE,$
	UNAME='WAVELENGTH_WIDTH_TEXT',$
 	XOFFSET=width_x_offset+40,$
	YOFFSET=width_y_offset-5,$
	SCR_XSIZE=50,$
	VALUE='0.1', /editable)

   WAVELENGTH_WIDTH_A_LABEL= widget_label(MAIN_BASE,$
 	XOFFSET=width_x_offset+90,$
	YOFFSET=width_y_offset,$
	VALUE="Angstroms")

   FRAME_WAVELENGTH = widget_label(MAIN_BASE, $
	XOFFSET=495,$
	YOFFSET=213,$
	SCR_XSIZE=160,$
	SCR_YSIZE=105,FRAME=3, value="")

   ;detector angle part
   DETECTOR_LABEL = widget_label(MAIN_BASE,$
 	XOFFSET=675,$
	YOFFSET=205,$
	VALUE="Detector angle/error")

   DETECTOR_ANGLE_VALUE = widget_text(MAIN_BASE,$
	UNAME="DETECTOR_ANGLE_VALUE",$
	XOFFSET=672,$
	YOFFSET=230,$
	SCR_XSIZE=40,$
	VALUE='0',$
	/editable)

   DETECTOR_ANGLE_PLUS_MINUS = widget_label(MAIN_BASE,$
	XOFFSET=711,$
	YOFFSET=236,$
	VALUE='+/-')

   DETECTOR_ANGLE_ERR = widget_text(MAIN_BASE,$
	UNAME="DETECTOR_ANGLE_ERR",$
	XOFFSET=732,$
	YOFFSET=230,$
	SCR_XSIZE=40,$
	VALUE='0',$
	/editable)

   angle_units = ["radians","degres"]
   DETECTOR_ANGLE_UNITS = widget_droplist(MAIN_BASE,$
	UNAME='DETECTOR_ANGLE_UNITS',$
	XOFFSET=762,$
	YOFFSET=228,$
	VALUE=angle_units, $
	title='')

   FRAME_DETECTOR = widget_label(MAIN_BASE,$
	XOFFSET=670,$
	YOFFSET=213,$
	SCR_XSIZE=180,$
	SCR_YSIZE=55,FRAME=3, value="")

   ;file name part
   FILE_NAME_LABEL = widget_label(MAIN_BASE,$
	XOFFSET=495,$
	YOFFSET=337,$
	VALUE='NeXus file name')

   FILE_NAME_TEXT = widget_text(MAIN_BASE,$
	UNAME="FILE_NAME_TEXT",$
	XOFFSET=600,$
	YOFFSET=330,$
	VALUE='',$
	SCR_XSIZE=250)
	
   ;big GO button
   START_CALCULATION = widget_button(MAIN_BASE,$
	UNAME='START_CALCULATION',$
	XOFFSET=670,$
	YOFFSET=283,$
	SCR_XSIZE=180,$
	SCR_YSIZE=35,FRAME=3, value="GO")

   ;background switch part
    FILE_BACK_BASE = widget_base(MAIN_BASE,$
	row=1, /nonexclusive,$
	XOFFSET=490,$
	YOFFSET=360)
    BACKGROUND_SWITCH = widget_button(FILE_BACK_BASE,$
	UNAME="BACKGROUND_SWITCH",$
	VALUE="Background")

;    ;path
;    PATH_LABEL = widget_label(MAIN_BASE,$
;	XOFFSET=602,$
;	YOFFSET=365,$
;	VALUE="Path:")
;
;    PATH_TEXT = widget_label(MAIN_BASE,$
;	UNAME="PATH_TEXT",$
;	XOFFSET=636,$
;	YOFFSET=365,$
;	SCR_XSIZE=210,$
;	SCR_YSIZE=19,$
;	value="",$
;	/align_left)
;
;    PATH_WHOLE_LABEL = widget_label(MAIN_BASE,$
;	XOFFSET=600,$
;	YOFFSET=363,$
;	SCR_XSIZE=245,$
;	SCR_YSIZE=20,$
;	FRAME=1)
	
    FILE_NORM_BASE = widget_base(MAIN_BASE,$
	row=1, /nonexclusive,$
	XOFFSET=490,$
	YOFFSET=390)
    NORMALIZATION_SWITCH = widget_button(FILE_NORM_BASE,$
	UNAME="NORMALIZATION_SWITCH",$
	VALUE="Normalization")

    NORM_FILE_TEXT = widget_text(MAIN_BASE,$
	UNAME='NORM_FILE_TEXT',$
	XOFFSET=600,$
	YOFFSET=390,$
	SCR_XSIZE=250,$
	value='')

  ;maine Data Reduction frame
  FRAME2 = widget_label(MAIN_BASE, $
	XOFFSET=3*draw_offset_x+ctrl_x+plot_height+plot_length,$
	YOFFSET=195,$
	SCR_XSIZE=2.5*plot_height,$
	SCR_YSIZE=225,FRAME=4, value="")

  FILE_MENU = Widget_Button(WID_BASE_0_MBAR, UNAME='FILE_MENU' ,/MENU  $
      ,VALUE='File')

  OPEN_MENU = Widget_Button(FILE_MENU, UNAME='OPEN_MENU'  $
      ,VALUE='Open Histogram')

;  OPEN_NORMALIZATION = Widget_Button(FILE_MENU, UNAME='OPEN_NORMALIZATION'  $
;      ,VALUE='Open Normalization')

  EXIT_MENU = Widget_Button(FILE_MENU, UNAME='EXIT_MENU'  $
      ,VALUE='Exit')

  UTILS_MENU = Widget_Button(WID_BASE_0_MBAR, UNAME='UTILS_MENU'  $
      ,/MENU ,VALUE='Utils')

  CTOOL_MENU = Widget_Button(UTILS_MENU, UNAME='CTOOL_MENU'  $
      ,VALUE='Color Tool')

;  CTOOL_MENU = Widget_Button(UTILS_MENU, UNAME='SWAP_ENDIAN'  $
;      ,VALUE='Swap Endian')

  Widget_Control, /REALIZE, MAIN_BASE


  Widget_Control, SAVE_BUTTON, sensitive=0
  Widget_Control, REFRESH_BUTTON, sensitive=0

  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

;
; Empty stub procedure used for autoloading.
;
pro extract_data, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
