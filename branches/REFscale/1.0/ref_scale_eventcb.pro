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

;##############################################################################
;******************************************************************************

;reset full session
PRO reset_all_button, Event

  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  
  ;reset all arrays
  ResetArrays, Event ;_utility
  ReinitializeColorArray, Event   ;_utility
  ClearAllDropLists, Event        ;_Gui
  ClearAllTextBoxes, Event        ;_Gui
  ClearFileInfoStep1, Event       ;_Gui
  ClearMainPlot, Event            ;_Gui
  ResetPositionOfSlider, Event    ;_Gui
  ResetAllOtherParameters, Event
  ResetRescaleBase,Event
  ActivateRescaleBase, Event, 0
  ActivateClearFileButton, Event, 0
  ClearCElabelStep2, Event        ;_Gui
  ClearStep2GlobalVariable, Event ;_Step2
  ActivatePrintFileButton, Event, 0
  (*global).NbrFilesLoaded = 0 ;Reset nbr of files loaded
  ActivateStep2, Event, 0 ;_Gui, desactivate base of step2
  ActivateStep3, Event, 0 ;_Gui, desactivate base of step3
  
  ;reset spin states
  (*global).current_spin_index = -1
  (*(*global).data_spin_state) = strarr(1)
  (*(*global).norm_spin_state) = strarr(1)
  (*(*global).list_of_spins_for_each_angle) = ptr_new(0L)
  (*global).working_with_ref_m_batch = 0b ;reset type of batch file
  uname = ['off_off','off_on','on_off','on_on']
  for i=0, 3 do begin
    ActivateWidget, event, uname[i], 0
  endfor
  ;reset all spin states button
  id = widget_info(event.top, find_by_Uname='spin_state_button_base')
  widget_control, id, set_button=0
  
  ;reset the output file name
  putValueInLabel, Event, 'output_short_file_name', '';_put
  ;output_file_name_value, event
  scaled_uname = 'scaled_data_file_name_value_'
  spin_state_uname = 'scaled_data_spin_state_'
  combined_scaled_uname = 'combined_scaled_data_file_name_value_'
  combined_spin_state_uname = 'combined_scaled_data_spin_state_'
  for i=0,3 do begin
    index = strcompress(i,/remove_all)
    putTextFieldValue, event, spin_state_uname + index, ''
    putTextFieldValue, event, scaled_uname + index, 'N/A'
    putTextFieldValue, event, combined_spin_state_uname + index, ''
    putTextFieldValue, event, combined_scaled_uname + index, 'N/A'
  endfor
  check_previews_button, event
  
  ;putValueInLabel, Event, 'output_file_text_field', '' ;_put
  ;ActivateSettingsBase, Event, 0 ;_gui
  ResetBatch, Event ;_batch
  ;ActivateWidget, Event, 'preview_output_file_button', 0 ;preview button
  idl_send_to_geek_addLogBookText, Event, '> Reset Full Session'
END

;##############################################################################
;******************************************************************************

PRO rescale_data_changed, Event
  widget_control,id,GET_UVALUE=global
  (*global).replot_me  = 1
  (*global).replotQnew = 1 ;means we need to replot the Qs
END

;##############################################################################
;******************************************************************************

;reset X and Y axis rescalling
PRO ResetRescaleButton, Event
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  ;repopulate Xmin, Xmax, Ymin and Ymax with first XYMinMax values
  putXYMinMax, Event, (*(*global).XYMinMax) ;_put
  DoPlot, Event
END

;##############################################################################
;******************************************************************************

;This function reinitialize the Rescale base
PRO ResetRescaleBase,Event
  ;reset X and Y, Min and Max text fields
  XminId = widget_info(Event.top,find_by_uname='XaxisMinTextField')
  XmaxId = widget_info(Event.top,find_by_uname='XaxisMaxTextField')
  YminId = widget_info(Event.top,find_by_uname='YaxisMinTextField')
  YmaxId = widget_info(Event.top,find_by_uname='YaxisMaxTextField')
  XYMinMax = [XminId, XmaxId, YminId, YmaxId]
  for i=0,3 do begin
    widget_control, XYMinMax[i], set_value=''
  endfor
  ;reset Y lin/log
  YaxisLinLogId = widget_info(Event.top,find_by_uname='YaxisLinLog')
  widget_control, YaxisLinLogId, set_value=0
END

;##############################################################################
;******************************************************************************
;This function display the full contain of the DR file
PRO DisplayFullPreviewOfButton, Event ;_eventcb
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,GET_UVALUE=global
  index  = getSelectedIndex(Event, 'list_of_files_droplist')
  ListOfFiles = (*(*global).ListOfLongFileName)
  selected_file = ListOfFiles[index]
  title = 'PREVIEW of ' + selected_file
  XDISPLAYFILE, selected_file, TITLE=title, group=id, /center
END

;##############################################################################
;******************************************************************************

PRO REF_SCALE_EVENTCB
END

;##############################################################################
;******************************************************************************

PRO MAIN_REALIZE, wWidget
  tlb = get_tlb(wWidget)
  ;indicate initialization with hourglass icon
  widget_control,/hourglass
  ;turn off hourglass
  widget_control,hourglass=0
end

;##############################################################################
;******************************************************************************

PRO WithWithoutErrorBars, Event
  plot_loaded_file, Event, 'all'  ;_Plot
END



