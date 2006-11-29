pro MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

case Event.id of
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_HISTO_EVENT_FILE_BUTTON_tab1'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          OPEN_HISTO_EVENT_FILE_CB, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='NUMBER_PIXEL_IDS_TEXT_tab1'): begin
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
    
;    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_MAPPING_FILE_BUTTON'): begin
;      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
;        OPEN_MAPPING_FILE_BUTTON_CB, Event
;	end
    
    Widget_Info(wWidget, FIND_BY_UNAME='DEFAULT_PATH_BUTTON'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
          DEFAULT_PATH_BUTTON_CB, Event
	end
        
        Widget_Info(wWidget, FIND_BY_UNAME='CREATE_NEXUS'): begin
            if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
              CREATE_NEXUS_CB, Event
        end
        
        Widget_Info(wWidget, FIND_BY_UNAME='DISPLAY_BUTTON'): begin
            if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
              DISPLAY_BUTTON, Event
        end
        
        Widget_Info(wWidget, FIND_BY_UNAME='COMPLETE_RUNINFO_FILE'): begin
            if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
              COMPLETE_RUNINFO_FILE_event, Event
        end
        
        Widget_Info(wWidget, FIND_BY_UNAME='COMPLETE_CVINFO_FILE'): begin
            if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
              COMPLETE_CVINFO_FILE_event, Event
        end
        
        Widget_Info(wWidget, FIND_BY_UNAME='CLOSE_COMPLETE_XML_DISPLAY_TEXT'): begin
            if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
              CLOSE_COMPLETE_XML_DISPLAY_TEXT_event, Event
        end
        
                                ;portal_go
        
        Widget_Info(wWidget, FIND_BY_UNAME='USER_TEXT'): begin
            USER_TEXT_CB, Event
        end
        
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

Resolve_Routine, 'make_nexus_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

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
	VALUE='j35',/EDITABLE,/ALL_EVENTS)	;REMOVE j35 (ONLY FOR SPEEDING things UP)
	

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
	XOFFSET=3, YOFFSET=245, $
	SCR_XSIZE=260, SCR_YSIZE=30,$
	UNAME="PORTAL_GO",$
	VALUE="E N T E R",$
	tooltip="Press to enter main program")

  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

pro wTLB, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument, user

Resolve_Routine, 'make_nexus_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

;define initial global values - these could be input via external file or other means

instrument_list = ['REF_L', 'REF_M', 'BSS']

