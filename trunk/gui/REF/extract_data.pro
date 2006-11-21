pro MAIN_BASE_event, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

  wWidget =  Event.top  ;widget id

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
    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_HISTO_MAPPED'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
	 OPEN_HISTO_MAPPED, Event
    end

    ;Open widget in the top toolbar
    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_HISTO_UNMAPPED'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_HISTO_UNMAPPED, Event
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

    ;Exit widget in the top toolbar for REF_M
    Widget_Info(wWidget, FIND_BY_UNAME='ABOUT'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        ABOUT_cb, Event;-----------------------------------------------------------------------------
    end

    ;Exit widget in the top toolbar for REF_L
    Widget_Info(wWidget, FIND_BY_UNAME='ABOUT_MENU_REF_L'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        ABOUT_MENU_REF_L_cb, Event
    end

    ;default path button
    Widget_Info(wWidget, FIND_BY_UNAME='DEFAULT_PATH'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        DEFAULT_PATH_cb, Event
    end

    ;default path button
    Widget_Info(wWidget, FIND_BY_UNAME='DEFAULT_PATH_REF_L'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        DEFAULT_PATH_REF_L_cb, Event
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


    ;##### REF_M #####

    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_RUN_NUMBER'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_NEXUS_FILE, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='SAVE_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        SAVE_REGION, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='IDENTIFICATION_GO'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        IDENTIFICATION_GO_cb, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='DEFAULT_PATH_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        DEFAULT_PATH_BUTTON_cb, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='IDENTIFICATION_TEXT'): begin
    	IDENTIFICATION_TEXT_CB, Event
    end

    ;##### REF_L #####

    Widget_Info(wWidget, FIND_BY_UNAME='SAVE_BUTTON_REF_L'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        SAVE_REGION_REF_L, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='IDENTIFICATION_GO_REF_L'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        IDENTIFICATION_GO_REF_L_cb, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='DEFAULT_PATH_BUTTON_REF_L'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        DEFAULT_PATH_BUTTON_REF_L_cb, Event
    end


    Widget_Info(wWidget, FIND_BY_UNAME='IDENTIFICATION_TEXT_REF_L'): begin
    	IDENTIFICATION_TEXT_REF_L_CB, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='PORTAL_GO'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
	id=widget_info(Event.top,FIND_BY_UNAME='INSTRUMENT_TYPE_GROUP')
	WIDGET_control, id, GET_VALUE=result
	portal_value = result

	id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
	WIDGET_CONTROL, id, /destroy

	if (portal_value EQ 1) then begin
	REF_M_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
	endif else begin
	REF_L_BASE, GROUP_LEASER=wGroup, _EXTRA=_VWBExtra_
	endelse

    end

    ;Exit widget in the top toolbar
    Widget_Info(wWidget, FIND_BY_UNAME='EXIT_MENU_REF_L'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        EXIT_PROGRAM_REF_L, Event
    end

    ;Open widget in the top toolbar
    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_HISTO_MAPPED_REF_L'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
	 OPEN_HISTO_MAPPED_REF_L, Event
    end

    ;Open widget in the top toolbar
    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_HISTO_UNMAPPED_REF_L'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_HISTO_UNMAPPED_REF_L, Event
    end

    ;Widget to change the color of graph
    Widget_Info(wWidget, FIND_BY_UNAME='CTOOL_MENU_REF_L'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        CTOOL_REF_L, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='REFRESH_BUTTON_REF_L'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        REFRESH_REF_L, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='VIEW_DRAW_REF_L'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_DRAW' )then $
        if( Event.type eq 0 )then $
          VIEW_ONBUTTON_REF_L, Event
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

Resolve_Routine, 'extract_data_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

;ABOUT_BASE = Widget_Base(GROUP_LEADER=wGroup, UNAME='ABOUT_BASE',$
;	SCR_XSIZE=200, SCR_YSIZE=200, XOFFSET=100, YOFFSET=100,$
;	TITLE="About miniReflPak", /column,MBAR=WID_BASE_0_MBAR)	
;
;ABOUT_TEXT = widget_text(ABOUT_BASE, SCR_XSIZE=200, SCR_YSIZE=200,$
;	XOFFSET=0, YOFFSET=0, UNAME="ABOUT_TEXT", VALUE="BLABLBBABABABAB")

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup, UNAME='MAIN_BASE'  $
      ,SCR_XSIZE=265 ,SCR_YSIZE=150, XOFFSET=450 ,YOFFSET=50 $
      ,NOTIFY_REALIZE='MAIN_REALIZE' ,TITLE='mini ReflPak'  $
      ,SPACE=3 ,XPAD=3 ,YPAD=3 ,MBAR=WID_BASE_0_MBAR)

;attach global data structure with widget ID of widget main base widget ID
widget_control,MAIN_BASE,set_uvalue=global

PORTAL_BASE= widget_base(MAIN_BASE, $
	UNAME='PORTAL_BASE',$
	SCR_XSIZE=240, SCR_YSIZE=120, FRAME=10,$
	SPACE=4, XPAD=3, YPAD=3,column=1)

PORTAL_LABEL = widget_label(PORTAL_BASE,$
	XOFFSET=40, YOFFSET=3, VALUE="SELECT YOUR INSTRUMENT")


INSTRUMENT_TYPE_GROUP = CW_BGROUP(PORTAL_BASE, $
	['Liquid Reflectometer', 'Magnetic Reflectometer'], $
    	/exclusive,/RETURN_NAME,$
	XOFFSET=30, YOFFSET=25,$
	SET_VALUE=0.0,$
	UNAME='INSTRUMENT_TYPE_GROUP')

PORTAL_GO = widget_button(PORTAL_BASE,$
	XOFFSET=80, YOFFSET=85, $
	SCR_XSIZE=60, SCR_YSIZE=30,$
	UNAME="PORTAL_GO",$
	VALUE="ENTER")

  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end
















pro REF_M_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

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

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup, UNAME='MAIN_BASE'  $
      ,SCR_XSIZE=scr_x ,SCR_YSIZE=scr_y, XOFFSET=250 ,YOFFSET=22 $
      ,NOTIFY_REALIZE='MAIN_REALIZE' ,TITLE='mini ReflPak'  $
      ,SPACE=3 ,XPAD=3 ,YPAD=3 ,MBAR=WID_BASE_0_MBAR)

;define initial global values - these could be input via external file or other means
global = ptr_new({ $
                   run_number   : 0L,$
                   character_id		: '',$
                   idl_path		: '/',$
                   ucams			: '',$
                   name			: '',$
                   filename		: '',$
                   histo_map_index		: 1L,$
                   norm_filename		: '',$
                   filename_only		: '',$
                   full_nexus_name : '',$
                   nexus_filename		: '',$
                   nexus_file_name_only	: '',$
                   nexus_path		: '/SNS/REF_M/2006_2_4A_SCI/',$
                   filename_index		: 0, $
                   full_histo_mapped_name : '',$
                   path			: '/SNSlocal/tmp/',$
                   default_output_path	: '/SNSlocal/users/j35/',$
                   default_path		: '/SNSlocal/users/',$
;	default_path		: '/Users/',$
                   working_path		: '',$
                     tmp_working_path        : '',$
                     tmp_working_path_extenstion: 'miniReflPak_M_tmp/',$
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
                     filter_histo		: '',$
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
                     tlb			: 0,$
                     window_counter		: 0L,$
                     overflow_number		: 500L,$
                     file_already_opened	: 0L,$
                     quit			: 0L$
                   })

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

Resolve_Routine, 'extract_data_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

;;get global structure
;widget_control,MAIN_BASE,get_uvalue=global

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
		XOFFSET=83, YOFFSET=55, VALUE=default_path,$
		UNAME='DEFAULT_PATH_TEXT',/editable,$
		SCR_XSIZE=160)

IDENTIFICATION_GO = widget_button(IDENTIFICATION_BASE,$
		XOFFSET=67, YOFFSET=90,$
		SCR_XSIZE=130, SCR_YSIZE=30,$
		VALUE="E N T E R",$
		UNAME='IDENTIFICATION_GO')		

;LABEL_IDENTIFICATION = widget_label(MAIN_BASE,$
;
;FRAME_IDENTIFICATION = widget_label(MAIN_BASE,$
;	XOFFSET=300,$
;	YOFFSET=300,$
;	SCR_XSIZE=180,$
;	SCR_YSIZE=55,FRAME=3, value="")

VIEW_DRAW = Widget_Draw(MAIN_BASE,$
                        UNAME='VIEW_DRAW',$
                        XOFFSET=draw_offset_x+ctrl_x,$
                        YOFFSET=2*draw_offset_y+plot_height,$
                        SCR_XSIZE=draw_x,$
                        SCR_YSIZE=draw_y,$
                        RETAIN=2,$
                        /BUTTON_EVENTS,$
                        /MOTION_EVENTS)

;draw boxes for plot windows
;TOF_tab
  OPEN_NEXUS_and_VIEW_DRAW_TOF_TAB = WIDGET_TAB(MAIN_BASE, $
                                                LOCATION=0,$
                                                XOFFSET=11,$
                                                YOFFSET=10,$
                                                SCR_XSIZE=plot_length,$
                                                SCR_YSIZE=plot_height)
  
  OPEN_NEXUS_BASE = widget_base(OPEN_NEXUS_and_VIEW_DRAW_TOF_TAB,$
                                TITLE='Open Run number',$
                                XOFFSET=0,$
                                YOFFSET=0)
  
  RUN_NUMBER_TEXT = widget_label(OPEN_NEXUS_BASE,$
                                 XOFFSET=10,$
                                 YOFFSET=10,$
                                 SCR_XSIZE=40,$
                                 SCR_YSIZE=30,$
                                 VALUE="RUN #")

  RUN_NUMBER_BOX = widget_text(OPEN_NEXUS_BASE,$
                               UNAME='RUN_NUMBER_BOX',$
                               XOFFSET=50,$
                               YOFFSET=10,$
                               SCR_XSIZE=50,$
                               SCR_YSIZE=30,$
                               VALUE='',$
                               /editable,$
                               /align_left)

  OPEN_RUN_NUMBER = widget_button(OPEN_NEXUS_BASE,$
                                  UNAME='OPEN_RUN_NUMBER',$
                                  XOFFSET=105,$
                                  YOFFSET=10,$
                                  SCR_XSIZE=80,$
                                  SCR_YSIZE=30,$
                                  VALUE='OPEN NeXus')
  
  
  OPEN_NEXUS = WIDGET_LABEL(OPEN_NEXUS_BASE,$
                            XOFFSET=5,$
                            YOFFSET=5,$
                            SCR_XSIZE=plot_length-15,$
                            SCR_YSIZE=38,$
                            FRAME=1,$
                            VALUE='')
  
  
















  VIEW_DRAW_TOF_BASE = widget_base(OPEN_NEXUS_and_VIEW_DRAW_TOF_TAB,$
                                   Title = "TOF of selected pixel",$
                                   XOFFSET=0,$
                                   YOFFSET=0,$
                                   SCR_XSIZE=plot_length,$
                                   SCR_YSIZE=plot_height)
  

  VIEW_DRAW_TOF = Widget_Draw(VIEW_DRAW_TOF_BASE, $
                              UNAME='VIEW_DRAW_TOF',$
                              XOFFSET=0,$
                              YOFFSET=0,$
                              SCR_XSIZE=plot_length-5,$
                              SCR_YSIZE=plot_height-25,$
                              RETAIN=2)
  



  ;xxxxxxxxxxxxxxxxxxxxxxx

  X_PLOT_TAB = WIDGET_TAB(MAIN_BASE, $
	LOCATION=1,$
	XOFFSET=draw_offset_x+ctrl_x,$
	YOFFSET=3*draw_offset_y+draw_y+plot_height,$
	SCR_XSIZE=plot_length,$
	SCR_YSIZE=plot_height-5)

  X_TOTAL_TAB_PLOT = WIDGET_BASE(X_PLOT_TAB,$
	TITLE= "Total",SCR_XSIZE=plot_length,SCR_YSIZE=plot_height-15)

  VIEW_DRAW_X = Widget_Draw(X_TOTAL_TAB_PLOT, UNAME='VIEW_DRAW_X',$
   	SCR_XSIZE=plot_length ,SCR_YSIZE=plot_height-15 ,RETAIN=2)

  X_SELECTION_TAB_PLOT = WIDGET_BASE(X_PLOT_TAB,$
	TITLE= "Selection",SCR_XSIZE=plot_length,SCR_YSIZE=plot_height-15)

  VIEW_DRAW_SELECTION_X = Widget_Draw(X_SELECTION_TAB_PLOT, UNAME='VIEW_DRAW_SELECTION_X',$
   	SCR_XSIZE=plot_length ,SCR_YSIZE=plot_height-15 ,RETAIN=2)

  ; hidding xxxxxxxx

  VIEW_DRAW_X_REF_M_HIDDING = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_X_REF_M_HIDDING',$
	XOFFSET=draw_offset_x+ctrl_x,$
      	YOFFSET=3*draw_offset_y+draw_y+plot_height,$
	SCR_XSIZE=plot_length,$
	SCR_YSIZE=plot_height-10 ,RETAIN=2)

  ;yyyyyyyyyyyyyyyyyyyyyyy

  Y_PLOT_TAB = WIDGET_TAB(MAIN_BASE, $
	LOCATION=3,$
	XOFFSET=2*draw_offset_x+draw_x+ctrl_x,$
	YOFFSET=2*draw_offset_y+plot_height,$
	SCR_XSIZE=plot_height-5,$
	SCR_YSIZE=draw_y)

  Y_TOTAL_TAB_PLOT = WIDGET_BASE(Y_PLOT_TAB,$
	TITLE= "Total",SCR_XSIZE=plot_height-5,SCR_YSIZE=draw_y)

  VIEW_DRAW_Y = Widget_Draw(Y_TOTAL_TAB_PLOT, UNAME='VIEW_DRAW_Y',$
	SCR_XSIZE=plot_height-15 ,SCR_YSIZE=draw_y,RETAIN=2)

  Y_SELECTION_TAB_PLOT = WIDGET_BASE(Y_PLOT_TAB,$
	TITLE= "Selection",SCR_XSIZE=plot_height-5,SCR_YSIZE=draw_y)

  VIEW_DRAW_SELECTION_Y = Widget_Draw(Y_SELECTION_TAB_PLOT, UNAME='VIEW_DRAW_SELECTION_Y',$
	SCR_XSIZE=plot_height-15 ,SCR_YSIZE=draw_y,RETAIN=2)


  VIEW_DRAW_REDUCTION = Widget_Draw(MAIN_BASE,$
	UNAME='VIEW_DRAW_REDUCTION',$
	XOFFSET=2*draw_offset_x+draw_x+ctrl_x, $
	YOFFSET=3*draw_offset_y+draw_y+plot_height, $
	SCR_XSIZE= 540, SCR_YSIZE= 2*plot_height, RETAIN=2)

  CONTENTS_FILE_INFO_TAB = WIDGET_TAB(MAIN_BASE, $
	LOCATION=0,$
	XOFFSET=480,$
	YOFFSET=0,$
	SCR_XSIZE=385,$
	SCR_YSIZE=180)

  FIRST_TAB = WIDGET_BASE(CONTENTS_FILE_INFO_TAB,$
	TITLE= "Program Infos",SCR_XSIZE=380,SCR_YSIZE=170)

  GENERAL_INFOS = widget_text(FIRST_TAB, $
	UNAME='GENERAL_INFOS', $
	XOFFSET=0,$
	YOFFSET= 0,$
	SCR_XSIZE=380,$
	SCR_YSIZE=150,$
	/WRAP,$
	/SCROLL)
	
  SECOND_TAB = WIDGET_BASE(CONTENTS_FILE_INFO_TAB,$
	TITLE= "NeXus file Infos",SCR_XSIZE=380,SCR_YSIZE=170)

  NEXUS_INFOS = widget_text(SECOND_TAB, $
	UNAME='NEXUS_INFOS', $
	XOFFSET=0,$
	YOFFSET= 0,$
	SCR_XSIZE=380,$
	SCR_YSIZE=150,$
	/WRAP,$
	/SCROLL)

;  THIRD_TAB = WIDGET_BASE(CONTENTS_FILE_INFO_TAB,$
;	TITLE= "XML file Infos",SCR_XSIZE=380,SCR_YSIZE=170)
;
;  XML_INFOS = widget_text(SECOND_TAB, $
;	UNAME='XML_INFOS', $
;	XOFFSET=0,$
;	YOFFSET= 0,$
;	SCR_XSIZE=380,$
;	SCR_YSIZE=150,$
;	/WRAP,$
;	/SCROLL)


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
	UNAME="SELECTION_INFOS",$
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
	UNAME='MICHAEL_SPACE_LABEL',$
	XOFFSET=490,$
	YOFFSET=187,$
	VALUE="Data Reduction Interface")
	
  ;Wavelength part (min, max, width)
   WAVELENGTH_LABEL = widget_label(MAIN_BASE,$
	UNAME='WAVELENGTH_LABEL',$
 	XOFFSET=500,$
	YOFFSET=205,$
	VALUE="Wavelength")

   wavelength_frame_y_offset = 230
   wavelength_frame_x_offset = 510
   
   ;min
   min_y_offset = wavelength_frame_y_offset
   min_x_offset = wavelength_frame_x_offset
   WAVELENGTH_MIN_LABEL= widget_label(MAIN_BASE,$
	UNAME='WAVELENGTH_MIN_LABEL',$
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
	UNAME='WAVELENGTH_MIN_A_LABEL',$
 	XOFFSET=min_x_offset+80,$
	YOFFSET=min_y_offset,$
	VALUE="Angstroms")

   ;max
   max_y_offset = wavelength_frame_y_offset+30
   max_x_offset = wavelength_frame_x_offset   
   WAVELENGTH_MAX_LABEL= widget_label(MAIN_BASE,$
	UNAME='WAVELENGTH_MAX_LABEL',$
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
	UNAME='WAVELENGTH_MAX_A_LABEL',$
 	XOFFSET=max_x_offset+80,$
	YOFFSET=max_y_offset,$
	VALUE="Angstroms")

   ;width
   width_y_offset =  wavelength_frame_y_offset +60
   width_x_offset = wavelength_frame_x_offset - 10
   WAVELENGTH_WIDTH_LABEL= widget_label(MAIN_BASE,$
	UNAME='WAVELENGTH_WIDTH_LABEL',$
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
	UNAME='WAVELENGTH_WIDTH_A_LABEL',$
 	XOFFSET=width_x_offset+90,$
	YOFFSET=width_y_offset,$
	VALUE="Angstroms")

   FRAME_WAVELENGTH = widget_label(MAIN_BASE, $
	UNAME='FRAME_WAVELENGTH',$
	XOFFSET=495,$
	YOFFSET=213,$
	SCR_XSIZE=160,$
	SCR_YSIZE=105,FRAME=3, value="")

   ;detector angle part
   DETECTOR_LABEL = widget_label(MAIN_BASE,$
	UNAME='DETECTOR_LABEL',$
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
	UNAME='DETECTOR_ANGLE_PLUS_MINUS',$
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
	UNAME='FRAME_DETECTOR',$
	XOFFSET=670,$
	YOFFSET=213,$
	SCR_XSIZE=180,$
	SCR_YSIZE=55,FRAME=3, value="")

   ;file name part
   FILE_NAME_LABEL = widget_label(MAIN_BASE,$	
	UNAME='FILE_NAME_LABEL',$
	XOFFSET=495,$
	YOFFSET=337,$
	VALUE='Output path')

   FILE_NAME_TEXT = widget_text(MAIN_BASE,$
	UNAME="FILE_NAME_TEXT",$
	XOFFSET=570,$
	YOFFSET=330,$
	VALUE=default_output_path,$
	SCR_XSIZE=280,$
	/align_right,$
	/editable)
	
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

;   ;histo_mapped switch part
;    HISTO_MAP_BASE = widget_base(MAIN_BASE,$
;	row=1, /nonexclusive,$
;	XOFFSET=602,$
;	YOFFSET=360)
;    HISTO_MAP_SWITCH = widget_button(HISTO_MAP_BASE,$
;	UNAME="HISTO_MAP_SWITCH",$
;	VALUE="Histogram file mapped",$
;	tooltip="ON: _histo_mapped.dat   OFF: _histo.dat")

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

  OPEN_HISTO_MAPPED = Widget_Button(FILE_MENU, UNAME='OPEN_HISTO_MAPPED'  $
      ,VALUE='Open Mapped Histogram')

  OPEN_HISTO_UNMAPPED = Widget_Button(FILE_MENU, UNAME='OPEN_HISTO_UNMAPPED'  $
      ,VALUE='Open Histogram')

  EXIT_MENU = Widget_Button(FILE_MENU, UNAME='EXIT_MENU'  $
      ,VALUE='Exit')

  UTILS_MENU = Widget_Button(WID_BASE_0_MBAR, UNAME='UTILS_MENU'  $
      ,/MENU ,VALUE='Utils')

  DEFAULT_PATH = Widget_Button(UTILS_MENU, UNAME='DEFAULT_PATH'  $
      ,VALUE='Path to working directory')

  CTOOL_MENU = Widget_Button(UTILS_MENU, UNAME='CTOOL_MENU'  $
      ,VALUE='Color Tool')

;  CTOOL_MENU = Widget_Button(UTILS_MENU, UNAME='SWAP_ENDIAN'  $
;      ,VALUE='Swap Endian')

  MINI_REFLPACK_MENU = Widget_Button(WID_BASE_0_MBAR, UNAME='MINI_REFLPAK_MENU'  $
      ,/MENU ,VALUE='mini ReflPak')

  ABOUT_MENU = Widget_Button(MINI_REFLPACK_MENU, UNAME='ABOUT'  $
      ,VALUE='About')

  Widget_Control, /REALIZE, MAIN_BASE

  Widget_Control, SAVE_BUTTON, sensitive=0
  Widget_Control, REFRESH_BUTTON, sensitive=0
  Widget_Control, START_CALCULATION, sensitive=0

  ;disabled background buttons/draw/text/labels
  Widget_Control, UTILS_MENU, sensitive=0
  Widget_Control, OPEN_HISTO_MAPPED, sensitive=0
  Widget_Control, OPEN_HISTO_UNMAPPED, sensitive=0
  Widget_Control, TBIN_UNITS_LABEL, sensitive=0
  Widget_Control, TBIN_LABEL, sensitive=0
  Widget_Control, TBIN_TXT, sensitive=0
  Widget_Control, MODE_INFOS, sensitive=0
  Widget_Control, CURSOR_X_LABEL, sensitive=0
  Widget_Control, CURSOR_X_POSITION, sensitive=0
  Widget_Control, CURSOR_Y_LABEL, sensitive=0
  Widget_Control, CURSOR_Y_POSITION, sensitive=0
  Widget_Control, SELECTION_INFOS, sensitive=0
  Widget_Control, PIXELID_INFOS, sensitive=0
  Widget_Control, MICHAEL_SPACE_LABEL, sensitive=0
  Widget_Control, WAVELENGTH_LABEL, sensitive=0
  Widget_Control, WAVELENGTH_MIN_LABEL, sensitive=0
  Widget_Control, WAVELENGTH_MIN_TEXT, sensitive=0
  Widget_Control, WAVELENGTH_MIN_A_LABEL, sensitive=0
  Widget_Control, WAVELENGTH_MAX_LABEL, sensitive=0
  Widget_Control, WAVELENGTH_MAX_TEXT, sensitive=0
  Widget_Control, WAVELENGTH_MAX_A_LABEL, sensitive=0
  Widget_Control, WAVELENGTH_WIDTH_LABEL, sensitive=0
  Widget_Control, WAVELENGTH_WIDTH_TEXT, sensitive=0
  Widget_Control, WAVELENGTH_WIDTH_A_LABEL, sensitive=0
  Widget_Control, FRAME_WAVELENGTH, sensitive=0
  Widget_Control, DETECTOR_LABEL, sensitive=0
  Widget_Control, DETECTOR_ANGLE_VALUE, sensitive=0
  Widget_Control, DETECTOR_ANGLE_PLUS_MINUS, sensitive=0
  Widget_Control, DETECTOR_ANGLE_ERR, sensitive=0
  Widget_Control, DETECTOR_ANGLE_UNITS, sensitive=0
  Widget_Control, FILE_NAME_LABEL, sensitive=0
  Widget_Control, FILE_NAME_TEXT, sensitive=0
  Widget_Control, BACKGROUND_SWITCH, sensitive=0
  Widget_Control, NORMALIZATION_SWITCH, sensitive=0
  Widget_Control, NORM_FILE_TEXT, sensitive=0

 XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end



pro REF_L_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;define parameters
scr_x 	= 880				;main window width
scr_y 	= 750				;main window height 
ctrl_x	= 1				;width of left box - control
ctrl_y	= scr_y				;height of lect box - control
draw_x 	= 256				;main width of draw area
draw_y 	= 304				;main heigth of draw area
draw_offset_x = 10			;draw x offset within widget
draw_offset_y = 10			;draw y offset within widget
plot_height = 130			;plot box height
plot_length = 256			;plot box length

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup, UNAME='MAIN_BASE'  $
      ,SCR_XSIZE=scr_x ,SCR_YSIZE=scr_y, XOFFSET=250 ,YOFFSET=22 $
      ,NOTIFY_REALIZE='MAIN_REALIZE' ,TITLE='mini ReflPak'  $
      ,SPACE=3 ,XPAD=3 ,YPAD=3 ,MBAR=WID_BASE_0_MBAR)

;define initial global values - these could be input via external file or other means
global = ptr_new({ $
	character_id		: '',$
	idl_path		: '/',$
	ucams			: '',$
	name			: '',$
	filename		: '',$
	histo_map_index		: 1L,$
	norm_filename		: '',$
	filename_only		: '',$
	nexus_filename		: '',$
	nexus_filename_only	: '',$
	nexus_path		: '/SNS/REF_M/2006_1_4A_SCI/',$
	filename_index		: 0, $
	path			: '/SNSlocal/tmp/',$
;	path 			: '~/data/REF_L/',$		;REMOVE ME
	default_output_path	: '/SNS/users/j35/',$
	default_path		: '/SNS/users/',$
;	default_path		: '/Users/',$
	working_path		: '',$
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
	filter_histo		: '',$
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
	Ny			: 256L,$
	Nx			: 304L,$
	Ntof			: 0L,$
        end_bin                 : 150000L,$
	starting_id_x		: 0L,$
	starting_id_y		: 0L,$
	ending_id_x		: 0L,$
	ending_id_y		: 0L,$
	data_ptr		: ptr_new(0L),$
	data_assoc		: ptr_new(0L),$
	img_ptr			: ptr_new(0L),$
	selection_ptr		: ptr_new(OL),$
	counts_vs_tof		: ptr_new(0L),$
	x			: 0L,$
	y			: 0L,$
	tof			: 0L,$
	ct			: 5,$
	pass			: 0,$
	have_indicies		: 0,$
	indicies		: ptr_new(0L),$
	tlb			: 0,$
	window_counter		: 0L,$
	quit			: 0L,$
	overflow_number		: 500L,$
	file_already_opened	: 0L$
	})

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

Resolve_Routine, 'extract_data_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

IDENTIFICATION_BASE_REF_L= widget_base(MAIN_BASE, XOFFSET=300, YOFFSET=300,$
	UNAME='IDENTIFICATION_BASE_REF_L',$
	SCR_XSIZE=240, SCR_YSIZE=120, FRAME=10,$
	SPACE=4, XPAD=3, YPAD=3)

IDENTIFICATION_LABEL_REF_L = widget_label(IDENTIFICATION_BASE_REF_L,$
		XOFFSET=40, YOFFSET=3, VALUE="ENTER YOUR 3 CHARACTERS ID")

IDENTIFICATION_TEXT_REF_L = widget_text(IDENTIFICATION_BASE_REF_L,$
		XOFFSET=100, YOFFSET=20, VALUE='',$
		SCR_XSIZE=37, /editable,$
		UNAME='IDENTIFICATION_TEXT_REF_L',/ALL_EVENTS)

ERROR_IDENTIFICATION_left_REF_L = widget_label(IDENTIFICATION_BASE_REF_L,$
		XOFFSET=5, YOFFSET=25, VALUE='',$
		SCR_XSIZE=90, SCR_YSIZE=20, $
		UNAME='ERROR_IDENTIFICATION_LEFT_REF_L')

ERROR_IDENTIFICATION_right_REF_L = widget_label(IDENTIFICATION_BASE_REF_L,$
		XOFFSET=140, YOFFSET=25, VALUE='',$
		SCR_XSIZE=90, SCR_YSIZE=20, $
		UNAME='ERROR_IDENTIFICATION_RIGHT_REF_L')

DEFAULT_PATH_BUTTON_REF_L = widget_button(IDENTIFICATION_BASE_REF_L,$
		XOFFSET=0, YOFFSET=55, VALUE='Working path',$
		SCR_XSIZE=80, SCR_YSIZE=30,$
		UNAME='DEFAULT_PATH_BUTTON_REF_L')

DEFAULT_PATH_TEXT_REF_L = widget_text(IDENTIFICATION_BASE_REF_L,$
		XOFFSET=83, YOFFSET=55, VALUE=default_path,$
		UNAME='DEFAULT_PATH_TEXT_REF_L',/editable,$
		SCR_XSIZE=160)

IDENTIFICATION_GO_REF_L = widget_button(IDENTIFICATION_BASE_REF_L,$
		XOFFSET=67, YOFFSET=90,$
		SCR_XSIZE=130, SCR_YSIZE=30,$
		VALUE="E N T E R",$
		UNAME='IDENTIFICATION_GO_REF_L')		

VIEW_DRAW_REF_L = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_REF_L' ,XOFFSET=draw_offset_x+ctrl_x  $
      ,YOFFSET=2*draw_offset_y+plot_height ,SCR_XSIZE=draw_x ,SCR_YSIZE=draw_y ,RETAIN=2 ,$
      /BUTTON_EVENTS,/MOTION_EVENTS)

;draw boxes for plot windows
;TOF
  VIEW_DRAW_TOF_REF_L = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_TOF_REF_L',$
	XOFFSET=draw_offset_x+ctrl_x,$
	YOFFSET=draw_offset_y,$
	SCR_XSIZE=plot_length,$
	SCR_YSIZE=130 ,RETAIN=2)
