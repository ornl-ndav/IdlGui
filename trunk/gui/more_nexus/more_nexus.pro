pro MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

case Event.id of
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
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
    
    Widget_Info(wWidget, FIND_BY_UNAME='activate_preview_button'): begin
        activate_preview_button_cb, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='output_data_group'): begin
        output_data_group_cb, Event
    end
    
;output format of event
    Widget_Info(wWidget, FIND_BY_UNAME='event_format_group'): begin
        output_format_group_cb, Event, 'event_format_group'
    end

;output format of histogram
    Widget_Info(wWidget, FIND_BY_UNAME='histogram_format_group'): begin
        output_format_group_cb, Event, 'histogram_format_group'
    end

;output format of timebins
    Widget_Info(wWidget, FIND_BY_UNAME='timebins_format_group'): begin
        output_format_group_cb, Event, 'timebins_format_group'
    end

;output format of pulseid
    Widget_Info(wWidget, FIND_BY_UNAME='pulseid_format_group'): begin
        output_format_group_cb, Event, 'pulseid_format_group'
    end

;output format of infos
    Widget_Info(wWidget, FIND_BY_UNAME='infos_format_group'): begin
        output_format_group_cb, Event, 'infos_format_group'
    end

    Widget_Info(wWidget, FIND_BY_UNAME='output_data_button'): begin
        output_data_button_cb, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_HISTO_EVENT_FILE_BUTTON_tab1'): begin
        open_nexus_cb, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='sns_idl_button'): begin
        sns_idl_button_eventcb, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='wTab'): begin
        wTab_eventcb, Event
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
                        YPAD=3)
                        
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
instrument = instrument_list[instrument]
working_path = '~/local/more_nexus/'

global = ptr_new({$
                   activate_preview     : 0,$  ;1 = preview when oppening NeXus run number
                   find_nexus           : 0,$  ;0 = nexus file not found, 1 = found
                   full_nexus_name      : '',$ ;full path of nexus file
                   instrument		: instrument,$
                   user			: user,$ ;j35, ele....
                   run_number		: '',$ ;run_number (without * if present)
                   tmp_folder           : '~/local/.more_nexus_tmp',$ ;used to dump histogram
                   local_nexus          : 0,$ ;1=local nexus, 0=archive version
                   working_path         : working_path,$ ;local folder of nexus files
                   event_ext            : '_neutron_event',$
                   histo_ext            : '_neutron_histo_mapped',$
                   timebins_ext         : '_timebin',$
                   pulseID_ext          : '_pulseid',$
                   infos_ext            : '_infos',$
                   binary               : '.dat',$
                   ascii                : '.txt',$
                   xml                  : '.xml',$
                   file_to_plot         : '',$
                   file_to_plot_top     : '',$
                   file_to_plot_bottom  : '',$

                   output_path		: '/SNSlocal/users/',$
                   full_path_to_prenexus: '',$
                   full_path_to_nexus : '',$
                   full_local_folder_name : '',$
                   output_path_for_this_file: '',$
                   instrument_run_number	: '',$
                   NX_REF_L		: 304L,$
                   NY_REF_L		: 256L,$
                   Npixels_REF_L		: 77824L,$
                   NX_REF_M		: 256L,$
                   NY_REF_M		: 304L,$
                   Npixels_REF_M        : 77824L,$
                   NX_BSS			: 190L,$
                   NY_BSS			: 130L,$
                   Npixels_BSS		: 9216L,$
                   pixel_number		: '',$
                   Ntof			: 0L,$
                   img_ptr 		: ptr_new(0L),$
                   data_assoc		: ptr_new(0L)$
	})

(*global).output_path = (*global).output_path + user + "/"
output_path = (*global).output_path 
instrument = (*global).instrument

; Create the top-level base and the tab.
title = " Output histo/event data - Check NeXus (" + (*global).instrument + ")"
MAIN_BASE = WIDGET_BASE(GROUP_LEADER=wGroup, $
                        UNAME='MAIN_BASE', $
                        XOFFSET=150,$
                        YOFFSET=350, $
                        SCR_XSIZE=950, $
                        SCR_YSIZE=600, $
                        title=title,$
                        MBAR=WID_BASE_0_MBAR)

