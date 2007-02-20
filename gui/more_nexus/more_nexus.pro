pro MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

case Event.id of
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end

    Widget_Info(wWidget, FIND_BY_UNAME='activate_preview_button'): begin
        activate_preview_button_cb, Event
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
            ucams = get_ucams()

            if (check_access(Event, instrument, ucams) NE -1) then begin
                id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
                WIDGET_CONTROL, id, /destroy
                wTLB, GROUP_LEASER=wGroup, _EXTRA=_VWBExtra_, instrument, ucams
            endif else begin
                image_logo="/SNS/users/j35/SVN/HistoTool/trunk/gui/MakeNeXus/access_denied.bmp"
                id = widget_info(wWidget,find_by_uname="logo_message_draw")
                WIDGET_CONTROL, id, GET_VALUE=id_value
                wset, id_value
                image = read_bmp(image_logo)
                tv, image,0,0,/true
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

Resolve_Routine, 'more_nexus_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

MAIN_BASE = Widget_Base(GROUP_LEADER=wGroup,$
                        UNAME='MAIN_BASE',$
                        SCR_XSIZE=265,$
                        SCR_YSIZE=270,$
                        XOFFSET=450,$
                        YOFFSET=50,$
                        NOTIFY_REALIZE='MAIN_REALIZE',$
                        TITLE='More NeXus',$
                        SPACE=3,$
                        XPAD=3,$
                        YPAD=3,$
                        MBAR=WID_BASE_0_MBAR)

;attach global data structure with widget ID of widget main base widget ID
widget_control,MAIN_BASE,set_uvalue=global

PORTAL_BASE= widget_base(MAIN_BASE,$
                         UNAME='PORTAL_BASE',$
                         SCR_XSIZE=240,$
                         SCR_YSIZE=110,$
                         FRAME=10,$
                         SPACE=4,$
                         XPAD=3,$
                         YPAD=3,$
                         column=1)

PORTAL_LABEL = widget_label(PORTAL_BASE,$
                            XOFFSET=40,$
                            YOFFSET=3,$
                            VALUE="SELECT YOUR INSTRUMENT")

instrument_list = ['Liquids Reflectometer',$
                   'Magnetism Reflectometer',$
                   'Backscattering Spectrometer']
INSTRUMENT_TYPE_GROUP = CW_BGROUP(PORTAL_BASE,$ 
                                  instrument_list,$
                                  /exclusive,$
                                  /RETURN_NAME,$
                                  XOFFSET=30,$
                                  YOFFSET=25,$
                                  SET_VALUE=0.0,$
                                  UNAME='INSTRUMENT_TYPE_GROUP')

LOGO_MESSAGE_BASE = widget_base(MAIN_BASE,$
                                UNAME="logo_message_base",$
                                SCR_XSIZE=265,$
                                SCR_YSIZE=70,$
                                XOFFSET=0,$
                                YOFFSET=140,$
                                FRAME=10,$
                                SPACE=4,$
                                XPAD=3,$
                                YPAD=3)

logo_message_draw = widget_draw(logo_message_base,$
                                uname='logo_message_draw',$
                                xoffset=5,$
                                yoffset=5,$
                                scr_xsize=235,$
                                scr_ysize=60,$
                                uvalue=0)

PORTAL_GO = widget_button(MAIN_BASE,$
                          XOFFSET=3,$
                          YOFFSET=235,$
                          SCR_XSIZE=260,$
                          SCR_YSIZE=30,$
                          UNAME="PORTAL_GO",$
                          VALUE="E N T E R",$
                          tooltip="Press to enter main program",$
                          font='rk24')

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

















pro wTLB, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument, user

Resolve_Routine, 'more_nexus_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

;define initial global values - these could be input via external file or other means

instrument_list = ['REF_L', 'REF_M', 'BSS']