;X
  VIEW_DRAW_X_REF_L = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_X_REF_L',$
	XOFFSET=draw_offset_x+ctrl_x,$
      	YOFFSET=3*draw_offset_y+draw_y+plot_height,$
	SCR_XSIZE=plot_length,$
	SCR_YSIZE=plot_height ,RETAIN=2)

  ; hidding xxxxxxxx

  VIEW_DRAW_X_REF_M_HIDDING = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_X_REF_L_HIDDING',$
	XOFFSET=draw_offset_x+ctrl_x,$
      	YOFFSET=3*draw_offset_y+draw_y+plot_height,$
	SCR_XSIZE=plot_length,$
	SCR_YSIZE=plot_height ,RETAIN=2)

;SUM_X
  VIEW_DRAW_SUM_X_REF_L = Widget_Draw(MAIN_BASE, UNAME='VIEW_DRAW_SUM_X_REF_L',$
	XOFFSET=draw_offset_x + ctrl_x,$
      	YOFFSET=605 ,SCR_XSIZE=plot_length,$
	SCR_YSIZE=plot_height ,RETAIN=2)






  big_TAB = WIDGET_TAB(MAIN_BASE, $
	LOCATION=0,$
	XOFFSET=2*draw_offset_x + draw_x + ctrl_x,$
	YOFFSET=2*draw_offset_y + plot_height,$
	SCR_XSIZE=580,$
	SCR_YSIZE=300)

  tab_1 = WIDGET_BASE(big_tab,$
                      TITLE= "plots and infos",$
                      SCR_XSIZE=580,$
                      SCR_YSIZE=300)

  VIEW_DRAW_Y_REF_L = Widget_Draw(tab_1, UNAME='VIEW_DRAW_Y_REF_L',$
                                  XOFFSET=0,$
                                  YOFFSET=0,$
                                  SCR_XSIZE=plot_height,$
                                  SCR_YSIZE=draw_y,RETAIN=2)

  VIEW_DRAW_SUM_Y_REF_L = Widget_Draw(tab_1, $
                                      UNAME='VIEW_DRAW_SUM_Y_REF_L',$
                                      XOFFSET=140,$
                                      YOFFSET=0,$
                                      SCR_XSIZE=plot_height,$
                                      SCR_YSIZE=draw_y,RETAIN=2)
  
  GENERAL_INFOS_REF_L = widget_text(tab_1, $
	UNAME='GENERAL_INFOS_REF_L',$
	XOFFSET=280,$
	YOFFSET= 0,$
	SCR_XSIZE=300, $
	SCR_YSIZE=280,$
	/WRAP,$
	/SCROLL)


  tab_2 = WIDGET_BASE(big_tab,$
                      TITLE= "Counts vs TOF",$
                      SCR_XSIZE=580,$
                      SCR_YSIZE=300)

  VIEW_DRAW_COUNTS_TOF_REF_L = Widget_Draw(tab_2,$
                                           UNAME='VIEW_DRAW_COUNTS_TOF_REF_L',$
                                           XOFFSET=0,$
                                           YOFFSET=0,$
                                           SCR_XSIZE= 580, SCR_YSIZE= 270, RETAIN=2)
  


  TBIN_UNITS_LABEL = widget_label(MAIN_BASE, UNAME='TBIN_UNITS_LABEL',XOFFSET=draw_offset_x+plot_length+120, $
	YOFFSET=draw_offset_y+10, VALUE="uS")

  TBIN_LABEL = widget_label(MAIN_BASE, $
                            UNAME='TBIN_LABEL',$
                            XOFFSET=draw_offset_x+plot_length+12, $
                            YOFFSET=draw_offset_y+10, $
                            VALUE="End bin")

  TBIN_TXT_REF_L = widget_text(MAIN_BASE, $
                               UNAME='TBIN_TXT_REF_L', $
                               XOFFSET=draw_offset_x+plot_length+58, $
                               YOFFSET=draw_offset_y+5,$
                               SCR_XSIZE=60, $
                               SCR_YSIZE=30, $
                               /editable, VALUE='')

  REFRESH_BUTTON_REF_L = Widget_Button(MAIN_BASE, $
                                       UNAME='REFRESH_BUTTON_REF_L', $
                                       XOFFSET=draw_offset_x+plot_length+12,$
                                       YOFFSET=50,$
                                       VALUE='Refresh Selection',$
                                       SCR_XSIZE=126)

  SAVE_BUTTON_REF_L = Widget_Button(MAIN_BASE, $
                                    UNAME='SAVE_BUTTON_REF_L', $
                                    XOFFSET=draw_offset_x+plot_length+12,$
                                    YOFFSET=80,$
                                    VALUE='Save I vs tof graph',$
                                    SCR_XSIZE=126)

   FRAME1_REF_L = widget_label(MAIN_BASE, $
                               XOFFSET=2*draw_offset_x+plot_length,$
                               YOFFSET=draw_offset_y,$
                               SCR_XSIZE=plot_height-5, $
                               SCR_YSIZE=plot_height-35,$
                               FRAME=3, value="")

   cursor_y_offset = 117
                                ;x position of cursor in Infos mode	
   CURSOR_X_LABEL_REF_L = Widget_label(MAIN_BASE, UNAME='CURSOR_X_LABEL_REF_L',$
                                       XOFFSET=2*draw_offset_x+plot_length+5,$
                                       YOFFSET=cursor_y_offset,$
                                       value="x= ")
   
   CURSOR_X_POSITION_REF_L = Widget_label(MAIN_BASE,UNAME='CURSOR_X_POSITION_REF_L',$
                                          XOFFSET=2*draw_offset_x+plot_length+15,$
                                          YOFFSET=cursor_y_offset-5,$
                                          VALUE="N/A",$
                                          SCR_XSIZE=45,$
                                          SCR_YSIZE=28)
   
                                ;y position of cursor in Infos mode	
   CURSOR_Y_LABEL_REF_L= Widget_label(MAIN_BASE, UNAME='CURSOR_Y_LABEL_REF_L',$
                                      XOFFSET=2*draw_offset_x+plot_length+65,$
                                      YOFFSET=cursor_y_offset,$
                                      value="y= ")
   
   CURSOR_Y_POSITION_REF_L = Widget_label(MAIN_BASE,UNAME='CURSOR_Y_POSITION_REF_L',$
                                          XOFFSET=2*draw_offset_x+plot_length+75,$
                                          YOFFSET=cursor_y_offset-5,$
                                          VALUE="N/A",$
                                          SCR_XSIZE=45,$
                                          SCR_YSIZE=28)
   
   SELECTION_INFOS_REF_L = widget_label(MAIN_BASE,$
                                        UNAME="SELECTION_INFOS_REF_L",$
                                        XOFFSET=430,$
                                        YOFFSET = 2, $
                                        value="Information about selection")  
   
   PIXELID_INFOS_REF_L = widget_text(MAIN_BASE, UNAME='PIXELID_INFOS_REF_L', $
                                     XOFFSET= 420,$
                                     YOFFSET= 10,$
                                     SCR_XSIZE=438, $
                                     SCR_YSIZE=130,$
                                     /SCROLL)
   
                                ;frame3 of x= and y= for infos mode
   FRAME3_REF_L = widget_label(MAIN_BASE, UNAME='FRAME3_REF_L', $
                               XOFFSET=2*draw_offset_x+plot_length,$
                               YOFFSET=110,$
                               SCR_XSIZE=plot_height-5,$
                               SCR_YSIZE=27,FRAME=3, value="")
   
   
   FILE_MENU_REF_L = Widget_Button(WID_BASE_0_MBAR, UNAME='FILE_MENU_REF_L' ,/MENU  $
                                   ,VALUE='File')
   
   OPEN_HISTO_MAPPED_REF_L = Widget_Button(FILE_MENU_REF_L, UNAME='OPEN_HISTO_MAPPED_REF_L'  $
                                           ,VALUE='Open Mapped Histogram')
   
   OPEN_HISTO_UNMAPPED_REF_L = Widget_Button(FILE_MENU_REF_L, UNAME='OPEN_HISTO_UNMAPPED_REF_L'  $
                                             ,VALUE='Open Histogram')
   
   EXIT_MENU_REF_L = Widget_Button(FILE_MENU_REF_L, UNAME='EXIT_MENU_REF_L'  $
                                   ,VALUE='Exit')
   
   UTILS_MENU_REF_L = Widget_Button(WID_BASE_0_MBAR, UNAME='UTILS_MENU_REF_L'  $
                                    ,/MENU ,VALUE='Utils')
   