wTab = WIDGET_TAB(MAIN_BASE,$
                  uname='wTab',$
                  LOCATION=location,$
                  /tracking_events)

;--------------------------------------------------------------------------------
; First tab (NEXUS interface)
wT1 = WIDGET_BASE(wTab,$
                  TITLE='NeXus',$
                  UNAME='wT1',$
                  SCR_XSIZE=940,$
                  xoffset=5,$
                  SCR_YSIZE=570)

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
                              YOFFSET=60,$
                              SCR_XSIZE=304,$		
                              SCR_YSIZE=256)		
    end
    'BSS' : begin
        drawing_top = widget_draw(wT1,$
                                  UNAME = 'drawing_top',$
                                  XOFFSET=15,$
                                  YOFFSET=45,$
                                  SCR_XSIZE=290,$	
                                  SCR_YSIZE=140)
        drawing_bottom = widget_draw(wT1,$
                                     UNAME = 'drawing_bottom',$
                                     XOFFSET=15,$
                                     YOFFSET=190,$
                                     SCR_XSIZE=290,$	
                                     SCR_YSIZE=140)
    end
    else:
endcase
    
;infos / settings / log book
infos_setting_base = widget_base(wT1,$
                                 xoffset=320,$
                                 yoffset=7,$
                                 scr_xsize=800,$
                                 scr_ysize=340)

wTab_2 = WIDGET_TAB(infos_setting_base,$
                    LOCATION=location)

wT1_1 = widget_base(wTab_2,$
                    title='INFOS',$
                    uname='wT1_1',$
                    scr_xsize=600,$
                    scr_ysize=350,$
                    frame=1)

infos_text = widget_text(wT1_1,$
                         yoffset=0,$
                         xoffset=0,$
                         value='',$
                         uname='infos_text',$
                         scr_xsize=600,$
                         scr_ysize=315,$
                         /wrap,$
                         /scroll)

;bottom part of first tab
output_data_base = widget_base(wT1,$
                               uname='output_data_base',$
                               xoffset=10,$
                               yoffset=360,$
                               scr_xsize=913,$
                               scr_ysize=190,$
                               frame=1,$
                               map=0)

;output data selection part                                 
output_data_list = ['event file',$
                    'histogram file',$
                    'time bins file',$
                    'Pulse ID file',$
                    'Infos text']
output_data_group = cw_bgroup(output_data_base,$ 
                              uname='output_data_group',$
                              output_data_list,$
                              /RETURN_NAME,$
                              XOFFSET=5,$
                              YOFFSET=5,$
                              /nonexclusive,$
                              font='lucidasans-14',$
                              set_value=[0,0,0,0,0])  

;output data text base
event_text_base = widget_base(output_data_base,$
                              uname='event_text_base',$
                              xoffset=140,$
                              yoffset=5,$
                              scr_xsize=680,$
                              scr_ysize=30,$
                              frame=0,$
                              map=0)

event_text = widget_text(event_text_base,$
                         uname='event_text',$
                         xoffset=0,$
                         yoffset=0,$
                         scr_xsize=400,$
                         scr_ysize=30,$
                         value='',$
                         /editable,$
                         font='lucidasans-10')

output_format_list = ['binary (Unix / Microsoft)',$
                      'ASCII']
event_format_group = cw_bgroup(event_text_base,$ 
                               uname='event_format_group',$
                               output_format_list,$
                               /RETURN_NAME,$
                               XOFFSET=405,$
                               YOFFSET=0,$
                               /exclusive,$
                               /row,$
                               font='lucidasans-12',$
                               set_value=0)
                         
histogram_text_base = widget_base(output_data_base,$
                                  uname='histogram_text_base',$
                                  xoffset=140,$
                                  yoffset=36,$
                                  scr_xsize=680,$
                                  scr_ysize=30,$
                                  frame=0,$
                                  map=0)

histogram_text = widget_text(histogram_text_base,$
                             uname='histogram_text',$
                             xoffset=0,$
                             yoffset=0,$
                             scr_xsize=400,$
                             scr_ysize=30,$
                             value='',$
                             /editable,$
                             font='lucidasans-10')

