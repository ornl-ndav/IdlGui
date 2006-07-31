pro MAIN_BASE_event, Event

  wWidget =  Event.top  ;widget id

;stop

  case Event.id of

    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end
    
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
scr_x 	= 1005				;main window width
scr_y 	= 600				;main window height 
ctrl_x	= 128				;width of left box - control
ctrl_y	= scr_y				;height of lect box - control
draw_x 	= 304				;main width of draw area
draw_y 	= 256				;main heigth of draw area
draw_offset_x = 10			;draw x offset within widget
draw_offset_y = 10			;draw y offset within widget
plot_height = 150			;plot box height
plot_length = 304			;plot box length

Resolve_Routine, 'extract_data_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup, UNAME='MAIN_BASE'  $
      ,XOFFSET=100 ,YOFFSET=50 ,SCR_XSIZE=scr_x ,SCR_YSIZE=scr_y  $
      ,NOTIFY_REALIZE='MAIN_REALIZE' ,TITLE='Extract Data Tool'  $
      ,SPACE=3 ,XPAD=3 ,YPAD=3 ,MBAR=WID_BASE_0_MBAR)

;define initial global values - these could be input via external file or other means

global = ptr_new({ $
	filename		: '',$
	filename_index		: 0, $
	scr_x			: scr_x,$
	scr_y			: scr_y,$
	ctrl_x			: ctrl_x,$
	ctrl_y			: ctrl_y,$
	draw_x			: draw_x,$
	draw_y			: draw_y,$
	draw_offset_x		: draw_offset_x,$
	draw_offset_y		: draw_offset_y,$
	plot_height		: plot_height,$
	plot_length		: plot_length, $
	filter			: '*.dat',$
	Nx			: 256L,$
	Ny			: 304L,$
	Ntof			: 0L, $
	data_ptr		: ptr_new(0L),$
	img_ptr			: ptr_new(0L), $
	selection_ptr		: ptr_new(OL), $
	x			: 0L,$
	y			: 0L,$
	tof			: 0L, $
	ct			: 5, $
	pass			: 0, $
	have_indicies		: 0, $
	indicies		: ptr_new(0L), $
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

  VIEW_DRAW_SELECTION = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_SELECTION', $
	XOFFSET=3*draw_offset_x+ctrl_x+plot_height+plot_length, $
	YOFFSET=2*draw_offset_y+1.3*plot_height+60, SCR_XSIZE=2.5*plot_height, $
	SCR_YSIZE=plot_height, RETAIN=2)

  TBIN_LABEL = widget_label(MAIN_BASE, UNAME='TBIN_LABEL',XOFFSET=draw_offset_x, YOFFSET=draw_offset_y, $
	VALUE="Enter Tbin width:")
	
  TBIN_UNITS_LABEL = widget_label(MAIN_BASE, UNAME='TBIN_UNITS_LABEL',XOFFSET=80+draw_offset_x, YOFFSET=28+draw_offset_y, $
	VALUE="microS")

  TBIN_TXT = widget_text(MAIN_BASE, UNAME='TBIN_TXT', XOFFSET=draw_offset_x, YOFFSET=30,$
	SCR_XSIZE=80, SCR_YSIZE=30,/editable, VALUE='25')
	
  PIXELID_INFOS = widget_text(MAIN_BASE, UNAME='PIXELID_INFOS', $
	XOFFSET=3*draw_offset_x+ctrl_x+plot_height+plot_length, $
	YOFFSET= draw_offset_y, $
	SCR_XSIZE=2.5*plot_height, $
	SCR_YSIZE=100+plot_height,$
	/SCROLL)

   MODE_INFOS = widget_text(MAIN_BASE, UNAME='MODE_INFOS', $
	XOFFSET= draw_offset_x, $
	YOFFSET= 60, SCR_XSIZE= 120, SCR_YSIZE= 30, value= 'MODE: 1 click') 

  FILE_MENU = Widget_Button(WID_BASE_0_MBAR, UNAME='FILE_MENU' ,/MENU  $
      ,VALUE='File')

  OPEN_MENU = Widget_Button(FILE_MENU, UNAME='OPEN_MENU'  $
      ,VALUE='Open')

  EXIT_MENU = Widget_Button(FILE_MENU, UNAME='EXIT_MENU'  $
      ,VALUE='Exit')

  UTILS_MENU = Widget_Button(WID_BASE_0_MBAR, UNAME='UTILS_MENU'  $
      ,/MENU ,VALUE='Utils')

  CTOOL_MENU = Widget_Button(UTILS_MENU, UNAME='CTOOL_MENU'  $
      ,VALUE='Color Tool')

  REFRESH_BUTTON = Widget_Button(MAIN_BASE, UNAME='REFRESH_BUTTON', XOFFSET=draw_offset_x,$
      YOFFSET=128,VALUE='Refresh Selection')
  
  SAVE_BUTTON = Widget_Button(MAIN_BASE, UNAME='SAVE_BUTTON', XOFFSET=draw_offset_x,$
      YOFFSET=128+40,VALUE='Save Region')

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