global = ptr_new({$
                   tmp_nxdir_folder : 'makeNeXus_tmp',$
                   full_tmp_nxdir_folder_path : '',$
                   already_archived	: 0,$
                   file_to_plot : '',$
                   full_path_instr_run_number : '',$
                   file_type_is_event	: 1,$
                   do_u_want_to_archive_it : 0,$
                   path			: '~/CD4/REF_M/REF_M_7/',$ 
                   path_to_DAS_proposal_number : '',$
                   output_path		: '/SNSlocal/users/',$
                   full_path_to_prenexus: '',$
                   full_path_to_nexus : '',$
                   output_path_for_this_file: '',$
                   instrument		: instrument_list[instrument],$
                   user			: user,$
                   filter_histo_event	: '*neutron*.dat',$
                   histo_event_filename  	: '',$
                   histo_event_filename_only	: '',$
                   histo_file_name_only: '',$
                   full_histo_mapped_file_name : '',$
                   histo_filename		: '',$
                   histo_mapped_filename	: '',$
                   histo_mapped_file_name_only : '',$
                   file_to_plot_top     : '',$
                   file_to_plot_bottom  : '',$

                   mapping_filename_REF_M       : '/SNS/REF_M/2006_1_4A_CAL/calibrations/REF_M_TS_2006_08_04.dat',$
                   translation_filename_REF_M	: '/SNS/REF_M/2006_1_4A_CAL/calibrations/REF_M_2006_08_25.nxt',$
                   geometry_filename_REF_M		: '/SNS/REF_M/2006_1_4A_CAL/calibrations/REF_M_geom_2006_09_18.nxs',$
                   mapping_filename_REF_L		: '/SNS/REF_L/2006_1_4B_CAL/calibrations/REF_L_TS_2006_08_10.dat',$
                   translation_filename_REF_L	: '/SNS/REF_L/2006_1_4B_CAL/calibrations/REF_L_2006_08_25.nxt',$
                   geometry_filename_REF_L		: '/SNS/REF_L/2006_1_4B_CAL/calibrations/REF_L_geom_2006_09_18.nxs',$
                   mapping_filename_BSS		: '/SNS/BSS/2006_1_2_CAL/calibrations/BSS_TS_2006_06_09.dat',$
                   translation_filename_BSS	: '/SNS/BSS/2006_1_2_CAL/calibrations/BSS_2006_08_25.nxt',$
                   geometry_filename_BSS		: '/SNS/BSS/2006_1_2_CAL/calibrations/BSS_geom_2006_09_26.nxs',$
                   translation_file : '',$
                   geometry_file : '',$
                   mapping_file : '',$
                   nexus_filename		: '',$
                   cvinfo_xml_filename	: '',$
                   runinfo_xml_filename	: '',$
                   new_translation_filename: '',$
                   das_mount_point		: '',$
                   proposal_number		: '',$
                   proposal_number_BSS	: '2006_1_2_SCI/',$
                   proposal_number_REF_L	: '2006_1_4B_SCI/',$
                   proposal_number_REF_M	: '2006_1_4A_SCI/',$
                   instrument_run_number	: '',$
                   run_number		: '',$
                   lin_log			: 0L,$
                   number_pixels		: 0L,$
                   rebinning		: 0L,$
                   min_time_bin		: 0L,$
                   max_time_bin		: 0L,$
                   number_tbin		: 0L,$
                   filter_mapping		: 'REF_M_TS_*.dat',$
                   path_mapping		: '/SNS/REF_M/2006_1_4A_CAL/calibrations/', $
                   xsize			: 850L,$	
                   ysize			: 310,$	
                   xsize_dislay_REF_L	: 850 + 265,$
                   xsize_display_REF_M	: 850 + 314,$
                   xsize_display_BSS	: 850 + 300,$   			
                   xsize_display		: 0L,$
                   ysize_display		: 700L,$
                   NX_REF_L		: 304L,$
                   NY_REF_L		: 256L,$
                   Nimg_REF_L		: 77824L,$
                   NX_REF_M		: 256L,$
                   NY_REF_M		: 304L,$
                   Nimg_REF_M		: 77824L,$
                   Nimg_BSS		: 9216L,$
                   pixel_number		: '',$
                   NX_BSS			: 190L,$
                   NY_BSS			: 130L,$
                   Ntof			: 0L,$
                   img_ptr 		: ptr_new(0L),$
                   data_assoc		: ptr_new(0L),$
                   display_button_activate : 0$
	})

case instrument OF
   0: begin 
	mapping_file = (*global).mapping_filename_REF_L
	translation_file = (*global).translation_filename_REF_L
	geometry_file = (*global).geometry_filename_REF_L
      end
   1: begin 
	mapping_file = (*global).mapping_filename_REF_M
	translation_file = (*global).translation_filename_REF_M
	geometry_file = (*global).geometry_filename_REF_M
      end
   2: begin 
	mapping_file = (*global).mapping_filename_BSS
	translation_file = (*global).translation_filename_BSS
	geometry_file = (*global).geometry_filename_BSS
      end
endcase


(*global).mapping_file = mapping_file
(*global).geometry_file = geometry_file
(*global).translation_file = translation_file