histogram_format_group = cw_bgroup(histogram_text_base,$ 
                                   uname='histogram_format_group',$
                                   output_format_list,$
                                   /RETURN_NAME,$
                                   XOFFSET=405,$
                                   YOFFSET=0,$
                                   /exclusive,$
                                   /row,$
                                   font='lucidasans-12',$
                                   set_value=0)

timebins_text_base = widget_base(output_data_base,$
                                 uname='timebins_text_base',$
                                 xoffset=140,$
                                 yoffset=67,$
                                 scr_xsize=680,$
                                 scr_ysize=30,$
                                 frame=0,$
                                 map=0)

timebins_text = widget_text(timebins_text_base,$
                             uname='timebins_text',$
                             xoffset=0,$
                             yoffset=0,$
                             scr_xsize=400,$
                             scr_ysize=30,$
                             value='',$
                             /editable,$
                             font='lucidasans-10')

timebins_format_group = cw_bgroup(timebins_text_base,$ 
                                  uname='timebins_format_group',$
                                  output_format_list,$
                                  /RETURN_NAME,$
                                  XOFFSET=405,$
                                  YOFFSET=0,$
                                  /exclusive,$
                                  /row,$
                                  font='lucidasans-12',$
                                  set_value=0.0)

pulseid_text_base = widget_base(output_data_base,$
                                uname='pulseid_text_base',$
                                xoffset=140,$
                                yoffset=98,$
                                scr_xsize=680,$
                                scr_ysize=30,$
                                frame=0,$
                                map=0)

pulseid_text = widget_text(pulseid_text_base,$
                             uname='pulseid_text',$
                             xoffset=0,$
                             yoffset=0,$
                             scr_xsize=400,$
                             scr_ysize=30,$
                             value='',$
                             /editable,$
                             font='lucidasans-10')

pulseid_format_group = cw_bgroup(pulseid_text_base,$ 
                                 uname='pulseid_format_group',$
                                 output_format_list,$
                                 /RETURN_NAME,$
                                 XOFFSET=405,$
                                 YOFFSET=0,$
                                 /exclusive,$
                                 /row,$
                                 font='lucidasans-12',$
                                 set_value=0.0)

infos_text_base = widget_base(output_data_base,$
                              uname='infos_text_base',$
                              xoffset=140,$
                              yoffset=129,$
                              scr_xsize=680,$
                              scr_ysize=30,$
                              frame=0,$
                              map=0)

infos_file_text = widget_text(infos_text_base,$
                         uname='infos_file_text',$
                         xoffset=0,$
                         yoffset=0,$
                         scr_xsize=400,$
                         scr_ysize=30,$
                         value='',$
                         /editable,$
                         font='lucidasans-10')

output_infos_format_list = ['ASCII',$
                            'XML']

infos_format_group = cw_bgroup(infos_text_base,$ 
                               uname='infos_format_group',$
                               output_infos_format_list,$
                               /RETURN_NAME,$
                               XOFFSET=405,$
                               YOFFSET=0,$
                               /exclusive,$
                               /row,$
                               font='lucidasans-12',$
                               set_value=0.0)

output_data_button_base = widget_base(output_data_base,$
                                      uname='output_data_button_base',$
                                      xoffset=820,$
                                      yoffset=5,$
                                      scr_xsize=90,$
                                      scr_ysize=150,$
                                      map=0)
bmp_file = "/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/output_data_go.bmp"
output_data_button = widget_button(output_data_button_base,$
                                   uname='output_data_button',$
                                   xoffset=0,$
                                   yoffset=0,$
                                   scr_xsize=90,$
                                   scr_ysize=150,$
                                   /bitmap,$
                                   value=bmp_file)


text_infos = '        binary (Unix-Microsoft) : .dat'
text_infos += '        binary (Macintosh) : M.dat'
text_infos += '        ASCII : .txt'
text_infos += '        XML : .xml       '
output_format_infos = widget_label(output_data_base,$  
                                   xoffset=100,$
                                   yoffset=165,$
                                   value=text_infos,$
                                   frame=1)
                                   