global = ptr_new({$
                   activate_preview : 0,$

                   default_log_rebin_coeff : 0.5,$
                   default_rebin_coeff     : 200,$
                   DAS_has_experiment_number : 0,$    ;put 1 when DAS will had experiment number
                   DAS_mouting_point : '-DAS-FS/',$
                   translate_use_experiment_number : 0,$
                   tmp_nxdir_folder : '.makeNeXus_tmp',$
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
                   full_local_folder_name : '',$
                   output_path_for_this_file: '',$
                   instrument		: instrument_list[instrument],$
                   is_file_histo        : 0,$
                   user			: user,$
                   filter_histo_event	: '*neutron*.dat',$
                   find_prenexus_on_das : 0,$
                   full_local_folder_name_preNeXus : '',$
                   full_local_folder_name_NeXus : '',$
                   histo_event_filename  	: '',$
                   histo_event_filename_only	: '',$
                   histo_file_name_only: '',$
                   full_histo_mapped_file_name : '',$
                   histo_filename		: '',$
                   histo_mapped_filename	: '',$
                   histo_mapped_file_name_only : '',$
                   file_to_plot_top     : '',$
                   file_to_plot_bottom  : '',$
                   nexus_filename		: '',$
                   cvinfo_xml_filename	: '',$
                   runinfo_xml_filename	: '',$
                   new_translation_filename: '',$
                   das_mount_point		: '',$
                   experiment_number : '',$
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

(*global).output_path = (*global).output_path + user + "/"
output_path = (*global).output_path 
instrument = (*global).instrument

; Create the top-level base and the tab.
title = " Output histo/event data - Check NeXus (" + (*global).instrument + ")"
MAIN_BASE = WIDGET_BASE(GROUP_LEADER=wGroup, $
                        UNAME='MAIN_BASE', $
                     ;   NOTIFY_REALIZE='MAIN_REALIZE_2',$
                        XOFFSET=150,$
                        YOFFSET=350, $
                        SCR_XSIZE=900, $
                        SCR_YSIZE=450, $
                        title=title)

; if (user EQ 'j35') then begin
;     map_hide_log_book_tab = 0
; endif else begin
;     map_hide_log_book_tab = 1
; endelse

; hide_log_book_tab_blocker = widget_base(MAIN_BASE,$
;                                         xoffset=130,$
;                                         yoffset=0,$
;                                         scr_xsize=60,$
;                                         scr_ysize=20,$
;                                         frame=0,$
;                                         map=map_hide_log_book_tab)

wTab = WIDGET_TAB(MAIN_BASE, LOCATION=location)



;--------------------------------------------------------------------------------
; First tab (NEXUS interface)
wT1 = WIDGET_BASE(wTab,$
                  TITLE='NeXus',$
                  UNAME='wT1',$
                  SCR_XSIZE=850,$
                  SCR_YSIZE=440)

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
                                        VALUE='',$   
                                        /align_left,$
                                        /editable)

OPEN_HISTO_EVENT_FILE_BUTTON_tab1 = WIDGET_BUTTON(wT1,$
                                                  UNAME="OPEN_HISTO_EVENT_FILE_BUTTON_tab1",$
                                                  XOFFSET= 90,$
                                                  YOFFSET = 5,$
                                                  SCR_XSIZE=60,$ 
                                                  SCR_YSIZE=30, $
                                                  VALUE= "O P E N",$
                                                  tooltip="NeXus file to load")


activate_preview_button = widget_button(wT1,$
                                        uname='activate_preview_button',$
                                        xoffset=158,$
                                        yoffset=5,$
                                        scr_xsize=140,$
                                        scr_ysize=30,$
                                        value='ACTIVATE PREVIEW',$
                                        tooltip='Activate or not preview')



;drawing
case instrument of

    'REF_L': begin
        drawing = widget_draw(wT1,$
                              UNAME = 'drawing',$
                              XOFFSET=25,$
                              YOFFSET=40,$
                              SCR_XSIZE=256,$		
                              SCR_YSIZE=304)		
    end
    'REF_M': begin
        drawing = widget_draw(wT1,$
                              UNAME = 'drawing',$
                              XOFFSET=5,$
                              YOFFSET=40,$
                              SCR_XSIZE=304,$		
                              SCR_YSIZE=256)		
    end
    'BSS' : begin
        drawing_top = widget_draw(wT1,$
                                  UNAME = 'drawing_top',$
                                  XOFFSET=5,$
                                  YOFFSET=40,$
                                  SCR_XSIZE=290,$	
                                  SCR_YSIZE=140)
        drawing_bottom = widget_draw(wT1,$
                                     UNAME = 'drawing_bottom',$
                                     XOFFSET=5,$
                                     YOFFSET=185,$
                                     SCR_XSIZE=290,$	
                                     SCR_YSIZE=140)
    end
    
    else:

endcase
    





        











;--------------------------------------------------------------------------------
wT2 = Widget_base(wTab,$
                  TITLE='Histogramming',$
                  UNAME='wT2',$
                  scr_xsize=850,$
                  scr_ysize=440)

;--------------------------------------------------------------------------------
wT3 = widget_base(wTab,$
                  title='Log Book',$
                  uname='wT3',$
                  scr_xsize=850,$
                  scr_ysize=440)













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
                                         VALUE= "Working path",$
                                         UNAME='DEFAULT_PATH_BUTTON')