(*global).output_path = (*global).output_path + user + "/"
output_path = (*global).output_path 

  ; Create the top-level base and the tab.
  title = "Histogramming - Mapping - Translation  (" + (*global).instrument + ")"
  MAIN_BASE = WIDGET_BASE(GROUP_LEADER=wGroup, $
	UNAME='MAIN_BASE', $
	XOFFSET=150, YOFFSET=350, $
	SCR_XSIZE=(*global).xsize, $
	SCR_YSIZE=(*global).ysize, $
	title=title)

  wTab = WIDGET_TAB(MAIN_BASE, LOCATION=location)
 
  ; Create the first tab base, containing a label and two
  ; button groups.
  wT1 = WIDGET_BASE(wTab, TITLE='Input file',$
	UNAME="wT1",$
	SCR_XSIZE=550, SCR_YSIZE=250)

  HISTO_EVENT_FILE_RUN_NUMBER = widget_label(wT1,$
                                             UNAME='HISTO_EVENT_FILE_RUN_NUMBER',$
                                             XOFFSET=5,$
                                             YOFFSET=5,$
                                             SCR_XSIZE=35,$
                                             SCR_YSIZE=30,$
                                             VALUE='Run #',$
                                             /align_left)

  HISTO_EVENT_FILE_TEXT_BOX = widget_text(wT1,$
                                          UNAME='HISTO_EVENT_FILE_TEXT_BOX',$
                                          XOFFSET=40,$
                                          YOFFSET=5,$
                                          SCR_XSIZE=50,$
                                          SCR_YSIZE=30,$
                                          VALUE='1728',$     ;REMOVE_ME, just for debugging
                                          /align_left,$
                                          /editable)

  OPEN_HISTO_EVENT_FILE_BUTTON_tab1 = WIDGET_BUTTON(wT1, $
                                                    UNAME="OPEN_HISTO_EVENT_FILE_BUTTON_tab1",$
                                                    XOFFSET= 90,$
                                                    YOFFSET = 5,$
                                                    SCR_XSIZE=60,$ 
                                                    SCR_YSIZE=30, $
                                                    VALUE= "O P E N",$
                                                    tooltip="NeXus file to load")
        
  HISTO_EVENT_FILE_TYPE = widget_label(wt1,$
	UNAME='HISTO_EVENT_FILE_TYPE',$
	XOFFSET=220,$
	YOFFSET=5,$
	SCR_XSIZE=80,$
	SCR_YSIZE=30,$
	VALUE='File type: ')

  ;where to put the file type (histogram or event)
  HISTO_EVENT_FILE_TYPE_RESULT = widget_label(wt1,$
	UNAME='HISTO_EVENT_FILE_TYPE_RESULT',$
	XOFFSET=300,$
	YOFFSET=5,$
	SCR_XSIZE=100,$
	SCR_YSIZE=25,$
	VALUE='',$
	FRAME=1)


  DISPLAY_BUTTON = WIDGET_BUTTON(wt1,$
	UNAME="DISPLAY_BUTTON",$
	XOFFSET=418,$
	YOFFSET=5,$
	SCR_XSIZE=120,$
	SCR_YSIZE=30,$
	VALUE="Activate preview",$
;	/tracking_events,$
;	/pushbutton_events,$
	sensitive=0,$
	tooltip="Preview of the data")

  DISPLAY_WINDOW_1_BASE = widget_base(MAIN_BASE,$	;draw windows for BSS
	UNAME="DISPLAY_WINDOW_1_BASE",$
	XOFFSET=850,$
	YOFFSET=10,$
	SCR_XSIZE=290,$
	SCR_YSIZE=290)

  DISPLAY_WINDOW_0 = widget_draw(DISPLAY_WINDOW_1_BASE,$
	UNAME = "DISPLAY_WINDOW_0",$
	XOFFSET=0,$
	YOFFSET=0,$
	SCR_XSIZE=290,$	
	SCR_YSIZE=140)
  
  DISPLAY_WINDOW_1 = widget_draw(DISPLAY_WINDOW_1_BASE,$
	UNAME = "DISPLAY_WINDOW_1",$
	XOFFSET=0,$
	YOFFSET=145,$
	SCR_XSIZE=290,$	
	SCR_YSIZE=140)

  DISPLAY_WINDOW_BASE = widget_base(MAIN_BASE,$		;draw windows for REF
	UNAME="DISPLAY_WINDOW_BASE",$
	XOFFSET=850,$
	YOFFSET=20,$
	SCR_XSIZE=356,$
	SCR_YSIZE=280,$
	map=0)

  DISPLAY_WINDOW = widget_draw(DISPLAY_WINDOW_BASE,$
	UNAME = "DISPLAY_WINDOW",$
	XOFFSET=0,$
	YOFFSET=0,$
	SCR_XSIZE=356,$		
	SCR_YSIZE=280)		





  ;****************LEFT FRAME (info about histo file)

  HISTO_INFO_BASE = WIDGET_BASE(wT1,$
	UNAME='HISTO_INFO_BASE',$
	XOFFSET=5, YOFFSET=37,$
	SCR_XSIZE=205, SCR_YSIZE=208,$
	map=0)
  	
  xoffset = 35
  yoffset = 35
  HISTO_INFO_NUMBER_PIXELIDS = widget_label(HISTO_INFO_BASE,$
	XOFFSET = xoffset,$
	YOFFSET = yoffset,$
	SCR_XSIZE = 60,$	
	SCR_YSIZE = 30,$
	VALUE = "Pixel IDs: ",$
	/align_left)

  HISTO_INFO_NUMBER_PIXELIDS_TEXT = widget_label(HISTO_INFO_BASE,$
	UNAME = "HISTO_INFO_NUMBER_PIXELIDS_TEXT",$
	XOFFSET = xoffset + 70,$
	YOFFSET = yoffset,$
	SCR_XSIZE = 60,$
	SCR_YSIZE = 30,$
	value="",$
	frame=1,$
	/align_left)

  yoffset += 40
  HISTO_INFO_NUMBER_BINS = widget_label(HISTO_INFO_BASE,$
	XOFFSET = xoffset,$
	YOFFSET = yoffset,$
	SCR_XSIZE = 60,$	
	SCR_YSIZE = 30,$
	VALUE = "Bins nbr: ",$
	/align_left)

  HISTO_INFO_NUMBER_BINS_TEXT = widget_label(HISTO_INFO_BASE,$
	UNAME = "HISTO_INFO_NUMBER_BINS_TEXT",$
	XOFFSET = xoffset + 70,$
	YOFFSET = yoffset,$
	SCR_XSIZE = 60,$
	SCR_YSIZE = 30,$
	frame=1,$
	/align_left)

  HISTO_INFO_LABLE = WIDGET_LABEL(HISTO_INFO_BASE,$
	XOFFSET= 13,$
	YOFFSET= 0,$
	SCR_XSIZE=130,$
	SCR_YSIZE=30,$
	VALUE = " Histogram file infos")

  HISTO_INFO_FRAME = WIDGET_LABEL(HISTO_INFO_BASE,$
	XOFFSET=10, YOFFSET=15,$
	SCR_XSIZE=180, SCR_YSIZE=170,$
	FRAME=2, value ='')






  ;****************LEFT FRAME (to histo a event file)

  HIDE_HISTO_BASE = WIDGET_BASE(wT1,$
                                UNAME='HIDE_HISTO_BASE',$
                                XOFFSET=5,$
                                YOFFSET=37,$
                                SCR_XSIZE=205,$
                                SCR_YSIZE=208)
  
  y_offset=57
  HIDE_HISTO_FRAME = WIDGET_LABEL(HIDE_HISTO_BASE,$
                                  UNAME='HIDE_HISTO_FRAME',$
                                  XOFFSET=5,$
                                  YOFFSET=y_offset,$
                                  SCR_XSIZE=205,$
                                  SCR_YSIZE=175,$
                                  VALUE="")
  
  NUMBER_PIXELIDS_LABEL_tab1 = WIDGET_LABEL(wT1,$
                                            UNAME="NUMBER_PIXELIDS_LABEL_tab1",$
                                            XOFFSET=8,$
                                            YOFFSET=y_offset+3,$
                                            SCR_XSIZE=130,$
                                            SCR_YSIZE=30,$
                                            VALUE='Number of pixel IDs')
  
  NUMBER_PIXELIDS_TEXT_tab1 = WIDGET_TEXT(wT1,$
                                          UNAME="NUMBER_PIXELIDS_TEXT_tab1",$
                                          XOFFSET=140,$
                                          YOFFSET=y_offset+3,$
                                          SCR_XSIZE=65,$
                                          SCR_YSIZE=30,$
                                          VALUE='',$
                                          /editable,$
                                          /ALL_EVENTS)
  
  REBINNING_TYPE_GROUP_wT1 = CW_BGROUP(wT1, ['linear', 'logarithmic'], $
                                       /ROW, /EXCLUSIVE, /RETURN_NAME,$
                                       XOFFSET=20,$
                                       YOFFSET=33+y_offset,$
                                       SET_VALUE=0.0,$
                                       UNAME='REBINNING_TYPE_GROUP')
  
  left_offset=8
  top_offset=70+y_offset-7
  REBINNING_LABEL_wT1 = WIDGET_LABEL(wT1, $
                                     UNAME="REBINNING_LABEL_wT1",$
                                     XOFFSET=left_offset,$
                                     YOFFSET=top_offset,$
                                     SCR_XSIZE=130, SCR_YSIZE=30,$
                                     VALUE='Rebin value (microS)')
  
  REBINNING_TEXT_wT1 = WIDGET_TEXT(wT1,$
                                   UNAME="REBINNING_TEXT_wT1",$
                                   XOFFSET=left_offset+132,$
                                   YOFFSET=top_offset+2,$
                                   SCR_XSIZE=65,$
                                   SCR_YSIZE=30,$
                                   VALUE='200',$
                                   /editable,$ ;change that to the default instrument one when openning a file
                                   /ALL_EVENTS)
  
  MIN_TIME_BIN_LABEL_wT1 = WIDGET_LABEL(wT1, $
                                        UNAME="MIN_TIME_BIN_LABEL_wT1",$
                                        XOFFSET=left_offset+2,$
                                        YOFFSET=top_offset+37,$
                                        SCR_XSIZE=120,$
                                        SCR_YSIZE=30,$
                                        VALUE='Min Tstamp (microS)')
  
  MIN_TIME_BIN_TEXT_wT1 = WIDGET_TEXT(wT1,$
                                      UNAME='MIN_TIME_BIN_TEXT_wT1',$
                                      XOFFSET=left_offset+132,$
                                      YOFFSET=top_offset+35,$
                                      SCR_XSIZE=65,$
                                      SCR_YSIZE=30,$
                                      VALUE='',$
                                      /editable,$
                                      /ALL_EVENTS)
  
  MAX_TIME_BIN_LABEL_wT1 = WIDGET_LABEL(wT1, $
                                        UNAME="MAX_TIME_BIN_LABEL_wT1",$
                                        XOFFSET=left_offset+2,$
                                        YOFFSET=top_offset+70,$
                                        SCR_XSIZE=120,$
                                        SCR_YSIZE=30,$
                                        VALUE='Max Tstamp (microS)')
  
  MAX_TIME_BIN_TEXT_wT1 = WIDGET_TEXT(wT1,$
                                      UNAME='MAX_TIME_BIN_TEXT_wT1',$
                                      XOFFSET=left_offset+132,$
                                      YOFFSET=top_offset+70,$
                                      SCR_XSIZE=65,$
                                      SCR_YSIZE=30,$
                                      VALUE='',$
                                      /editable,$
                                      /ALL_EVENTS)
  
  LEFT_FRAME_wT1 = WIDGET_LABEL(wT1,$
                                XOFFSET=5,$
                                YOFFSET=y_offset,$
                                SCR_XSIZE=200,$
                                SCR_YSIZE=170,$
                                FRAME=2,$
                                value ='')
  
                                ;general info that is outside the tabs
  HISTOGRAM_STATUS_wT1 = WIDGET_TEXT(Main_base,$
                                     XOFFSET=565,$
                                     YOFFSET=25,$
                                     SCR_XSIZE=275,$
                                     SCR_YSIZE=280,$
                                     /scroll,$
                                     /wrap,$
                                     UNAME='HISTOGRAM_STATUS')
  
  HISTOGRAM_STATUS_wT1_label= widget_label(Main_base,$
                                           XOFFSET=565,$
                                           YOFFSET=02,$
                                           SCR_XSIZE=90,$
                                           SCR_YSIZE=30,$
                                           VALUE="General infos:")
  
  ;file info that is part of the first tab
 FILE_INFO_BASE = widget_base(wT1,$
	XOFFSET=215, YOFFSET=35,$
	SCR_XSIZE=325, SCR_YSIZE=215)

 FILE_INFO_wT1_label = widget_label(file_info_base,$
	XOFFSET=2, YOFFSET=0,$
	SCR_XSIZE=72, SCR_YSIZE=26,$
	VALUE="File infos")

 x_offset = 4
 y_offset = 26
 delta_y = 35
 XML_FILE_LABEL = widget_label(file_info_base,$
	XOFFSET=x_offset, YOFFSET=y_offset,$
	SCR_XSIZE=70, SCR_YSIZE=25,$
	VALUE = "XML FILE: ",/align_left)
 XML_FILE_TEXT = widget_label(file_info_base,$
	UNAME="XML_FILE_TEXT",$
	XOFFSET=x_offset + 70, YOFFSET=y_offset,$
	SCR_XSIZE=240, SCR_YSIZE=25,$
	frame=1,$
	/align_left,$
	VALUE = "")

 y_offset += delta_y
 TITLE_LABEL = widget_label(file_info_base,$
	XOFFSET=x_offset,$
	YOFFSET=y_offset,$
	SCR_XSIZE=50,$
	SCR_YSIZE=25,$
	VALUE = "Title: ",$
	/align_left)
 TITLE_TEXT = widget_label(file_info_base,$
	UNAME="TITLE_TEXT",$
	XOFFSET=x_offset + 50,$
	YOFFSET=y_offset,$
	SCR_XSIZE=260,$
	SCR_YSIZE=25,$
	VALUE = "",$
	frame=1,$
	/align_left)

 y_offset += delta_y
 NOTES_LABEL = widget_label(file_info_base,$
	XOFFSET=x_offset, YOFFSET=y_offset,$
	SCR_XSIZE=50, SCR_YSIZE=25,$
	VALUE = "Notes: ",/align_left)
 NOTES_TEXT = widget_label(file_info_base,$
	UNAME="NOTES_TEXT",$
	XOFFSET=x_offset + 50,$
	YOFFSET=y_offset,$
	SCR_XSIZE=260, SCR_YSIZE=25,$
	frame=1,$
	/align_left,$
	VALUE = "")

 y_offset += delta_y
 SPECIAL_DESIGNATION_LABEL = widget_label(file_info_base,$
	XOFFSET=x_offset,$
	YOFFSET=y_offset,$
	SCR_XSIZE=85,$
	SCR_YSIZE=25,$
	VALUE = "Special notes: ",/align_left)
 NOTES_TEXT = widget_label(file_info_base,$
	UNAME="SPECIAL_DESIGNATION",$
	XOFFSET=x_offset + 90,$
	YOFFSET=y_offset,$
	SCR_XSIZE=220,$
	SCR_YSIZE=25,$
	frame=1,$
	/align_left,$
	VALUE = "")

 y_offset += delta_y
 SCRIPT_ID_LABEL = widget_label(file_info_base,$
	XOFFSET=x_offset, YOFFSET=y_offset,$
	SCR_XSIZE=70, SCR_YSIZE=25,$
	VALUE = "Script ID: ",/align_left)
 SCRIPT_ID_TEXT = widget_label(file_info_base,$
	UNAME="SCRIPT_ID_TEXT",$
	XOFFSET=x_offset + 70,$
	YOFFSET=y_offset,$
	SCR_XSIZE=140,$ 
	SCR_YSIZE=25,$
	frame=1,$
	/align_left,$
	VALUE = "")

 complete_infofile_offset_x = 220
 complete_infofile_offset_y = y_offset-2
 COMPLETE_RUNINFO_FILE = widget_button(file_info_base,$
	UNAME="COMPLETE_RUNINFO_FILE",$
	XOFFSET=complete_infofile_offset_x,$
	YOFFSET=complete_infofile_offset_y,$
	SCR_XSIZE=100,$
	SCR_YSIZE=20,$
	VALUE="runinfo.xml",$
	/tracking_events,$
	/pushbutton_events,$
	tooltip="Display full runinfo.xml file")
 
 complete_infofile_offset_y += 22
 COMPLETE_CVINFO_FILE = widget_button(file_info_base,$
	UNAME="COMPLETE_CVINFO_FILE",$
	XOFFSET=complete_infofile_offset_x,$
	YOFFSET=complete_infofile_offset_y,$
	SCR_XSIZE=100,$
	SCR_YSIZE=20,$
	VALUE="cvinfo.xml",$
	/tracking_events,$
	tooltip="Display full cvinfo.xml file")

  FILE_INFO_wT1 = WIDGET_label(file_info_base,$
	XOFFSET=0, YOFFSET=15,$	
	SCR_XSIZE=325, SCR_YSIZE=190,$
	VALUE="", $
	UNAME="FILE_INFO_wT1",$
	frame=2)

  COMPLETE_XML_DISPLAY_TEXT = widget_text(MAIN_BASE,$
	UNAME="COMPLETE_XML_DISPLAY_TEXT",$
	XOFFSET=5,$
	YOFFSET=320,$
	SCR_XSIZE=835,$
	SCR_YSIZE=340,$
	/wrap,$
	/scroll)

  CLOSE_COMPLETE_XML_DISPLAY_TEXT = widget_button(MAIN_BASE,$
	UNAME="CLOSE_COMPLETE_XML_DISPLAY_TEXT",$
	XOFFSET=300,$
	YOFFSET=660,$
	SCR_XSIZE=150,$
	SCR_YSIZE=30,$
	VALUE = "CLOSE XML WINDOW",$
	/tracking_events,$
	tooltip="Remove xml extension window")


  