wT1_2 = widget_base(wTab_2,$
                    title='SETTINGS',$
                    uname='wT1_2',$
                    scr_xsize=400,$
                    scr_ysize=350,$
                    frame=1)

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
                  scr_xsize=940,$
                  scr_ysize=570)

log_book_text = widget_text(wT3,$
                            uname='log_book_text',$
                            xoffset=5,$
                            yoffset=5,$
                            scr_xsize=935,$
                            scr_ysize=560,$
                            value='',$
                            /wrap,$
                            /scroll)
















; file info that is part of the first tab
; FILE_INFO_BASE = widget_base(wT1,$
;                              XOFFSET=215, YOFFSET=35,$
;                              SCR_XSIZE=325, SCR_YSIZE=215)

; FILE_INFO_wT1_label = widget_label(file_info_base,$
;                                    XOFFSET=2, YOFFSET=0,$
;                                    SCR_XSIZE=72, SCR_YSIZE=26,$
;                                    VALUE="File infos")

; x_offset = 4
; y_offset = 26
; delta_y = 35
; XML_FILE_LABEL = widget_label(file_info_base,$
;                               XOFFSET=x_offset, YOFFSET=y_offset,$
;                               SCR_XSIZE=70, SCR_YSIZE=25,$
;                               VALUE = "XML FILE: ",/align_left)
; XML_FILE_TEXT = widget_label(file_info_base,$
;                              UNAME="XML_FILE_TEXT",$
;                              XOFFSET=x_offset + 70, YOFFSET=y_offset,$
;                              SCR_XSIZE=240, SCR_YSIZE=25,$
;                              frame=1,$
;                              /align_left,$
;                              VALUE = "")

; y_offset += delta_y
; TITLE_LABEL = widget_label(file_info_base,$
;                            XOFFSET=x_offset,$
;                            YOFFSET=y_offset,$
;                            SCR_XSIZE=50,$
;                            SCR_YSIZE=25,$
;                            VALUE = "Title: ",$
;                            /align_left)
; TITLE_TEXT = widget_label(file_info_base,$
;                           UNAME="TITLE_TEXT",$
;                           XOFFSET=x_offset + 50,$
;                           YOFFSET=y_offset,$
;                           SCR_XSIZE=260,$
;                           SCR_YSIZE=25,$
;                           VALUE = "",$
;                           frame=1,$
;                           /align_left)

; y_offset += delta_y
; NOTES_LABEL = widget_label(file_info_base,$
;                            XOFFSET=x_offset, YOFFSET=y_offset,$
;                            SCR_XSIZE=50, SCR_YSIZE=25,$
;                            VALUE = "Notes: ",/align_left)
; NOTES_TEXT = widget_label(file_info_base,$
;                           UNAME="NOTES_TEXT",$
;                           XOFFSET=x_offset + 50,$
;                           YOFFSET=y_offset,$
;                           SCR_XSIZE=260, SCR_YSIZE=25,$
;                           frame=1,$
;                           /align_left,$
;                           VALUE = "")

; y_offset += delta_y
; SPECIAL_DESIGNATION_LABEL = widget_label(file_info_base,$
;                                          XOFFSET=x_offset,$
;                                          YOFFSET=y_offset,$
;                                          SCR_XSIZE=85,$
;                                          SCR_YSIZE=25,$
;                                          VALUE = "Special notes: ",/align_left)
; NOTES_TEXT = widget_label(file_info_base,$
;                           UNAME="SPECIAL_DESIGNATION",$
;                           XOFFSET=x_offset + 90,$
;                           YOFFSET=y_offset,$
;                           SCR_XSIZE=220,$
;                           SCR_YSIZE=25,$
;                           frame=1,$
;                           /align_left,$
;                           VALUE = "")

