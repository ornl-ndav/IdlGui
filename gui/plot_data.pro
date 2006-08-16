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

global = ptr_new({$
		path			:'~/CD4/BSS/2006_1_2_SCI/BSS_22/',$
		filter_histo		:'',$
		nbytes			:4L,$
		swap_endian		:1,$
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

;VIEW_DRAW = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW' ,XOFFSET=draw_offset_x+ctrl_x  $
;      ,YOFFSET=2*draw_offset_y+plot_height ,SCR_XSIZE=draw_x ,SCR_YSIZE=draw_y ,RETAIN=2 ,$
;      /BUTTON_EVENTS,/MOTION_EVENTS)

;draw boxes for plot windows

;TOP_BANK
  VIEW_DRAW_TOP_BANK = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_TOP_BANK',$
	XOFFSET=10,$
        YOFFSET=200,$
	SCR_XSIZE=800,$
	SCR_YSIZE=250 ,RETAIN=2)

;BOTTOM_BANK
  VIEW_DRAW_BOTTOM_BANK = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_BOTTOM_BANK',$
	XOFFSET=10,$
        YOFFSET=455,$
	SCR_XSIZE=800,$
	SCR_YSIZE=250 ,RETAIN=2)

 X_SCALE = Widget_Draw(MAIN_BASE, UNAME='X_SCALE',$
	XOFFSET=4,$
	YOFFSET=710,$
	SCR_XSIZE=812,$
	SCR_YSIZE=30)

 Y_SCALE_TOP_BANK = Widget_Draw(MAIN_BASE, UNAME='Y_SCALE_TOP_BANK',$
	XOFFSET=815,$
	YOFFSET=194,$
	SCR_XSIZE=30,$
	SCR_YSIZE=262)

 Y_SCALE_BOTTOM_BANK = Widget_Draw(MAIN_BASE, UNAME='Y_SCALE_BOTTOM_BANK',$
	XOFFSET=815,$
	YOFFSET=449,$
	SCR_XSIZE=30,$
	SCR_YSIZE=262)


  GENERAL_INFOS = widget_text(MAIN_BASE, $
	UNAME='GENERAL_INFOS', $
	XOFFSET=10,$
	YOFFSET= 20+draw_offset_y, $
	SCR_XSIZE=500, $
	SCR_YSIZE=plot_height,$
	/WRAP,$
	/SCROLL)
	
   GENERAL_INFOS_LABEL = widget_label(MAIN_BASE, $
	XOFFSET=10,$
	YOFFSET= draw_offset_y, $
	value="General Informations")

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

  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

;
; Empty stub procedure used for autoloading.
;
pro plot_data, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