;  wT4 = WIDGET_BASE(wTab, TITLE='Display')
;
;  PLOT_DATA = widget_draw(wT4,$
;	UNAME = 'PLOT_DATA',$
;	XOFFSET=5, YOFFSET=5,$
;	SCR_XSIZE=485,$
;	SCR_YSIZE=235,$
;	RETAIN=2)	

  wT2 = WIDGET_BASE(wTab, TITLE='Settings')

  OPEN_MAPPING_FILE_BUTTON_tab2 = WIDGET_label(wT2, $
	XOFFSET= 5, YOFFSET = 5, $
	SCR_XSIZE=130, SCR_YSIZE=30, $
	VALUE= "Mapping file",$
	UNAME='OPEN_MAPPING_FILE_BUTTON')

  MAPPING_FILE_LABEL_tab2 = WIDGET_label(wT2,$
	UNAME='MAPPING_FILE_LABEL',$
	XOFFSET=135, YOFFSET=5,$
	SCR_XSIZE=408, SCR_YSIZE=32, $
	value = mapping_file,$
	frame=1,$
	/align_left)

  DEFAULT_TRANSLATION_BUTTON_tab2 = WIDGET_label(wT2, $
	XOFFSET= 5, YOFFSET = 45, $
	SCR_XSIZE=130, SCR_YSIZE=30, $
	VALUE= "Translation file",$
	UNAME='DEFAULT_TRANSLATION_BUTTON')

  DEFAULT_TRANSLATION_FILE_tab2 = WIDGET_label(wT2,$
	UNAME='DEFAULT_TRANSLATION_FILE',$
	XOFFSET=135, YOFFSET=45,$
	SCR_XSIZE=408, SCR_YSIZE=32, $
	value = translation_file,$
	frame=1,$
	/align_left)

  DEFAULT_GEOMETRY_BUTTON_tab2 = WIDGET_label(wT2, $
	XOFFSET= 5, YOFFSET = 85, $
	SCR_XSIZE=130, SCR_YSIZE=30, $
	VALUE= "Geometry file",$
	UNAME='DEFAULT_GEOMETRY_BUTTON')

  DEFAULT_GEOMETRY_FILE_tab2 = WIDGET_label(wT2,$
	UNAME='DEFAULT_GEOMETRY_FILE',$
	XOFFSET=135, YOFFSET=85,$
	SCR_XSIZE=408, SCR_YSIZE=32, $
	value = geometry_file,$
	frame=1,$
	/align_left)

  DEFAULT_PATH_BUTTON_tab2 = WIDGET_BUTTON(wT2, $
	XOFFSET= 5, YOFFSET = 125, $
	SCR_XSIZE=130, SCR_YSIZE=30, $
	VALUE= "Output path",$
	UNAME='DEFAULT_PATH_BUTTON')

  DEFAULT_FINAL_PATH_tab2 = WIDGET_TEXT(wT2,$
	UNAME='DEFAULT_FINAL_PATH_tab2',$
	XOFFSET=135, YOFFSET=125,$
	SCR_XSIZE=408, SCR_YSIZE=32, $
	value = output_path,$
	/editable)

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
  CREATE_NEXUS = WIDGET_BUTTON(wControl, VALUE='Create local NeXus file',$
	UNAME = "CREATE_NEXUS",$
	XOFFSET=5,$
	YOFFSET=277,$
	SCR_XSIZE=200,$
	SCR_YSIZE=30,$
	tooltip="Create NeXus")

  exist_frame = WIDGET_BASE(MAIN_BASE, $
	UNAME="exist_FRAME",$
	XOFFSET=215,$
	YOFFSET=277,$
	SCR_XSIZE=290,$
	SCR_YSIZE=35)

  exist_label = WIDGET_LABEL(exist_frame,$
	UNAME="exist_LABEL",$
	XOFFSET=30,$
	YOFFSET=3,$
	SCR_XSIZE=380,$
	SCR_YSIZE=65,$
	frame=0,value="")

  exist_or_not_base = WIDGET_BASE(MAIN_BASE,$
                                  XOFFSET=240,$
                                  YOFFSET=277,$
                                  SCR_XSIZE=240,$
                                  SCR_YSIZE=30,$
                                  UNAME="exist_or_not_base")

  exist_or_not_label = WIDGET_LABEL(exist_or_not_base,$
                                    XOFFSET=60, YOFFSET=0,$
                                    SCR_XSIZE=160, SCR_YSIZE=30,$
                                    VALUE="NEXUS FILE DOES NOT EXIST",$
                                    FRAME=2)

;   Realize the widgets, set the user value of the top-level
;  base, and call XMANAGER to manage everything.
  WIDGET_CONTROL, MAIN_BASE, /REALIZE
  WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global ;we've used global, not stash as the structure name
  Widget_Control, CREATE_NEXUS, sensitive=0
  Widget_control, DISPLAY_WINDOW_1_BASE, map=0
  XMANAGER, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
    
  if ((*global).runinfo_xml_filename EQ '') then begin
     widget_control, COMPLETE_RUNINFO_FILE, sensitive=0
  endif

  if ((*global).cvinfo_xml_filename EQ '') then begin
     widget_control, COMPLETE_CVINFO_FILE, sensitive=0
  endif
  


end

;
; Empty stub procedure used for autoloading.
;
pro make_nexus, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
   PORTAL_BASE, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra
end