;  DEFAULT_PATH = Widget_Button(UTILS_MENU, UNAME='DEFAULT_PATH'  $
;     ,VALUE='Path to working directory')
   
   CTOOL_MENU_REF_L = Widget_Button(UTILS_MENU_REF_L, UNAME='CTOOL_MENU_REF_L'  $
                                    ,VALUE='Color Tool')
   
   DEFAULT_PATH = Widget_Button(UTILS_MENU_REF_L, UNAME='DEFAULT_PATH_REF_L'  $
                                ,VALUE='Path to working directory')
   
   MINI_REFLPACK_MENU_REF_L = Widget_Button(WID_BASE_0_MBAR, UNAME='MINI_REFLPAK_MENU_REF_L'  $
                                            ,/MENU ,VALUE='mini ReflPak')
   
   ABOUT_MENU_REF_L = Widget_Button(MINI_REFLPACK_MENU_REF_L, UNAME='ABOUT_MENU_REF_L'  $
                                    ,VALUE='About')
   
   Widget_Control, /REALIZE, MAIN_BASE
   
   Widget_Control, SAVE_BUTTON_REF_L, sensitive=0
   Widget_Control, REFRESH_BUTTON_REF_L, sensitive=0
   
;disabled before the user has been identified
   Widget_Control, CTOOL_MENU_REF_L, sensitive=0
   Widget_Control, OPEN_HISTO_MAPPED_REF_L, sensitive=0
   Widget_Control, OPEN_HISTO_UNMAPPED_REF_L, sensitive=0
   
   XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
   
end

;
; Empty stub procedure used for autoloading.
;
pro extract_data, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
PORTAL_BASE, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra
end
