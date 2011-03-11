;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

;This function defines the instrument if the program is started from
;heater
PRO REFreductionEventcb_InstrumentSelected, Event

  id = widget_info(Event.top,find_by_uname='instrument_selection_cw_bgroup')
  widget_control, id, get_value=instrument_selected

; CHANGE CODE (RC WARD, 22 June 2010): Add selection for resolution so code can run on laptop or desktop
  id = widget_info(Event.top,find_by_uname='resolution_selection_cw_bgroup')
  widget_control, id, get_value=resolution_selected

; Change Code (RC Ward, 13 Aug 2010); This was removed from the front screen on this day
; CHANGE CODE (RC WARD, 3 August 2010): Add choice of splicing alternative
;  id = widget_info(Event.top,find_by_uname='splicing_alternative_cw_bgroup')
;  widget_control, id, get_value=splicing_alternative
 
;print, "splicing_alternative: ",  splicing_alternative

; CHANGE CODE (RC WARD, 23 July 2010): Capture users path for reduce step files
  id = widget_info(Event.top,find_by_uname='reduce_step_path')
  widget_control, id, get_value=reduce_step_path

; Change Code 6 Jan 2011 - If user does not add / to results dir, then add it
len = STRLEN(reduce_step_path)
last = STRMID(reduce_step_path,len-1,1)
;print, "last character of reduce_step_path: ",last
IF (last NE '/') THEN BEGIN
   reduce_step_path = reduce_step_path +'/'
ENDIF
;print, "new_path: ", reduce_step_path
  

  if (resolution_selected EQ 0) then begin
; desktop resolution 
      MainBaseSize = [30,50,1276,901]
  endif else begin  
      MainBaseSize = [30,50,1300,770]
  endelse
  
  ;descativate instrument selection base and activate main base
  ISBaseID = widget_info(Event.top,find_by_uname='MAIN_BASE')
  widget_control, ISBaseId, map=0

; CHANGE CODE (RC WARD, 22 June 2010): Pass MainBaseSize from here to control resolution
  if (instrument_selected EQ 0) then begin
    BuildGui, 'REF_L', reduce_step_path, splicing_alternative, MainBaseSize, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  endif else begin
    BuildGui, 'REF_M', reduce_step_path, splicing_alternative, MainBaseSize, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  endelse
   
END
PRO Update_Reduce_Step_Path, Event, global

  id = widget_info(Event.top,find_by_uname='new_reduce_step_path')
  widget_control, id, get_value=path
  (*global).ascii_path = path
  (*global).working_path = path

; Change Code 6 Jan 2011 - If user does not add / to results dir, then add it
len = STRLEN(path)
last = STRMID(path,len-1,1)
;print, "last character of reduce_step_path: ",last
IF (last NE '/') THEN BEGIN
   path = path +'/'
ENDIF
;print, "new_path: ", path

    message = '> Switch to: ' + path   
    PlotUtility_addLogBookText, Event,  message 
; Change made (29 Dec 2010): add RESTART flag for resetting things in scaling_1D
; so far this is not implemented - I can't figure out what is going on (RCW)
    (*global).RESTART = 1

END
;------------------------------------------------------------------------------
;Preview of selected ascii file(s)
PRO  preview_ascii_file, Event ;_eventcb
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  list_OF_files = (*(*global).list_OF_ascii_files)
  index = getAsciiSelectedIndex(Event)
  IF (index[0] NE -1) THEN BEGIN
    sz = N_ELEMENTS(index)
    CASE (sz) OF
      1: XDISPLAYFILE, list_OF_files[index[0]]
      ELSE: BEGIN
        FOR i=0,(sz-1) DO BEGIN
          XDISPLAYFILE, list_OF_files[index[i]]
        ENDFOR
      END
    ENDCASE
  ENDIF
END

;-----------------------------------------------------------------------------
PRO reduce_tab_event, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_tab')
  CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
  PrevTabSelect = (*global).PrevReduceTabSelect
  
  IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
  
    CASE (currTabSelect) OF
      0: BEGIN
        ;sangle base
        IF (isBaseMapped(Event, 'reduce_step1_sangle_base')) THEN BEGIN
        display_reduce_step1_sangle_buttons, Event=event, global
        ENDIF ELSE BEGIN
          display_reduce_step1_buttons, EVENT=EVENT,$
            ACTIVATE=(*global).reduce_step1_spin_state_mode, $
            global
        ENDELSE
      END
      1: BEGIN
        base_mapped = isBaseMapped(Event,'reduce_step2_create_roi_base')
        IF (~base_mapped) THEN BEGIN
          refresh_reduce_step2_big_table, Event
          IF ((*global).instrument EQ 'REF_M') THEN BEGIN
            refresh_reduce_step2_data_spin_state_table, Event
          ENDIF
