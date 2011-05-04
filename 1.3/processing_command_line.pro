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

;This function run the command line and will output the plot and info text
PRO REFreductionEventcb_ProcessingCommandLine, Event

  ;get global structure
  widget_control,event.top,get_uvalue=global
  
  if ((*global).instrument eq 'REF_L') then begin
  
    run_command_line_ref_l, event
    
    IF ((*global).DataReductionStatus EQ 'OK') then begin
      ;data reduction was successful
    
      ;get name of .txt file
      output_file_path   = getOutputPathFromButton(Event)
      output_file_name   = getOutputFileName(Event)
      FullOutputFileName = output_file_path + output_file_name
      FullXmlFileName    = getXmlFileName(FullOutputFileName)
      
      ;get metadata
      RefReduction_SaveXmlInfo, Event,  FullXmlFileName
      
      ;Display XML file in Reduce tab
      REfReduction_DisplayXmlFile, Event
      
      ;apply auto cleanup of data if switch is on
      value = getButtonValue(event,'auto_cleaning_data_cw_bgroup')
      if (value eq 0) then begin ;apply auto cleanup
        cleanup_reduce_data, event, file_name = FullOutputFileName
      endif
      
      ;Load main data reduction File and  plot it
      putTextFieldValue, Event, 'plot_tab_input_file_text_field', FullOutputFileName
      ;move to new tab
      id1 = WIDGET_INFO(Event.top, FIND_BY_UNAME='main_tab')
      WIDGET_CONTROL, id1, SET_TAB_CURRENT = 2 ;plot tab
      LoadAsciiFile, Event
      
    ;get flt0, flt1 and flt2 and put them into array
    ;    RefReduction_LoadMainOutputFile, Event, FullOutputFileName
      
    ;;Plot main data reduction plot for the first time
    ;    RefReduction_PlotMainDataReductionFileFirstTime, Event
      
    ENDIF
    
  endif else begin
  
    if ((*global).reduction_mode eq 'one_per_selection') then begin
    
      run_command_line_ref_m, event
      
      first_ref_m_file_to_plot = (*global).first_ref_m_file_to_plot
      if (first_ref_m_file_to_plot ne -1) then begin
      
        list_of_output_file_name = (*(*global).list_of_output_file_name)
        ;apply auto cleanup of data if switch is on
        value = getButtonValue(event,'auto_cleaning_data_cw_bgroup')
        if (value eq 0) then begin ;apply auto cleanup
          sz = n_elements(list_of_output_file_name)
          index = 0
          while (index lt sz) do begin
            cleanup_reduce_data, event, file_name = list_of_output_file_name[index]
            index++
          endwhile
        endif
        
        FullOutputFileName = list_of_output_file_name[first_ref_m_file_to_plot]
        ;Load main data reduction File and  plot it
        putTextFieldValue, Event, 'plot_tab_input_file_text_field', FullOutputFileName
        ;move to new tab
        id1 = WIDGET_INFO(Event.top, FIND_BY_UNAME='main_tab')
        WIDGET_CONTROL, id1, SET_TAB_CURRENT = 2 ;plot tab
        LoadAsciiFile, Event
        
      endif
      
    endif else begin ;if 'one_per_pixel'
    
    
    run_command_line_ref_m_broad_peak, event
    
    
    
    
    endelse
    
  endelse
  
END
