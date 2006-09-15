pro MAIN_BASE_event, Event

  wWidget =  Event.top  ;widget id

  case Event.id of

    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end

    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_EVENT_FILE_BUTTON_tab1'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_EVENT_FILE_CB, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='NUMBER_PIXEL_IDS'): begin
    	NUMBER_PIXEL_IDS_CB, Event
    end
	
    widget_info(wWidget, FIND_BY_UNAME='REBINNING_TYPE_GROUP'): begin
	REBINNING_TYPE_GROUP_CP, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='REBINNING_TEXT'): begin
    	REBINNING_TEXT_CB, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='MAX_TIME_BIN_TEXT'): begin
    	MAX_TIME_BIN_TEXT_CB, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_MAPPING_FILE_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_MAPPING_FILE_BUTTON_CB, Event
	end

    Widget_Info(wWidget, FIND_BY_UNAME='DEFAULT_PATH_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        DEFAULT_PATH_BUTTON_CB, Event
	end

    Widget_Info(wWidget, FIND_BY_UNAME='GO_HISTOGRAM_BUTTON_wT1'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        GO_HISTOGRAM_CB, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='CREATE_NEXUS'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        CREATE_NEXUS_CB, Event
    end

    ;portal_go
	
    Widget_Info(wWidget, FIND_BY_UNAME='PORTAL_GO'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
	id=widget_info(Event.top,FIND_BY_UNAME='INSTRUMENT_TYPE_GROUP')
	WIDGET_control, id, GET_VALUE=instrument

	id=widget_info(Event.top,FIND_BY_UNAME='USER_TEXT')
	WIDGET_control, id, GET_VALUE=user


	CASE instrument OF
		0: print, "portal_value= ", instrument
		1: print, "portal_value= ", instrument
		2: print, "portal_value= ", instrument
	ENDCASE

	if (check_access(Event, instrument, user) NE -1) then begin
		id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
		WIDGET_CONTROL, id, /destroy
		wTLB, GROUP_LEASER=wGroup, _EXTRA=_VWBExtra_, instrument, user
	endif else begin
		access = "!ACCESS!"
		denied = "!DENIED!"		
		id=widget_info(Event.top,FIND_BY_UNAME='LEFT_TOP_ACCESS_DENIED')
		WIDGET_control, id, set_value=access
		id=widget_info(Event.top,FIND_BY_UNAME='LEFT_BOTTOM_ACCESS_DENIED')
		WIDGET_control, id, set_value=denied
		id=widget_info(Event.top,FIND_BY_UNAME='RIGHT_TOP_ACCESS_DENIED')
		WIDGET_control, id, set_value=access
		id=widget_info(Event.top,FIND_BY_UNAME='RIGHT_BOTTOM_ACCESS_DENIED')
		WIDGET_control, id, set_value=denied
		id=widget_info(Event.top,FIND_BY_UNAME="USER_TEXT")
		WIDGET_control, id, set_value=""
			
	endelse



     end

    else:

  endcase

end


pro PORTAL_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

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

Resolve_Routine, 'make_histo_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup, UNAME='MAIN_BASE'  $
      ,SCR_XSIZE=265 ,SCR_YSIZE=280, XOFFSET=450 ,YOFFSET=50 $
      ,NOTIFY_REALIZE='MAIN_REALIZE' ,TITLE='Make NeXus'  $
      ,SPACE=3 ,XPAD=3 ,YPAD=3 ,MBAR=WID_BASE_0_MBAR)

;attach global data structure with widget ID of widget main base widget ID
widget_control,MAIN_BASE,set_uvalue=global

PORTAL_BASE= widget_base(MAIN_BASE, $
	UNAME='PORTAL_BASE',$
	SCR_XSIZE=240, SCR_YSIZE=110, FRAME=10,$
	SPACE=4, XPAD=3, YPAD=3,column=1)

PORTAL_LABEL = widget_label(PORTAL_BASE,$
	XOFFSET=40, YOFFSET=3, VALUE="SELECT YOUR INSTRUMENT")

instrument_list = ['Liquid Reflectometer', 'Magnetic Reflectometer', 'Backscattering Spectrometer']

INSTRUMENT_TYPE_GROUP = CW_BGROUP(PORTAL_BASE,$ 
	instrument_list,$
    	/exclusive,/RETURN_NAME,$
	XOFFSET=30, YOFFSET=25,$
	SET_VALUE=0.0,$
	UNAME='INSTRUMENT_TYPE_GROUP')

USER_BASE = widget_base(MAIN_BASE,$
	UNAME="USER_BASE",$
	SCR_XSIZE=240,$
	SCR_YSIZE=70,$
	XOFFSET=3,$
	YOFFSET=150,$
	FRAME=10,$
	SPACE=4, XPAD=3, YPAD=3)

USER_LABEL = Widget_label(USER_BASE,$
	XOFFSET=65, YOFFSET=3, VALUE="ENTER YOUR UCAMS")

USER_TEXT = widget_text(USER_BASE,$
	UNAME='USER_TEXT',$
	XOFFSET=90, YOFFSET=25,$
	SCR_XSIZE=40, SCR_YSIZE=35,$
	VALUE='',/EDITABLE)
	

LEFT_TOP_ACCESS_DENIED = widget_label(USER_BASE,$
	UNAME='LEFT_TOP_ACCESS_DENIED',$
	XOFFSET=5,$
	YOFFSET=20,$
	SCR_XSIZE=80,$
	SCR_YSIZE=25,$
	VALUE="")

LEFT_BOTTOM_ACCESS_DENIED = widget_label(USER_BASE,$
	UNAME='LEFT_BOTTOM_ACCESS_DENIED',$
	XOFFSET=5,$
	YOFFSET=40,$
	SCR_XSIZE=80,$
	SCR_YSIZE=25,$
	VALUE="")

RIGHT_TOP_ACCESS_DENIED = widget_label(USER_BASE,$
	UNAME='RIGHT_TOP_ACCESS_DENIED',$
	XOFFSET=135,$
	YOFFSET=20,$	
	SCR_XSIZE=80,$
	SCR_YSIZE=25,$
	VALUE="")

RIGHT_BOTTOM_ACCESS_DENIED = widget_label(USER_BASE,$
	UNAME='RIGHT_BOTTOM_ACCESS_DENIED',$
	XOFFSET=135,$
	YOFFSET=40,$	
	SCR_XSIZE=80,$
	SCR_YSIZE=25,$
	VALUE="")

PORTAL_GO = widget_button(MAIN_BASE,$
	XOFFSET=3, YOFFSET=250, $
	SCR_XSIZE=260, SCR_YSIZE=30,$
	UNAME="PORTAL_GO",$
	VALUE="E N T E R")

  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

pro wTLB, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument, user

Resolve_Routine, 'make_histo_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

;define initial global values - these could be input via external file or other means

instrument_list = ['REF_L', 'REF_M', 'BSS']
;instrument1 = instrument_list[instrument]

global = ptr_new({$
		path			: '~/CD4/REF_M/REF_M_7/',$
		instrument		: instrument_list[instrument],$
		user			: user,$
		filter_event		: '*_event.dat',$
		event_filename  	: '',$
		event_filename_only	: '',$
		histo_filename		: '',$
		histo_mapped_filename	: '',$
		mapping_filename	: '/SNS/REF_M/2006_1_4A_CAL/calibrations/REF_M_TS_2006_08_04.dat',$
		translation_filename	: '/SNS/REF_M/2006_1_4A_CAL/calibrations/REF_M_2006_08_03.nxt',$
		nexus_filename		: '',$
		new_translation_filename: '',$
		lin_log			: 0L,$
		number_pixels		: 0L,$
		rebinning		: 0L,$
		max_time_bin		: 0L,$
		filter_mapping		: 'REF_M_TS_*.dat',$
		path_mapping		: '/SNS/REF_M/2006_1_4A_CAL/calibrations/' $
		 })

  ; Create the top-level base and the tab.
  MAIN_BASE = WIDGET_BASE(GROUP_LEADER=wGroup, UNAME='wTLB',/COLUMN, XOFFSET=50, YOFFSET=450, $
	SCR_XSIZE=500, SCR_YSIZE=310, title="Histogramming - Mapping - Translation")

  wTab = WIDGET_TAB(MAIN_BASE, LOCATION=location)

  ; Create the first tab base, containing a label and two
  ; button groups.
  wT1 = WIDGET_BASE(wTab, TITLE='Histogramming',$
	UNAME="wT1",$
	SCR_XSIZE=500, SCR_YSIZE=250)

  OPEN_EVENT_FILE_BUTTON_tab1 = WIDGET_BUTTON(wT1, $
	UNAME="OPEN_EVENT_FILE_BUTTON_tab1",$
	XOFFSET= 10, YOFFSET = 5, $
	SCR_XSIZE=120, SCR_YSIZE=30, $
	VALUE= "Select Event file")
  EVENT_FILE_LABEL_tab1 = WIDGET_TEXT(wT1,$
	UNAME='EVENT_FILE_LABEL_tab1',$
	XOFFSET=135, YOFFSET=5,$
	SCR_XSIZE=358, SCR_YSIZE=30, $
	value = '')

  NUMBER_PIXELIDS_LABEL_tab1 = WIDGET_LABEL(wT1,$
	UNAME="NUMBER_PIXELIDS_LABEL_tab1",$
	XOFFSET=8, YOFFSET=40,$
	SCR_XSIZE=130, SCR_YSIZE=30,$
	VALUE='Number of pixel IDs',$
	sensitive=0)

  NUMBER_PIXELIDS_TEXT_tab1 = WIDGET_TEXT(wT1,$
	UNAME="NUMBER_PIXELIDS_TEXT_tab1",$
	XOFFSET=140, YOFFSET=40,$
	SCR_XSIZE=65, SCR_YSIZE=30,$
	VALUE='',$
	/editable,$
	/ALL_EVENTS,$
	sensitive=0)

  REBINNING_TYPE_GROUP_wT1 = CW_BGROUP(wT1, ['linear', 'logarithmic'], $
    /ROW, /EXCLUSIVE, /RETURN_NAME,$
	XOFFSET=20, YOFFSET=70,$
	SET_VALUE=0.0,$
	UNAME='REBINNING_TYPE_GROUP')

  left_offset=8
  top_offset=70+30
  REBINNING_LABEL_wT1 = WIDGET_LABEL(wT1, $
	UNAME="REBINNING_LABEL_wT1",$
	XOFFSET=left_offset, YOFFSET=top_offset,$
	SCR_XSIZE=130, SCR_YSIZE=30,$
	VALUE='Rebin value (microS)',$
	sensitive=0)

  REBINNING_TEXT_wT1 = WIDGET_TEXT(wT1,$
	UNAME="REBINNING_TEXT_wT1",$
	XOFFSET=left_offset+132,$
	YOFFSET=top_offset+2,$
	SCR_XSIZE=65, SCR_YSIZE=30,$
	VALUE='25', /editable,$
	/ALL_EVENTS,$
	sensitive=0)

  MIN_TIME_BIN_LABEL_wT1 = WIDGET_LABEL(wT1, $
	UNAME="MIN_TIME_BIN_LABEL_wT1",$
	XOFFSET=left_offset+2,$
	YOFFSET=top_offset+37,$
	SCR_XSIZE=120,$
	SCR_YSIZE=30,$
	VALUE='Min Tstamp (microS)',$
	sensitive=0)

  MIN_TIME_BIN_TEXT_wT1 = WIDGET_TEXT(wT1,$
	UNAME='MIN_TIME_BIN_TEXT_wT1',$
	XOFFSET=left_offset+132,$
	YOFFSET=top_offset+35,$
	SCR_XSIZE=65,$
	SCR_YSIZE=30,$
	VALUE='0', /editable,$
	/ALL_EVENTS,$
	sensitive=0)

  MAX_TIME_BIN_LABEL_wT1 = WIDGET_LABEL(wT1, $
	UNAME="MAX_TIME_BIN_LABEL_wT1",$
	XOFFSET=left_offset+2,$
	YOFFSET=top_offset+70,$
	SCR_XSIZE=120, SCR_YSIZE=30,$
	VALUE='Max Tstamp (microS)',$
	sensitive=0)

  MAX_TIME_BIN_TEXT_wT1 = WIDGET_TEXT(wT1,$
	UNAME='MAX_TIME_BIN_TEXT_wT1',$
	XOFFSET=left_offset+132,$
	YOFFSET=top_offset+70,$
	SCR_XSIZE=65, SCR_YSIZE=30,$
	VALUE='', /editable,$
	/ALL_EVENTS,$
	sensitive=0)

  LEFT_FRAME_wT1 = WIDGET_LABEL(wT1,$
	XOFFSET=5, YOFFSET=37,$
	SCR_XSIZE=200, SCR_YSIZE=170,$
	FRAME=2, value ='')

  GO_HISTOGRAM_BUTTON_wT1 = WIDGET_BUTTON(wT1,$
	XOFFSET=3, $
	YOFFSET=top_offset+115,$
	SCR_XSIZE=208, SCR_YSIZE=30,$
	VALUE='Histogram Data',$
	UNAME='GO_HISTOGRAM_BUTTON_wT1')

  HISTOGRAM_STATUS_wT1 = WIDGET_TEXT(wT1,$
	XOFFSET=215, YOFFSET=37,$
	SCR_XSIZE=275, SCR_YSIZE=210,$
	VALUE='First, select an event file.', /scroll,$
	/wrap,$
	UNAME='HISTOGRAM_STATUS')

;  wLabel = WIDGET_LABEL(wT1, VALUE='Choose values')
;  wBgroup1 = CW_BGROUP(wT1, ['one', 'two', 'three'], $
;    /ROW, /NONEXCLUSIVE, /RETURN_NAME)
;  wBgroup2 = CW_BGROUP(wT1, ['red', 'green', 'blue'], $
;    /ROW, /EXCLUSIVE, /RETURN_NAME)

  wT2 = WIDGET_BASE(wTab, TITLE='Mapping and Default Path')

  OPEN_MAPPING_FILE_BUTTON_tab2 = WIDGET_BUTTON(wT2, $
	XOFFSET= 5, YOFFSET = 5, $
	SCR_XSIZE=130, SCR_YSIZE=30, $
	VALUE= "Mapping file",$
	UNAME='OPEN_MAPPING_FILE_BUTTON')
  MAPPING_FILE_LABEL_tab2 = WIDGET_TEXT(wT2,$
	UNAME='MAPPING_FILE_LABEL_tab1',$
	XOFFSET=135, YOFFSET=5,$
	SCR_XSIZE=358, SCR_YSIZE=32, $
	value = (*global).mapping_filename)

  DEFAULT_TRANSLATION_BUTTON_tab2 = WIDGET_BUTTON(wT2, $
	XOFFSET= 5, YOFFSET = 45, $
	SCR_XSIZE=130, SCR_YSIZE=30, $
	VALUE= "Translation file",$
	UNAME='DEFAULT_TRANSLATION_BUTTON')
  DEFAULT_TRANSLATION_FILE_tab2 = WIDGET_TEXT(wT2,$
	UNAME='DEFAULT_TRANSLATION_FILE_tab2',$
	XOFFSET=135, YOFFSET=45,$
	SCR_XSIZE=358, SCR_YSIZE=32, $
	value = (*global).translation_filename)

  DEFAULT_PATH_BUTTON_tab2 = WIDGET_BUTTON(wT2, $
	XOFFSET= 5, YOFFSET = 85, $
	SCR_XSIZE=130, SCR_YSIZE=30, $
	VALUE= "Default final path",$
	UNAME='DEFAULT_PATH_BUTTON')
  DEFAULT_FINAL_PATH_tab2 = WIDGET_TEXT(wT2,$
	UNAME='DEFAULT_FINAL_PATH_tab2',$
	XOFFSET=135, YOFFSET=85,$
	SCR_XSIZE=358, SCR_YSIZE=32, $
	value = '')

;   Create the second tab base, containing a label and
;  a slider.
;  wLabel = WIDGET_LABEL(wT2, VALUE='Move the Slider')
;  wSlider = WIDGET_SLIDER(wT2)

;   Create the third tab base, containing a label and
;  a text-entry field.
;  wT3 = WIDGET_BASE(wTab, TITLE='Default Path', /COLUMN)
;  wLabel = WIDGET_LABEL(wT3, VALUE='Enter some text')
;  wText= WIDGET_TEXT(wT3, /EDITABLE, /ALL_EVENTS)

;   Create a base widget to hold the 'Create NeXus' button, and
;   the button itself.
  wControl = WIDGET_BASE(MAIN_BASE)
  CREATE_NEXUS = WIDGET_BUTTON(wControl, VALUE='C R E A T E    N E X U S',$
	UNAME = "CREATE_NEXUS",$
	XOFFSET=10, YOFFSET=5,$
	SCR_XSIZE=480, SCR_YSIZE=30)

;   Realize the widgets, set the user value of the top-level
;  base, and call XMANAGER to manage everything.
  WIDGET_CONTROL, MAIN_BASE, /REALIZE
  WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global ;we've used global, not stash as the structure name
  Widget_Control, CREATE_NEXUS, sensitive=0
  Widget_Control, GO_HISTOGRAM_BUTTON_wT1, sensitive=0
  Widget_Control, DEFAULT_PATH_BUTTON_tab2, sensitive=0
  XMANAGER, 'wTLB', MAIN_BASE, /NO_BLOCK
    
end

;
; Empty stub procedure used for autoloading.
;
pro make_histo, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
   PORTAL_BASE, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra
end