;          refresh_roi_file_name, Event
        ENDIF
      END
      2: BEGIN ;step3: recapitulation tab
        refresh_reduce_step3_table, Event
      ;reduce_step3_plot_jobs, Event ;REMOVE_ME
      END
      ELSE:
    ENDCASE
    
    (*global).PrevReduceTabSelect = CurrTabSelect
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO reduce_step2_data_tab, Event

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  tab_id = WIDGET_INFO(Event.top,$
    FIND_BY_UNAME='reduce_step2_data_spin_state_tab_uname')
  CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
  PrevTabSelect = (*global).PrevReduceStep2TabSelect
  
  IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
    CASE (currTabSelect) OF
      0: BEGIN ;off_off
        check_status_of_reduce_step2_data_spin_state_hidden_base, Event, tab=1
      END
      1: BEGIN ;off_on
        check_status_of_reduce_step2_data_spin_state_hidden_base, Event, tab=2
      END
      2: BEGIN ;on_off
        check_status_of_reduce_step2_data_spin_state_hidden_base, Event, tab=3
      END
      3: BEGIN ;on_on
        check_status_of_reduce_step2_data_spin_state_hidden_base, Event, tab=4
      END
      ELSE:
    ENDCASE
    (*global).PrevReduceStep2TabSelect = CurrTabSelect
    
    ;refresh_roi_file_name, Event  
    ;;MESSAGE
    ;;not required anymore as the file name label
    ;;are not there anymore in the DIRECT tab
  
  ENDIF
  
END

;-----------------------------------------------------------------------------
;this function is trigerred each time the user changes tab
PRO tab_event, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='main_tab')
  CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
  PrevTabSelect = (*global).PrevTabSelect
  
  IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
    CASE (CurrTabSelect) OF
    
;*** STEP 1 *******************************************************************
      0: BEGIN ;step1 (reduction)
      
        reduce_tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='reduce_tab')
        CurrReduceTabSelect = WIDGET_INFO(reduce_tab_id,/TAB_CURRENT)
        
        CASE (CurrReduceTabSelect) OF
        
          0: BEGIN
                ;sangle base
        IF (isBaseMapped(Event, 'reduce_step1_sangle_base')) THEN BEGIN
        display_reduce_step1_sangle_buttons, Event=event, global
        ENDIF ELSE BEGIN
          display_reduce_step1_buttons, EVENT=EVENT,$
            ACTIVATE=(*global).reduce_step1_spin_state_mode, $
            global
        ENDELSE
            END
          1: BEGIN
            base_mapped = isBaseMapped(Event,'reduce_step2_create_roi_base')
            IF (~base_mapped) THEN BEGIN
              refresh_reduce_step2_big_table, Event
              IF ((*global).instrument EQ 'REF_M') THEN BEGIN
                refresh_reduce_step2_data_spin_state_table, Event
              ENDIF
              refresh_roi_file_name, Event
            ENDIF
          ;              step2_tab_id = WIDGET_INFO(Event.top,$
          ;                FIND_BY_UNAME='reduce_step2_data_spin_state_tab_uname')
          ;              Step2CurrTabSelect = WIDGET_INFO(step2_tab_id,/TAB_CURRENT)
          ;              check_status_of_reduce_step2_data_spin_state_hidden_base, $
          ;                Event, $
          ;                tab=(Step2CurrTabSelect+1)
          END
          ELSE:
        ENDCASE
        
      END ;end of step1 *******************************************************

;*** STEP 2 *******************************************************************     
      1: BEGIN ;load
        IF((*global).something_to_plot) THEN BEGIN
          xaxis = (*(*global).x_axis)
          contour_plot, Event, xaxis
          plotAsciiData, Event, RESCALE=1, TYPE='replot'
        ENDIF
      END ;end of step2 *******************************************************

;*** STEP 3 *******************************************************************
      
      2: BEGIN ;shifting
        display_shifting_help, Event, ''
        IF((*global).something_to_plot) THEN BEGIN
          ActiveFileDroplist, Event ;_shifting
          xaxis = (*(*global).x_axis)
          populate_step3_range_init, Event ;_shifting
          contour_plot_shifting, Event, xaxis ;_shifting
          plotAsciiData_shifting, Event