DEFAULT_FINAL_PATH_tab2 = WIDGET_TEXT(wT2,$
                                      UNAME='DEFAULT_FINAL_PATH_tab2',$
                                      XOFFSET=135, YOFFSET=125,$
                                      SCR_XSIZE=408, SCR_YSIZE=32, $
                                      value = output_path,$
                                      /editable)

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

; exist_frame = WIDGET_BASE(MAIN_BASE, $
;                           UNAME="exist_FRAME",$
;                           XOFFSET=215,$
;                           YOFFSET=277,$
;                           SCR_XSIZE=290,$
;                           SCR_YSIZE=35,$
;                           map=0)

; exist_label = WIDGET_LABEL(exist_frame,$
;                            UNAME="exist_LABEL",$
;                            XOFFSET=30,$
;                            YOFFSET=3,$
;                            SCR_XSIZE=380,$
;                            SCR_YSIZE=65,$
;                            frame=0,value="")

;archive or not
already_archived_base = widget_base(MAIN_BASE,$
                                    uname='already_archived_base',$
                                    xoffset=240,$
                                    yoffset=275,$
                                    scr_xsize=270,$
                                    scr_ysize=30,$
                                    frame=2,$
                                    map=0)

already_archived_label = widget_label(already_archived_base,$
                                      uname='already_archived_label',$
                                      xoffset=5,$
                                      yoffset=0,$
                                      value='',$
                                      /align_center,$
                                     scr_xsize=300,$
                                     scr_ysize=30)

; archive_nexus_base = widget_base(MAIN_BASE,$
;                                  uname='archive_nexus_base',$
;                                  xoffset=240,$
;                                    yoffset=275,$
;                                  scr_xsize=270,$
;                                  scr_ysize=30,frame=2,$
;                                   map=0)

; archive_list = ['Yes',$
;                    'No']
; archive_type_group = CW_BGROUP(archive_nexus_base,$ 
;                                archive_list,$
;                                /exclusive,$
;                                /RETURN_NAME,$
;                                XOFFSET=160,$
;                                YOFFSET=0,$
;                                SET_VALUE=1.0,$
;                                row=1,$
;                                UNAME='archive_type_group')
; archive_label = widget_label(archive_nexus_base,$
;                              xoffset=5,$
;                              yoffset=5,$
;                              value='Archive this run number: ',$
;                              /align_left)


;   Realize the widgets, set the user value of the top-level
;  base, and call XMANAGER to manage everything.
WIDGET_CONTROL, MAIN_BASE, /REALIZE
WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global ;we've used global, not stash as the structure name
Widget_Control, CREATE_NEXUS, sensitive=0
XMANAGER, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

case instrument of

    'REF_L': begin
        no_preview="/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/no_preview_REF_L.bmp"
        id = widget_info(Main_base,find_by_uname='drawing')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        wset, id_value
        image = read_bmp(no_preview)
        tv, image,0,0,/true
    end
    'REF_M': begin
        no_preview="/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/no_preview_REF_M.bmp"
        id = widget_info(main_base,find_by_uname='drawing')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        wset, id_value
        image = read_bmp(no_preview)
        tv, image,0,0,/true
    end
    'BSS' : begin
        no_preview=$
          "/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/no_preview_BSS_top.bmp"
        id_top = widget_info(main_base,find_by_uname='drawing_top')
        WIDGET_CONTROL, id_top, GET_VALUE=id_top_value
        wset, id_top_value
        image = read_bmp(no_preview)
        tv, image,0,0,/true
        
        no_preview=$
           "/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/no_preview_BSS_bottom.bmp"
        id_bottom = widget_info(main_base,find_by_uname='drawing_bottom')
        WIDGET_CONTROL, id_bottom, GET_VALUE=id_bottom_value
        wset, id_bottom_value
        image = read_bmp(no_preview)
        tv, image,0,0,/true
    end
    
    else:

endcase

end

;
; Empty stub procedure used for autoloading.
;
pro more_nexus, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

PORTAL_BASE, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra

end