; y_offset += delta_y
; SCRIPT_ID_LABEL = widget_label(file_info_base,$
;                                XOFFSET=x_offset, YOFFSET=y_offset,$
;                                SCR_XSIZE=70, SCR_YSIZE=25,$
;                                VALUE = "Script ID: ",/align_left)
; SCRIPT_ID_TEXT = widget_label(file_info_base,$
;                               UNAME="SCRIPT_ID_TEXT",$
;                               XOFFSET=x_offset + 70,$
;                               YOFFSET=y_offset,$
;                               SCR_XSIZE=140,$ 
;                               SCR_YSIZE=25,$
;                               frame=1,$
;                               /align_left,$
;                               VALUE = "")

; complete_infofile_offset_x = 220
; complete_infofile_offset_y = y_offset-2
; COMPLETE_RUNINFO_FILE = widget_button(file_info_base,$
;                                       UNAME="COMPLETE_RUNINFO_FILE",$
;                                       XOFFSET=complete_infofile_offset_x,$
;                                       YOFFSET=complete_infofile_offset_y,$
;                                       SCR_XSIZE=100,$
;                                       SCR_YSIZE=20,$
;                                       VALUE="runinfo.xml",$
;                                       /tracking_events,$
;                                       /pushbutton_events,$
;                                       tooltip="Display full runinfo.xml file")

; complete_infofile_offset_y += 22
; COMPLETE_CVINFO_FILE = widget_button(file_info_base,$
;                                      UNAME="COMPLETE_CVINFO_FILE",$
;                                      XOFFSET=complete_infofile_offset_x,$
;                                      YOFFSET=complete_infofile_offset_y,$
;                                      SCR_XSIZE=100,$
;                                      SCR_YSIZE=20,$
;                                      VALUE="cvinfo.xml",$
;                                      /tracking_events,$
;                                      tooltip="Display full cvinfo.xml file")

; FILE_INFO_wT1 = WIDGET_label(file_info_base,$
;                              XOFFSET=0, YOFFSET=15,$	
;                              SCR_XSIZE=325, SCR_YSIZE=190,$
;                              VALUE="", $
;                              UNAME="FILE_INFO_wT1",$
;                              frame=2)

; COMPLETE_XML_DISPLAY_TEXT = widget_text(MAIN_BASE,$
;                                         UNAME="COMPLETE_XML_DISPLAY_TEXT",$
;                                         XOFFSET=5,$
;                                         YOFFSET=320,$
;                                         SCR_XSIZE=835,$
;                                         SCR_YSIZE=340,$
;                                         /wrap,$
;                                         /scroll)

; CLOSE_COMPLETE_XML_DISPLAY_TEXT = widget_button(MAIN_BASE,$
;                                                 UNAME="CLOSE_COMPLETE_XML_DISPLAY_TEXT",$
;                                                 XOFFSET=300,$
;                                                 YOFFSET=660,$
;                                                 SCR_XSIZE=150,$
;                                                 SCR_YSIZE=30,$
;                                                 VALUE = "CLOSE XML WINDOW",$
;                                                 /tracking_events,$
;                                                 tooltip="Remove xml extension window")

; wT2 = WIDGET_BASE(wTab, TITLE='Settings')

; OPEN_MAPPING_FILE_BUTTON_tab2 = WIDGET_label(wT2, $
;                                              XOFFSET= 5, YOFFSET = 5, $
;                                              SCR_XSIZE=130, SCR_YSIZE=30, $
;                                              VALUE= "Mapping file",$
;                                              UNAME='OPEN_MAPPING_FILE_BUTTON')

; MAPPING_FILE_LABEL_tab2 = WIDGET_label(wT2,$
;                                        UNAME='MAPPING_FILE_LABEL',$
;                                        XOFFSET=135, YOFFSET=5,$
;                                        SCR_XSIZE=408, SCR_YSIZE=32, $
;                                        value = mapping_file,$
;                                        frame=1,$
;                                        /align_left)

; DEFAULT_TRANSLATION_BUTTON_tab2 = WIDGET_label(wT2, $
;                                                XOFFSET= 5, YOFFSET = 45, $
;                                                SCR_XSIZE=130, SCR_YSIZE=30, $
;                                                VALUE= "Translation file",$
;                                                UNAME='DEFAULT_TRANSLATION_BUTTON')