; Change code (RC Ward Feb 18, 2010): If RefPixLoad is set to yes in REFoffSpec.cfg 
; then load the RefPix values from RefPix file
; This is only to be used by magetism reflectometer data reduction process, so check for REF_M
           instrument = (*global).instrument

           IF (instrument EQ 'REF_M') THEN BEGIN
             refpixload = (*global).RefPixLoad

             IF (refpixload EQ 'yes') THEN BEGIN
               box_color = (*global).box_color
               list_OF_files = (*(*global).list_OF_ascii_files)
               sz = N_ELEMENTS(list_OF_files)
;               RefPixSave = INTARR(sz)
; CHANGE (RC Ward, 22 Dec 2010): This needs to be float array
                RefPixSave = FLTARR(sz)
                PreviousRefPix = FLTARR(sz)

; Change code (RC Ward Feb 26, 2010): Read file containing RefPix values on clicking the Shifting step tab
               list = list_OF_files[0]
; Change code (RC Ward 30 June 2010): STR_SEP is obsolte. Replace with IDL routine STRSPLIT
;               parts = STR_SEP(list,'.')

; 9 Jan 2010: CHANGE TO SINGLE REFPIX FILE FOR ALL SPIN STATES
;                parts = STRSPLIT(list,'.',/EXTRACT)
;print, "RefPixLoad: test: ", parts[0]," ", parts[1]
;               input_file_name = parts[0] + '_RefPix.txt'

               parts = STRSPLIT(list,'_',/EXTRACT)
;print, "RefPixLoad: parts[0]: ", parts[0]
;print, "RefPixLoad: parts[0]: ", parts[1]
;print, "RefPixLoad: parts[0]: ", parts[2]
               input_file_name = parts[0] + "_" + parts[1] + "_" + parts[2] + '_RefPix.txt'

               (*global).input_file_name = input_file_name
;print, "OPEN RefPix file: ", input_file_name

               OPENR, 1, input_file_name, ERROR = err
               IF (ERR EQ 0) THEN BEGIN  ; NO ERROR, FILE EXISTS SO CONTINUE ON
                 READF, 1, RefPixSave
;print, "RefPix file: ", RefPixSave
                 CLOSE, 1
                 FREE_LUN, 1
                 (*(*global).RefPixSave) = RefPixSave 
                 (*(*global).ref_pixel_list_original) = RefPixSave
; Change code (15 Jan 11, RC Ward): Save previous value of RefPix 
                 (*(*global).PreviousRefPix) = RefPixSave                
    PreviousRefPix = (*(*global).PreviousRefPix)
; DEBUG =====
;  print, " previous RefPix: ", PreviousRefPix
; DEBUG =====  
                  x_value = 400
                 FOR i=0,(sz-1) DO BEGIN
                     IF (RefPixSave[i] NE 0.) THEN BEGIN
; draw RefPix line   
                        plotLine, Event, RefPixSave[i], x_value, box_color[i]           
                     ENDIF
                 ENDFOR
                 (*(*global).ref_x_list)=RefPixSave
                 (*(*global).ref_pixel_list)=RefPixSave
               ENDIF ELSE BEGIN
                 PRINT, "Warning: RefPix file does not exist. Use mouse or text entry to enter values."
                 CLOSE, 1 
; DO NOT SET RefPixSave - NOTHING EXISTS: User must enter RefPix values using the mouse.
               ENDELSE            
             ENDIF
           
          ENDIF
          plotReferencedPixels, Event ;_shifting
          refresh_plot_selection_OF_2d_plot_mode, Event
        ENDIF
        CheckShiftingGui, Event ;_gui
      END ;end of step3 *******************************************************
      
;*** STEP 4 *******************************************************************
      3: BEGIN ;scaling
        tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='scaling_main_tab')
        step4CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
 
; Change code (RC Ward, 28 Dec 2010): If user has entered new reference run#
; RESTART will be set to 1. This is not implemented yet - not sure how to reset things.
     RESTART = (*global).RESTART
; print, "test: eventcb:scaling RESTART: ", RESTART
;==================================================================================\
; make sure this droplist is updated
;droplist of 'active files' 
    updateStep3FileNames, Event;_scaling
     IF ( RESTART EQ 1) THEN BEGIN
;       if RESTART is 1, force the initial scaling screen
        WIDGET_CONTROL, tab_id, set_tab_current=0     
        step4CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
     ENDIF
