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
    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_MAPPED_HISTOGRAM'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_MAPPED_HISTOGRAM, Event
    end

;open_nexus
    ;Open widget in the top toolbar - OPEN RUN #
    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_NEXUS_menu'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_NEXUS_INTERFACE, Event
    end

    ;Open widget in the top toolbar - OPEN LOCAL RUN #
    Widget_Info(wWidget, FIND_BY_UNAME='open_local_nexus_menu'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_LOCAL_NEXUS_INTERFACE, Event
    end

    ;Open widget in the top toolbar - OPEN RUN #
    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_RUN_NUMBER_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_NEXUS, Event
    end

    ;Open widget in the top toolbar - OPEN LOCAL RUN #
    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_LOCAL_RUN_NUMBER_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_NEXUS, Event, 1
    end

    ;Open rebinNeXus GUI
    Widget_Info(wWidget, FIND_BY_UNAME='rebinGUI_button'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        rebinGUI_button_eventcb, Event
    end

    ;Cancel open_run_number - OPEN RUN #
    Widget_Info(wWidget, FIND_BY_UNAME='CANCEL_OPEN_RUN_NUMBER_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        CANCEL_OPEN_NEXUS, Event
    end

    ;Cancel open_local_run_number - OPEN RUN #
    Widget_Info(wWidget, FIND_BY_UNAME='CANCEL_LOCAL_OPEN_RUN_NUMBER_BUTTON'): begin
        if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        CANCEL_LOCAL_OPEN_NEXUS, Event
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

    ;top left tab
    Widget_Info(wWidget, FIND_BY_UNAME='draw_tube_pixels_base'): begin
        draw_tube_pixels_base_eventcb, Event
    end

    ;slider tube in histo tab
    Widget_Info(wWidget, FIND_BY_UNAME='histo_draw_tube_pixels_slider'): begin
        histo_plot_tubes_pixels, Event
    end

    ;slider Nt in histo tab
    Widget_Info(wWidget, FIND_BY_UNAME='nt_histo_draw_tube_pixels_slider'): begin
        histo_plot_tubes_pixels, Event
    end

    ;Widget to change the color of graph
    Widget_Info(wWidget, FIND_BY_UNAME='ABOUT_MENU'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        ABOUT_MENU, Event
    end

    ;slider pixels
    Widget_Info(wWidget, FIND_BY_UNAME='get_pixels_infos'): begin
        get_pixels_infos, Event
    end

;MOVE EDGES OF TUBES
;tube0
    ;tube0_left_minus button
    Widget_Info(wWidget, FIND_BY_UNAME='tube0_left_minus'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        move_tube_edges, Event, 0, "left", "minus"
    end

    ;tube0_left_plus button
    Widget_Info(wWidget, FIND_BY_UNAME='tube0_left_plus'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        move_tube_edges, Event, 0, "left", "plus"
    end

    ;tube0_right_minus button
    Widget_Info(wWidget, FIND_BY_UNAME='tube0_right_minus'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        move_tube_edges, Event, 0, "right", "minus"
    end

    ;tube0_right_plus button
    Widget_Info(wWidget, FIND_BY_UNAME='tube0_right_plus'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        move_tube_edges, Event, 0, "right", "plus"
    end

;center

    ;center_minus button
    Widget_Info(wWidget, FIND_BY_UNAME='center_minus'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        move_tube_edges, Event, "center", "" , "minus"
    end

    ;center_plus button
    Widget_Info(wWidget, FIND_BY_UNAME='center_plus'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        move_tube_edges, Event, "center", "", "plus"
    end

;tube1
    ;right1_left_minus button
    Widget_Info(wWidget, FIND_BY_UNAME='tube1_left_minus'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        move_tube_edges, Event, 1, "left", "minus"
    end

    ;tube1_left_plus button
    Widget_Info(wWidget, FIND_BY_UNAME='tube1_left_plus'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        move_tube_edges, Event, 1, "left", "plus"
    end

    ;tube1_right_minus button
    Widget_Info(wWidget, FIND_BY_UNAME='tube1_right_minus'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        move_tube_edges, Event, 1, "right", "minus"
    end

    ;tube1_right_plus button
    Widget_Info(wWidget, FIND_BY_UNAME='tube1_right_plus'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        move_tube_edges, Event, 1, "right", "plus"
    end

;plot mapped data

    Widget_Info(wWidget, FIND_BY_UNAME='plot_mapped_data'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        plot_mapped_data, Event
    end

;--tube--
;REMOVE tube
    Widget_Info(wWidget, FIND_BY_UNAME='remove_tube_button'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        save_changes, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='cancel_remove_tube_button'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        add_tube, Event
    end


;reset all changes
    Widget_Info(wWidget, FIND_BY_UNAME='reset_all_button_validate_yes'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        reset_all_changes, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='reset_all_button_validate_cancel'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        cancel_reset_all, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='reset_all_button'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        validate_reset_all_changes, Event
    end

;--pixelID-- 
;REMOVE pixelid
    Widget_Info(wWidget, FIND_BY_UNAME='remove_pixelid'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        save_pixelid_changes, Event
    end

;ADD pixelid 
    Widget_Info(wWidget, FIND_BY_UNAME='pixelid_new_counts_reset'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        pixelid_new_counts_reset, Event
    end

;Widget to change the color of graph of DAS
    Widget_Info(wWidget, FIND_BY_UNAME='CTOOL_MENU_DAS'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        CTOOL_DAS, Event
    end

;Widget to change the color of graph of realign data
    Widget_Info(wWidget, FIND_BY_UNAME='CTOOL_MENU_realign'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        CTOOL_realign, Event
    end

;Widget to output histo_mapped_realigned data
    Widget_Info(wWidget, FIND_BY_UNAME='output_new_histo_mapped_file'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
;        output_new_histo_mapped_file, Event
         create_nexus_file, Event
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

    Widget_Info(wWidget, FIND_BY_UNAME='interactive_ok_button'): begin
  	interactive_ok_button_eventcb, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='interactive_cancel_button'): begin
  	interactive_cancel_button_eventcb, Event
    end





  

    else:
  endcase

end

pro MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;define parameters
scr_x 	= 1118				;main window width
scr_y 	= 700				;main window height 
ctrl_x	= 1				;width of left box - control
ctrl_y	= scr_y				;height of lect box - control
draw_x 	= 304				;main width of draw area
draw_y 	= 256				;main heigth of draw area
draw_offset_x = 10			;draw x offset within widget
draw_offset_y = 10			;draw y offset within widget
plot_height = 150			;plot box height
plot_length = 304			;plot box length

Resolve_Routine, 'RealignGUI_eventcb',/COMPILE_FULL_FILE 
;Load event callback routines

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup, UNAME='MAIN_BASE'  $
      ,XOFFSET=100 ,YOFFSET=22 ,SCR_XSIZE=scr_x ,SCR_YSIZE=scr_y  $
      ,NOTIFY_REALIZE='MAIN_REALIZE' ,TITLE='Realign BSS tubes'  $
      ,SPACE=3 ,XPAD=3 ,YPAD=3 ,MBAR=WID_BASE_0_MBAR)

;define initial global values - these could be input via external file
;or other means

global = ptr_new({$
                   debugger : '',$    ;'j35' or 'ele'
                   nexus_open : 0,$
                   debug : 1,$                     ;1 for debugging  ;0 for not debgging
                   debug_output_file_name : '~/RealignGUI_debug.txt',$
                   tmp_nxdir_folder : '/realignGUI_tmp/',$
                   file_type : '',$
                   file_to_plot_top : '',$
                   file_to_plot_bottom : '',$
                   full_tmp_nxdir_folder_path : '',$  ;/working_path/tmp_nxdir_folder
                   find_nexus : 0,$
                   full_nexus_name : '',$
                   file			      :'',$
                   full_output_file_name      :'',$  
                   file_already_opened	      :0,$
                   new_tube                   :1,$
                   path			      :'/SNSlocal/tmp/',$
                   working_path		      :'',$
                   default_path		      :'/SNSlocal/users/',$
                   remapped_file_name         :'mapped.dat',$
                   mapping_file  :'/SNS/users/j35/BSS/BSS_TS_2006_11_16.dat',$
                   geometry_file  :'/SNS/BSS/2006_1_2_CAL/calibrations/BSS_geom_2006_09_26.nxs',$
                   translation_file :'/SNS/BSS/2006_1_2_CAL/calibrations/BSS_2006_08_25.nxt',$
                   path_to_preNeXus           :'',$
                   full_output_folder_name    :'',$
                   path_up_to_proposal_number :'',$
                   proposal_number            :'',$
                   run_number                 :0,$ 
                   ucams	              :'',$
                   name			      :'',$
                   character_id		      :'',$
                   filter_histo		      :'*_histo_mapped.dat',$
                   nbytes	              :4L,$
                   swap_endian		      :0,$
                   Nx			      :128L,$
                   Ny_scat		      :64L,$
                   Ny_diff                    :8L,$
                   Nt			      :1L,$
                   y_coeff		      :10L,$
                   x_coeff		      :8.4,$
                   image1                     : ptr_new(0L),$
                   image_2d_1		      : ptr_new(0L),$
                   image_2d_1_untouched	      : ptr_new(0L),$   
                   remap_histo                : ptr_new(0L),$
                   reorder_array              : ptr_new(0L),$
                   tube_removed               : ptr_new(0L),$
                   pixel_removed              : ptr_new(0L),$
                   IDL_pixelid_removed        : ptr_new(0L),$
                   look_up                    : ptr_new(0L),$
                   look_up_histo              : ptr_new(0L),$
                   image_nt_nx_ny             : ptr_new(0L),$
                   i1                         : ptr_new(0L),$
                   i2                         : ptr_new(0L),$
                   i3                         : ptr_new(0L),$
                   i4                         : ptr_new(0L),$
                   i5                         : ptr_new(0L),$
                   len1                       : ptr_new(0L),$
                   len2                       : ptr_new(0L)$
})

;attach global data structure with widget ID of widget main base widget ID
widget_control,MAIN_BASE,set_uvalue=global

;   IDENTIFICATION_BASE= widget_base(MAIN_BASE,$
;                                    XOFFSET=150,$
;                                    YOFFSET=120,$
;                                    UNAME='IDENTIFICATION_BASE',$
;                                    SCR_XSIZE=240,$
;                                    SCR_YSIZE=120,$
;                                    FRAME=10,$
;                                    SPACE=4,$
;                                    XPAD=3,$
;                                    YPAD=3)
  
;   IDENTIFICATION_LABEL = widget_label(IDENTIFICATION_BASE,$
;                                       XOFFSET=40,$
;                                       YOFFSET=3,$
;                                       VALUE="ENTER YOUR 3 CHARACTERS ID")
  
;   IDENTIFICATION_TEXT = widget_text(IDENTIFICATION_BASE,$
;                                     XOFFSET=100,$
;                                     YOFFSET=20,$
;                                     VALUE='',$ ;
;                                     SCR_XSIZE=37,$
;                                     /editable,$
;                                     UNAME='IDENTIFICATION_TEXT',$
;                                     /ALL_EVENTS)
  
;   ERROR_IDENTIFICATION_left = widget_label(IDENTIFICATION_BASE,$
;                                            XOFFSET=5,$
;                                            YOFFSET=25,$
;                                            VALUE='',$
;                                            SCR_XSIZE=90,$
;                                            SCR_YSIZE=20, $
;                                            UNAME='ERROR_IDENTIFICATION_LEFT')
  
;   ERROR_IDENTIFICATION_right = widget_label(IDENTIFICATION_BASE,$
;                                             XOFFSET=140,$
;                                             YOFFSET=25,$
;                                             VALUE='',$
;                                             SCR_XSIZE=90,$
;                                             SCR_YSIZE=20, $
;                                             UNAME='ERROR_IDENTIFICATION_RIGHT')
  
;   DEFAULT_PATH_BUTTON = widget_button(IDENTIFICATION_BASE,$
;                                       XOFFSET=0,$
;                                       YOFFSET=55,$
;                                       VALUE='Working path',$
;                                       SCR_XSIZE=80,$
;                                       SCR_YSIZE=30,$
;                                       UNAME='DEFAULT_PATH_BUTTON')
  
;   DEFAULT_PATH_TEXT = widget_text(IDENTIFICATION_BASE,$
;                                   XOFFSET=83,$
;                                   YOFFSET=55,$
;                                   VALUE=(*global).default_path,$
;                                   UNAME='DEFAULT_PATH_TEXT',$
;                                   /editable,$
;                                   SCR_XSIZE=150)
  
;   IDENTIFICATION_GO = widget_button(IDENTIFICATION_BASE,$
;                                     XOFFSET=67,$
;                                     YOFFSET=90,$
;                                     SCR_XSIZE=130,$
;                                     SCR_YSIZE=30,$
;                                     VALUE="E N T E R",$
;                                     UNAME='IDENTIFICATION_GO')		
  

;open nexus_file window
OPEN_NEXUS_BASE= widget_base(MAIN_BASE,$
                             XOFFSET=90,$
                             YOFFSET=60,$
                             UNAME='OPEN_NEXUS_BASE',$
                             SCR_XSIZE=300,$
                             SCR_YSIZE=60,$
                             FRAME=10,$
                             SPACE=4,$
                             XPAD=3,$
                             YPAD=3,$
                             MAP=0)



;interactive command line window

interactive_cmd_line_base = widget_base(main_base,$
                                        xoffset=560,$
                                        yoffset=455,$
                                        uname='interactive_cmd_line_base',$
                                        scr_xsize=545,$
                                        scr_ysize=235,$
                                        frame=1,$
                                        map=1)

interactive_create_tbin_file_label = widget_label(interactive_cmd_line_base,$
                                                  xoffset=5,$
                                                  yoffset=15,$
                                                  value='Create_Tbin_File: ',$
                                                  /align_left)

interactive_create_tbin_file_text = widget_text(interactive_cmd_line_base,$
                                                xoffset=120,$
                                                yoffset=10,$
                                                scr_xsize=420,$
                                                scr_ysize=60,$
                                                value='',$
                                               /align_left,$
                                               /editable,$
                                               /wrap,$
                                               /scroll)

;Nt
interactive_nt_label = widget_label(interactive_cmd_line_base,$
                                    xoffset=5,$
                                    yoffset=85,$
                                    value='Nt:',$
                                    /align_left)

interactive_nt_text = widget_text(interactive_cmd_line_base,$
                                  uname='interactive_nt_text',$
                                  xoffset=30,$
                                  yoffset=80,$
                                  value='',$
                                  scr_xsize=60,$
                                  scr_ysize=30,$
                                  /align_left,$
                                  /editable)


;Nx
x_off = 100
interactive_nx_label = widget_label(interactive_cmd_line_base,$
                                    xoffset=5+x_off,$
                                    yoffset=85,$
                                    value='Nx:',$
                                    /align_left)

interactive_nx_text = widget_text(interactive_cmd_line_base,$
                                  uname='interactive_nx_text',$
                                  xoffset=30+x_off,$
                                  yoffset=80,$
                                  value='',$
                                  scr_xsize=60,$
                                  scr_ysize=30,$
                                  /align_left,$
                                  /editable)

;Ny
x_off = 200
interactive_ny_label = widget_label(interactive_cmd_line_base,$
                                    xoffset=5+x_off,$
                                    yoffset=85,$
                                    value='Ny:',$
                                    /align_left)

interactive_ny_text = widget_text(interactive_cmd_line_base,$
                                  uname='interactive_ny_text',$
                                  xoffset=30+x_off,$
                                  yoffset=80,$
                                  value='',$
                                  scr_xsize=60,$
                                  scr_ysize=30,$
                                  /align_left,$
                                  /editable)


;N
x_off = 300
interactive_n_label = widget_label(interactive_cmd_line_base,$
                                    xoffset=5+x_off,$
                                    yoffset=85,$
                                    value='Nbr elements:',$
                                    /align_left)

interactive_n_text = widget_text(interactive_cmd_line_base,$
                                  uname='interactive_n_text',$
                                  xoffset=90+x_off,$
                                  yoffset=80,$
                                  value='',$
                                  scr_xsize=100,$
                                  scr_ysize=30,$
                                  /align_left,$
                                  /editable)


interactive_nexus_label = widget_label(interactive_cmd_line_base,$
                                       xoffset=5,$
                                       yoffset=130,$
                                       value='NeXus file:',$
                                       /align_left)

interactive_nexus_text = widget_text(interactive_cmd_line_base,$
                                     xoffset=80,$
                                     yoffset=125,$
                                     value='',$
                                     scr_xsize=460,$
                                     scr_ysize=50,$
                                     uname='interactive_nexus_text',$
                                     /align_left,$
                                     /editable,$
                                     /scroll,$
                                    /wrap)

;OK button
interactive_ok_button = widget_button(interactive_cmd_line_base,$
                                      xoffset=50,$
                                      yoffset=190,$
                                      value='VALIDATE',$
                                      uname='interactive_ok_button',$
                                      scr_xsize=200,$
                                      scr_ysize=30,$
                                     frame=1)


;CANCEL button
interactive_cancel_button = widget_button(interactive_cmd_line_base,$
                                          xoffset=270,$
                                          yoffset=190,$
                                          value='CANCEL',$
                                          uname='interactive_cancel_button',$
                                          scr_xsize=200,$
                                          scr_ysize=30,$
                                          frame=1)




;open local nexus interface
OPEN_LOCAL_LABEL = widget_label(OPEN_NEXUS_BASE,$
                                xoffset=0,$
                                yoffset=0,$
                                value='Open archived nexus file',$
                                scr_xsize=295,$
                                frame=1)
                          
yoffset=18
OPEN_RUN_NUMBER_LABEL = widget_label(OPEN_NEXUS_BASE,$
                                     xoffset=5,$
                                     yoffset=8+yoffset,$
                                     uname='OPEN_RUN_NUMBER_LABEL',$
                                     scr_xsize=65,$
                                     scr_ysize=30,$
                                     value='Run number ')

OPEN_RUN_NUMBER_TEXT = widget_text(OPEN_NEXUS_BASE,$
                                   xoffset=70,$
                                   yoffset=8+yoffset,$
                                   scr_xsize=80,$
                                   scr_ysize=30,$
                                   value='',$
                                   uname='OPEN_RUN_NUMBER_TEXT',$
                                   /editable,$
                                   /align_left)

OPEN_RUN_NUMBER_BUTTON = widget_button(OPEN_NEXUS_BASE,$
                                       xoffset=160,$
                                       yoffset=8+yoffset,$
                                       scr_xsize=60,$
                                       scr_ysize=30,$
                                       value='OPEN',$
                                       uname='OPEN_RUN_NUMBER_BUTTON')

CANCEL_OPEN_RUN_NUMBER_BUTTON = widget_button(OPEN_NEXUS_BASE,$
                                              xoffset=230,$
                                              yoffset=8+yoffset,$
                                              scr_xsize=60,$
                                              scr_ysize=30,$
                                              value='CANCEL',$
                                              uname='CANCEL_OPEN_RUN_NUMBER_BUTTON')

;open local nexus_file window
OPEN_LOCAL_NEXUS_BASE = widget_base(MAIN_BASE,$
                                    xoffset=90,$
                                    yoffset=60,$
                                    uname='open_local_nexus_base',$
                                    scr_xsize=300,$
                                    scr_ysize=60,$
                                    frame=10,$
                                    xpad=4,$
                                    ypad=3,$
                                    map=0)
          
OPEN_LOCAL_LABEL = widget_label(OPEN_LOCAL_NEXUS_BASE,$
                                xoffset=0,$
                                yoffset=0,$
                                value='Open local nexus file (~/local/)',$
                                scr_xsize=295,$
                                frame=1)
                          
yoffset=18
OPEN_LOCAL_RUN_NUMBER_LABEL = widget_label(OPEN_LOCAL_NEXUS_BASE,$
                                           xoffset=5,$
                                           yoffset=8+yoffset,$
                                           uname='OPEN_LOCAL_RUN_NUMBER_LABEL',$
                                           scr_xsize=65,$
                                           scr_ysize=30,$
                                           value='Run number ')

OPEN_LOCAL_RUN_NUMBER_TEXT = widget_text(OPEN_LOCAL_NEXUS_BASE,$
                                         xoffset=70,$
                                         yoffset=8+yoffset,$
                                         scr_xsize=80,$
                                         scr_ysize=30,$
                                         value='',$
                                         uname='OPEN_LOCAL_RUN_NUMBER_TEXT',$
                                         /editable,$
                                         /align_left)

OPEN_LOCAL_RUN_NUMBER_BUTTON = widget_button(OPEN_LOCAL_NEXUS_BASE,$
                                             xoffset=160,$
                                             yoffset=8+yoffset,$
                                             scr_xsize=60,$
                                             scr_ysize=30,$
                                             value='OPEN',$
                                             uname='OPEN_LOCAL_RUN_NUMBER_BUTTON')

CANCEL_LOCAL_OPEN_RUN_NUMBER_BUTTON = widget_button(OPEN_LOCAL_NEXUS_BASE,$
                                                    xoffset=230,$
                                                    yoffset=8+yoffset,$
                                                    scr_xsize=60,$
                                                    scr_ysize=30,$
                                                    value='CANCEL',$
                                                    uname='CANCEL_LOCAL_OPEN_RUN_NUMBER_BUTTON')









;top-left frame (display of counts vs pixelID for each tube
;one at a time and tube per tube for each of the Nt time bins

  draw_tube_pixels_base = widget_base(MAIN_BASE,$
                                      SCR_XSIZE=550,$
                                      SCR_YSIZE=370,$
                                      XOFFSET=5,$
                                      YOFFSET=10)
  
;    drawing_tab = widget_tab(draw_tube_pixels_base,$
;                             uname='draw_tube_pixels_base',$
;                             location=0,$
;                             xoffset=0,$
;                             yoffset=0,$
;                             scr_xsize=550,$
;                             scr_ysize=370)
; ;                          /tracking_events)
  
 ; tube_per_tube_plot_base = widget_base(drawing_tab,$
   tube_per_tube_plot_base= widget_base(draw_tube_pixels_base,$
                                        uname='tube_per_tube_plot_base',$
                                        title='Tube per tube plot',$
                                        xoffset=0,$
                                        yoffset=0)

  draw_tube_pixels_draw = widget_draw(tube_per_tube_plot_base,$
                                      UNAME='draw_tube_pixels_draw',$
                                      SCR_XSIZE=536,$
                                      SCR_YSIZE=300,$
                                      XOFFSET=4,$
                                      YOFFSET=5)
  
  draw_tube_pixels_slider = WIDGET_SLIDER(tube_per_tube_plot_base,$
                                          UNAME="draw_tube_pixels_slider",$
                                          XOFFSET= 5,$
                                          YOFFSET= 304,$
                                          SCR_XSIZE=536,$
                                          SCR_YSIZE=35,$
                                          MINIMUM=0,$
                                          MAXIMUM=63,$
                                          /DRAG,$
                                          VALUE=0,$
                                          EVENT_PRO="plot_tubes_pixels")
  
;   histo_tube_per_tube_plot_base = widget_base(drawing_tab,$
;                                               uname='histo_tube_per_tube_plot_base',$
;                                               title='Tube per tube for each Nt',$
;                                               xoffset=0,$
;                                               yoffset=0)

;   histo_draw_tube_pixels_draw = widget_draw(histo_tube_per_tube_plot_base,$
;                                             UNAME='histo_draw_tube_pixels_draw',$
;                                             SCR_XSIZE=536,$
;                                             SCR_YSIZE=270,$
;                                             XOFFSET=4,$
;                                             YOFFSET=3)

;   nt_histo_label = widget_label(histo_tube_per_tube_plot_base,$
;                                 xoffset=0,$
;                                 yoffset=287,$
;                                 value='Nt:')

;   nt_histo_draw_tube_pixels_slider = WIDGET_SLIDER(histo_tube_per_tube_plot_base,$
;                                           UNAME="nt_histo_draw_tube_pixels_slider",$
;                                           XOFFSET= 40,$
;                                           YOFFSET= 272,$
;                                           SCR_XSIZE=500,$
;                                           SCR_YSIZE=35,$
;                                           MINIMUM=0,$
;                                           MAXIMUM=(*global).Nt,$
;                                           /DRAG,$
;                                           VALUE=0,$
;                                           EVENT_PRO="histo_plot_tubes_pixels")
  
;   tube_histo_label = widget_label(histo_tube_per_tube_plot_base,$
;                                 xoffset=0,$
;                                 yoffset=306+15,$
;                                 value='Tube:')

;   histo_draw_tube_pixels_slider = WIDGET_SLIDER(histo_tube_per_tube_plot_base,$
;                                           UNAME="histo_draw_tube_pixels_slider",$
;                                           XOFFSET= 5+35,$
;                                           YOFFSET= 306,$
;                                           SCR_XSIZE=536-35,$
;                                           SCR_YSIZE=35,$
;                                           MINIMUM=0,$
;                                           MAXIMUM=63,$
;                                           /DRAG,$
;                                           VALUE=0,$
;                                           EVENT_PRO="histo_plot_tubes_pixels")

;######################################################################
;Top right part that will contain 2 tabs (interaction and log_book)
 tabs_base = widget_base(main_base,$
                         xoffset=560,$
                         yoffset=10,$
                         scr_xsize=545,$
                         scr_ysize=440)


 first_tab = widget_tab(tabs_base,$
                        uname='data_reduction_tab',$
                        location=0,$
                        xoffset=0,$
                        yoffset=0,$
                        scr_xsize=545,$
                        scr_ysize=440)

interactive_tab_base = widget_base(first_tab,$
                                   uname='interactive_tab',$
                                   title='Main Tab',$
                                   xoffset=0,$
                                   yoffset=0)


;Pixels counts vertical window info
pixels_counts_base = widget_base(interactive_tab_base,$
                                 XOFFSET=355,$
                                 YOFFSET=5,$
                                 SCR_XSIZE=180,$
                                 SCR_YSIZE=400,$
                                 frame=1)

pixels_counts_title = widget_label(pixels_counts_base,$
                                   xoffset=40,$
                                   yoffset=0,$
                                   scr_xsize=90,$
                                   scr_ysize=20,$
                                   value="Pixels values")

pixels_counts_values = widget_text(pixels_counts_base,$
                                   XOFFSET=3,$
                                   YOFFSET=20,$
                                   SCR_XSIZE=173,$
                                   SCR_YSIZE=375,$
                                   /wrap,$
                                   /scroll,$
                                   value = '',$
                                   UNAME='pixels_counts_values')

;General infos window
infos_base = widget_base(interactive_tab_base,$
                          XOFFSET=0,$
                          YOFFSET=5,$
                          SCR_XSIZE=350,$
                          SCR_YSIZE=120,$
                         frame=1)

infos_title = widget_label(infos_base,$
                           xoffset=6,$
                           yoffset=0,$
                           scr_xsize=40,$
                           scr_ysize=20,$
                           value = 'Infos')

general_infos = widget_text(infos_base,$
                             uname = "general_infos",$
                             xoffset=5,$
                             yoffset=18,$
                             scr_xsize=340,$
                             scr_ysize=100,$
                             /wrap,$
                            /scroll,$
                             value="")

;pixelID slider
pixelID_base = widget_base(interactive_tab_base,$
                           XOFFSET=0,$
                           YOFFSET=130,$
                           SCR_XSIZE=245,$
                           SCR_YSIZE=120)

pixelID_text = widget_label(pixelID_base,$
                            XOFFSET=5,$
                            YOFFSET=0,$
                            SCR_XSIZE=60,$
                            SCR_YSIZE=20,$
                            VALUE="Pixel ID")

pixels_slider = WIDGET_SLIDER(pixelID_base,$
                              UNAME="pixels_slider",$
                              XOFFSET= 7,$
                              YOFFSET= 18,$
                              SCR_XSIZE=230,$
                              SCR_YSIZE=35,$
                              MINIMUM=0,$
                              MAXIMUM=127,$
                              /DRAG,$
                              VALUE=0,$
                              EVENT_PRO="get_pixels_infos")


;pixelID interaction window
y_off_counts = 55
y_off_buttons = 80
pixelid_counts_label = widget_label(pixelID_base,$
                                    xoffset=10,$
                                    yoffset=y_off_counts,$
                                    scr_xsize=50,$
                                    scr_ysize=20,$
                                    value='Counts:',$
                                    /align_left)

pixelid_counts_value = widget_label(pixelID_base,$
                                    uname='pixelid_counts_value',$
                                    xoffset=65,$
                                    yoffset=y_off_counts,$
                                    scr_xsize=150,$
                                    scr_ysize=20,$
                                    value='',$
                                    /align_left)


remove_pixel_id = widget_button(pixelID_base,$
                                uname='remove_pixelid',$
                                xoffset=5,$
                                yoffset=y_off_buttons,$
                                scr_xsize=120,$
                                scr_ysize=30,$
                                value='R E M O V E',$
                                sensitive=0)

pixelid_new_counts_reset = $
  widget_button(pixelID_base,$
                uname='pixelid_new_counts_reset',$
                xoffset=125,$
                yoffset=y_off_buttons,$
                scr_xsize=115,$
                scr_ysize=30,$
                value='A D D',$
                sensitive=0)


pixel_and_tube_frame = widget_label(pixelID_base,$
                                    xoffset=0,$
                                    yoffset=8,$
                                    scr_xsize=355,$
                                    scr_ysize=105,$
                                    frame=1,$
                                    value='')

;pixelID, tube and bank info
 ptb_info_base = widget_base(interactive_tab_base,$
                             XOFFSET=246,$
                             YOFFSET=127,$
                             SCR_XSIZE=140,$
                             SCR_YSIZE=80)

 pixel_label = widget_label(ptb_info_base,$
                            xoffset=5,$
                            yoffset=15,$
                            scr_xsize=60,$
                            scr_ysize=20,$
                            value="Pixel ID:",$
                            uname='pixel_label')

 pixel_value = widget_label(ptb_info_base,$
                            xoffset=70,$
                            yoffset=15,$
                            scr_xsize=25,$
                            scr_ysize=20,$
                            value='63',$
                            /align_left,$
                            uname='pixel_value')

 tube_label = widget_label(ptb_info_base,$
                           xoffset=5,$
                           yoffset=35,$
                           scr_xsize=60,$
                           scr_ysize=20,$
                           value="  Tube #:",$
                           uname='tube_label')

tube_value = widget_label(ptb_info_base,$
                           xoffset=70,$
                           yoffset=35,$
                           scr_xsize=20,$
                           scr_ysize=20,$
                           value='0',$
                           /align_left,$
                           uname='tube_value')

 bank_label = widget_label(ptb_info_base,$
                           xoffset=5,$
                           yoffset=55,$
                           scr_xsize=60,$
                           scr_ysize=20,$
                           value="  Bank #:",$
                           uname='bank_label')

 bank_value = widget_label(ptb_info_base,$
                           xoffset=70,$
                           yoffset=55,$
                           scr_xsize=10,$
                           scr_ysize=20,$
                           value='1',$
                           /align_left,$
                           uname='bank_value')

 ptb_info_label = widget_label(ptb_info_base,$
                               XOFFSET=0,$
                               YOFFSET=10,$
                               SCR_XSIZE=100,$
                               SCR_YSIZE=65,$
                               frame=4,$
                               value='')


;tube removed window
removed_tube_base = widget_base(interactive_tab_base,$
                                XOFFSET=247,$
                                YOFFSET=210,$
                                SCR_XSIZE=103,$
                                SCR_YSIZE=195,$
                                frame=1)

removed_tube_title = widget_label(removed_tube_base,$
                                  xoffset=5,$
                                  yoffset=0,$
                                  value="Data removed")

removed_tube_text = widget_text(removed_tube_base,$
                                uname="removed_tube_text",$
                                xoffset=3,$
                                yoffset=15,$
                                scr_xsize=95,$
                                scr_ysize=175,$
                                /wrap,$
                                /scroll,$
                                sensitive=0)

;tube interaction window
tube_base = widget_base(interactive_tab_base,$
                        XOFFSET=0,$
                        YOFFSET=245,$  
                        SCR_XSIZE=245,$
                        SCR_YSIZE=60)

tube_title = widget_label(tube_base,$
                          xoffset=5,$
                          yoffset=0,$
                          scr_xsize=30,$
                          scr_ysize=20,$
                          value='Tube')

remove_tube_button = widget_button(tube_base,$
                                   uname='remove_tube_button',$
                                   xoffset=5,$
                                   yoffset=20,$
                                   scr_xsize=120,$
                                   scr_ysize=30,$
                                   value='R E M O V E',$
                                   sensitive=0)

cancel_remove_tube_button = widget_button(tube_base,$
                                          uname='cancel_remove_tube_button',$
                                          xoffset=125,$
                                          yoffset=20,$
                                          scr_xsize=115,$
                                          scr_ysize=30,$
                                          value='A D D',$
                                          sensitive=0)

Tube_frame = widget_label(tube_base,$
                          xoffset=0,$
                          yoffset=10,$
                          scr_xsize=245,$
                          scr_ysize=45,$
                          frame=1,$
                          value='')

;reset and save buttons
RESET_ALL_button = widget_button(interactive_tab_base,$
                                 UNAME="reset_all_button",$
                                 xoffset=5,$
                                 yoffset=310,$
                                 scr_xsize=235,$
                                 scr_ysize=30,$
                                 value="REINITIALIZE ALL VARIABLES",$
                                 sensitive=0)

RESET_ALL_BUTTON_VALIDATE_BASE = WIDGET_BASE(interactive_tab_base,$
                                             uname='RESET_ALL_BUTTON_VALIDATE_BASE',$
                                             xoffset=5,$
                                             yoffset=340,$ ;378
                                             scr_xsize=235,$
                                             scr_ysize=40,$
                                             map=0) 

RESET_ALL_BUTTON_VALIDATE_TEXT = widget_label(RESET_ALL_BUTTON_VALIDATE_BASE,$
                                              uname='reset_all_button_validate_text',$
                                              xoffset=15,$
                                              yoffset=5,$
                                              scr_xsize=90,$
                                              scr_ysize=30,$
                                              value='Are you sure? ',$
                                             /align_left)

RESET_ALL_BUTTON_VALIDATE_YES = WIDGET_BUTTON(RESET_ALL_BUTTON_VALIDATE_BASE,$
                                              uname='reset_all_button_validate_yes',$
                                              xoffset=110,$
                                              yoffset=5,$
                                              scr_xsize=40,$
                                              scr_ysize=25,$
                                              value='YES')

RESET_ALL_BUTTON_VALIDATE_CANCEL = WIDGET_BUTTON(RESET_ALL_BUTTON_VALIDATE_BASE,$
                                              uname='reset_all_button_validate_cancel',$
                                              xoffset=150,$
                                              yoffset=5,$
                                              scr_xsize=85,$
                                              scr_ysize=25,$
                                              value='CANCEL')


;processing info
processing_base = WIDGET_BASE(interactive_tab_base,$
                              uname='processing_base',$
                              xoffset=10,$
                              yoffset=340,$
                              scr_xsize=224,$
                              scr_ysize=35,$
                              map=0,$
                              frame=0)

processing_draw = widget_draw(processing_base,$
                              uname='processing_draw',$
                              xoffset=1,$
                              yoffset=18,$
                              scr_xsize=1,$ ;220 is max
                              scr_ysize=16)

processing_draw_frame = widget_label(processing_base,$
                                     xoffset=0,$
                                     yoffset=17,$
                                     scr_xsize=220,$
                                     scr_ysize=15,$
                                     frame=1,$
                                     value='')

processing_label = widget_label(processing_base,$
                                uname='processing_label',$
                                xoffset=10,$
                                yoffset=0,$
                                scr_xsize=200,$
                                scr_ysize=20,$
                                value='Processing...... 0%')





;Get Mapped Plot
plot_mapped_data = widget_button(interactive_tab_base,$
                                 XOFFSET=2,$
                                 YOFFSET=380,$
                                 SCR_XSIZE=110,$
                                 SCR_YSIZE=30,$
                                 VALUE="Realign / Plot",$
                                 UNAME='plot_mapped_data')
                                 

;Procude output file
output_new_histo_mapped_file = widget_button(interactive_tab_base,$
                                             XOFFSET=111,$
                                             YOFFSET=380,$
                                             SCR_XSIZE=135,$
                                             SCR_YSIZE=30,$
                                             VALUE="CREATE histo/NeXus",$
                                             UNAME='output_new_histo_mapped_file')


log_book_tab_base = widget_base(first_tab,$
                                uname='log_book_tab_base',$
                                title='Log book',$
                                xoffset=0,$
                                yoffset=0)

log_book = widget_text(log_book_tab_base,$
                       uname='log_book',$
                       xoffset=5,$
                       yoffset=5,$
                       scr_xsize=530,$
                       scr_ysize=405,$
                       /scroll,$
                       /wrap)
                       

;Rick's way plot
DAS_plot_base = widget_base(MAIN_BASE,$
                            SCR_XSIZE=550,$
                            SCR_YSIZE=245,$
                            XOFFSET=5,$
                            YOFFSET=455)


DAS_plot_title = widget_label(DAS_plot_base,$
                              SCR_XSIZE=70,$
                              SCR_YSIZE=20,$
                              XOFFSET=5,$
                              YOFFSET=0s,$
                              VALUE="DAS's plot")


 DAS_plot_draw = widget_draw(DAS_plot_base,$
                             UNAME='DAS_plot_draw',$
                             SCR_XSIZE=536,$
                             SCR_YSIZE=213,$
                             XOFFSET=6,$
                             YOFFSET=20)

DAS_plot_frame = widget_label(DAS_plot_base,$
                              UNAME='DAS_plot_frame',$
                              SCR_XSIZE=547,$
                              SCR_YSIZE=225,$
                              XOFFSET=0,$
                              YOFFSET=10,$
                              FRAME=1)




;Mapped plot
map_plot_base = widget_base(MAIN_BASE,$
                            XOFFSET=560,$
                            YOFFSET=445,$
                            SCR_XSIZE=550,$
                            SCR_YSIZE=250)

map_plot_title = widget_label(map_plot_base,$
                              SCR_XSIZE=70,$
                              SCR_YSIZE=15,$
                              XOFFSET=5,$
                              YOFFSET=12,$
                              VALUE="Mapped plot")

map_plot_draw = widget_draw(map_plot_base,$
                            UNAME='map_plot_draw',$
                            SCR_XSIZE=536,$
                            SCR_YSIZE=213,$
                            XOFFSET=6,$
                            YOFFSET=30)

map_plot_frame = widget_label(map_plot_base,$
                              SCR_XSIZE=547,$
                              SCR_YSIZE=225,$
                              XOFFSET=0,$
                              YOFFSET=20,$
                              FRAME=1)





y_offset = 380
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
                              UNAME='tube0_left_text',$
                              /align_left)

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
                               UNAME='tube0_right_text',$
                               /align_left)

tube0_right_plus = widget_button(tube0_base,$
                                 XOFFSET=69+105,$
                                 YOFFSET=32,$
                                 SCR_XSIZE=30,$
                                 SCR_YSIZE=30,$
                                 VALUE='+',$
                                 UNAME='tube0_right_plus')

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
                          UNAME='center_text',$
                          /align_left)

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
                              UNAME='tube1_left_text',$
                              /align_left)

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
                               UNAME="tube1_right_text",$
                               /align_left)

tube1_right_plus = widget_button(tube1_base,$
                                 XOFFSET=72+105,$
                                 YOFFSET=32,$
                                 SCR_XSIZE=30,$
                                 SCR_YSIZE=30,$
                                 VALUE='+',$
                                 UNAME="tube1_right_plus")

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










;draw boxes for plot windows
  FILE_MENU = Widget_Button(WID_BASE_0_MBAR, UNAME='FILE_MENU' ,/MENU  $
      ,VALUE='File')

  OPEN_NEXUS_menu = widget_button(FILE_MENU,$
                                  value="Open Run #...",$
                                  uname="OPEN_NEXUS_menu")
  

  open_local_nexus_menu = widget_button(FILE_MENU,$
                                        value='Open local Run #...',$
                                        uname='open_local_nexus_menu')

  OPEN_MAPPED_HISTOGRAM = Widget_Button(FILE_MENU, $
                                        UNAME='OPEN_MAPPED_HISTOGRAM',$
                                        VALUE='Open Mapped Histogram')
                                     
  rebinGUI_button = widget_button(FILE_MENU,$
                                  uname='rebinGUI_button',$
                                  value='RebinNeXus')

  EXIT_MENU = Widget_Button(FILE_MENU,$
                            UNAME='EXIT_MENU',$
                            VALUE='Exit')

  UTILS_MENU = Widget_Button(WID_BASE_0_MBAR,$
                             UNAME='UTILS_MENU',$
                             /MENU ,VALUE='RealignGUI')

  ABOUT_MENU = Widget_Button(UTILS_MENU,$
                             UNAME='ABOUT_MENU',$
                             VALUE='about RealignGUI')

  CTOOL_MENU_DAS = Widget_Button(UTILS_MENU,$
                                 UNAME='CTOOL_MENU_DAS',$
                                 VALUE='Color Tool for DAS')

  CTOOL_MENU_realign = Widget_Button(UTILS_MENU,$
                                     UNAME='CTOOL_MENU_realign',$
                                     VALUE='Color Tool for realign data')

  Widget_Control, /REALIZE, MAIN_BASE
  
                                ;disabled background buttons/draw/text/labels
  Widget_Control, draw_tube_pixels_slider, sensitive=0
  Widget_Control, pixels_slider, sensitive=0
  Widget_Control, tube0_left_minus, sensitive=0
  Widget_Control, tube0_left_text, sensitive=0  
  Widget_Control, tube0_left_plus, sensitive=0
  Widget_Control, tube0_right_minus, sensitive=0
  Widget_Control, tube0_right_text, sensitive=0
  Widget_Control, tube0_right_plus, sensitive=0
  Widget_Control, center_minus, sensitive=0
  Widget_Control, center_text, sensitive=0
  Widget_Control, center_plus, sensitive=0
  Widget_Control, tube1_left_minus, sensitive=0
  Widget_Control, tube1_left_text, sensitive=0
  Widget_Control, tube1_left_plus, sensitive=0
  Widget_Control, tube1_right_minus, sensitive=0
  Widget_Control, tube1_right_text, sensitive=0
  Widget_Control, tube1_right_plus, sensitive=0
  Widget_Control, plot_mapped_data, sensitive=0  
  Widget_Control, output_new_histo_mapped_file, sensitive=0
  Widget_Control, CTOOL_MENU_DAS, sensitive=0
  Widget_Control, CTOOL_MENU_realign, sensitive=0

  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

;
; Empty stub procedure used for autoloading.
;
pro RealignGUI, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