; DEFAULT_TRANSLATION_FILE_tab2 = WIDGET_label(wT2,$
;                                              UNAME='DEFAULT_TRANSLATION_FILE',$
;                                              XOFFSET=135, YOFFSET=45,$
;                                              SCR_XSIZE=408, SCR_YSIZE=32, $
;                                              value = translation_file,$
;                                              frame=1,$
;                                              /align_left)

; DEFAULT_GEOMETRY_BUTTON_tab2 = WIDGET_label(wT2, $
;                                             XOFFSET= 5, YOFFSET = 85, $
;                                             SCR_XSIZE=130, SCR_YSIZE=30, $
;                                             VALUE= "Geometry file",$
;                                             UNAME='DEFAULT_GEOMETRY_BUTTON')

; DEFAULT_GEOMETRY_FILE_tab2 = WIDGET_label(wT2,$
;                                           UNAME='DEFAULT_GEOMETRY_FILE',$
;                                           XOFFSET=135, YOFFSET=85,$
;                                           SCR_XSIZE=408, SCR_YSIZE=32, $
;                                           value = geometry_file,$
;                                           frame=1,$
;                                           /align_left)

; DEFAULT_PATH_BUTTON_tab2 = WIDGET_BUTTON(wT2, $
;                                          XOFFSET= 5, YOFFSET = 125, $
;                                          SCR_XSIZE=130, SCR_YSIZE=30, $
;                                          VALUE= "Working path",$
;                                          UNAME='DEFAULT_PATH_BUTTON')

; DEFAULT_FINAL_PATH_tab2 = WIDGET_TEXT(wT2,$
;                                       UNAME='DEFAULT_FINAL_PATH_tab2',$
;                                       XOFFSET=135, YOFFSET=125,$
;                                       SCR_XSIZE=408, SCR_YSIZE=32, $
;                                       value = output_path,$
;                                       /editable)

;    Create a base widget to hold the 'Create NeXus' button, and
;    the button itself.
; wControl = WIDGET_BASE(MAIN_BASE)
; CREATE_NEXUS = WIDGET_BUTTON(wControl, VALUE='Create local NeXus file',$
;                              UNAME = "CREATE_NEXUS",$
;                              XOFFSET=5,$
;                              YOFFSET=277,$
;                              SCR_XSIZE=200,$
;                              SCR_YSIZE=30,$
;                              tooltip="Create NeXus")

;  exist_frame = WIDGET_BASE(MAIN_BASE, $
;                            UNAME="exist_FRAME",$
;                            XOFFSET=215,$
;                            YOFFSET=277,$
;                            SCR_XSIZE=290,$
;                            SCR_YSIZE=35,$
;                            map=0)

;  exist_label = WIDGET_LABEL(exist_frame,$
;                             UNAME="exist_LABEL",$
;                             XOFFSET=30,$
;                             YOFFSET=3,$
;                             SCR_XSIZE=380,$
;                             SCR_YSIZE=65,$
;                             frame=0,value="")

; archive or not
; already_archived_base = widget_base(MAIN_BASE,$
;                                     uname='already_archived_base',$
;                                     xoffset=240,$
;                                     yoffset=275,$
;                                     scr_xsize=270,$
;                                     scr_ysize=30,$
;                                     frame=2,$
;                                     map=0)

; already_archived_label = widget_label(already_archived_base,$
;                                       uname='already_archived_label',$
;                                       xoffset=5,$
;                                       yoffset=0,$
;                                       value='',$
;                                       /align_center,$
;                                      scr_xsize=300,$
;                                      scr_ysize=30)

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


idl_tools_menu = Widget_Button(WID_BASE_0_MBAR, $
                               UNAME='idl_tools_menu',$
                               /MENU,$
                               VALUE='sns_idl_tools')

sns_idl_button = widget_button(idl_tools_menu,$
                               value="launch sns_idl_tools...",$
                               uname="sns_idl_button")

;   Realize the widgets, set the user value of the top-level
;  base, and call XMANAGER to manage everything.
WIDGET_CONTROL, MAIN_BASE, /REALIZE
WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global ;we've used global, not stash as the structure name
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