;==================================================================================/     
        IF((*global).something_to_plot) THEN BEGIN
          IF (step4CurrTabSelect EQ 0) THEN BEGIN ;scaling_step1
            populate_step4_range_init, Event ;_scaling
            refresh_step4_step1_plot, Event ;_scaling
            checkScalingGui, Event ;_gui           
          ENDIF ELSE BEGIN    ;scaling_step2
;===================================================\
     IF ( RESTART EQ 1) THEN BEGIN
; if RESTART is 1, force the first page of scaling step2 
        tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step2_tab')
        WIDGET_CONTROL, tab_id, set_tab_current=0     
        step4CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
     ENDIF
;===================================================/
            (*global).PrevScalingTabSelect = -1 ;this forces a refresh
            scaling_tab_event, Event
          ;display_step4_step2_step2_selection, $
          ;  Event         ;scaling_step2_step1
          ;plotLambdaSelected, Event ;scaling_step2_step2
          ENDELSE
        ENDIF
      END ;end of step4 *******************************************************

;*** STEP 5 **********************************************************************      
      4: BEGIN ;scaling_2d
        check_step5_gui, Event ;_step5
        LoadBaseStatus  = isBaseMapped(Event,'shifting_base_step5')
        ;ScaleBaseStatus = isBaseMapped(Event,'scaling_base_step5')

        IF (LoadBaseStatus EQ 0) THEN BEGIN
          id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_draw')
          WIDGET_CONTROL, id_draw, GET_VALUE=id_value
          WSET,id_value
          error = 0
          CATCH, error
          IF (error NE 0) THEN BEGIN
            CATCH,/CANCEL
            refresh_recap_plot, Event ;_step5
          ENDIF ELSE BEGIN
            IF ((*global).zmax_g_recap EQ 0d AND $
              (*global).zmin_g_recap EQ 0d) THEN BEGIN
   ; draw 2D data
              refresh_recap_plot, Event
   ; pick up the xmin,ymin,xmax,ymax from Step 4 
              step5_rescale_populate_zoom_widgets, Event
   ; draw the selection box
              refresh_plotStep5Selection, Event
            ENDIF ELSE BEGIN
   ; draw 2D data
              refresh_recap_plot, Event, RESCALE=1;_step5
   ; pick up the xmin,ymin,xmax,ymax from Step 4 
              step5_rescale_populate_zoom_widgets, Event
   ; draw the selection box
              refresh_plotStep5Selection, Event       
            ENDELSE
         ENDELSE
; 
; Change Code (RC Ward, 18 Apr 2010/11 May 2010) - add connection to zoom boxes
;          step5_rescale_populate_zoom_widgets, Event ;scaling_step2 used in step 5
;          re_display_step4_step2_step1_selection, Event ;scaling_step2 used in step 5       
;show selection if one is selected
          selection_value = $
            getCWBgroupValue(Event,'step5_selection_group_uname')
;       print, 'test eventcb - selection_value: ', selection_value
          CASE (selection_value) OF
            1: BEGIN
;               create_step5_selection_data, Event 
;               step5_rescale_populate_zoom_widgets, Event
              IF ((*global).step5_x0 + $
                (*global).step5_x1 + $
                (*global).step5_y0 + $
                (*global).step5_y1 NE 0) THEN BEGIN
                replot_step5_i_vs_Q_selection, Event ;step5
;                step5_rescale_populate_zoom_widgets, Event
              ENDIF
            END
            ELSE:
          ENDCASE
          
        ENDIF
      END  ;end of step5 *******************************************************
      
;*** STEP 6 ********************************************************************
      5: BEGIN ;create output file
        UpdateStep6Gui, Event ;_step6
      END  ;end of step6 *******************************************************

;*** STEP 7 ********************************************************************      
      6: BEGIN ;options
      END  ;end of step7 *******************************************************

;*** STEP 8 ********************************************************************
      7: BEGIN ;logbook
      END  ;end of step8 *******************************************************
      
      
      ELSE:
    ENDCASE
    (*global).PrevTabSelect = CurrTabSelect
  ENDIF
END

;------------------------------------------------------------------------------
;This function is triggered each time the mouse moves over the tab of step4
PRO scaling_tab_event, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='scaling_main_tab')
  CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
  PrevTabSelect = (*global).PrevScalingTabSelect
  
  IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
;=======================================
     RESTART = (*global).RESTART
     IF ( RESTART EQ 1) THEN BEGIN
; if RESTART is 1, force the first page of scaling step2 
        tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step2_tab')
        WIDGET_CONTROL, tab_id, set_tab_current=0     
        step4CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
        (*global).PrevScalingStep2TabSelect = 0
     ENDIF
     RESTART = 0
     (*global).RESTART = RESTART  
;========================================

    CASE (CurrTabSelect) OF
    
      0: BEGIN ;step1 (pixel range selection)
        IF((*global).something_to_plot) THEN BEGIN
          refresh_step4_step1_plot, Event ;scaling_step1
        ENDIF
      END
      
      1: BEGIN ;step2 (scaling)
      
        populate_zoom_widgets, Event ;scaling_step2
        ;  tab_step4_step2_event, Event
        
        CASE ((*global).PrevScalingStep2TabSelect) OF
          0: BEGIN                ;all files
; the following call was added to properly set up the droplist
            populate_step4_2_3_droplist, Event
            re_display_step4_step2_step1_selection, Event ;scaling_step2
          END
          1: BEGIN                ;CE files
            re_display_step4_step2_step1_selection, Event ;scaling_step2
            re_plot_lambda_selected, Event ;scaling_step2
            re_plot_fitting, Event ;scaling_step2_step2
          END
          2: BEGIN                ;other files
            re_display_step4_step2_step1_selection, Event ;scaling_step2
            check_step4_2_3_gui, Event ;scaling_step2_step3
          END
          ELSE:
        ENDCASE
        error = 0
        CATCH, error
        IF (error NE 0) THEN BEGIN
          CATCH,/CANCEL
        ENDIF ELSE BEGIN
; FIGURE OUT THE PROBLEM HERE - WHY IS MANUAL SCALING CALLED? HOW DO WE GET TO THIS SPLOT?
;         step4_2_3_manual_scaling, Event, FACTOR='manual' ;scaling_step2_step3
        ENDELSE
        
      ;          0: BEGIN ;all files
      ;            display_step4_step2_step1_selection, Event
      ;          END
      ;          1: BEGIN ;CE files
      ;            display_step4_step2_step2_selection, Event
      ;            re_plot_lambda_selected, Event ;scaling_step2
      ;            re_plot_fitting, Event ;scaling_step2_step2
      ;          END
      ;          2: BEGIN ;other files
      ;            check_step4_2_3_gui, Event ;scaling_step2_step3
      ;          END
      ;          ELSE:
      ;        ENDCASE
      END
      ELSE:
    ENDCASE
    
    (*global).PrevScalingTabSelect = CurrTabSelect
  ENDIF
END

;------------------------------------------------------------------------------
PRO tab_step4_step2_event, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step2_tab')
  CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
  PrevTabSelect = (*global).PrevScalingStep2TabSelect
  
  IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
    CASE (CurrTabSelect) OF
      0: BEGIN                ;all files
        re_display_step4_step2_step1_selection, Event ;scaling_step2
      END
      1: BEGIN                ;CE files
        re_display_step4_step2_step1_selection, Event ;scaling_step2
        re_plot_lambda_selected, Event ;scaling_step2
        re_plot_fitting, Event ;scaling_step2_step2
      END
      2: BEGIN                ;other files
        re_display_step4_step2_step1_selection, Event ;scaling_step2
        check_step4_2_3_gui, Event ;scaling_step2_step3
      END
      ELSE:
    ENDCASE
    error = 0
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH,/CANCEL
    ENDIF ELSE BEGIN
; FIGURE OUT THE PROBLEM HERE - WHY IS MANUAL SCALING CALLED? HOW DO WE GET TO THIS SPLOT?
;     step4_2_3_manual_scaling, Event, FACTOR='manual' ;scaling_step2_step3
    ENDELSE
    
    (*global).PrevScalingStep2TabSelect = CurrTabSelect
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO initialize_arrays, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  list_OF_files = (*(*global).list_OF_ascii_files)
  sz = N_ELEMENTS(list_OF_files)
; Change (29 Dec 2010): Make ref_pixel_list a FLOAT
;  ref_pixel_list = INTARR(sz)
  ref_pixel_list = FLTARR(sz)
  ref_x_list     = INTARR(sz)
  scaling_factor = FLTARR(sz)+1
  (*(*global).ref_pixel_list)        = ref_pixel_list
  (*(*global).ref_pixel_offset_list) = ref_pixel_list
  (*(*global).ref_x_list)            = ref_x_list
  (*(*global).scaling_factor)        = scaling_factor
END

;------------------------------------------------------------------------------
PRO MAIN_REALIZE, wWidget
  tlb = get_tlb(wWidget)
  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/HOURGLASS
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
END

;------------------------------------------------------------------------------
PRO ref_off_spec_eventcb, event
END
